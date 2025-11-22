FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    git \
    curl \
    wget \
    bats \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy the git-remote-web script
COPY git-remote-web /app/git-remote-web
COPY tests /app/tests

# Make scripts executable
RUN chmod +x /app/git-remote-web /app/tests/run_tests.sh

# Configure git for testing
RUN git config --global user.email "test@example.com" && \
    git config --global user.name "Test User"

# Default command
CMD ["bash", "/app/tests/run_tests.sh"]
