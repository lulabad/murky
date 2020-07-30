defmodule MurkyWeb.PageLiveTest do
  use MurkyWeb.ConnCase

  import Phoenix.LiveViewTest

  setup_all do
    # make shure the STORAGE_PATH exists
    dir = Murky.Data.get_storage_path()
    
    if !File.exists?(dir) do
      File.mkdir!(dir)

      on_exit fn -> 
        File.rmdir!(Murky.Data.get_storage_path())
      end
    end
    :ok
  end

  test "make shure index page is shown", %{conn: conn} do
    {:ok, _page_live, disconnected_html} = live(conn, "/")

    {:ok, document} = Floki.parse_document(disconnected_html)
    
    index_page_found = document
    |> Floki.find(".index-page")
    |> Enum.count

    assert index_page_found == 1
  end
end
