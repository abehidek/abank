defmodule Abank.Auth.UserSession do
  use Ecto.Schema
  import Ecto.Query

  @hash_algo :sha256
  @rand_size 32

  @session_validity_in_days 60

  schema "users_session" do
    field :token, :binary
    belongs_to :user, Abank.Auth.User

    timestamps(updated_at: false)
  end

  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)

    {token,
     %__MODULE__{
       token: token,
       user_id: user.id
     }}
  end

  def validate_max_sessions_query(user) do
    query =
      from session in Abank.Auth.UserSession,
        where: session.user_id == ^user.id,
        select: count()

    {:ok, query}
  end

  def verify_session_token_query(token) do
    query =
      from token in get_token(token),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  def get_token(token) do
    from __MODULE__, where: [token: ^token]
  end
end
