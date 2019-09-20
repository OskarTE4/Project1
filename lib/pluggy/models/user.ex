defmodule Pluggy.User do
  defstruct(id: nil, username: "")
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]
  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, name FROM teachers WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.Poolboy
    ).rows
    |> to_struct
  end

  def to_struct([]), do: %User{}
  def to_struct([[id, username]]) do
    %User{id: id, username: username}
  end
  def to_struct_list(rows) do
    for [id, name] <- rows, do: %User{id: id, username: name}
  end
  def delete(conn, params) do
     # get user if logged in
     session_user = conn.private.plug_session["user_id"]

     current_user =
       case session_user do
         nil -> nil
         _ -> User.get(session_user)
       end
    teacher_id = String.to_integer(params["teacher_id"])
    Postgrex.query!(DB, "DELETE FROM teachers WHERE id = $1", [teacher_id], pool: DBConnection.Poolboy)
    teachers = Postgrex.query!(DB, "SELECT * FROM teachers", [], pool: DBConnection.Poolboy)
    send_resp(conn, 200, srender("/admin/home", locals: %{user: current_user, teachers: teachers}))
  end
end
