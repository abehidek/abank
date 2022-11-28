import { createContext } from "react";
import type { ReactNode } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";

import type {
  UseMutationOptions,
  UseMutateFunction,
} from "@tanstack/react-query";

export interface AuthProps {
  account?: Account;
  user: User;
}

export interface Account {
  number: string;
  balance_in_cents: number;
  score: number;
  user_id: number;
  max_limit: number;
  id: number;
}

export interface User {
  email: string;
  hashed_password: string;
  confirmed_at: null;
  password: null;
  has_account: boolean;
}

export type AuthContextDataProps = {
  data: AuthProps | undefined;
  isUserLoading: boolean;
  isUserError: boolean;
  signIn: UseMutateFunction<any, unknown, SignInValues, unknown>;
  signUp: UseMutateFunction<any, unknown, SignUpValues, unknown>;
  signOut: () => Promise<void>;
};

export const AuthContext = createContext<AuthContextDataProps>(
  {} as AuthContextDataProps // because we only will use this context through the provider below
);

export type SignInValues = {
  email: string;
  password: string;
};

export type SignUpValues = {
  email: string;
  password: string;
};

export function AuthContextProvider({ children }: { children: ReactNode }) {
  const api = process.env.API_URL || "http://localhost:4000/api";
  const requestInit: RequestInit = {
    mode: "cors",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
    },
  };
  const {
    data,
    isError: isUserError,
    isLoading: isUserLoading,
    refetch: userRefetch,
  } = useQuery(["user"], () =>
    fetch(api + "/users/me", requestInit).then((res) => res.json())
  );

  const { mutate: signIn } = useMutation(
    ["signIn"],
    (values: SignInValues) =>
      fetch(api + "/users/login", {
        ...requestInit,
        method: "POST",
        body: JSON.stringify(values),
      }).then((res) => res.json()),
    {
      onSettled: () => {
        userRefetch();
      },
    }
  );

  const { mutate: signUp } = useMutation(
    ["signUp"],
    (values: SignUpValues) =>
      fetch(api + "/users/register", {
        ...requestInit,
        method: "POST",
        body: JSON.stringify(values),
      }).then((res) => res.json()),
    {
      onSettled: () => {
        userRefetch();
      },
    }
  );

  const signOut = async () => {
    await fetch(api + "/users/logout", {
      method: "DELETE",
      mode: "cors",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((res) => res.json());

    userRefetch();
  };

  return (
    <AuthContext.Provider
      value={{
        data,
        isUserError,
        isUserLoading,
        signIn,
        signUp,
        signOut,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}
