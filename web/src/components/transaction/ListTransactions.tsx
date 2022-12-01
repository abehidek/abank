import { Currency } from "../Currency";
import { Heading } from "../Heading";
import { Text } from "../Text";
import { format } from "date-fns";

interface Transaction {
  type: string;
  amount_in_cents: number;
  status: string;
  description: string | null;
  from_account_number: string;
  to_account_number: string;
  card_number: string | null;
  id: number;
  inserted_at: string;
}

interface ListTransactionsProps {
  transactions: Transaction[] | undefined;
}

export function ListTransactions({ transactions }: ListTransactionsProps) {
  return (
    <div>
      <Heading size="lg">Transaction History</Heading>
      <ul className="flex flex-col gap-6">
        {!transactions || transactions.length === 0 ? (
          <Text>There is no transactions found in this accont</Text>
        ) : (
          transactions.map((transaction) => (
            <li key={transaction.id}>
              <Transaction transaction={transaction} />
            </li>
          ))
        )}
      </ul>
    </div>
  );
}

export function Transaction({ transaction }: { transaction: Transaction }) {
  const date = new Date(transaction.inserted_at);
  date.setHours(date.getHours() - 3);
  return (
    <div className="flex flex-col gap-2 rounded-md bg-black px-8 py-3 text-white">
      <div className="flex justify-between">
        <Text size="md">Status: {transaction.status.toUpperCase()}</Text>
        <Text size="md">Type: {transaction.type.toUpperCase()}</Text>
      </div>

      <div className="flex justify-between">
        <Text>
          {transaction.from_account_number
            ? `From ${transaction.from_account_number}`
            : `From Bank`}
        </Text>
        <Text>
          {transaction.to_account_number
            ? `To ${transaction.to_account_number}`
            : `To Bank`}
        </Text>
      </div>

      {transaction.card_number ? <h3>{transaction.card_number}</h3> : null}
      <Text size="lg">
        Amount: <Currency amountInCents={transaction.amount_in_cents} />
      </Text>

      <Text>Transaction created on {format(date, "dd/MM/YYY HH:mm")}</Text>
    </div>
  );
}
