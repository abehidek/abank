import { useQuery } from "@tanstack/react-query"
import { NextPage } from "next"
import Loading from "../components/Loading"
import Base from "../layouts/Base"

const api = "http://localhost:4000/api"

const Home: NextPage = () => {
  const auth = useQuery(["me"], () =>
    fetch(api + '/users/me', {
      mode: 'cors',
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json'
      },
    }).then(res => res.json())
  )

  if (auth.isLoading) return <Loading />

  return (
    <Base>
      Index
      {JSON.stringify(auth.data, null, 2)}
    </Base>
  )
}

export default Home