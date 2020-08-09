defmodule MurkyWeb.ViewLive do
  use MurkyWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    filename = Map.get(params, "file")
    md = Murky.Data.get_md(filename)
    {:ok, assign(socket, md: md, filename: filename)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="markdown_view">
      <div class="markdown_view__header">
          <div class="markdown_view__title"><%= @filename %></div>
          <%= live_redirect "edit", to: Routes.live_path(@socket, MurkyWeb.EditLive, file: @filename), class: "btn"%>
      </div>
      <%= live_component @socket, MurkyWeb.ViewMarkdown, rendered_markdown: @md %>
    </div>
    """
  end
end
