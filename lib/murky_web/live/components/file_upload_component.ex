defmodule MurkyWeb.Component.FileUpload do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <section id="drop-target" phx-drop-target="<%= @uploads.attachements.ref %>">
      <form id="upload-form" phx-submit="upload_attachements" phx-change="validate">
        <%= live_file_input @uploads.attachements %>
      </form>
      Drop a file
    </section>
    """
  end
end
