defmodule AuthrUno.Repo do
  use Ecto.Repo,
    otp_app: :authr_uno,
    adapter: Ecto.Adapters.MyXQL
end
