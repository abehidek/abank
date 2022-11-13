import { ReactNode } from "react";
import Navbar from "../components/Navbar";

export interface BaseProps {
  children: ReactNode
}

export default function Base({ children }: BaseProps) {
  return (
    <main className="flex items-center flex-col gap-4 p-5">
      <Navbar />
      {children}
    </main>
  )
}