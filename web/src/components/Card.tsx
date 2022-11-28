interface CardProps {
  name: string;
  number: string;
  // valid: string;
  expiry: string;
  cvv: string;
  type: "debit" | "credit";
}

export default function Card(props: CardProps) {
  return (
    <div className="relative h-56 w-96 transform rounded-xl bg-red-100 text-white shadow-2xl transition-transform hover:scale-110">
      <picture>
        <img
          className="relative h-full w-full rounded-xl object-cover"
          src={
            props.type === "credit"
              ? "https://i.imgur.com/Zi6v09P.png"
              : "https://i.imgur.com/kGkSg1v.png"
          }
          alt="Card"
        />
      </picture>

      <div className="absolute top-8 w-full px-8">
        <div className="flex justify-between">
          <div className="">
            <p className="font-light">Name</p>
            <p className="font-medium tracking-widest">{props.name}</p>
          </div>
          <picture>
            <img
              className="h-14 w-14"
              src="https://i.imgur.com/bbPHJVe.png"
              alt="Card flag"
            />
          </picture>
        </div>
        <div className="pt-1">
          <p className="font-light">Card Number</p>
          <p className="tracking-more-wider font-medium">{props.number}</p>
        </div>
        <div className="pt-6 pr-6">
          <div className="flex justify-between">
            {/* <div className="">
              <p className="text-xs font-light">Valid</p>
              <p className="text-sm font-medium tracking-wider">
                {props.valid}
              </p>
            </div> */}
            <div className="">
              <p className="text-xs font-light">Expiry</p>
              <p className="text-sm font-medium tracking-wider">
                {props.expiry}
              </p>
            </div>

            <div className="">
              <p className="text-xs font-light">CVV</p>
              <p className="tracking-more-wider text-sm font-bold">
                {props.cvv}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
