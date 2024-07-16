# Use the latest ubuntu base image
FROM ubuntu:24.04

# Install necessary tools and python
RUN apt-get update && \
    apt-get install -y python3 python3-pip git curl npm && \
    apt-get clean

# Install vulcanize globally using npm
RUN npm install -g vulcanize

# Set the working directory
WORKDIR /opt/netlog-viewer

# Copy only the netlog_viewer directory
COPY netlog_viewer /opt/netlog-viewer/netlog_viewer

# Set the working directory to netlog_viewer
WORKDIR /opt/netlog-viewer/netlog_viewer

# Run the build script to package the app for deployment
RUN ./netlog_viewer_build/build_for_appengine.py

# Set the working directory to the appengine directory
WORKDIR /opt/netlog-viewer/netlog_viewer/appengine

# Install Flask and other dependencies
RUN pip3 install -r requirements.txt

# Expose the port the app runs on
EXPOSE 8080

# Health check to verify if the webapp is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080 || exit 1

# Command to run the static HTTP server script using an absolute path
CMD ["/opt/netlog-viewer/netlog_viewer/bin/serve_static"]
