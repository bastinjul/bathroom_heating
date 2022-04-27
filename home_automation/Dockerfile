FROM elixir:1.13.4

EXPOSE 4000

WORKDIR /app

RUN apt-get update && \
  apt-get install -y postgresql-client inotify-tools

RUN mix local.hex --force

COPY entrypoint.sh /app/entrypoint.sh

RUN echo $(ls -l /app)

RUN chmod +x entrypoint.sh

RUN echo $(ls -l /app)

ENTRYPOINT ["/app/entrypoint.sh"]