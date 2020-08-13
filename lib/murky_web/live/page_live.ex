defmodule MurkyWeb.PageLive do
  use MurkyWeb, :live_view
  use Phoenix.HTML
  alias Murky.Data

  @defaults %{
    show_new: false,
    show_confirm_delete: false,
    filename_to_delete: "",
    list_of_files: []
  }

  @impl true
  def mount(_params, _session, socket) do
    list_of_files = Data.get_files()
    {:ok, assign(socket, Map.merge(@defaults, %{list_of_files: list_of_files}))}
  end

  @impl true
  def handle_event("save", value, socket) do
    Data.create_file(Map.get(value, "filename"))
    list_of_files = Data.get_files()
    {:noreply, assign(socket, show_new: false, list_of_files: list_of_files)}
  end

  def handle_event("add_md", _, socket) do
    {:noreply, assign(socket, show_new: true)}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, assign(socket, show_new: false)}
  end

  def handle_event("to-view", %{"filename" => filename}, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.live_path(socket, MurkyWeb.ViewLive, file: filename))}
  end

  def handle_event("try-delete-file", %{"filename" => filename}, socket) do
    {:noreply, assign(socket, show_confirm_delete: true, filename_to_delete: filename)}
  end

  def handle_event("close-delete-file", _, socket) do
    {:noreply, assign(socket, show_confirm_delete: false, filename_to_delete: "")}
  end

  def handle_event("delete-file", _, socket) do
    Data.delete_file(socket.assigns.filename_to_delete)
    list_of_files = Data.get_files()
    {:noreply, assign(socket, list_of_files: list_of_files, show_confirm_delete: false)}
  end

  def handle_event("edit-file", %{"filename" => filename}, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.live_path(socket, MurkyWeb.EditLive, file: filename))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="index-page">
      <h2 class="index-page__title">Index
        <button phx-click="add_md" class="btn">add new file</button>
      </h2>
      <div class="index-list">
        <ul>
        <%= for f <- @list_of_files do %>
          <%= live_component @socket, MurkyWeb.Component.ListItem, filename: f %>
        <% end %>
        </ul>
      </div>
    </div>
    <%= if @show_new do %>
      <%= live_component @socket, MurkyWeb.Component.ModalContainer, close: "cancel" do %>
        <form phx-submit="save" >
          <input type="text" placeholder="new name" name="filename"/>
          <button class="btn">save</button>
        </form>
        <button phx-click="cancel" phx-value-button="cancel" class="btn">cancel</button>
      <% end %>
    <% end %>

    <%= if @show_confirm_delete do %>
      <%= live_component @socket, MurkyWeb.Component.ModalContainer, close: "close-delete-file" do %>
        <%= live_component @socket, MurkyWeb.Component.DeleteFile, filename: @filename_to_delete %>
      <% end %>
    <% end %>
    """
  end
end
