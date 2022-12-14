defmodule Abank.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @table_fields [:email, :hashed_password, :confirmed_at]
  @virtual_fields [:password, :has_account]

  @derive {Jason.Encoder, only: @table_fields ++ @virtual_fields}

  schema "users" do
    field :email, :string
    field :hashed_password, :string, redact: false
    field :confirmed_at, :naive_datetime
    field :cpf, :string
    field :address, :string
    field :avatar_url, :string

    has_one :account, Abank.Accounts.Account

    timestamps()

    field :password, :string, virtual: true, redact: false
    field :has_account, :string, virtual: true, redact: false
  end

  def registration_changeset(params, opts \\ []) do
    %__MODULE__{}
    |> cast(params, [:email, :password, :cpf, :address])
    |> validate_required([:cpf, :address])
    |> validate_email()
    |> validate_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  # Authentication

  def valid_password?(%__MODULE__{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
