defmodule MurkyWeb.Component.DeleteFile do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="flex flex-col">
      <div class="mb-1 text-lg">Do you really want to delete the file <span class="font-black text-primary-500">'<%= @filename %>'</span>?</div>
      <div class="mb-6 text-primary-100">This cannot be undone.</div>
      <div class="flex space-x-2">
        <%= live_component @socket, MurkyWeb.Component.Button, action: "delete-file", text: "delete file", primary: true %>
        <%= live_component @socket, MurkyWeb.Component.Button, action: "close-delete-file", text: "cancel" %>
      </div>
    </div>

    """
  end
end
