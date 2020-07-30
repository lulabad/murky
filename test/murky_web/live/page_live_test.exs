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
           |> Floki.find(".index-page")
           |> Enum.count() == 1
  end

  test "existing files are listed in the index page", %{conn: conn} do
    Data.create_file("first_file")
    Data.create_file("second_file")

    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> render()
           |> Floki.parse_document!()
           |> Floki.find(".index-list__item")
           |> Enum.count() == 2
  end

  test "click on the link redirects to the view", %{conn: conn} do
    Data.create_file("first_file")
    {:ok, view, _disconnected_html} = live(conn, "/")

    view
    |> element(".index-list__item a:first-child()")
    |> render_click()

    assert_redirect(view, Routes.live_path(conn, MurkyWeb.ViewLive, file: "first_file.md"))
  end

  test "click on add md opens the new dialog", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> element("button[phx-click='add_md']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find(".new-file")
           |> Enum.count() == 1
  end

  test "click on cancel on new md close the dialog", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    # make sure the dialog is open
    assert view
           |> element("button[phx-click='add_md']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find(".new-file")
           |> Enum.count() == 1

    assert view
           |> element("button[phx-click='cancel']")
           |> render_click()
           |> Floki.parse_document!()
           |> Floki.find(".new-file")
           |> Enum.count() == 0
  end

  test "save new file creates a new file and updates the index page", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, "/")

    assert view
           |> element("button[phx-click='add_md']")
           |> render_click()

    assert view
           |> element("form")
           |> render_submit(%{"filename" => "my_new_file"})
           |> Floki.parse_document!()
           |> Floki.find(".index-list__item")
           |> Enum.count() == 1
  end
end
