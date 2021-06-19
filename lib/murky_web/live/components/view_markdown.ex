defmodule MurkyWeb.ViewMarkdown do
  use Phoenix.LiveComponent

  def render(assigns) do
    raw_md = Phoenix.HTML.raw(assigns.rendered_markdown)

    ~L"""
        <div class="markdown" phx-hook="MarkdownPreview" id="markdown-preview">
            <%= raw_md %>
        </div>
    """
  end
end
