defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.PageLoader
  alias Pluggy.UserController
  alias Pluggy.Schools
  alias Pluggy.User
  alias Pluggy.AdminController
  alias Pluggy.TeacherController
  alias Pluggy.GameController

  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get("/", do: PageLoader.index(conn))
  get("/error", do: PageLoader.error(conn))
  get("/teacher/home", do: TeacherController.home(conn))
  get("/teacher/group/:id", do: GameController.showG(conn, id))
  get("/admin/new", do: AdminController.nt(conn))
  get("/admin/home", do: AdminController.home(conn))
  get("/admin/schools", do: AdminController.ns(conn))
  get("/admin/students", do: AdminController.nst(conn))
  get("/admin/groups", do: AdminController.ng(conn))
  get("/admin/teacher/:schools", do: AdminController.schools(conn))
  get("/teacher/1A", do: PageLoader.a1(conn))
  get("/teacher/2A", do: PageLoader.a2(conn))
  get("/teacher/3A", do: PageLoader.a3(conn))
  get("/teacher/1quiz", do: PageLoader.q1(conn))
  get("/teacher/2quiz", do: PageLoader.q2(conn))


  post("/logout", do: UserController.logout(conn))
  post("/login", do: UserController.login(conn, conn.body_params))
  post("/delete_school", do: Schools.delete(conn, conn.body_params))
  post("/delete_teacher", do: User.delete(conn, conn.body_params))
  post("/newT", do: TeacherController.add_new(conn, conn.body_params))
  post("/newS", do: AdminController.add_new(conn, conn.body_params))
  post("/newG", do: AdminController.new_group(conn, conn.body_params))
  post("/newSt", do: AdminController.new_student(conn, conn.body_params))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
