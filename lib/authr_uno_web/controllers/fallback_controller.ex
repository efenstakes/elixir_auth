defmodule AuthrUnoWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AuthrUnoWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AuthrUnoWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    # conn
    # |> put_status(:not_found)
    # |> put_view(AuthrUnoWeb.ErrorView)
    # |> render(:"404")
    conn
      |> put_status(:not_found)
      |> render("error.json", %{})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{ error: 403 })
  end

  def call(conn, _) do
    conn
      |> put_status(:not_found)
      |> render("error.json", %{})
  end

end