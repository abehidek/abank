import type { ReactNode } from "react";

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
