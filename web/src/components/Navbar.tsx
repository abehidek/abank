import Link from "next/link";
import { useAuth } from "../auth/useAuth";
import Loading from "./Loading";
import {
  ArrowsDownUp,
  CreditCard,
  Gear,
  House,
  List,
  Money,
  SignOut,
  User,
} from "phosphor-react";
import { useState, createElement } from "react";

export default function Navbar() {
  const { user, account, isUserLoading } = useAuth();
  const [open, setOpen] = useState(false);

  if (isUserLoading) return <Loading />;

  const menus = [
    { name: "Home", link: "/", icon: House },
    { name: "Cards", link: "/cards", icon: CreditCard, account: true },
    {
      name: "Transactions",
      link: "/transactions",
      icon: ArrowsDownUp,
      account: true,
    },
    { name: "Loans", link: "/loans", icon: Money, margin: true, account: true },
    {
      name: "Settings",
      link: "/settings",
      icon: Gear,
      margin: true,
      account: true,
    },
    { name: user?.email, link: "/user", icon: User },
    { name: "Sign out", link: "/signout", icon: SignOut },
  ];

  return (
    <div
      className={`absolute min-h-screen bg-[#0e0e0e] md:relative ${
        open ? "w-72" : "w-16"
      } px-4 text-gray-100 duration-500`}
    >
      <div className="flex justify-end py-3">
        <List size={32} onClick={() => setOpen(!open)} />
      </div>
      <div className="relative mt-4 flex flex-col gap-4">
        {menus?.map((menu, i) => (
          <Link
            href={"/app" + menu?.link}
            onClick={() => setOpen(false)}
            key={i}
            className={` ${menu?.account && !account && "hidden"} ${
              menu?.margin && "mt-5"
            } group flex items-center gap-3.5  rounded-md p-2 text-sm font-medium hover:bg-gray-800`}
          >
            <div>{createElement(menu?.icon, { size: "20" })}</div>
            <h2
              style={{
                transitionDelay: `${i + 3}00ms`,
              }}
              className={`whitespace-pre duration-500 ${
                !open && "translate-x-28 overflow-hidden opacity-0"
              }`}
            >
              {menu?.name}
            </h2>
            <h2
              className={`${
                open && "hidden"
              } absolute left-48 z-50 w-0 overflow-hidden whitespace-pre rounded-md bg-white px-0 py-0 font-semibold text-gray-900 drop-shadow-lg group-hover:left-14 group-hover:w-fit group-hover:px-2 group-hover:py-1 group-hover:duration-300 `}
            >
              {menu?.name}
            </h2>
          </Link>
        ))}
      </div>
    </div>
  );
}
