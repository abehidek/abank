import type { NextPage } from "next";
import { useAuth } from "../auth/useAuth";
import Card from "../components/Card";
import CreateAccount from "../components/CreateAccount";
import Currency from "../components/Currency";
import Loading from "../components/Loading";

const Home: NextPage = () => {
  const { data, user, account, isUserError, isUserLoading } = useAuth();

  if (isUserLoading) return <Loading />;

  if (isUserError) return <p>Error...</p>;

  if (!user) return <p>Sign In pls</p>;

  if (!account) return <CreateAccount />;

  return (
    <div>
      {/* {JSON.stringify(data, null, 2)} */}

      <h1>Hello {user.email}</h1>
      <h2>Your account: {account.number}</h2>
      <h2>
        Balance: <Currency amountInCents={account.balance_in_cents} />
      </h2>
    </div>
  );
};

export default Home;
