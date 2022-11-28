import type { NextPage } from "next";
import Account from "../layouts/Account";
import Base from "../layouts/Base";

const Home: NextPage = () => {
  return (
    <Base>
      <Account>
        <p>Index</p>
      </Account>
    </Base>
  );
};

export default Home;
