#!/bin/bash


# Variables
APP_NAME="simple-app"               
IMAGE_TAG="v1"                     
DOCKER_REGISTRY="docker.io/arunvel1988"    
DOCKER_USERNAME="arunvel1988"        
DOCKER_PASSWORD="Ssjcoe123@#"        
PORT=8000                         

# Step 1: Stop and remove the running container (if any)
echo "Stopping and removing the existing container (if running)..."
docker ps -q --filter "name=$APP_NAME" | grep -q . && docker stop "$APP_NAME" && docker rm "$APP_NAME"
if [ $? -eq 0 ]; then
    echo "Stopped and removed the existing container."
else
    echo "No running container found for $APP_NAME."
fi

# Step 2: Authenticate with Docker registry
echo "Authenticating with Docker registry..."
echo "$DOCKER_PASSWORD" | docker login "$DOCKER_REGISTRY" --username "$DOCKER_USERNAME" --password-stdin
if [ $? -ne 0 ]; then
    echo "Docker login failed. Please check your credentials."
    exit 1
fi

# Step 3: Build the Docker image
echo "Building Docker image..."
docker build -t "$DOCKER_REGISTRY/$APP_NAME:$IMAGE_TAG" .
if [ $? -ne 0 ]; then
    echo "Docker build failed. Please check the Dockerfile and context."
    exit 1
fi

# Step 4: Push the Docker image to the registry
echo "Pushing Docker image to the registry..."
docker push "$DOCKER_REGISTRY/$APP_NAME:$IMAGE_TAG"
if [ $? -ne 0 ]; then
    echo "Docker push failed. Please check your network or permissions."
    exit 1
fi

# Step 5: Run the new container
echo "Running the new Docker container..."
docker run -d --name "$APP_NAME" -p "$PORT:$PORT" "$DOCKER_REGISTRY/$APP_NAME:$IMAGE_TAG"
if [ $? -eq 0 ]; then
    echo "Container is up and running on port $PORT."
else
    echo "Failed to start the container."
    exit 1
fi

exit 0

