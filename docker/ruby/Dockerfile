FROM ruby:3.1.3-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN bundle install

ENTRYPOINT ["bundle", "exec", "ruby"]
CMD ["-v"]
