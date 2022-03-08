defmodule AuthrUnoWeb.MustAuthPlug do
  import Plug.Conn

  alias AuthrUnoWeb.Token


  def init(opts), do: opts


  def call(conn, _params) do
    case Token.get_token(conn) do
      { :ok, jwt } ->

        case Token.verify_and_validate(jwt) do
          {:ok, claims}->
            assign(conn, :user, Map.get(claims, "user", nil))
          _->
            send_resp(conn, 401, %{ error: 401 })
        end

      :error->
        send_resp(conn, 401, %{ error: 401 })
    end
  end


end
