# Use the latest python base image
FROM python:3.11-slim

# Set the working directory
WORKDIR /opt/netlog-viewer

# Copy only the necessary files to the container
COPY appengine /opt/netlog-viewer/appengine

# Set the working directory to appengine
WORKDIR /opt/netlog-viewer/appengine

# Install Flask and other dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 8080

# Health check to verify if the webapp is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080 || exit 1

# Command to run the Flask application
CMD ["python", "main.py"]
