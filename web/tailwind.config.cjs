/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    colors: {
      transparent: "transparent",
      black: "#000",
      white: "#fff",
    },
    fontSize: {
      xs: 14,
      sm: 16,
      md: 18,
      lg: 20,
      xl: 24,
      '2xl': 32,
      '3xl': 72,
    },
    extend: {
      gridTemplateColumns: {
        main: "1fr 1fr",
      },
      fontFamily: {
        sans: 'Zen Kaku Gothic New, sans-serif'
      }
    },
  },
  daisyui: {
    themes: false,
  },
  plugins: [require("daisyui"), require('flowbite/plugin')],
};
