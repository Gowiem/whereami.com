FROM elixir:latest

RUN mkdir -p /app
WORKDIR /app
COPY ./config ./config
COPY ./lib ./lib
COPY ./mix.* ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

CMD ["mix", "run", "--no-halt"]
