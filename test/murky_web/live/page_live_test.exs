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
    {:ok, _page_live, disconnected_html} = live(conn, "/")

    {:ok, document} = Floki.parse_document(disconnected_html)

    index_page_found =
      document
      |> Floki.find(".index-page")
      |> Enum.count()

    assert index_page_found == 1
  end

  test "existing files are listed in the index page", %{conn: conn} do
    Data.create_file("first_file")
    Data.create_file("second_file")

    {:ok, page_live, _disconnected_html} = live(conn, "/")
    html = render(page_live)
    {:ok, document} = Floki.parse_document(html)

    c = document |> Floki.find(".index-list__item") |> Enum.count()

    assert c == 2
  end
end
