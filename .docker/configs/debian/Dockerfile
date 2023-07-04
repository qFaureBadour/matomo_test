FROM debian:buster-slim
WORKDIR /var/www/project

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gnupg \
    tzdata \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn \
    && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && apt-get autoremove --purge -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
