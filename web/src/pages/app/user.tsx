import { useQuery } from "@tanstack/react-query";
import type { NextPage } from "next";
import { api, requestInit } from "../../auth/AuthContext";
import { Error } from "../../components/Error";
import { Heading } from "../../components/Heading";
import { Loading } from "../../components/Loading";
import AppLayout from "../../layouts/AppLayout";
import { Field, Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { useMutation } from "@tanstack/react-query";
import { useRouter } from "next/router";
import { useAuth } from "../../auth/useAuth";
import { Input } from "../../components/Input";
import { Button } from "../../components/Button";
import { Text } from "../../components/Text";
import { Currency } from "../../components/Currency";
import { date } from "zod";

const User: NextPage = () => {
  return (
    <AppLayout>
      {({ account, user }) => (
        <div className="flex flex-col gap-3">
          <Heading size="lg">User</Heading>
          <Text size="lg">Email: {user.email}</Text>
          <Text size="lg">Has Account?: {account ? "Yes" : "No"}</Text>
          <Text size="lg">Account number: {account.number}</Text>
        </div>
      )}
    </AppLayout>
  );
};

export default User;
