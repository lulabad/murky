defmodule MurkyWeb.ViewLiveTest do
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

  test "make sure the markdown view page is shown", %{conn: conn} do
    Data.create_file("first_file")
    Data.save_file("first_file", "# Das ist ein Titel")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.live_path(conn, MurkyWeb.ViewLive, file: "first_file"))

    assert view
           |> render()
           |> Floki.parse_document!()
           |> Floki.find(".markdown")
           |> Enum.count() == 1
  end

  test "shows the content of the file", %{conn: conn} do
    Data.create_file("first_file")
    Data.save_file("first_file", "# Das ist ein Titel")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.live_path(conn, MurkyWeb.ViewLive, file: "first_file"))

    assert view
           |> render()
           |> Floki.parse_document!()
           |> Floki.find("div[class='markdown'] h1")
           |> Floki.text() =~ "Das ist ein Titel"
  end

  test "click on edit redirects to the edit page", %{conn: conn} do
    Data.create_file("first_file")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.live_path(conn, MurkyWeb.ViewLive, file: "first_file"))

    view
    |> element("button[phx-click='edit']")
    |> render_click()

    assert_redirect(view, Routes.live_path(conn, MurkyWeb.EditLive, file: "first_file"))
  end
end
