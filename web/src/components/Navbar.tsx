import Link from "next/link";
import { useAuth } from "../auth/useAuth";

export function Navbar() {
  const { user, signOut } = useAuth();
  return (
    <div className="navbar justify-between">
      <div className="md:hidden">
        <div className="dropdown">
          <label tabIndex={0} className="btn-ghost btn-circle btn">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h16M4 18h7"
              />
            </svg>
          </label>
          <ul
            tabIndex={0}
            className="dropdown-content menu rounded-box menu-compact mt-3 w-52 bg-base-100 p-2 shadow"
          >
            {user ? (
              <>
                <li>
                  <Link href="/app/user">{user.email}</Link>
                </li>
                <li>
                  <Link href="/app">Account</Link>
                </li>
                <li>
                  <button onClick={signOut}>Sign out</button>
                </li>
              </>
            ) : (
              <>
                <li>
                  <Link href="/pricing">Pricing</Link>
                </li>
                <li>
                  <Link href="/signin">Sign In</Link>
                </li>
                <li>
                  <Link href="/signup">Sign Up</Link>
                </li>
              </>
            )}
          </ul>
        </div>
      </div>
      <div className="">
        <Link href="/" className="btn-ghost btn text-xl normal-case">
          Abank
        </Link>
      </div>
      <div className="hidden flex-none md:block">
        <ul className="menu menu-horizontal p-0">
          {user ? (
            <li tabIndex={0}>
              <a>
                Hi {user.email}
                <svg
                  className="fill-current"
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                >
                  <path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z" />
                </svg>
              </a>
              <ul className="bg-base-100 p-2">
                <li>
                  <Link href="/app">Enter app</Link>
                </li>
                <li>
                  <button onClick={signOut}>Sign out</button>
                </li>
              </ul>
            </li>
          ) : (
            <>
              <li>
                <Link href="/pricing">Pricing</Link>
              </li>
              <li>
                <Link href="/signin">Sign In</Link>
              </li>
              <li>
                <Link href="/signup">Sign Up</Link>
              </li>
            </>
          )}
        </ul>
      </div>
    </div>
  );
}
