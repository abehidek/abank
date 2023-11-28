<h1 align="center">
  <!--<br>
  Logo in progress... -->
  <br>
  Abank
  <br>
</h1>

<h4 align="center">Fintech services easily at your disposal.</h4>

<p align="center">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-purple">
  <img height=20 alt="Powered by phoenix framework" src="https://raw.githubusercontent.com/phoenixframework/media/master/badges/poweredby-phoenix-badge3-07.png">
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#faq">FAQ</a> •
  <a href="#roadmap">Roadmap</a> •
  <!-- <a href="#support">Support</a> • -->
  <a href="#license">License</a>
</p>

<!-- ![screenshot](screenshots/1.jpg) -->

## About

A digital bank system made for the SENAI final paper, using Elixir's Phoenix web framwork.

## Key Features

- Account transference via pix and TED/DOC.
- View balance and your transaction history.
- Debit and credit card.
- Pay other people using your card.
- Don't forget to pay your invoice before the due date!.
- Get a loan with your bank.
- Account score calculations made easy!.

## Getting Started

This repository contains the backend written in elixir with a docker-compose.yaml to spin-up a [PostgreSQL](https://www.postgresql.org/) database.

It also contains a Next.js project for client-side application and a Expo React Native project for mobile application.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- Backend: Elixir and Erlang OTP
- Backend: PostgreSQL (using docker or by installing in your machine)
- Web and Mobile: Node.js
- Mobile: Setup React Native proper environment.

### Installing and Running

Below is an example of how you can instruct your audience on installing and setting up your app. This template doesn't rely on any external dependencies or services.

```bash
# Clone this repository
$ git clone https://github.com/[your-github-user]/[your-repository-name]

# Go into the repository
$ cd [your-repository-name]
```

#### Server

```bash
$ cd server
$ docker-compose up -d # -d to detach from shell process
$ sh setup.sh
$ mix phx.server # or iex -S mix phx.server to live interaction
```

#### Web

Needs the server and Node.js with a package manager to be working properly.

```bash
$ cd web

# for npm users:
$ npm install
$ npm run dev

# for yarn users:
$ yarn
$ yarn dev

# for pnpm users:
$ pnpm install
$ pnpm run dev
```

## FAQ

### Is it any good?

[yes.](https://news.ycombinator.com/item?id=3067434)

## Roadmap

- [x] Start this README using [abehidek's template](https://github.com/abehidek/readme).
- [ ] Add the Roadmap section for README

## Emailware

[Project's name] is an [emailware](https://en.wiktionary.org/wiki/emailware). Meaning, if you liked using this app or it has helped you in any way, I'd like you send me an email at <your-email@email.com> about anything you'd want to say about this software. I'd really appreciate it!

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- ## Support

You can also support us by:

<p align="left">
  <a href="https://www.buymeacoffee.com" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a> &nbsp &nbsp
  <a href="https://www.patreon.com">
    <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
  </a>
</p> -->

## License

MIT

## Acknowledgments

Inspiration, code snippets, etc.

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Elixir](https://elixir-lang.org/)
- [Ecto](https://hexdocs.pm/ecto/Ecto.html)
- [Next.js](https://nextjs.org/)
- [React](https://reactjs.org/)

## You may also like...

List of apps or libs that do similar stuff as your project.

- [Dotto-bank](https://github.com/viktormarinho/dotto-bank-web)
- [Moitabank](https://github.com/vitormiura/moitabank/)
- [CAT digital bank](https://github.com/iguoliveira/cat-digital-bank)

---

> [abehidek.me](https://abehidek.me) &nbsp;&middot;&nbsp;
> GitHub [@abehidek](https://github.com/abehidek) &nbsp;&middot;&nbsp;
> Twitter [@guilhermehabe](https://twitter.com/guilhermehabe)
