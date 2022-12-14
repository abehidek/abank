import { createContext } from "react";
import type { ReactNode } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";

import type {
  QueryObserverResult,
  RefetchOptions,
  RefetchQueryFilters,
} from "@tanstack/react-query";

import type { UseMutateFunction } from "@tanstack/react-query";
import { useRouter } from "next/router";

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
  user: User | undefined;
  account: Account | undefined;
  isUserLoading: boolean;
  isUserError: boolean;
  error: any;
  userRefetch: <TPageData>(
    options?: (RefetchOptions & RefetchQueryFilters<TPageData>) | undefined
  ) => Promise<QueryObserverResult<any, unknown>>;
  signIn: UseMutateFunction<any, unknown, SignInValues, unknown>;
  signUp: UseMutateFunction<any, unknown, SignUpValues, unknown>;
  signOut: () => Promise<void>;
  createAccount: () => Promise<void>;
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

export const api =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:4000/api";

export const requestInit: RequestInit = {
  mode: "cors",
  credentials: "include",
  headers: {
    "Content-Type": "application/json",
  },
};

export function AuthContextProvider({ children }: { children: ReactNode }) {
  const router = useRouter();
  const {
    data,
    error,
    isError: isUserError,
    isLoading: isUserLoading,
    refetch: userRefetch,
  } = useQuery(["user"], () =>
    fetch(api + "/users/me", requestInit).then((res) => res.json())
  );

  const user = data && "user" in data ? data.user : undefined;
  const account = data && "account" in data ? data.account : undefined;

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
        router.push("/signin");
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

  const createAccount = async () => {
    await fetch(api + "/accounts", {
      method: "POST",
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
        user,
        account,
        isUserError,
        error,
        isUserLoading,
        userRefetch,
        signIn,
        signUp,
        signOut,
        createAccount,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}
