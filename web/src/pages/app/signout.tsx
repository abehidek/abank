import { useRouter } from "next/router";
import { useAuth } from "../../auth/useAuth";

export default function SignOut() {
  const { signOut } = useAuth();
  const router = useRouter();

  signOut();
  router.push("/");

  return <></>;
}
