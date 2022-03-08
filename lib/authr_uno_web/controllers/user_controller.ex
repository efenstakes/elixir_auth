defmodule AuthrUnoWeb.UserController do
  use AuthrUnoWeb, :controller

  alias AuthrUno.Accounts
  alias AuthrUno.Accounts.User

  alias AuthrUno.Guardian

  action_fallback AuthrUnoWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do

      case Guardian.encode_and_sign(user) do
        {:ok, token, claims} ->
          IO.inspect("claims")
          IO.inspect(claims)
          render(conn, "jwt.json", jwt: token)
        _->
          render(conn, "error.json", message: "Server Error")
      end
    end
  end


  def login( conn, %{ "user"=> user_params } ) do
    case Accounts.login_user(user_params) do
      { :ok, user }->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        user = %User { user | jwt: token, password: nil }
        render( conn, "show.json", user: user )
      _->
        render( conn, "login.json", data: "no" )
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end


  def secret(conn, _params) do
    render(conn, "secret.json", secret: "yes")
  end


end
