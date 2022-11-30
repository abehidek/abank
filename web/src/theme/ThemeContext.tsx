import { createContext, useState } from "react";
import type { ReactNode, Dispatch, SetStateAction } from "react";

export type ThemeContextDataProps = {
  isSideBarOpen: boolean;
  setIsSideBarOpen: Dispatch<SetStateAction<boolean>>;
};

export const ThemeContext = createContext<ThemeContextDataProps>(
  {} as ThemeContextDataProps // because we only will use this context through the provider below
);

export function ThemeContextProvider({ children }: { children: ReactNode }) {
  const [isSideBarOpen, setIsSideBarOpen] = useState(false);

  return (
    <ThemeContext.Provider
      value={{
        isSideBarOpen,
        setIsSideBarOpen,
      }}
    >
      {children}
    </ThemeContext.Provider>
  );
}
