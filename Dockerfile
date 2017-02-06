FROM elixir:latest

RUN mkdir -p /app
WORKDIR /app
COPY ./config ./config
COPY ./lib ./lib
COPY ./mix.* ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

ENV MIX_ENV=prod

RUN mix compile

CMD ["mix", "run", "--no-halt"]
