defmodule Pluggy.TeacherController do
  require IEx

  alias Pluggy.User
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def home(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

      id = current_user.id

      #TODO change this to a JOIN query instead of two SQL querys

      connection = Postgrex.query!(DB, "SELECT school_id FROM teachers_schools WHERE teacher_id = $1", [id], pool: DBConnection.Poolboy)

      groups = Enum.map(connection, &(Postgrex.query!(DB, "SELECT * FROM groups WHERE school = $1", [&1], pool: DBConnection.Poolboy)))

      send_resp(conn, 200, srender("teacher/home", groups))
  end

  def play(conn), do: send_resp(conn, 200, srender("teacher/play", []))

end
