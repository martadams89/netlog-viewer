# Use the latest ubuntu base image
FROM ubuntu:24.04

# Install necessary it and python
RUN apt-get update && \
    apt-get install -y python3 git curl && \
    apt-get clean

# Set the working directory
WORKDIR /opt

# Clone the catapult repository
RUN git clone https://github.com/catapult-project/catapult.git

# Set the working directory to netlog_viewer
WORKDIR /opt/catapult/netlog_viewer

# Expose the port the app runs on
EXPOSE 8080

#checkov:skip=CKV_DOCKER_3: container needs to run as root

# Health check to verify if the webapp is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/index.html || exit 1

# Command to run the HTTP server
CMD ["python", "-m", "SimpleHTTPServer", "8080"]
