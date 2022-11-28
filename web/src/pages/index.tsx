import type { NextPage } from "next";
import { useAuth } from "../auth/useAuth";
import CreateAccount from "../components/CreateAccount";
import Loading from "../components/Loading";

const Home: NextPage = () => {
  const { data, user, account, isUserError, isUserLoading } = useAuth();

  if (isUserLoading) return <Loading />;

  if (isUserError) return <p>Error...</p>;

  if (!user) return <p>Sign In pls</p>;

  if (!account) return <CreateAccount />;

  return (
    <div>
      <p>Index</p>
      {JSON.stringify(data, null, 2)}
    </div>
  );
};

export default Home;
