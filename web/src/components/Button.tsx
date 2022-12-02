import type { ButtonHTMLAttributes, ReactNode } from "react";
import { clsx } from "clsx";
import { Slot } from "@radix-ui/react-slot";
interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  className?: string;
  asChild?: boolean;
  variant?: "text" | "contained" | "outlined";
  size?: "sm" | "md" | "lg";
}

export function Button({
  children,
  className,
  asChild = false,
  variant = "text",
  size = "md",
  ...props
}: ButtonProps) {
  const Comp = asChild ? Slot : "button";
  return (
    <Comp
      type="button"
      className={clsx(
        "inline-flex cursor-pointer justify-center rounded-md border font-medium focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2",
        {
          "border-transparent text-black": variant === "text",
          "border-black text-black": variant === "outlined",
          "bg-black text-white": variant === "contained",
          "px-5 py-3 text-sm": size === "sm",
          "px-7 py-5 text-md": size === "md",
          "px-9 py-6 text-lg": size === "lg",
        },
        className
      )}
      {...props}
    >
      {children}
    </Comp>
  );
}
