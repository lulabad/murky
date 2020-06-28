defmodule MurkyWeb.EditLive do
    use MurkyWeb, :live_view
    alias Murky.Data

    def mount(params, _session, socket) do
        IO.inspect(params)
        filename = Map.get(params,"file")
        raw_md = File.read!("wiki/" <> filename)
        md = Murky.Data.get_md(filename)
        socket = socket
            |> assign(raw_md: raw_md)
            |> assign(md: md)
            |> assign(raw_md_new: raw_md)
            |> assign(filename: filename)
       {:ok, socket}
    end

    def handle_event("update", value, socket) do
        raw_md = Map.get(value, "value")
        md = Earmark.as_html!(raw_md)
        {:noreply, assign(socket, raw_md_new: raw_md, md: md)}
    end

    def handle_event("save", value, socket) do
        IO.inspect(socket.assigns.raw_md_new)
        Data.save_file(socket.assigns.filename, socket.assigns.raw_md_new)
        {:noreply, socket}
    end
end