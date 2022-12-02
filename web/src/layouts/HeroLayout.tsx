import type { ReactNode } from "react";
import { Navbar } from "../components/Navbar";

interface HeroLayoutProps {
  children: ReactNode;
}

export default function HeroLayout({ children }: HeroLayoutProps) {
  return (
    <div className="flex h-screen w-full flex-col overflow-y-scroll">
      <Navbar />
      <main className="w-full overflow-y-scroll px-2 py-6 sm:px-8 md:ml-0 md:px-16 lg:px-48">
        {children}
      </main>
    </div>
  );
}
