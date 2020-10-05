defmodule Murky.MenuEntry do
  @enforce_keys [:name, :action]
  defstruct [:name,  :action, :icon, prominent: false]

  @type t :: %Murky.MenuEntry{name: string, action: string}

  def all_prominent(data) do
    Enum.filter(data, fn x -> x.prominent end)
  end
end
