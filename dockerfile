# Declare the platform argument with a default value
ARG TARGETPLATFORM=linux/amd64

FROM --platform=$TARGETPLATFORM ubuntu:20.04

# Set environment variables
ENV CURSOR_CLI_TELEMETRY_DISABLED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    libcurl4-openssl-dev \
    libssl-dev \
    nodejs \
    npm \
    tar \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /root

# Download and install Cursor CLI
RUN curl -L "https://api2.cursor.sh/updates/download-latest?os=cli-linux-x64" -o cli-linux-x64.tar.gz && \
    tar -xzf cli-linux-x64.tar.gz && \
    rm cli-linux-x64.tar.gz && \
    chmod +x cursor && \
    mv cursor /usr/local/bin/

# Install UV package installer
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Expose the default port
EXPOSE 8000

# Start Cursor tunnel service
CMD ["cursor", "tunnel"]