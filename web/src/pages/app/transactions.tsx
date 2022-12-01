import { Loading } from "../../components/Loading";
import { useQuery } from "@tanstack/react-query";
import { api, requestInit } from "../../auth/AuthContext";
import AppLayout from "../../layouts/AppLayout";
import { ListTransactions } from "../../components/transaction/ListTransactions";
import { Error } from "../../components/Error";
import { CreateTransaction } from "../../components/transaction/CreateTransaction";

export default function Transactions() {
  const {
    data,
    isError,
    error: transactionError,
    isLoading,
  } = useQuery(["transactions"], () =>
    fetch(api + "/transactions", { ...requestInit }).then((res) => res.json())
  );

  if (isLoading) return <Loading />;

  if (isError) {
    console.error(transactionError);
    return <Error />;
  }

  return (
    <AppLayout>
      {({}) => (
        <>
          <CreateTransaction />
          <ListTransactions transactions={data.transactions} />
        </>
      )}
    </AppLayout>
  );
}
