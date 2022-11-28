import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import Loading from "./Loading";

const api = "http://localhost:4000/api";

export default function Navbar() {
  const auth = useQuery(["me"], () =>
    fetch(api + "/users/me", {
      mode: "cors",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((res) => res.json())
  );
  async function logout() {
    const response = await fetch(api + "/users/logout", {
      method: "DELETE",
      mode: "cors",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((res) => res.json());

    auth.refetch();

    console.log(response);
  }

  if (auth.isLoading) return null;

  return (
    <div className="flex gap-5">
      <h1>
        <Link href="/">Abank</Link>
      </h1>
      <div className="flex gap-5">
        {"user" in auth.data ? (
          <>
            <h3>Hello {auth.data.user.email}</h3>
            <h3>
              <button onClick={logout}>Logout</button>
            </h3>
          </>
        ) : (
          <>
            <h3>
              <Link href="/login">Login</Link>
            </h3>
            <h3>
              <Link href="/create/user">Sign up</Link>
            </h3>
          </>
        )}
      </div>
    </div>
  );
}
