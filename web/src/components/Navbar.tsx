import Link from "next/link";
import { useAuth } from "../auth/useAuth";
import Loading from "./Loading";

export default function Navbar() {
  const { user, account, isUserLoading, signOut } = useAuth();

  if (isUserLoading) return <Loading />;

  return (
    <div className="flex gap-5">
      <h1>
        <Link href="/app">Home</Link>
      </h1>
      <div className="flex gap-5">
        {user ? (
          <>
            {account ? (
              <>
                <h3>
                  <Link href="/app/cards">Cards</Link>
                </h3>
                <h3>
                  <Link href="/app/transfer">Transfer</Link>
                </h3>
              </>
            ) : null}

            <h3>Hello {user.email}</h3>
            <h3>
              <button onClick={signOut}>Logout</button>
            </h3>
          </>
        ) : null}
      </div>
    </div>
  );
}
