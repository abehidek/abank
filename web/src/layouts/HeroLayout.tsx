import type { ReactNode } from "react";
import Navbar from "../components/Navbar";

interface HeroLayoutProps {
  children: ReactNode;
}

export default function HeroLayout({ children }: HeroLayoutProps) {
  return (
    <main>
      <p>Hero!!</p>
      {children}
    </main>
  );
}
