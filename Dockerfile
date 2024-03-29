FROM elixir:1.10-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
COPY deps/phoenix /node_modules/phoenix
COPY deps/phoenix_html /node_modules/phoenix_html
COPY deps/phoenix_live_view /node_modules/phoenix_live_view

RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release
# RUN ls -lR  /app/_build/prod/rel//
# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app
RUN mkdir wiki
RUN chown -R nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/murky ./


ENV HOME=/app
ENV STORAGE_PATH=/app/wiki
EXPOSE 4000
CMD ["bin/murky", "start"]
