interface Props {
  amountInCents: number;
}

export default function Currency(props: Props) {
  return <span>R$ {props.amountInCents / 100}</span>;
}
