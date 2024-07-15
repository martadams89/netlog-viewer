# Use the latest ubuntu base image
FROM ubuntu:24.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip git curl npm && \
    apt-get clean

# Install vulcanize
RUN npm install -g vulcanize

# Set the working directory
WORKDIR /opt

# Clone the catapult repository
RUN git clone https://chromium.googlesource.com/catapult

# Set the working directory to netlog_viewer
WORKDIR /opt/catapult/netlog_viewer

# Run the build script to package the app for deployment
RUN ./netlog_viewer_build/build_for_appengine.py

# Set the working directory to the appengine directory
WORKDIR /opt/catapult/netlog_viewer/appengine

# Verify the requirements file exists and display its contents
RUN ls -l /opt/catapult/netlog_viewer/appengine && cat /opt/catapult/netlog_viewer/appengine/requirements.txt

# Install Flask and other dependencies
RUN pip3 install -r /opt/catapult/netlog_viewer/appengine/requirements.txt

# Expose the port the app runs on
EXPOSE 8080

# Health check to verify if the webapp is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080 || exit 1

# Command to run the Flask server
CMD ["python3", "main.py"]
