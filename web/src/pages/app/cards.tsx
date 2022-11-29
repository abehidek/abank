import { useQuery } from "@tanstack/react-query";
import type { NextPage } from "next";
import { useRouter } from "next/router";
import { api, requestInit } from "../../auth/AuthContext";
import { useAuth } from "../../auth/useAuth";
import Card from "../../components/Card";
import CreateAccount from "../../components/CreateAccount";
import CreateCard from "../../components/CreateCard";
import ListCards from "../../components/ListCards";
import Loading from "../../components/Loading";
import AppLayout from "../../layouts/AppLayout";

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
  const { user, account, isUserError, error, isUserLoading } = useAuth();
  const router = useRouter();
  const {
    data,
    isLoading,
    isError,
    error: cardError,
  } = useQuery<CardsQuery>(["cards"], () =>
    fetch(api + "/cards", { ...requestInit }).then((res) => res.json())
  );

  if (isUserLoading || isLoading) return <Loading />;

  if (isUserError || isError) {
    console.error(error);
    console.error(cardError);
    return <p>Error...</p>;
  }

  if (!user) {
    router.push("/signin");
    return <></>;
  }

  if (!account) return <CreateAccount />;

  const debitCards = data.cards
    ? data.cards.filter((card) => card.type == "debit")
    : undefined;
  const creditCards = data.cards
    ? data.cards.filter((card) => card.type == "credit")
    : undefined;

  return (
    <AppLayout>
      <CreateCard />
      {data.cards ? (
        <div>
          <ListCards cards={debitCards} type="Debit" user={user} />
          <ListCards cards={creditCards} type="Credit" user={user} />
        </div>
      ) : (
        <p>No cards found</p>
      )}
    </AppLayout>
  );
};

export default Cards;
