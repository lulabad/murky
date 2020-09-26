defmodule MurkyWeb.EditLive do
  use MurkyWeb, :live_view
  alias Murky.Data

  @impl true
  def mount(params, _session, socket) do
    filename = Map.get(params, "file")

    raw_md = filename |> Data.get_raw_md()
    md = filename |> Murky.Data.get_md()

    socket =
      socket
      |> assign(raw_md: raw_md)
      |> assign(md: md)
      |> assign(raw_md_new: raw_md)
      |> assign(filename: filename)

    {:ok, socket}
  end

  @impl true
  def handle_event("update", value, socket) do
    raw_md = Map.get(value, "value")
    md = Earmark.as_html!(raw_md)
    {:noreply, assign(socket, raw_md_new: raw_md, md: md)}
  end

  def handle_event("save", _value, socket) do
    Data.save_file(socket.assigns.filename, socket.assigns.raw_md_new)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="mx-6 flex flex-col h-full ">
      <div class="flex mb-10 mt-4 ">
        <div class="mr-6 text-xl border-b-4 border-primary-200 px-2"><%= @filename %></div>
        <div class="flex-grow"></div>
        <%= live_component @socket, MurkyWeb.Component.Button, action: "save", text: "save" %>
      </div>
      <div class="h-full relative">
        <div id="blub" class="flex absolute inset-0">
          <div class="flex-grow h-full relative">
          <%= live_component @socket, MurkyWeb.MonacoComponent, id: "monaco", raw_md: @raw_md %>
          </div>
          <div class="overflow-y-scroll h-full w-2/4">
            <%= live_component @socket, MurkyWeb.ViewMarkdown, rendered_markdown: @md  %>
          </div>
        </div>
      </div>
    </div>

    """
  end
end
