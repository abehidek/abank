defmodule Abank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:number, :balance_in_cents, :score, :user_id]

  @derive {Jason.Encoder, only: @fields ++ [:id]}

  schema "accounts" do
    field :number, :string
    field :balance_in_cents, :integer, default: 0
    field :score, :integer, default: 50

    belongs_to :user, Abank.Auth.User, foreign_key: :user_id, references: :id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:number, :user_id])
    |> unique_constraint([:user_id])
  end
end
