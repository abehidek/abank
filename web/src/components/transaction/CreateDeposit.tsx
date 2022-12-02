import { Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { useMutation } from "@tanstack/react-query";
import { api, requestInit } from "../../auth/AuthContext";
import { useRouter } from "next/router";
import { Button } from "../Button";
import { Input } from "../Input";
import { Heading } from "../Heading";
import { useAuth } from "../../auth/useAuth";

interface Values {
  amount_in_cents: string;
  type: "deposit";
}

export function CreateDeposit() {
  const router = useRouter();
  const { userRefetch } = useAuth();

  const { mutate } = useMutation(
    ["createTransaction"],
    (values: Values) =>
      fetch(api + "/transactions", {
        ...requestInit,
        method: "POST",
        body: JSON.stringify(values),
      }),
    {
      onSuccess: () => {
        userRefetch();
        router.push("/app");
      },
    }
  );
  return (
    <div id="create-deposit">
      <Heading size="lg">Deposit</Heading>
      <Formik
        initialValues={{
          amount_in_cents: "0",
          type: "deposit",
        }}
        onSubmit={(
          values: Values,
          { setSubmitting, resetForm }: FormikHelpers<Values>
        ) => {
          setTimeout(() => {
            mutate(values);
            resetForm();
            setSubmitting(false);
          }, 500);
        }}
      >
        <Form className="flex flex-col gap-4">
          <Input
            id="amount_in_cents"
            type="number"
            label="What is your desired amount?"
            placeholder="732.03"
            isFormikInput={true}
            required
          />

          <Button variant="contained" type="submit">
            Deposit
          </Button>
        </Form>
      </Formik>
    </div>
  );
}
