import type { NextPage } from "next";
import { useAuth } from "../auth/useAuth";
import Loading from "../components/Loading";

const Home: NextPage = () => {
  const { data, isUserError, isUserLoading } = useAuth();

  if (isUserLoading) return <Loading />;

  if (isUserError) return <p>Error...</p>;

  if (data?.user && !data?.user.has_account)
    return <div>You do not have a account</div>;

  return (
    <div>
      <p>Index</p>
      {JSON.stringify(data, null, 2)}
    </div>
  );
};

export default Home;
