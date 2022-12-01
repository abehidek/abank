interface Props {
  amountInCents: number;
}

export function Currency(props: Props) {
  return <span>R$ {props.amountInCents / 100}</span>;
}
