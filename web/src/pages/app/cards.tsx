import { useQuery } from "@tanstack/react-query";
import type { NextPage } from "next";
import { api, requestInit } from "../../auth/AuthContext";
import { CreateCard } from "../../components/card/CreateCard";
import { ListCards } from "../../components/card/ListCards";
import { Loading } from "../../components/Loading";
import { Error } from "../../components/Error";
import AppLayout from "../../layouts/AppLayout";
import { Heading } from "../../components/Heading";
import { Text } from "../../components/Text";

export interface CardDTO {
  account_number: string;
  card_number: string;
  id: number;
  type: "debit" | "credit";
  flag: "visa" | "mastercard";
  expiration_date: string;
  cvc: string;
}

interface CardsQuery {
  cards: CardDTO[] | undefined;
}

const Cards: NextPage = () => {
  const {
    data,
    isLoading,
    isError,
    error: cardError,
  } = useQuery<CardsQuery>(["cards"], () =>
    fetch(api + "/cards", { ...requestInit }).then((res) => res.json())
  );

  if (isLoading) return <Loading />;

  if (isError) {
    console.error(cardError);
    return <Error />;
  }
  const debitCards = data.cards
    ? data.cards.filter((card) => card.type == "debit")
    : undefined;
  const creditCards = data.cards
    ? data.cards.filter((card) => card.type == "credit")
    : undefined;

  return (
    <AppLayout>
      {({ user }) => {
        return (
          <div className="flex flex-col gap-4">
            <Heading size="lg">Your cards</Heading>
            <CreateCard />
            {data.cards ? (
              <div>
                <ListCards cards={debitCards} type="Debit" user={user} />
                <ListCards cards={creditCards} type="Credit" user={user} />
              </div>
            ) : (
              <Text>No cards found for this account</Text>
            )}
          </div>
        );
      }}
    </AppLayout>
  );
};

export default Cards;
