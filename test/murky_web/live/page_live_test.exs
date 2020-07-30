defmodule MurkyWeb.PageLiveTest do
  use MurkyWeb.ConnCase

  import Phoenix.LiveViewTest

  test "make shure index page is shown", %{conn: conn} do
    # IO.inspect(conn)
    {:ok, _page_live, disconnected_html} = live(conn, "/")

    {:ok, document} = Floki.parse_document(disconnected_html)
    
    index_page_found = document
    |> Floki.find(".index-page")
    |> Enum.count

    assert index_page_found == 1
  end
end
