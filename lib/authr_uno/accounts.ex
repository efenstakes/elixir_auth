defmodule AuthrUno.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias AuthrUno.Repo

  alias AuthrUno.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end



  def login_user(attrs \\ %{}) do
    # case User.login_changeset(%User{}, attrs) do
    #   %Ecto.Changeset { valid?: true, changes: %{ email: email } } ->

    #     case Repo.get_by(User, email: attrs["email"] ) do

    #       %User{} = user->
    #         case User.verify_password( user.password, %{ password_hash: attrs["plain_password"] } ) do
    #           { :ok, _ }-> { :ok, user }
    #           _-> { :error, "Bad Details" }
    #         end

    #       _-> { :error, "Bad Details" }

    #     end

    #   _ ->
    #     { :error, "Bad Details" }
    # end

    # with
    #   %Ecto.Changeset { valid?: true, changes: %{ email: email } } <- User.login_changeset(%User{}, attrs),
    #   { :ok, user } <- get_user_by_email(email),
    #   { :ok, _ } <- User.verify_password( user.password, %{ password_hash: attrs["plain_password"] } ) do
    #     {:ok, user}
    # else
    #   { :error, "Wrong Details" }
    # end
    # :ok

    with %Ecto.Changeset{ valid?: true, changes: %{ email: email } } <- User.login_changeset(%User{}, attrs), { :ok, user } <- get_user_by_email(email), true <- User.verify_password( attrs["plain_password"], user.password ) do
      {:ok, user}
    else

      _-> { :error, "Wrong Details" }
    end

  end


  def get_user_by_email(email) do
    case Repo.get_by(User, email: email ) do
      %User{} = user-> { :ok, user }
      _-> { :error, "Bad Details" }
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.register_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.register_changeset(user, attrs)
  end
end
