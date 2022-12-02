import type { NextPage } from "next";
import Link from "next/link";
import { Button } from "../../components/Button";
import { Currency } from "../../components/Currency";
import { Heading } from "../../components/Heading";
import { Text } from "../../components/Text";
import AppLayout from "../../layouts/AppLayout";

const HomeApp: NextPage = () => {
  const currentHour = new Date().getHours();

  const greeting =
    currentHour > 12
      ? currentHour < 17
        ? "Good Afternoon"
        : "Good Evening"
      : "Good Morning";

  return (
    <AppLayout>
      {({ account, user }) => {
        return (
          <div className="flex flex-col gap-6">
            <Heading size="lg">
              {greeting} {user.email}
            </Heading>
            <Heading>Your account: {account.number}</Heading>
            <Heading>
              Your Balance:{" "}
              <Currency amountInCents={account.balance_in_cents} />
            </Heading>

            <div className="grid w-full max-w-2xl grid-cols-1 gap-4 md:grid-cols-2">
              <Button
                className="w-full max-w-lg"
                asChild
                variant="outlined"
                size="lg"
              >
                <Link href="/app/cards">See My cards</Link>
              </Button>
              <Button
                className="w-full max-w-lg"
                asChild
                variant="outlined"
                size="lg"
              >
                <Link href="/app/transactions#create-transaction">
                  Transfer
                </Link>
              </Button>
              <Button
                className="w-full max-w-lg"
                asChild
                variant="outlined"
                size="lg"
              >
                <Link href="/app/transactions#create-deposit">Deposit</Link>
              </Button>
              <Button
                className="w-full max-w-lg"
                asChild
                variant="outlined"
                size="lg"
              >
                <Link href="/app/transactions#list-transactions">History</Link>
              </Button>
            </div>
          </div>
        );
      }}
    </AppLayout>
  );
};

export default HomeApp;
