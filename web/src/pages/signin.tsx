import { type NextPage } from "next";
import Head from "next/head";
import { Field, Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { useAuth } from "../auth/useAuth";
import Loading from "../components/Loading";
import { useRouter } from "next/router";

interface Values {
  email: string;
  password: string;
}

const SignIn: NextPage = () => {
  const router = useRouter();
  const { user, isUserLoading, signIn } = useAuth();

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

      <div className="flex flex-col items-center gap-3">
        <h1 className="text-2xl font-bold">Log in</h1>

        <Formik
          initialValues={{ email: "", password: "" }}
          onSubmit={(
            values: Values,
            { setSubmitting, resetForm }: FormikHelpers<Values>
          ) => {
            setTimeout(() => {
              signIn(values);
              resetForm();
              setSubmitting(false);
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
            <button type="submit">Submit</button>
          </Form>
        </Formik>
      </div>
    </>
  );
};

export default SignIn;
