# Use the official Ubuntu base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python git && \
    apt-get clean

# Set the working directory
WORKDIR /opt

# Clone the catapult repository
RUN git clone https://github.com/catapult-project/catapult.git

# Set the working directory to netlog_viewer
WORKDIR /opt/catapult/netlog_viewer

# Expose the port the app runs on
EXPOSE 8080

# Command to run the HTTP server
CMD ["python", "-m", "SimpleHTTPServer", "8080"]
