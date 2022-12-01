import type { ButtonHTMLAttributes, ReactNode } from "react";
import { clsx } from "clsx";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  className?: string;
  variant?: "text" | "contained" | "outlined";
}

export function Button({
  children,
  className,
  variant = "text",
  ...props
}: ButtonProps) {
  return (
    <button
      type="button"
      className={clsx(
        "inline-flex justify-center rounded-md border px-5 py-3 text-sm font-medium focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
        {
          "border-transparent text-black": variant === "text",
          "border-black text-black": variant === "outlined",
          "bg-black text-white": variant === "contained",
        },
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}
