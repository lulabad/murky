defmodule MurkyWeb.PageLive do
  use MurkyWeb, :live_view
  use Phoenix.HTML
  alias Murky.Data

  @defaults %{
    show_new: false,
    show_confirm_delete: false,
    filename_to_delete: "",
    list_of_files: [],
    new_filename: "",
    new_error: false
  }

  @impl true
  def mount(_params, _session, socket) do
    list_of_files = Data.get_files()
    {:ok, assign(socket, Map.merge(@defaults, %{list_of_files: list_of_files}))}
  end

  @impl true
  def handle_event("new_save", _, socket) do
    case Data.filename_valid?(socket.assigns.new_filename) do
      false ->
        {:noreply, assign(socket, new_error: true)}

      _ ->
        Data.create_file(socket.assigns.new_filename)
        list_of_files = Data.get_files()

        {:noreply,
         assign(socket, show_new: false, list_of_files: list_of_files, new_filename: "")}
    end
  end

  def handle_event("new_show", _, socket) do
    {:noreply, assign(socket, show_new: true)}
  end

  def handle_event("new_cancel", _, socket) do
    {:noreply, assign(socket, show_new: false, new_filename: "", new_error: false)}
  end

  def handle_event("new_changed", %{"key" => "Enter"}, socket) do
    handle_event("new_save", nil, socket)
  end

  def handle_event("new_changed", %{"key" => _, "value" => value}, socket) do
    {:noreply, assign(socket, new_filename: value, new_error: !Data.filename_valid?(value))}
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
        <button phx-click="new_show" class="btn">add new file</button>
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
      <%= live_component @socket, MurkyWeb.Component.ModalContainer, close: "new_cancel" do %>
        <div class="new">
          <div class="new__row">
            <div class="new__title">Create new file</div>
          </div>
          <div class="new__row">
            <input phx-keyup="new_changed" type="text" placeholder="Filename" name="filename" value="<%= @new_filename %>"/>
          </div>
          <%= if @new_error do %>
            <div class="new__row">
              <div class="new__error">Filename contains invalid characters</div>
            </div>
          <% end %>
          <div class="new__row">
            <button phx-click="new_save" class="btn btn-primary">save</button>
            <button phx-click="new_cancel" class="btn">cancel</button>
          </div>
        </div>
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
