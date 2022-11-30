import Loading from "../../components/Loading";
import { useMutation, useQuery } from "@tanstack/react-query";
import { api, requestInit } from "../../auth/AuthContext";
import { useRouter } from "next/router";
import AppLayout from "../../layouts/AppLayout";
import ListTransactions from "../../components/ListTransactions";
import Error from "../../components/Error";
import CreateTransaction from "../../components/CreateTransactions";

export default function Transactions() {
  const router = useRouter();

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
