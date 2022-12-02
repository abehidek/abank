import type { NextPage } from "next";
import Image from "next/image";
import Link from "next/link";
import { Button } from "../components/Button";
import HeroLayout from "../layouts/HeroLayout";

const Home: NextPage = () => {
  return (
    <HeroLayout>
      <div className="flex flex-col gap-6 md:flex-row md:justify-between">
        <div>
          <h1 className="whitespace-pre-line text-2xl font-bold 2xl:text-3xl">
            {`Abank, a digital bank for
          the 21st Century`}
          </h1>
          <h2 className="mt-2 whitespace-pre-line text-2xl font-normal">
            {`Easily simplify the way you can handle money
            without losing nothing, earning more time.
            `}
          </h2>

          <Button
            size="md"
            className="mt-6 w-full max-w-sm"
            asChild
            variant="contained"
          >
            <Link href="/signup">Be part of it</Link>
          </Button>
        </div>
        <div className="relative w-full overflow-hidden">
          <Image
            // placeholder="blur"
            className="hidden self-start object-cover md:block"
            alt="Stonks meme"
            src="/hero.jpg"
            fill
            // height={100}
            // width={500}
          />
        </div>
      </div>
    </HeroLayout>
  );
};

export default Home;
