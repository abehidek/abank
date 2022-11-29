import type { ReactNode } from "react";
import Navbar from "../components/Navbar";

interface AppLayoutProps {
  children: ReactNode;
}

export default function AppLayout({ children }: AppLayoutProps) {
  return (
    <main>
      <Navbar />
      {children}
    </main>
  );
}
