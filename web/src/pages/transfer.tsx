import { useAuth } from "../auth/useAuth";
import CreateAccount from "../components/CreateAccount";
import Loading from "../components/Loading";
import { Field, Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { useMutation } from "@tanstack/react-query";
import { api, requestInit } from "../auth/AuthContext";
import { useRouter } from "next/router";

interface Values {
  amount_in_cents: string;
  to_account_number: string;
  type: "pix" | "ted" | "doc";
}

export default function Transfer() {
  const { user, account, isUserError, isUserLoading } = useAuth();
  const router = useRouter();

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
        router.push("/");
      },
    }
  );

  if (isUserLoading) return <Loading />;

  if (isUserError) return <p>Error...</p>;

  if (!user) return <p>Sign In pls</p>;

  if (!account) return <CreateAccount />;

  return (
    <div className="">
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
            // alert(JSON.stringify(values));
            mutate(values);
            resetForm();
            setSubmitting(false);
          }, 500);
        }}
      >
        <Form className="flex flex-col items-center gap-4 p-5">
          <label className="text-xl font-bold" htmlFor="email">
            Amount
          </label>
          <Field
            className="input-bordered input w-full max-w-xs"
            type="number"
            id="amount_in_cents"
            name="amount_in_cents"
            placeholder="0"
            required
          />
          <label className="text-xl font-bold" htmlFor="password">
            Account Number
          </label>
          <Field
            className="input-bordered input w-full max-w-xs"
            id="to_account_number"
            name="to_account_number"
            placeholder="39752152"
            required
          />
          <div id="my-radio-group">
            <label className="text-xl font-bold" htmlFor="password">
              Type
            </label>
          </div>
          <div
            role="group"
            aria-labelledby="my-radio-group"
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
            <label>
              <Field type="radio" name="type" value="doc" />
              DOC
            </label>
          </div>
          <button type="submit">Submit</button>
        </Form>
      </Formik>
    </div>
  );
}
