defmodule MurkyWeb.UploadController do
  use MurkyWeb, :controller

  alias Murky.Data

  def update(conn, %{"id" => id}) do
    {:ok, body, _conn} = Plug.Conn.read_body(conn)

    file =
      Data.get_storage_path()
      |> Path.join(id)
      |> File.open!([:write])

    # {:ok, file} = File.open(Path.join(Data.get_storage_path(), id), [:write])
    IO.binwrite(file, body)
    # just a dummy response
    json(conn, %{id: id})
  end
end
