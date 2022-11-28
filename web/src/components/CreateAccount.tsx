import { useAuth } from "../auth/useAuth";

export default function CreateAccount() {
  const { createAccount } = useAuth();

  return <button onClick={createAccount}>No account, create it?</button>;
}
