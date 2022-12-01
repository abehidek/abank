import type { NextPage } from "next";
import Image from "next/image";
import Link from "next/link";
import HeroLayout from "../layouts/HeroLayout";

const Home: NextPage = () => {
  return (
    <HeroLayout>
      <div className="flex flex-col items-center justify-center">
        <h1 className="text-3xl font-bold">The bank for the 21st century</h1>
        <Image alt="Stonks meme" src="/hero.jpg" height={500} width={500} />
      </div>
    </HeroLayout>
  );
};

export default Home;
