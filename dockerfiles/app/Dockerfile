FROM elixir:1.8.1-slim

WORKDIR /app

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo \
    curl \
    git \
    build-essential \
    inotify-tools

RUN yes | mix local.hex
RUN yes | mix archive.install hex phx_new ${PHOENIX_VERSION}
RUN mix local.rebar --force

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn
RUN apt-get clean

CMD ["mix", "phx.server"]