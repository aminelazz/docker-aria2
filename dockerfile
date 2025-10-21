# ---- Stage 1: Clone the webui-aria2 repository ----
FROM alpine/git AS clone-webui

# Clone the webui-aria2 repository
RUN git clone https://github.com/ziahamza/webui-aria2.git /webui-aria2

# ---- Stage 2: Build the final image ----
# Base image (Python 3.10 on Alpine 3.22)
FROM python:3.10-alpine3.22

# Set arguments
ARG LISTEN_PORT=6800
ARG DOWNLOAD_DIR=/downloads
ARG CONFIG_DIR=/config

ARG WEBUI_PORT=80

# Install aria2
RUN apk add --no-cache aria2

# Copy webui-aria2 from the clone stage
COPY --from=clone-webui /webui-aria2 /webui-aria2

# Create download directory
RUN mkdir -p ${DOWNLOAD_DIR}

# Create config directory
RUN mkdir -p ${CONFIG_DIR}

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
