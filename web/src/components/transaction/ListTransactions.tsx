import { Currency } from "../Currency";
import { Heading } from "../Heading";
import { Text } from "../Text";

interface Transaction {
  type: string;
  amount_in_cents: number;
  status: string;
  description: string | null;
  from_account_number: string;
  to_account_number: string;
  card_number: string | null;
  id: number;
}

interface ListTransactionsProps {
  transactions: Transaction[] | undefined;
}

export function ListTransactions({ transactions }: ListTransactionsProps) {
  return (
    <div>
      <Heading size="lg">Transaction History</Heading>
      <ul>
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
  return (
    <div>
      <h2>Status: {transaction.status}</h2>
      <h2>From {transaction.from_account_number}</h2>
      <h2>To {transaction.to_account_number}</h2>
      <h3>{transaction.type}</h3>
      {transaction.card_number ? <h3>{transaction.card_number}</h3> : null}
      <Currency amountInCents={transaction.amount_in_cents} />
    </div>
  );
}
