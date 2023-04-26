FROM python:3.10-slim-bullseye

# Install all python3.10 dependencies
RUN --mount=type=cache,target=/var/cache/apt \
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
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    --quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    libpq-dev \
    postgresql-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# For weasyprint
RUN --mount=type=cache,target=/var/cache/apt \
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

# Create a working directory
RUN mkdir --parents /opt/app/donggiang_store
WORKDIR /opt/app/donggiang_store

# Copy requirements.txt
COPY requirements.txt /opt/app/donggiang_store/
# Install project dependencies from requirements.txt
# hadolint ignore=DL3013
RUN pip install --upgrade --no-cache-dir pip \
    && pip install --no-cache-dir --requirement requirements.txt

# Copy source code to working directory
COPY . /opt/app/donggiang_store/
# Copy environment variable
COPY .env /opt/app/donggiang_store/

# Expose port 8000 for Django as default port
EXPOSE 8000

# Runserver at container launch
CMD ["/opt/app/donggiang_store/start-server.sh"]
