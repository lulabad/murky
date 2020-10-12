defmodule MurkyWeb.EditLive do
  use MurkyWeb, :live_view
  alias Murky.Data
  alias MurkyWeb.Router.Helpers, as: Routes
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

  def handle_event("phx-dropzone", [event, payload], socket) do
    socket |> handle_drop(event, payload) |> drop_replay
  end

  defp drop_replay(socket = %{assigns: %{filetarget: filetarget, file_data: %{id: id}}}) do
    replay_message = "![" <> id <> "](" <> filetarget <> ")"

    socket = %{
      socket
      | assigns: Map.delete(socket.assigns, :filetarget),
        changed: Map.put_new(socket.changed, :filetarget, true)
    }

    {:noreply, push_event(socket, "uploaded", %{image_link_md: replay_message})}
  end

  defp drop_replay(socket) do
    {:noreply, socket}
  end

  defp handle_drop(socket, "generate-url", payload) do
    id = Map.get(payload, "id")

    assign(socket,
      file_data: %{
        id: id,
        url: Routes.upload_path(MurkyWeb.Endpoint, :update, id)
      }
    )
  end

  defp handle_drop(socket, "file-status", %{"status" => "Done", "id" => id, "name" => name}) do
    ext = Path.extname(name)
    path = &(Data.get_storage_path() |> Path.join(&1))

    source = path.(id)
    new_name = id <> ext
    target = path.(new_name)

    File.rename!(source, target)
    assign(socket, filetarget: "/files/" <> new_name)
  end

  defp handle_drop(socket, "file-status", _) do
    socket
  end

  defp buttons() do
    [
      %MenuEntry{name: "Save", action: "save", prominent: true, icon: "edit"},
    ]
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="mx-6 flex flex-col h-full ">
      <div class="flex mb-10 mt-4 ">
        <div class="mr-6 text-xl border-b-4 border-primary-200 px-2"><%= @filename %></div>
        <div class="flex-grow"></div>
        <%= live_component @socket, PhoenixLiveViewDropzone, file_data: @file_data %>
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
