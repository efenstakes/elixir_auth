defmodule AuthrUnoWeb.Token do
  use Joken.Config

  alias AuthrUnoWeb.Token
  alias AuthrUno.Accounts.User


  def generate_jwt(user) do
    user_map = User.to_map(user)

    {:ok, token, _claims} = Token.generate_and_sign(%{ user: user_map })
    token
  end

  def get_token(conn) do
    with [ "Bearer " <> jwt ] <- Plug.Conn.get_req_header(conn, "authorization") do
      {:ok, jwt}
    else
      _-> :error
    end
  end

  def get_user(conn) do
    with { :ok, jwt } <- get_token(conn), {:ok, claims} <- Token.verify_and_validate(jwt) do
      IO.inspect("get_user claims")
      IO.inspect(claims)
      usr = Map.get(claims, "user", nil)
      IO.inspect("get_user usr")
      IO.inspect(usr)
    else
      _-> nil
    end
  end

end
