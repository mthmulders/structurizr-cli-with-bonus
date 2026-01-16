# Notes:
#   - about USER: GitHub Actions requires Docker actions to run as the default Docker user (root). This is because non-root users might not have access to the GITHUB_WORKSPACE directory. 
#   - about WORKDIR: GitHub recommends avoiding the use of the WORKDIR instruction in Dockerfiles for actions. This is because GitHub sets the working directory path in the GITHUB_WORKSPACE environment variable and mounts this directory at the specified location in the Docker image, potentially overwriting anything that was there. 
#   - about ENTRYPOINT: GitHub Actions recommend using an absolute path for the entrypoint. 

# Builder stage
FROM eclipse-temurin:25.0.1_8-jre-noble AS builder

# Install dependencies
RUN apt-get update && \
    apt-get install -y -q curl graphviz unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PlantUML
RUN curl -sLOJ https://github.com/plantuml/plantuml/releases/download/v1.2026.0/plantuml.jar --output-dir /usr/local/bin/ && \
    echo '#!/bin/bash\njava -jar /usr/local/bin/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
    chmod +x /usr/local/bin/plantuml

# Copy and setup Structurizr CLI
RUN curl -sLOJ https://github.com/structurizr/cli/releases/download/v2025.11.09/structurizr-cli.zip && \
    mkdir /structurizr-cli && \
    unzip structurizr-cli.zip -d /structurizr-cli && \
    chmod +x /structurizr-cli/structurizr.sh

# Verify versions of installed software
RUN plantuml --version && \
    /structurizr-cli/structurizr.sh version && \
    java -version

### Final image
FROM eclipse-temurin:25.0.1_8-jre-noble

LABEL org.opencontainers.image.source="https://github.com/mthmulders/structurizr-cli-with-bonus" 
LABEL org.opencontainers.image.description A Docker image with structurizr-cli, Git, Graphviz, jq, and PlantUML installed.
LABEL org.opencontainers.image.licenses="MIT"

# Install dependencies and clean up
RUN apt-get update && \
    apt-get install -y -q graphviz jq git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy necessary files from builder stage
COPY --from=builder /structurizr-cli /usr/local/structurizr-cli
COPY --from=builder /usr/local/bin/plantuml.jar /usr/local/bin/
COPY --from=builder /usr/local/bin/plantuml /usr/local/bin/

# Update PATH
ENV PATH=/usr/local/structurizr-cli/:/usr/local/bin/:$PATH

# Setup Git configuration
RUN git config --global user.name github-actions && \
    git config --global user.email github-actions@github.com

# Set the entry point with an absolute path
ENTRYPOINT ["/usr/local/structurizr-cli/structurizr.sh"]
