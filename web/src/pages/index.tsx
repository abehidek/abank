import type { NextPage } from "next";
import Link from "next/link";
import { useRouter } from "next/router";
import { useAuth } from "../auth/useAuth";
import HeroLayout from "../layouts/HeroLayout";

const Home: NextPage = () => {
  const router = useRouter();
  const { user } = useAuth();

  if (user) {
    router.push("/app");
    return <></>;
  }

  return (
    <HeroLayout>
      <h1>The bank for the 21st century</h1>
      <Link href="/signin">Sign In</Link>
      <Link href="/signup">Sign Up</Link>
    </HeroLayout>
  );
};

export default Home;
