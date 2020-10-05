defmodule MurkyWeb.PageLive do
  use MurkyWeb, :live_view
  use Phoenix.HTML
  alias Murky.Data
  alias MurkyWeb.Component

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
    <div id="page_live" class="flex flex-col">
      <div class="mx-2 mb-4 mt-2">
        <%= live_component @socket, Component.Button, action: "new_show", text: "add new file" %>
        </div>
      <div class="index-list">
        <ul class="flex flex-wrap list-none">
        <%= for f <- @list_of_files do %>
          <%= live_component @socket, Component.ListItem, filename: f %>
        <% end %>
        </ul>
      </div>
    </div>
    <%= if @show_new do %>
      <%= live_component @socket, Component.ModalContainer, close: "new_cancel" do %>
        <div class="space-y-4">
          <div class="">
            <div class="text-lg">Create new file</div>
          </div>
          <div class="">
            <input class="shadow focus:border-primary-200 border focus:border-b-8 appearance-none rounded py-1 px-3" phx-keyup="new_changed" type="text" placeholder="Filename" name="filename" value="<%= @new_filename %>"/>
          </div>
              <div class="text-red-800  <%= if !@new_error do %>invisible<% end %>">Filename contains invalid characters</div>
          <div class="flex space-x-2">
            <%= live_component @socket, Component.Button, action: "new_save", text: "save", primary: true %>
            <%= live_component @socket, Component.Button, action: "new_cancel", text: "cancel" %>
          </div>
        </div>
      <% end %>
    <% end %>

    <%= if @show_confirm_delete do %>
      <%= live_component @socket, Component.ModalContainer, close: "close-delete-file" do %>
        <%= live_component @socket, Component.DeleteFile, filename: @filename_to_delete %>
      <% end %>
    <% end %>
    """
  end
end
