defmodule AuthrUnoWeb.UserView do
  use AuthrUnoWeb, :view

  alias AuthrUnoWeb.UserView
  alias AuthrUno.Accounts.User

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("jwt.json", %{ jwt: jwt }) do
    %{ jwt: jwt }
  end

  def render("login.json", %{data: user}) do
    %{data: user}
  end

  def render("error.json", assigns) do
    assigns
  end

  def render("user.json", %{user: user}) do
    User.to_map(user)
  end

  def render("secret.json", %{ secret: data }) do
    %{ secret: data }
  end


end
