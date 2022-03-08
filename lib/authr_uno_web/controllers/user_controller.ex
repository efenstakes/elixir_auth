defmodule AuthrUnoWeb.UserController do
  use AuthrUnoWeb, :controller

  alias AuthrUno.Accounts
  alias AuthrUno.Accounts.User

  alias AuthrUnoWeb.Token

  action_fallback AuthrUnoWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do

      token = Token.generate_jwt(user)
      render(conn, "jwt.json", jwt: token)

      # case Token.generate_jwt(user) do
      #   {:ok, token, claims} ->
      #     IO.inspect("claims")
      #     IO.inspect(claims)
      #     render(conn, "jwt.json", jwt: token)
      #   _->
      #     render(conn, "error.json", message: "Server Error")
      # end
    end
  end


  def login( conn, %{ "user"=> user_params } ) do
    case Accounts.login_user(user_params) do
      { :ok, user }->
        token = Token.generate_jwt(user)
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


  def my_profile(conn, _params) do
    case Token.get_user(conn) do
      %User{} = user->
        render(conn, "show.json", user: user)
      _->
        render(conn, "error.json", error: "no user")
    end
  end

  def secret(%Plug.Conn{ assigns: assigns } = conn, _params) do
    case Map.get(assigns, :user, nil) do
      nil-> render(conn, "error.json", error: "no user")
      user->
        user = User.from_map(user)
        render(conn, "show.json", user: user)
    end
  end

  def zen(%Plug.Conn{ assigns: assigns } = conn, _params) do
    user = Map.get(assigns, :user, nil)

    # IO.inspect("user")
    # IO.inspect(user)

    user = User.from_map(user)

    # IO.inspect("user")
    # IO.inspect(user)

    render(conn, "show.json", user: user)
  end


end
