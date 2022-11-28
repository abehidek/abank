import Link from "next/link";
import { useAuth } from "../auth/useAuth";
import Loading from "./Loading";

export default function Navbar() {
  const { user, account, isUserError, isUserLoading, signOut } = useAuth();

  if (isUserLoading) return <Loading />;

  return (
    <div className="flex gap-5">
      <h1>
        <Link href="/">Abank</Link>
      </h1>
      <div className="flex gap-5">
        {user ? (
          <>
            <h3>Hello {data.user.email}</h3>
            <h3>
              <button onClick={signOut}>Logout</button>
            </h3>
          </>
        ) : (
          <>
            <h3>
              <Link href="/signin">Sign In</Link>
            </h3>
            <h3>
              <Link href="/signup">Sign up</Link>
            </h3>
          </>
        )}
      </div>
    </div>
  );
}
