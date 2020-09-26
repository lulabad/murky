defmodule MurkyWeb.PageLiveTest do
  use MurkyWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Murky.Data

  setup do
    # make sure the STORAGE_PATH exists
    Data.get_storage_path() |> File.mkdir!()

    on_exit(fn ->
      File.rm_rf!(Murky.Data.get_storage_path())
    end)

    :ok
  end

  test "make sure index page is shown", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, "/")

    assert disconnected_html
           |> Floki.parse_document!()
           |> Floki.find("#page_live")
           |> Enum.count() == 1
  end

  test "existing files are listed in the index page", %{conn: conn} do
    Data.create_file("first_file")
    Data.create_file("second_file")

    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> render()
           |> Floki.parse_document!()
           |> Floki.find("li")
           |> Enum.count() == 2
  end

  test "click on the item redirects to the view", %{conn: conn} do
    Data.create_file("first_file")
    {:ok, view, _disconnected_html} = live(conn, "/")

    view
    |> element("li:first-child()")
    |> render_click()

    assert_redirect(view, Routes.live_path(conn, MurkyWeb.ViewLive, file: "first_file"))
  end

  test "click on add md opens the new dialog", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> element("button[phx-click='new_show']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find("button[phx-click='new_save']")
           |> Enum.count() == 1
  end

  test "click on cancel on new close the dialog", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    # make sure the dialog is open
    assert view
           |> element("button[phx-click='new_show']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find("button[phx-click='new_save']")
           |> Enum.count() == 1

    assert view
           |> element("button[phx-click='new_cancel']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find("button[phx-click='new_save']")
           |> Enum.count() == 0
  end

  test "save new file creates a new file and updates the index page", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> element("button[phx-click='new_show']")
           |> render_click()

    view
    |> element("input")
    |> render_keyup(%{key: "d", value: "blub"})

    assert view
           |> element("button[phx-click='new_save']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find("li")
           |> Enum.count() == 1
  end

  test "delete a file", %{conn: conn} do
    Data.create_file("first_file")
    {:ok, view, _disconnected_html} = live(conn, "/")

    view
    |> element("button[phx-click='try-delete-file'][phx-value-filename='first_file']")
    |> render_click()

    view
    |> element("button[phx-click='delete-file']")
    |> render_click()

    refute view |> element("li[phx-value-filename='first-file']") |> has_element?()
    assert Data.get_files() == []
  end

  test "cancel delete a file", %{conn: conn} do
    Data.create_file("first_file")
    {:ok, view, _disconnected_html} = live(conn, "/")

    view
    |> element("button[phx-click='try-delete-file'][phx-value-filename='first_file']")
    |> render_click()

    view
    |> element("button[phx-click='close-delete-file']")
    |> render_click()

    refute view |> element(".modal-container") |> has_element?()
    assert view |> element("li[phx-value-filename='first_file']") |> has_element?()
    assert Data.get_files() == ["first_file"]
  end

  test "click on the edit file redirects to the edit view", %{conn: conn} do
    Data.create_file("first_file")
    {:ok, view, _disconnected_html} = live(conn, "/")

    view
    |> element("button[phx-click='edit-file'][phx-value-filename='first_file']")
    |> render_click()

    assert_redirect(view, Routes.live_path(conn, MurkyWeb.EditLive, file: "first_file"))
  end
end
