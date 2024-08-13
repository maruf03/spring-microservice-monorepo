#!/bin/bash

# List of Maven project directories relative to the current directory
PROJECT_DIRS=(
    "config-server"
    "gateway"
    "service-registry"
    "demo-service"
)

# Check if there are any Maven arguments provided
MAVEN_ARGS="$@"

# Initialize counters and arrays for build status
SUCCESS_COUNT=0
FAILURE_COUNT=0
SUCCESSFUL_PROJECTS=()
FAILED_PROJECTS=()

# Iterate over each project directory
for dir in "${PROJECT_DIRS[@]}"; do
    # Check if the directory exists
    if [ -d "$dir" ]; then
        echo "Building project in directory: $dir"
        cd "$dir" || exit
        # Run Maven build with optional arguments
        if mvn clean package $MAVEN_ARGS; then
            echo "Build successful for $dir"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            SUCCESSFUL_PROJECTS+=("$dir")
        else
            echo "Build failed for $dir"
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
            FAILED_PROJECTS+=("$dir")
        fi
        cd .. || exit
    else
        echo "Directory $dir does not exist, skipping..."
    fi
done

# Summary
echo
echo "Build Summary:"
echo "---------------"
echo "Successful builds: $SUCCESS_COUNT"
for project in "${SUCCESSFUL_PROJECTS[@]}"; do
    echo "  - $project"
done
echo "Failed builds: $FAILURE_COUNT"
for project in "${FAILED_PROJECTS[@]}"; do
    echo "  - $project"
done

# Return appropriate exit code
if [ $FAILURE_COUNT -eq 0 ]; then
    exit 0
else
    exit 1
fi