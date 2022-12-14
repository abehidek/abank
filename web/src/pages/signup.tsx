import { type NextPage } from "next";
import Head from "next/head";
import { Form, Formik } from "formik";
import type { FormikHelpers } from "formik";
import { Loading } from "../components/Loading";
import { Error } from "../components/Error";
import { useRouter } from "next/router";
import { useAuth } from "../auth/useAuth";
import HeroLayout from "../layouts/HeroLayout";
import { Input } from "../components/Input";
import { Heading } from "../components/Heading";
import { Button } from "../components/Button";

interface Values {
  email: string;
  password: string;
  address: string;
  cpf: string;
}

const Signup: NextPage = () => {
  const router = useRouter();
  const { user, isUserLoading, isUserError, signUp } = useAuth();

  if (isUserLoading) return <Loading />;

  if (isUserError) return <Error />;

  if (user) {
    router.push("/app");
  }

  return (
    <HeroLayout>
      <Head>
        <title>Create T3 App</title>
        <meta name="description" content="Generated by create-t3-app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div className="flex max-w-lg flex-col gap-3">
        <Heading size="lg">Sign Up</Heading>
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
          <Form className="flex flex-col gap-4">
            <Input
              id="email"
              type="email"
              label="What is your email?"
              placeholder="john@doe.com"
              isFormikInput={true}
            />
            <Input
              id="password"
              type="password"
              label="Type your password"
              placeholder="************"
              isFormikInput={true}
            />
            <Input
              id="address"
              type="text"
              label="What is your address?"
              placeholder="St John Doe 777"
              isFormikInput={true}
            />
            <Input
              id="cpf"
              type="text"
              label="What is your CPF?"
              placeholder="12345678910"
              isFormikInput={true}
            />
            <Button variant="contained" type="submit">
              Sign Up
            </Button>
          </Form>
        </Formik>
      </div>
    </HeroLayout>
  );
};

export default Signup;
