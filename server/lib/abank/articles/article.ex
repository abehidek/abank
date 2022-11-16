defmodule Abank.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:title, :content, :draft, :author]

  @derive {Jason.Encoder, only: @required_fields}

  schema "articles" do
    field :title, :string
    field :content, :string
    field :draft, :boolean

    belongs_to :user, Abank.Auth.User, foreign_key: :author, references: :id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
