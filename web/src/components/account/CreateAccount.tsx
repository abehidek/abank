import { useAuth } from "../../auth/useAuth";
import { Button } from "../Button";
import { Heading } from "../Heading";

export function CreateAccount() {
  const { createAccount, userRefetch } = useAuth();

  return (
    <div className="flex h-screen w-full flex-col items-center justify-center gap-3 bg-white">
      <Heading size="lg">No account was created for this user</Heading>
      <Button
        onClick={() => {
          createAccount();
          userRefetch();
        }}
        size="lg"
        variant="contained"
        className="w-full max-w-md"
      >
        Create?
      </Button>
    </div>
  );
}
