FROM elixir:latest

COPY ./config .
COPY ./lib .
COPY ./mix.* ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

CMD ["mix", "run", "--no-halt"]
