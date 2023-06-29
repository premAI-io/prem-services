# 🤖 Prem Services

## Contributing 

Each folder represents one or more Prem services. All the current services have been built with Python and FastAPI. In order to create a new service you need to create a new folder or extend an existing one.

### Release Process

1. Extend or create a new folder with the model you wanna serve.
2. Extend the `scripts/` folder with the commands to build the docker images
3. Build the service and publish the new images.

> Make sure to set visibility as `Public` for the new docker images. Go to `Packages > {package} > Package settings > Change Visibility`.

4. Create a pull request to the Registry with all the necessary info. You can check the Registry documentation [here](https://dev.premai.io/docs/registry)

### How to serve a Model

How to serve a model it's up to you, but we suggest you follow the same pattern as we did for all the other services using FastAPI. A Service Packaging refactoring will come in the next months.
