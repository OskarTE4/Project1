defmodule Pluggy.GameController do

  alias Pluggy.Class
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def showG(conn, id) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    group_id = Postgrex.query!(DB, "SELECT id FROM groups WHERE school = $1", [id], pool: DBConnection.Poolboy)
    group = Postgrex.query!(DB, "SELECT * FROM students WHERE group_id = $1", [group_id], pool: DBConnection.Poolboy)
    names = Postgrex.query!(DB, "SELECT name FROM students WHERE group_id = $1", [group_id], pool: DBConnection.Poolboy)
    class_list = Class.to_struct_list(group.rows)

    send_resp(conn, 200, srender("teacher/play", locals: %{user: current_user, students: class_list, name: names}))

  end

end
