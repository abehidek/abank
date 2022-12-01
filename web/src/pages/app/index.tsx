import type { NextPage } from "next";
import { Button } from "../../components/Button";
import { Currency } from "../../components/Currency";
import { Heading } from "../../components/Heading";
import { Text } from "../../components/Text";
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
            <Button variant="contained">aaaaaaaaaaaaaaaaaa</Button>
            <Button variant="outlined">Outlined</Button>
            <Button variant="text">Outlined</Button>

            <div>
              <Text size="lg">Abe</Text>
              <Text size="md">Abe</Text>
              <Text size="sm">Abe</Text>

              <Text size="lg" asChild>
                <h1>This should be a h1</h1>
              </Text>

              <Text size="sm" asChild>
                <a href="https://google.com">This should be a a tag</a>
              </Text>

              <Heading size="lg">Eba</Heading>
              <Heading size="md">Eba</Heading>
              <Heading size="sm">Eba</Heading>
            </div>
          </>
        );
      }}
    </AppLayout>
  );
};

export default HomeApp;
