defmodule Pluggy.Groups do
  defstruct(id: nil, name: "", group: nil, school: nil, img: nil)
  alias Pluggy.Groups
  def to_struct([id, name, group, school, img]) do
    %Groups{id: id, name: name, group: group, school: school, img: img}
  end
  def to_struct_list(rows) do
    for [id, name, group, school, img] <- rows, do:  %Groups{id: id, name: name, group: group, school: school, img: img}
  end
end
