FROM python:3.10-slim-bullseye as builder

# Install all python3.10 dependencies
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    --quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    build-essential \
    python3-dev \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# For postgres:
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    --quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    libpq-dev \
    postgresql-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# For weasyprint
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    --quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    libpango-1.0-0 \
    libharfbuzz0b \
    libpangoft2-1.0-0 \
    libffi-dev \
    libjpeg-dev \
    libopenjp2-7-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app/
# Upgrade pip
# hadolint ignore=DL3013
RUN pip install --upgrade --no-cache-dir pip
# Copy requirements.txt
COPY requirements.txt .
# Run pip wheel
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels --requirement requirements.txt

# Final state
FROM python:3.10-slim-bullseye

# create the app user
RUN useradd --user-group --create-home app

# Define user home
ENV HOME=/home/app
ENV APP_HOME=/home/app/web

# Create a working directory
RUN mkdir --parents $APP_HOME \
    && mkdir --parents $APP_HOME/static_cdn/static_root \
    && mkdir --parents $APP_HOME/static_cdn/media_root
WORKDIR $APP_HOME

# Install postgres dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    --quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    make \
    awscli \
    libpq-dev \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --no-cache-dir /wheels/*

# Copy source code to working directory
COPY . $APP_HOME

# chown all the files to the app user
RUN chown --recursive --from=root:root app:app $APP_HOME

# change to the app user
USER app

# Expose port 8000 for Django default port
EXPOSE 8000

ARG profile=""
ENV profile="$profile"

# Change permission
RUN chmod +x /home/app/web/*.sh

# Entrypoint
ENTRYPOINT ["/home/app/web/entrypoint.sh"]

# Runserver at container launch
CMD ["/home/app/web/start-server.sh"]
