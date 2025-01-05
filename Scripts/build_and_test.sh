#!/bin/bash

set -e

# Create Logs Directory
# Ensure the 'Scripts' directory exists
mkdir -p Scripts

# Create Logs Directory
mkdir -p TestLogs

# Build and Test Function
function build_and_test() {
  echo "Starting Build and Test..."

  # Navigate to the correct directory
  cd OpenAPIHandlerGen || { echo "Directory OpenAPIHandlerGen not found!"; exit 1; }

  # Verify Package.swift exists
  if [ ! -f Package.swift ]; then
    echo "Package.swift not found in OpenAPIHandlerGen!" > ../TestLogs/error-$(date +'%Y%m%d-%H%M%S').log
    exit 1
  fi

  # Check Swift Version
  swift --version

  # Compile Sources
  echo "Building project..."
  swift build 2>&1 | tee ../TestLogs/build-$(date +'%Y%m%d-%H%M%S').log

  # Run Tests
  echo "Running tests..."
  swift test 2>&1 | tee ../TestLogs/test-results-$(date +'%Y%m%d-%H%M%S').log
}

# Execute the Build and Test Workflow
build_and_test

# Commit logs to GitHub repository
cd ..
git add TestLogs/*.log
git commit -m "Add logs from build and test run on $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main

# Final Message
echo "Build and Test Completed Successfully!"
