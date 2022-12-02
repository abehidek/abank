import clsx from "clsx";
import type { InputHTMLAttributes, ReactNode } from "react";
import { Field } from "formik";

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  label: string;
  id: string;
  isTextInput?: boolean;
  isFormikInput?: boolean;
  children?: ReactNode;
}

export function Input({
  className,
  label,
  isTextInput = true,
  isFormikInput = false,
  children,
  id,
  ...props
}: InputProps) {
  const Comp = isFormikInput ? Field : "input";
  return (
    <>
      <label className="text-lg font-bold" htmlFor={id}>
        {label}
      </label>
      {isTextInput ? (
        <Comp
          className={clsx("input-bordered input w-full text-lg", {}, className)}
          id={id}
          name={id}
          {...props}
        />
      ) : (
        children
      )}
    </>
  );
}
