# Base image
FROM ubuntu:22.04

# Set arguments
ARG LISTEN_PORT=6800
ARG DOWNLOAD_DIR=/downloads
ARG CONFIG_DIR=/config

ARG WEBUI_PORT=80

# Install python3.10 & aria2 if not already included in the base image
RUN apt-get update && \
    apt-get install -y python3.10 aria2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create download directory
RUN mkdir -p ${DOWNLOAD_DIR}

# Create config directory
RUN mkdir -p ${CONFIG_DIR}

# Create webui directory
RUN mkdir -p /webui-aria2

ADD src/webui-aria2 /webui-aria2

# # Set working directory
# WORKDIR /webui-aria2

# Set working directory for downloads
WORKDIR ${DOWNLOAD_DIR}

# Expose RPC port
EXPOSE ${LISTEN_PORT}

# Expose Web UI port
EXPOSE ${WEBUI_PORT}

# Start aria2c with RPC mode
# CMD ["aria2c", "--conf-path=${CONFIG_DIR}/aria2.conf"]

# Start web server
# CMD ["/usr/bin/python3.10", "-m", "http.server", ${WEBUI_PORT}]
