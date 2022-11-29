import { useState, Fragment } from "react";
import type { ChangeEvent } from "react";
import { Dialog, Tab, Transition } from "@headlessui/react";
import Button from "./Button";
import clsx from "clsx";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api, requestInit } from "../auth/AuthContext";

interface Values {
  type: "credit" | "debit";
  limit?: number;
}

export default function CreateCard() {
  const [isOpen, setIsOpen] = useState(false);
  const [limit, setLimit] = useState(0);

  const queryClient = useQueryClient();

  const { mutate } = useMutation(
    ["createCard"],
    (values: Values) =>
      fetch(api + "/cards", {
        ...requestInit,
        method: "POST",
        body: JSON.stringify(values),
      }),
    {
      onSettled: () => setIsOpen(false),
      onSuccess: () => queryClient.invalidateQueries(["cards"]),
    }
  );

  function closeModal() {
    setIsOpen(false);
  }

  function openModal() {
    setIsOpen(true);
  }

  function createCard(type: "debit" | "credit") {
    if (type === "credit") {
      mutate({ type, limit });
    } else {
      mutate({ type });
    }
  }

  return (
    <>
      <div
        onClick={openModal}
        className="relative h-56 w-96 transform cursor-pointer rounded-xl bg-gray-400 text-white shadow-2xl transition-transform hover:scale-105"
      >
        <div className="flex h-full items-center justify-center text-5xl">
          +
        </div>
      </div>
      <Transition appear show={isOpen} as={Fragment}>
        <Dialog as="div" className="relative z-10" onClose={closeModal}>
          <Transition.Child
            as={Fragment}
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 bg-black bg-opacity-25" />
          </Transition.Child>

          <div className="fixed inset-0 overflow-y-auto">
            <div className="flex min-h-full items-center justify-center p-4 text-center">
              <Transition.Child
                as={Fragment}
                enter="ease-out duration-300"
                enterFrom="opacity-0 scale-95"
                enterTo="opacity-100 scale-100"
                leave="ease-in duration-200"
                leaveFrom="opacity-100 scale-100"
                leaveTo="opacity-0 scale-95"
              >
                <Dialog.Panel className="w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all">
                  <Dialog.Title
                    as="h3"
                    className="text-lg font-medium leading-6 text-gray-900"
                  >
                    Creating a new card
                  </Dialog.Title>

                  <div className="mt-4">
                    <Tab.Group>
                      <Tab.List className="flex justify-around rounded bg-gray-300 p-1">
                        <Tab
                          className={({ selected }) =>
                            clsx("w-full rounded py-2", {
                              "bg-white": selected,
                            })
                          }
                        >
                          Debit
                        </Tab>
                        <Tab
                          className={({ selected }) =>
                            clsx("w-full rounded py-2", {
                              "bg-white": selected,
                            })
                          }
                        >
                          Credit
                        </Tab>
                      </Tab.List>
                      <Tab.Panels>
                        <Tab.Panel>
                          <div className="mt-4">
                            <Button onClick={() => createCard("debit")}>
                              Create card
                            </Button>
                          </div>
                        </Tab.Panel>
                        <Tab.Panel>
                          <div className="form-control w-full max-w-xs">
                            <label className="label">
                              <span className="label-text">
                                Enter your desired limit
                              </span>
                            </label>
                            <input
                              type="text"
                              placeholder="Type here"
                              value={limit}
                              onChange={(e: ChangeEvent<HTMLInputElement>) => {
                                const result = e.target.value.replace(
                                  /\D/g,
                                  ""
                                );
                                setLimit(Number(result));
                              }}
                              className="input-bordered input w-full max-w-xs"
                            />
                          </div>
                          <div className="mt-4">
                            <Button onClick={() => createCard("credit")}>
                              Create card
                            </Button>
                          </div>
                        </Tab.Panel>
                      </Tab.Panels>
                    </Tab.Group>
                  </div>
                </Dialog.Panel>
              </Transition.Child>
            </div>
          </div>
        </Dialog>
      </Transition>
    </>
  );
}
