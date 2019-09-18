defmodule Pluggy.Class do
  defstruct(id: nil, name: "", group_id: nil, image: "")
  alias Pluggy.Class
  def to_struct([id, name, group_id, image]) do
    %Class{id: id, name: name, group_id: group_id, image: image}
  end
  def to_struct_list(rows) do
    for [id, name, group_id, image] <- rows, do: %Class{id: id, name: name, group_id: group_id, image: image}
  end
end
