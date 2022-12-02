import { useEffect, useRef, useState } from "react";
import type { MutableRefObject } from "react";
import Image from "next/image";

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
      <Image
        className="relative h-full w-full rounded-[0.75em] object-cover"
        alt={`${props.type} card`}
        src={props.type === "credit" ? "/credit-card.png" : "/debit-card.png"}
        height={183}
        width={343}
      />

      <div className="absolute top-[0em] w-full p-[2em]">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-[1em] font-bold">Name</p>
            <p className="font-medium tracking-widest">{props.name}</p>
          </div>
          <picture>
            <Image
              alt="card flag"
              className="h-[3em] w-[3em]"
              width={3}
              height={3}
              src="/mastercard.svg"
            />
          </picture>
        </div>
        <div className="mt-[1em]">
          <p className="font-bold">Card Number</p>
          <p className="tracking-more-wider font-medium">{props.number}</p>
        </div>
        <div className="pt-[1em] pr-[1em]">
          <div className="flex justify-between">
            <div className="">
              <p className="text-[0.75em] font-bold">Expiry</p>
              <p className="text-[0.75em] font-medium tracking-wider">
                {props.expiry}
              </p>
            </div>

            <div className="">
              <p className="text-[0.75em] font-bold">CVV</p>
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
