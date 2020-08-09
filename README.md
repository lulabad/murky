# Murky - the markdown experience

A simple markdown wiki

## Description

`Murky` is a simple Markdown wiki written in Elixir with Phoenix Liveview.

## Usage

To start your Phoenix server:

-   Setup the project with `mix setup`
-   Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Docker

To create and start the docker image run:

```sh
docker-compose -f "docker-compose.yml" up -d --build
```

After the image is build and up you can reach the application with [http://localhost:4000](http://localhost:4000)

## Run tests

To run the tests you need to set the environment variable `STORAGE_PATH` to a directory. The directory does not need to exist and will be **deleted** by the test.

On Windows:

```powershell
$env:STORAGE_PATH="xxx"
```

Then you can run the tests with `mix test`
