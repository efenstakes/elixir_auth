defmodule AuthrUno.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :authr_uno,
          module: AuthrUno.Guardian,
          error_handler: AuthrUno.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
