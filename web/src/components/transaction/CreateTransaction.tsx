import { Field, Form, Formik } from "formik";
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
  to_account_number: string;
  type: "pix" | "ted";
}

export function CreateTransaction() {
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
    <div id="create-transaction">
      <Heading size="lg">Create Transaction</Heading>
      <Formik
        initialValues={{
          amount_in_cents: "0",
          to_account_number: "",
          type: "pix",
        }}
        onSubmit={(
          values: Values,
          { setSubmitting, resetForm }: FormikHelpers<Values>
        ) => {
          setTimeout(() => {
            console.log(values);
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

          <Input
            id="to_account_number"
            label="Type the receiver's account number"
            placeholder="39752152"
            isFormikInput={true}
            required
          />

          <Input
            id="transaction-type-group"
            label="What is the transaction type?"
            isTextInput={false}
          >
            <div
              role="group"
              aria-labelledby="transaction-type-group"
              className="flex gap-3"
            >
              <label>
                <Field type="radio" name="type" value="pix" />
                Pix
              </label>
              <label>
                <Field type="radio" name="type" value="ted" />
                TED
              </label>
            </div>
          </Input>

          <Button variant="contained" type="submit">
            Transfer
          </Button>
        </Form>
      </Formik>
    </div>
  );
}
