defmodule AuthTutorialPhoenixWeb.UserController do
  use AuthTutorialPhoenixWeb, :controller

  alias AuthTutorialPhoenix.Accounts
  alias AuthTutorialPhoenix.Accounts.User

  action_fallback AuthTutorialPhoenixWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> text("User successfully registered with email:" <> " " <> user.email)
    end
  end



  # just added

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def showUserBy(conn, params) do

    if Map.has_key?(params, "email") do
      user = Accounts.get_user_by_email!(conn.query_params["email"])
      render(conn, "show.json", user: user)
    end

    if Map.has_key?(params, "first_name") do
      user = Accounts.get_user_by_first_name!(conn.query_params["first_name"])
      render(conn, "show.json", user: user)
    end

    if Map.has_key?(params, "email") and Map.has_key?(params, "first_name") do
      user =
        Accounts.get_user_by_email_and_first_name!(
          conn.query_params["email"],
          conn.query_params["first_name"]
        )
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_by_id!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_by_id!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

end
