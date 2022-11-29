import { useContext } from "react";

import { AuthContext } from "./AuthContext";

import type { AuthContextDataProps } from "./AuthContext";

export function useAuth(): AuthContextDataProps {
  const context = useContext(AuthContext);

  return context;
}
