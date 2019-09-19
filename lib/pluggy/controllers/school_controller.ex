defmodule Pluggy.Schools do
  defstruct(id: nil, name: "")
  alias Pluggy.Schools
  def to_struct([id, name]) do
    %Schools{id: id, name: name}
  end
  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Schools{id: id, name: name}
  end
end
