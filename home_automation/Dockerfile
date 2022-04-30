FROM elixir:1.13.4

EXPOSE 4000

RUN apt-get update && \
  apt-get install -y postgresql-client inotify-tools

WORKDIR /app

RUN mix local.hex --force

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]