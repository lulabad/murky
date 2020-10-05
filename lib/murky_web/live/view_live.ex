defmodule MurkyWeb.ViewLive do
  use MurkyWeb, :live_view
  alias MurkyWeb.Component
  alias Murky.MenuEntry
  alias MurkyWeb.Router.Helpers

  @impl true
  def mount(params, _session, socket) do
    filename = Map.get(params, "file")
    md = Murky.Data.get_md(filename)
    {:ok, assign(socket, md: md, filename: filename)}
  end

  @impl true
  def handle_event("edit", _, socket) do
    {:noreply,
     push_redirect(
       socket,
       to: Routes.live_path(socket, MurkyWeb.EditLive, file: socket.assigns.filename)
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="px-6 ">
      <div class="flex mb-10 mt-4 ">
          <div class="mr-6 text-xl border-b-4 border-primary-200 px-2">
            <%= @filename %>
          </div>
          <div class="flex-grow"></div>
          <%= live_component @socket, Component.Menu, entries: [
            %MenuEntry{name: "Edit", action: "edit", prominent: true, icon: Helpers.static_path(@socket, "/images/edit-icon.svg")},
            %MenuEntry{name: "Rename", action: "show_rename"},
            %MenuEntry{name: "Delete", action: "show_delete"}
          ] %>
      </div>
      <div class="container mx-auto">
        <%= live_component @socket, MurkyWeb.ViewMarkdown, rendered_markdown: @md %>
      </div>
    </div>
    """
  end
end
