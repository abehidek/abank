import React from "react";
import type { ReactNode } from "react";
import Navbar from "../components/Navbar";
import Loading from "../components/Loading";
import { useRouter } from "next/router";
import { useAuth } from "../auth/useAuth";
import CreateAccount from "../components/CreateAccount";
import type { Account, User } from "../auth/AuthContext";
import Error from "../components/Error";

interface AppLayoutProps {
  children: ({ account, user }: { account: Account; user: User }) => ReactNode;
}

export default function AppLayout({ children }: AppLayoutProps) {
  const { user, account, isUserError, isUserLoading, error } = useAuth();
  const router = useRouter();

  if (isUserLoading) return <Loading />;

  if (isUserError) {
    console.error(error);
    return <Error />;
  }

  if (!user) {
    router.push("/signin");
    return <></>;
  }

  if (!account) {
    return (
      <main className="flex gap-6">
        <Navbar />
        <CreateAccount />
      </main>
    );
  }

  return (
    <div className="flex h-full w-full lg:grid-cols-main lg:justify-between">
      <div className="sticky top-0 z-50 min-h-screen self-start bg-[#0e0e0e]">
        <Navbar />
      </div>

      <main className="ml-16 h-screen w-full overflow-scroll px-2 py-6 sm:px-8 md:ml-0 lg:px-48">
        {children({ user, account })}
      </main>
    </div>
  );
}
