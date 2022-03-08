defmodule AuthrUno.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  alias AuthrUno.Accounts.User



  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    # virtuals
    field :plain_password, :string, virtual: true
    field :jwt, :string, virtual: true

    timestamps()
  end

  @doc false
  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :plain_password])
    |> validate_required([:name, :email, :plain_password])
    |> unique_constraint(:email)
    |> hash_password
  end

  @doc false
  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :plain_password])
    |> validate_required([:email, :plain_password])
  end



  def hash_password( %Ecto.Changeset{ valid?: true, changes: %{ plain_password: plain_password } } = changeset ) do
    %{ password_hash: hash } = Pbkdf2.add_hash(plain_password)

    put_change( changeset, :password, hash )
  end

  def hash_password( changeset ), do: changeset


  def verify_password( plain_password, hashed_password ) do
    case Pbkdf2.check_pass(%{ password_hash: hashed_password }, plain_password) do
      {:ok, _}->   true
      _->          false
    end
  end

  def to_map(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      jwt: user.jwt
    }
  end
  def to_map(_), do: nil


  def from_map(%{ "name"=> name, "email"=> email } = user) do
    %User{
      id: Map.get(user, "id", nil),
      name: name,
      email: email,
      password: Map.get(user, "id", nil),
      jwt: Map.get(user, "jwt", nil)
    }
  end
  def from_map(_), do: %User{}

end
