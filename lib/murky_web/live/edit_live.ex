defmodule MurkyWeb.EditLive do
  use MurkyWeb, :live_view
  alias Murky.Data
  alias MurkyWeb.Component
  alias Murky.MenuEntry

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
      |> assign(file_data: %{id: "", url: ""})
      |> allow_upload(:attachements,
        accept: ~w(.jpg .jpeg .png),
        progress: &handle_progress/3,
        auto_upload: true
      )

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

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  defp handle_progress(:attachements, entry, socket) do
    if entry.done? do
      uploaded_file =
        consume_uploaded_entry(socket, entry, fn %{path: path} ->
          file_extension = Path.extname(entry.client_name)
          new_filename = Path.basename(path) <> file_extension
          dest = Data.get_storage_path() |> Path.join(new_filename)
          File.cp!(path, dest)
          new_filename
        end)

      replay_message = "![" <> uploaded_file <> "](/files/" <> uploaded_file <> ")"

      {:noreply, push_event(socket, "uploaded", %{image_link_md: replay_message})}
    else
      {:noreply, socket}
    end
  end

  defp buttons() do
    [
      %MenuEntry{name: "Save", action: "save", prominent: true, icon: "edit"}
    ]
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="mx-6 flex flex-col h-full ">
      <div class="flex mb-10 mt-4 ">
        <div class="mr-6 text-xl border-b-4 border-primary-200 px-2"><%= @filename %></div>
        <div class="flex-grow"></div>
        <%= live_component @socket, Component.FileUpload, uploads: assigns.uploads %>
        <%= live_component @socket, Component.Menu, entries: buttons(), first_rounded: true %>
      </div>
      <div class="h-full relative">
        <div id="blub" class="flex absolute inset-0">
          <div class="flex-grow h-full relative">
          <%= live_component @socket, MurkyWeb.MonacoComponent, id: "monaco", raw_md: @raw_md %>
          </div>
          <div class="overflow-y-scroll h-full w-2/4">
            <%= live_component @socket, MurkyWeb.ViewMarkdown, rendered_markdown: @md  %>
          </div>
        </div>
      </div>
    </div>

    """
  end
end
