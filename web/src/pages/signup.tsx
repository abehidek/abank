import { type NextPage } from "next";
import Head from "next/head";
import { Field, Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import Loading from "../components/Loading";
import { useRouter } from "next/router";
import { useAuth } from "../auth/useAuth";

interface Values {
  email: string;
  password: string;
  address: string;
  cpf: string;
}

const Signup: NextPage = () => {
  const router = useRouter();
  const { user, isUserLoading, signUp } = useAuth();

  if (isUserLoading) return <Loading />;

  if (user) {
    router.push("/");
  }

  return (
    <>
      <Head>
        <title>Create T3 App</title>
        <meta name="description" content="Generated by create-t3-app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div>
        <h1 className="text-2xl font-bold">Sign Up</h1>
        <Formik
          initialValues={{ email: "", password: "", address: "", cpf: "" }}
          onSubmit={(
            values: Values,
            { setSubmitting, resetForm }: FormikHelpers<Values>
          ) => {
            setTimeout(() => {
              resetForm();
              setSubmitting(false);
              signUp(values);
            }, 500);
          }}
        >
          <Form className="flex flex-col items-center gap-4 p-5">
            <label className="text-xl font-bold" htmlFor="email">
              Email
            </label>
            <Field
              type="email"
              id="email"
              name="email"
              placeholder="john@doe.com"
            />
            <label className="text-xl font-bold" htmlFor="password">
              Password
            </label>
            <Field id="password" name="password" placeholder="******" />

            <label className="text-xl font-bold" htmlFor="address">
              Address
            </label>
            <Field id="address" name="address" placeholder="St John Doe 777" />

            <label className="text-xl font-bold" htmlFor="cpf">
              cpf
            </label>
            <Field id="cpf" name="cpf" placeholder="123.456.789-10" />
            <button type="submit">Submit</button>
          </Form>
        </Formik>
      </div>
    </>
  );
};

export default Signup;
