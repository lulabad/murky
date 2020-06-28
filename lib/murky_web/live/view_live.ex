defmodule MurkyWeb.ViewLive do
    use MurkyWeb, :live_view

    def mount(params, _session, socket) do
        filename = Map.get(params, "file")
        md = Murky.Data.get_md(filename)
        {:ok, assign(socket, md: md, filename: filename)}

      end
end