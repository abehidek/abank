import { type AppType } from "next/dist/shared/lib/utils";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import "../styles/globals.css";
import { AuthContextProvider } from "../auth/AuthContext";
import Navbar from "../components/Navbar";

const queryClient = new QueryClient();

const MyApp: AppType = ({ Component, pageProps }) => {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthContextProvider>
        <div className="flex h-screen w-screen flex-col">
          <Navbar />
          <Component {...pageProps} />
        </div>
      </AuthContextProvider>
    </QueryClientProvider>
  );
};

export default MyApp;
