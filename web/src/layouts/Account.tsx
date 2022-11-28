import { useQuery } from "@tanstack/react-query";
import type { ReactNode } from "react";
import CreateAccount from "../components/CreateAccount";
import Loading from "../components/Loading";

export interface BaseProps {
  children: ReactNode;
}

const api = "http://localhost:4000/api";

export default function Account({ children }: BaseProps) {
  const auth = useQuery(["me"], () =>
    fetch(api + "/users/me", {
      mode: "cors",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((res) => res.json())
  );

  if (auth.isLoading) return <Loading />;

  if (auth.error) return <p>Error...</p>;

  if (auth.data.message)
    return (
      <div>
        {auth.data.message}
        {JSON.stringify(auth.data, null, 2)}
      </div>
    );

  if (!auth.data.user.has_account)
    return (
      <div>
        <CreateAccount /> {JSON.stringify(auth.data, null, 2)}
      </div>
    );
  else
    return (
      <div>
        {children}
        {JSON.stringify(auth.data, null, 2)}
      </div>
    );
}
