ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem update --system && gem install bundler

# ── Gems ──────────────────────────────────────────────────────────────────────
FROM base AS gems

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ /usr/local/bundle/ruby/*/cache

# ── App ───────────────────────────────────────────────────────────────────────
FROM base AS app

COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=false

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
