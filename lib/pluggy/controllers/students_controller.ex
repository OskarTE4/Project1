defmodule Pluggy.Students do
  defstruct(id: nil, name: "", group: "", img: nil)
  alias Pluggy.User
  alias Pluggy.Students
  alias Pluggy.Groups
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]
  def get(conn, id) do
    session_user = conn.private.plug_session["user_id"]
    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    gId = Postgrex.query!(DB, "SELECT id FROM groups WHERE id= $1", [String.to_integer(id)], pool: DBConnection.Poolboy)
    send_resp(conn, 200, srender("testGame", locals: %{user: current_user, group: gId}))
  end

  def api_get(conn, id) do
    class_list = Postgrex.query!(DB, "SELECT * FROM students WHERE groups = $1", [String.to_integer(id)], pool: DBConnection.Poolboy)
    group = Groups.to_struct_list(class_list.rows)
    |> Poison.encode!()
    send_resp(conn, 200, srender("testGame", group))

  end
  def to_struct([id, name, group, img]) do
    %Students{id: id, name: name, group: group, img: img}
  end
  def to_struct_list(rows) do
    for [id, name, group, img] <- rows, do:  %Students{id: id, name: name, group: group, img: img}
  end
end
