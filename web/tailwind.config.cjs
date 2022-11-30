/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      gridTemplateColumns: {
        main: "1fr 1024px 1fr",
      }
    },
  },
  daisyui: {
    themes: false,
  },
  plugins: [require("daisyui")],
};
