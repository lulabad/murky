defmodule MurkyWeb.EditLiveTest do
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

  test "show the correct page", %{conn: conn} do
    Data.create_file("first_file")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.live_path(conn, MurkyWeb.EditLive, file: "first_file"))

    assert view.module() == MurkyWeb.EditLive
  end
end
