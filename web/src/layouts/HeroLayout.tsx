import type { ReactNode } from "react";
import { Navbar } from "../components/Navbar";

interface HeroLayoutProps {
  children: ReactNode;
}

export default function HeroLayout({ children }: HeroLayoutProps) {
  return (
    <div>
      <Navbar />
      <main className="px-2 py-6 sm:px-8 md:ml-0 lg:px-48">{children}</main>
    </div>
  );
}
