defmodule AuthrUno.Guardian do
  use Guardian, otp_app: :authr_uno

  alias AuthrUno.Accounts.User

  def subject_for_token(user, _claims) do
    sub = User.to_map(user)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    resource = claims["sub"]
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
