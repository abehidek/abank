import type { NextPage } from "next";
import Currency from "../../components/Currency";
import AppLayout from "../../layouts/AppLayout";

const HomeApp: NextPage = () => {
  return (
    <AppLayout>
      {({ account, user }) => {
        return (
          <>
            <h1>Hello {user.email}</h1>
            <h2>Your account: {account.number}</h2>
            <h2>
              Balance: <Currency amountInCents={account.balance_in_cents} />
            </h2>
          </>
        );
      }}
    </AppLayout>
  );
};

export default HomeApp;
