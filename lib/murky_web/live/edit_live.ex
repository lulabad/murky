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
    <div class="edit-container">
      <h1>
          Live Edit
          <button phx-click="save" class="btn">save</button>
      </h1>
      <div class="edit-container__edit">
          <%= live_component @socket, MurkyWeb.MonacoComponent, id: "monaco", raw_md: @raw_md %>
          <div class="edit-container__preview">
              <%= live_component @socket, MurkyWeb.ViewMarkdown, rendered_markdown: @md  %>
          </div>
      </div>
    </div>

    """
  end
end
