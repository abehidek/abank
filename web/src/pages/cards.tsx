import { useQuery } from "@tanstack/react-query";
import type { NextPage } from "next";
import { api, requestInit } from "../auth/AuthContext";
import { useAuth } from "../auth/useAuth";
import Card from "../components/Card";
import CreateAccount from "../components/CreateAccount";
import CreateCard from "../components/CreateCard";
import Loading from "../components/Loading";

interface Card {
  account_number: string;
  card_number: string;
  id: number;
  type: "debit" | "credit";
  flag: "visa" | "mastercard";
  expiration_date: string;
  cvc: string;
}

interface CardsQuery {
  cards: Card[];
}

const Cards: NextPage = () => {
  const { user, account, isUserError, isUserLoading } = useAuth();
  const { data, isLoading, isError } = useQuery<CardsQuery>(["cards"], () =>
    fetch(api + "/cards", { ...requestInit }).then((res) => res.json())
  );

  if (isUserLoading || isLoading) return <Loading />;

  if (isUserError || isError) return <p>Error...</p>;

  if (!user) return <p>Sign In pls</p>;

  if (!account) return <CreateAccount />;

  if (!data.cards) return <p>No cards</p>;

  return (
    <div>
      <CreateCard />
      <h2>Debit cards</h2>
      <div className="flex flex-col gap-6">
        {data.cards
          .filter((card) => card.type == "debit")
          .map((card) => (
            <div key={card.id}>
              <Card
                name={user.email}
                cvv={card.cvc}
                expiry={card.expiration_date}
                number={card.card_number}
                type={card.type}
              />
            </div>
          ))}
      </div>
      <h2>Credit cards</h2>
      <div className="flex flex-col gap-6">
        {data.cards
          .filter((card) => card.type == "credit")
          .map((card) => (
            <div key={card.id}>
              <Card
                name={user.email}
                cvv={card.cvc}
                expiry={card.expiration_date}
                number={card.card_number}
                type={card.type}
              />
            </div>
          ))}
      </div>
    </div>
  );
};

export default Cards;
