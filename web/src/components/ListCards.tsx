import Card from "./Card";

import type { CardDTO } from "../pages/app/cards";
import type { User } from "../auth/AuthContext";

interface ListCardsProps {
  cards: CardDTO[] | undefined;
  user: User;
  type: "Debit" | "Credit";
}

export default function ListCards({ cards, user, type }: ListCardsProps) {
  console.log(cards);
  return (
    <div className="flex flex-col gap-6">
      {cards && cards.length !== 0 ? (
        <>
          <h2>{type} cards</h2>
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
        <p>No {type} cards</p>
      )}
    </div>
  );
}
