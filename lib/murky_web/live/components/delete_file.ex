defmodule MurkyWeb.Component.DeleteFile do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="flex flex-col">
      <div class="mb-4 text-lg">Do you really want to delete the file <span class="font-black">'<%= @filename %>'</span>?</div>
      <div>
        <%= live_component @socket, MurkyWeb.Component.Button, action: "delete-file", text: "delete file", primary: true %>
        <%= live_component @socket, MurkyWeb.Component.Button, action: "close-delete-file", text: "cancel" %>
      </div>
    </div>

    """
  end
end
