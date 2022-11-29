import clsx from "clsx";
import { InputHTMLAttributes } from "react";

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  label: string;
}

export default function Input({ className, label, ...props }: InputProps) {
  return (
    <div className="form-control w-full max-w-xs">
      <label className="label">
        <span className="label-text">{label}</span>
      </label>
      <input
        className={clsx("input-bordered input w-full max-w-xs", {}, className)}
        {...props}
      />
    </div>
  );
}
