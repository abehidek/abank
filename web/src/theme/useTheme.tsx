import { useContext } from "react";
import { ThemeContext } from "./ThemeContext";
import type { ThemeContextDataProps } from "./ThemeContext";

export function useTheme(): ThemeContextDataProps {
  const context = useContext(ThemeContext);

  return context;
}
