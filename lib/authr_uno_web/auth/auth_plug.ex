defmodule AuthrUnoWeb.AuthPlug do
  import Plug.Conn

  alias AuthrUnoWeb.Token


  def init(opts), do: opts


  def call(conn, _params) do
    case Token.get_token(conn) do
      :error->
        assign(conn, :user, nil)
      { :ok, jwt }->

        case Token.verify_and_validate(jwt) do
          {:ok, claims}->
            IO.inspect("call claims")
            IO.inspect(jwt)
            IO.inspect("call claims")
            IO.inspect(claims)
            assign(conn, :user, Map.get(claims, "user", nil))
          error->
            IO.inspect("call fail")
            IO.inspect(error)
            assign(conn, :user, nil)
        end
    end
  end


end
