import Link from "next/link";

export default function Navbar() {
  return (
    <div className="flex gap-5">
      <h1><Link href="/">Abank</Link></h1>
      <div className="flex gap-5">
        <h3><Link href="/login">Login</Link></h3>
        <h3><Link href="/signup">Sign up</Link></h3>
      </div>
    </div>
  )
}