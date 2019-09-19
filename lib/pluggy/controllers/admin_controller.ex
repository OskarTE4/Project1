defmodule Pluggy.AdminController do

  require IEx

  alias Pluggy.User
  alias Pluggy.Schools
  alias Pluggy.Groups
  import Pluggy.Template, only: [srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def home(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]
    #TODO: Ändra så att det kollas om användaren är en admin
    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
      IO.inspect current_user
      send_resp(conn, 200, srender("admin/home", user: current_user))
  end

  def nt(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

      schools = Postgrex.query!(DB, "SELECT * FROM schools", [], pool: DBConnection.Poolboy)
      schoollist = Schools.to_struct_list(schools.rows)
      IO.inspect schoollist
      send_resp(conn, 200, srender("admin/new", locals: %{user: current_user, schools: schoollist}))
  end

  def ns(conn) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    send_resp(conn, 200, srender("admin/schools", user: current_user))
  end

  def add_new(conn, params) do
      Postgrex.query!(DB, "INSERT INTO schools (name)
                          VALUES('#{params["name"]}')",
                          [],
                          pool: DBConnection.Poolboy)
      redirect(conn, "/admin/home")
  end

  def nst(conn) do
     # get user if logged in
     session_user = conn.private.plug_session["user_id"]

     current_user =
       case session_user do
         nil -> nil
         _ -> User.get(session_user)
       end
      groups_list =  Postgrex.query!(DB, "SELECT * FROM groups", [],  pool: DBConnection.Poolboy)
      groups = Groups.to_struct_list(groups_list.rows)

      school_list = Postgrex.query!(DB, "SELECT * FROM schools", [], pool: DBConnection.Poolboy)
      schools = Schools.to_struct_list(school_list.rows)
      send_resp(conn, 200, srender("admin/students", locals: %{user: current_user, groups: groups, schools: schools}))
  end
  def new_student(conn, params) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end

    dir = "../students/"
    img_path = "#{dir}" <> "#{params["img"]}"

    IO.inspect params["group"].to_i


    Postgrex.query!(DB, "INSERT INTO students (name, groups, school, image)
                        VALUES('#{params["name"]}', #{params["group"]}, #{params["school"]}, '#{img_path}')",
                        [],
                        pool: DBConnection.Poolboy)

    send_resp(conn, 200, srender("/admin/home", user: current_user))
  end

  def ng(conn) do
     # get user if logged in
     session_user = conn.private.plug_session["user_id"]

     current_user =
       case session_user do
         nil -> nil
         _ -> User.get(session_user)
       end

       send_resp(conn, 200, srender("admin/groups", user: current_user))
  end

  def new_group(conn, params) do
    # get user if logged in
    session_user = conn.private.plug_session["user_id"]

    current_user =
      case session_user do
        nil -> nil
        _ -> User.get(session_user)
      end
    IO.inspect params["school"]

    school = Postgrex.query!(DB, "SELECT id FROM schools WHERE name = $1", [params["school"]],  pool: DBConnection.Poolboy)
    id = Enum.at(school.rows, 0) |> Enum.at(0)
    Postgrex.query!(DB, "INSERT INTO groups (name, school, image)
    VALUES('#{params["name"]}', '#{id}', 'nil')",
    [],
    pool: DBConnection.Poolboy)

  send_resp(conn, 200, srender("/admin/home", user: current_user))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end
