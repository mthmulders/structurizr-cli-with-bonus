# Introduction

This Docker image does exactly what the `structurizr/cli` image does, but with the added configuration that it allows a run within Github Actions workflow or Gitlab CI job.
Its default entrypoint is to run Structurizr, but you can run PlantUML inside it, too.

It includes additional tools such as Git, jq, and PlantUML, as well as Graphviz and `structurizr.sh`.
This makes this image ideal for advanced diagram generation and version control in Structurizr projects including documentation-as-code.
The image is automatically built and published using a GitHub Actions workflow.

For now this image depends on manually updating the URLs for downloading Structurizr and PlantUML; the version history is documented at the end of this file.

## Why do I need this?

I use this image to generate SVG diagrams from a Structurizr workspace, with PlantUML as the "step-in-between".
To ensure the generated diagrams are consistent, this image is pulled by developers to extract diagrams from the workspace.
In a pipeline, I mostly use the image to check if the diagrams were updated - but you could also use it to generate them and add them to the Git repository.

## Getting the Image

The image is automatically built and published to the GitHub Container Registry. You can pull the image using the following command:

```bash
docker pull ghcr.io/mthmulders/structurizr-cli-with-bonus:latest
```

Alternatively, to build the image locally:

```bash
git clone git@github.com:mthmulders/structurizr-cli-with-bonus.git
cd structurizr-cli-with-bonus
docker build -t my-structurizr-image .
```

## How to Use the Image

Run a container based on the image:

```bash
# Runs Structurizr, append only arguments to structurizr-cli
docker run --rm -v $(pwd):/workspace ghcr.io/mthmulders/structurizr-cli-with-bonus:latest export --workspace workspace/my-workspace.dsl --format plantuml

# Runs PlantUML
docker run --rm --entrypoint /usr/local/bin/plantuml -v $(pwd):/workspace ghcr.io/mthmulders/structurizr-cli-with-bonus:latest -tsvg workspace/my-diagram.puml -o .
```

This command runs the container interactively, removes it after exit, and mounts the current directory to the container's workspace.

## Included Tools

- **jq**: A lightweight and flexible command-line JSON processor.
- **Git**: For version control of your Structurizr projects.
- **Graphviz**: Enables graph-based diagram representations.
- **PlantUML**: Supports UML diagram generation within Structurizr.

## Versions

| Image version | Java version | Structurizr CLI version | PlantUML version |
| --- | --- | --- | --- |
| *unreleased* | 25.0.1_8 | v2025.11.09 | v1.2026.0 |
| **v20251118.1** | 25.0.1_8 | v2025.11.01 | v1.2025.10 |
| **v20251021.1** | 25+36 | v2025.05.28 | v1.2025.9 |

## Credits

This image is a fork of the incredible work done by [Sébastien Fichot](sebastienfi/structurizr-cli-with-bonus).
It builds on top of that by

- using a more recent version of Java;
- publishing images for multiple CPU architectures;
- using a more recent version of PlantUML;

## Contributing

If you have suggestions for improving this Docker image, please submit an issue or pull request to the repository.
