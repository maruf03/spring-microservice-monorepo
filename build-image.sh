#!/bin/bash

# List of Maven project directories relative to the current directory
PROJECT_DIRS=(
    "config-server"
    "gateway"
    "service-registry"
    "demo-service"
)

# Initialize counters and arrays for Docker build status
SUCCESS_COUNT=0
FAILURE_COUNT=0
SUCCESSFUL_PROJECTS=()
FAILED_PROJECTS=()

# Docker image creation
for project in "${PROJECT_DIRS[@]}"; do
    if [ -d "$project" ]; then
        if [ -f "$project/Dockerfile" ]; then
            echo "Creating Docker image for $project"
            cd "$project" || exit
            # Create Docker image, using project directory name as image name
            if docker build -t "$project:latest" .; then
                echo "Docker image created successfully for $project"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
                SUCCESSFUL_PROJECTS+=("$project")
            else
                echo "Docker image creation failed for $project"
                FAILURE_COUNT=$((FAILURE_COUNT + 1))
                FAILED_PROJECTS+=("$project")
            fi
            cd .. || exit
        else
            echo "No Dockerfile found in $project, skipping Docker image creation..."
        fi
    else
        echo "Directory $project does not exist, skipping..."
    fi
done

# Final Summary
echo
echo "Docker Image Creation Summary:"
echo "-------------------------------"
echo "Successful Docker images: $SUCCESS_COUNT"
for project in "${SUCCESSFUL_PROJECTS[@]}"; do
    echo "  - $project"
    done
echo "Failed Docker images: $FAILURE_COUNT"
for project in "${FAILED_PROJECTS[@]}"; do
    echo "  - $project"
done

# Return appropriate exit code
if [ $FAILURE_COUNT -eq 0 ]; then
    exit 0
else
    exit 1
fi
