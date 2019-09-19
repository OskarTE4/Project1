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

      grouplist = Enum.map(connection, &(Postgrex.query!(DB, "SELECT * FROM groups WHERE school = $1", [&1], pool: DBConnection.Poolboy)))

      send_resp(conn, 200, srender("teacher/home", locals: %{user: current_user, groups: grouplist}))
  end

  @spec add_new(Plug.Conn.t(), nil | keyword | map) :: Plug.Conn.t()
  def add_new(conn, params) do
    Postgrex.query!(DB, "INSERT INTO teachers (name, password, rights)
                        VALUES('#{params["name"]}', '#{params["pwd"]}', false)",
                        [],
                        pool: DBConnection.Poolboy)
    list = Postgrex.query!(DB, "SELECT id FROM teachers WHERE name = $1", [params["name"]], pool: DBConnection.Poolboy)
    id = Enum.at(list.rows, 0) |> Enum.at(0)
    IO.inspect params["school"]
    Postgrex.query!(DB, "INSERT INTO teachers_schools (teacher_id, school_id)
                        VALUES('#{id}', '#{params["school"]}')", [], pool: DBConnection.Poolboy)
    redirect(conn, "/admin/home")
  end
  @spec play(Plug.Conn.t()) :: Plug.Conn.t()
  def play(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
   send_resp(conn, 200, srender("teacher/play", user: current_user))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
