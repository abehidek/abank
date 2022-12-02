import type { ButtonHTMLAttributes, ReactNode } from "react";
import { clsx } from "clsx";
import { Slot } from "@radix-ui/react-slot";
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  className?: string;
  asChild?: boolean;
  variant?: "text" | "contained" | "outlined";
}

export function Button({
  children,
  className,
  asChild = false,
  variant = "text",
  ...props
}: ButtonProps) {
  const Comp = asChild ? Slot : "button";
  return (
    <Comp
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
    </Comp>
  );
}
