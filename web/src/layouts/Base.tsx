import type { ReactNode } from "react";
import Navbar from "../components/Navbar";

export interface BaseProps {
  children: ReactNode;
}

export default function Base({ children }: BaseProps) {
  return (
    <div className="flex flex-col items-center gap-4 p-5">
      <Navbar />
      {children}
    </div>
  );
}
