defmodule MurkyWeb.PageLive do
  use MurkyWeb, :live_view
  use Phoenix.HTML
  alias Murky.Data


  @impl true
  def mount(_params, _session, socket) do
    list_of_files = Data.get_files()
    {:ok, assign(socket, list_of_files: list_of_files, show_new: false)}
  end

  def handle_event("save", value, socket) do
    Data.create_file(Map.get(value, "filename"))
    list_of_files = Data.get_files()
    {:noreply, assign(socket, show_new: false, list_of_files: list_of_files)}
  end

  def handle_event("add_md", _value, socket) do
    {:noreply, assign(socket, show_new: true)}
  end

  def handle_event("cancel", _value, socket) do
    {:noreply, assign(socket, show_new: false)}
  end

end
