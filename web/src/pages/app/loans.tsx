import type { NextPage } from "next";
import { useRouter } from "next/router";
import { useAuth } from "../../auth/useAuth";
import CreateAccount from "../../components/CreateAccount";
import Currency from "../../components/Currency";
import Loading from "../../components/Loading";
import AppLayout from "../../layouts/AppLayout";

const Loans: NextPage = () => {
  const { data, user, account, isUserError, isUserLoading, error } = useAuth();
  const router = useRouter();

  if (isUserLoading) return <Loading />;

  if (isUserError) {
    console.error(error);
    return <p>Error...</p>;
  }

  if (!user) {
    router.push("/signin");
    return <></>;
  }

  if (!account) return <CreateAccount />;

  return (
    <AppLayout>
      <h1>Loans</h1>
    </AppLayout>
  );
};

export default Loans;
