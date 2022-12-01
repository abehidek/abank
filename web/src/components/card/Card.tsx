import { useEffect, useRef, useState } from "react";
import type { MutableRefObject } from "react";

interface CardProps {
  name: string;
  number: string;
  // valid: string;
  expiry: string;
  cvv: string;
  type: "debit" | "credit";
}

export function Card(props: CardProps) {
  const ref = useRef(null);

  const { width } = useContainerDimensions(ref);

  return (
    <div
      ref={ref}
      style={{ fontSize: width / 26 }}
      className="relative max-h-56 max-w-sm transform rounded-xl text-white shadow-2xl"
    >
      <picture>
        <img
          className="relative h-full w-full rounded-[0.75em] object-cover"
          src={
            props.type === "credit"
              ? "https://i.imgur.com/Zi6v09P.png"
              : "https://i.imgur.com/kGkSg1v.png"
          }
          alt="Card"
        />
      </picture>

      <div className="absolute top-[0em] w-full p-[2em]">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-[1em] font-light">Name</p>
            <p className="font-medium tracking-widest">{props.name}</p>
          </div>
          <picture>
            <img
              className="h-[3em] w-[3em]"
              src="https://i.imgur.com/bbPHJVe.png"
              alt="Card flag"
            />
          </picture>
        </div>
        <div className="mt-[1em]">
          <p className="font-light">Card Number</p>
          <p className="tracking-more-wider font-medium">{props.number}</p>
        </div>
        <div className="pt-[1em] pr-[1em]">
          <div className="flex justify-between">
            {/* <div className="">
              <p className="text-xs font-light">Valid</p>
              <p className="text-sm font-medium tracking-wider">
                {props.valid}
              </p>
            </div> */}
            <div className="">
              <p className="text-[0.75em] font-light">Expiry</p>
              <p className="text-[0.75em] font-medium tracking-wider">
                {props.expiry}
              </p>
            </div>

            <div className="">
              <p className="text-[0.75em] font-light">CVV</p>
              <p className="tracking-more-wider text-[0.75em] font-bold">
                {props.cvv}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export const useContainerDimensions = (
  myRef: MutableRefObject<HTMLDivElement> | MutableRefObject<null>
) => {
  const [dimensions, setDimensions] = useState({ width: 0, height: 0 });

  useEffect(() => {
    const getDimensions = () => {
      if (myRef === null || !myRef.current) {
        return {
          width: 0,
          height: 0,
        };
      }

      return {
        width: myRef.current.offsetWidth,
        height: myRef.current.offsetHeight,
      };
    };

    const handleResize = () => {
      setDimensions(getDimensions());
    };

    if (myRef.current) {
      setDimensions(getDimensions());
    }

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, [myRef]);

  return dimensions;
};
