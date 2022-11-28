defmodule Abank.Cards do
  alias Abank.Cards.Card
  alias Abank.Accounts

  def create({:ok, params}) do
    params
    |> Card.changeset()
    |> Abank.Repo.insert()
    |> handle_create()
  end

  def create({:error, %{result: result, status: status}}) do
    {:error, %{result: result, status: status}}
  end

  def create(_) do
    {:error, %{result: "Something bad happened", status: 500}}
  end

  defp handle_create({:ok, %Card{}} = result), do: result
  defp handle_create({:error, result}), do: {:error, %{result: result, status: :bad_request}}

  def all(user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      {:ok, query} = Card.get_cards_by_account_number(account.number)

      cards = query |> Abank.Repo.all()

      if cards do
        {:ok, cards}
      else
        {:error, %{result: "No card found", status: 403}}
      end
    end
  end

  def new(%{"type" => type} = params, user) do
    with {:ok, account} <- Accounts.get_account_by_user(user) do
      expiration_year = Date.utc_today().year() + Enum.random(4..8)
      expiration_month = Enum.random(1..12)
      expiration_day = Enum.random(1..28)

      params =
        params
        |> Map.put("account_number", account.number)
        |> Map.put("cvc", Integer.to_string(Enum.random(100..999)))
        |> Map.put(
          "card_number",
          Integer.to_string(Enum.random(1_000_000_000_000_000..9_999_999_999_999_999))
        )
        |> Map.put("flag", "visa")
        |> Map.put("expiration_date", %Date{
          day: expiration_day,
          month: expiration_month,
          year: expiration_year
        })

      case type do
        "credit" ->
          params
          |> Map.put_new("limit_in_cents", account.max_limit)
          |> credit(account)
          |> create()

        "debit" ->
          params |> debit() |> create()

        _ ->
          {:error, %{result: "This type of card does not exist", status: 400}}
      end
    end
  end

  defp credit(%{"limit_in_cents" => limit_in_cents} = params, account) do
    if limit_in_cents <= account.max_limit do
      {:ok,
       params
       |> Map.put("invoice_due_day", 1)}
    else
      {:error,
       %{
         result:
           "Your card surpasses your account max_limit which is #{account.max_limit}, improve your credit score.",
         status: 400
       }}
    end
  end

  defp debit(params) do
    {:ok, params}
  end

  def get_card_by_number(number) do
    {:ok, query} = Card.get_card_by_number_query(number)

    card =
      query
      |> Abank.Repo.one()

    if card do
      {:ok, card}
    else
      {:error, %{result: "No card with that number found", status: 404}}
    end
  end
end
