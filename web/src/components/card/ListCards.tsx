import { Card } from "./Card";

import type { CardDTO } from "../../pages/app/cards";
import type { User } from "../../auth/AuthContext";
import { Heading } from "../Heading";
import { Text } from "../Text";

interface ListCardsProps {
  cards: CardDTO[] | undefined;
  user: User;
  type: "Debit" | "Credit";
}

export function ListCards({ cards, user, type }: ListCardsProps) {
  return (
    <div className="flex flex-col gap-6">
      <Heading size="md">{type} cards</Heading>
      {cards && cards.length !== 0 ? (
        <>
          {cards.map((card) => (
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
        </>
      ) : (
        <Text>No {type} cards found for this account</Text>
      )}
    </div>
  );
}
