import { useQuery } from "@tanstack/react-query";
import type { NextPage } from "next";
import { api, requestInit } from "../../auth/AuthContext";
import { Error } from "../../components/Error";
import { Heading } from "../../components/Heading";
import { Loading } from "../../components/Loading";
import AppLayout from "../../layouts/AppLayout";
import { Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { useMutation } from "@tanstack/react-query";
import { Input } from "../../components/Input";
import { Button } from "../../components/Button";
import { Currency } from "../../components/Currency";

interface Values {
  amount_in_cents: string;
}

export interface Loan {
  amount_in_cents: number;
  status: string;
  loan_due_date: string;
  account_number: string;
  id: number;
  inserted_at: string;
}

const Loans: NextPage = () => {
  const { data, isLoading, isError, error, refetch } = useQuery<{ loan: Loan }>(
    ["getCurrentLoan"],
    () =>
      fetch(api + "/loans/current", { ...requestInit }).then((res) =>
        res.json()
      )
  );

  const { mutate } = useMutation(
    ["createLoan"],
    (values: Values) =>
      fetch(api + "/loans", {
        ...requestInit,
        method: "POST",
        body: JSON.stringify(values),
      }),
    {
      onSuccess: () => {
        refetch();
      },
    }
  );

  if (isLoading) return <Loading />;

  if (isError) return <Error error={error} />;

  console.log(data);

  return (
    <AppLayout>
      {({}) => (
        <div>
          <Heading size="lg">Loans</Heading>

          <div id="create-loan">
            <Heading size="md">Request Loan</Heading>
            <Formik
              initialValues={{
                amount_in_cents: "0",
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

                {data && "loan" in data ? (
                  <Button disabled variant="contained" type="submit">
                    An open loan already exists
                  </Button>
                ) : (
                  <Button variant="contained" type="submit">
                    Request
                  </Button>
                )}
              </Form>
            </Formik>
          </div>

          <div id="current-loan" className="mt-4 flex flex-col gap-2">
            <Heading size="md">Current Loan</Heading>
            {data && "loan" in data ? (
              <div className="rounded bg-black px-6 py-4 text-white">
                <Heading size="sm">
                  Amount: <Currency amountInCents={data.loan.amount_in_cents} />
                </Heading>
                <Heading size="sm">Status: {data.loan.status}</Heading>
                <Heading size="sm">Due date: {data.loan.loan_due_date}</Heading>
              </div>
            ) : (
              <Heading size="sm">No current loan found</Heading>
            )}
          </div>
        </div>
      )}
    </AppLayout>
  );
};

export default Loans;
