import type { NextPage } from "next";
import Link from "next/link";
import { useRouter } from "next/router";
import { useAuth } from "../auth/useAuth";

const Home: NextPage = () => {
  const router = useRouter();
  const { user } = useAuth();

  if (user) {
    router.push("/app");
    return <></>;
  }

  return (
    <div>
      <h1>Beautiful index page here pls</h1>
      <Link href="/signin">Sign In</Link>
      <Link href="/signup">Sign Up</Link>
    </div>
  );
};

export default Home;
