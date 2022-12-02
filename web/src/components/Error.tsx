import Link from "next/link";
import { Button } from "./Button";
import { Heading } from "./Heading";
import { Text } from "./Text";

export function Error({ error }: { error?: any }) {
  return (
    <div className="flex h-screen w-full flex-1 flex-col items-center justify-center gap-3">
      <Heading size="lg">Something wrong happened</Heading>
      <Text size="lg">{JSON.stringify(error)}</Text>
      <Button variant="contained" asChild>
        <Link href="/">Go back to home</Link>
      </Button>
    </div>
  );
}
