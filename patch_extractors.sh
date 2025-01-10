#!/bin/bash

# Define the files to be patched
CORE_FILE="./Sources/Core/OpenAPIHandlerGen.swift"
SERVICE_GENERATOR_FILE="./Sources/Generators/ServiceGenerator.swift"
HANDLER_GENERATOR_FILE="./Sources/Generators/HandlerGenerator.swift"

# Update OpenAPIHandlerGen.swift
sed -i '' -e 's/EndpointExtractor/OpenAPIFileEndpointExtractor/g' "$CORE_FILE"

# Update ServiceGenerator.swift
sed -i '' -e 's/EndpointExtractor.Endpoint/OpenAPIFileEndpointExtractor.Endpoint/g' "$SERVICE_GENERATOR_FILE"

# Update HandlerGenerator.swift
sed -i '' -e 's/EndpointExtractor.Endpoint/OpenAPIFileEndpointExtractor.Endpoint/g' "$HANDLER_GENERATOR_FILE"

# Verify changes
echo "Patching completed. Here's the diff for verification:"

# Show diff for each file
for file in "$CORE_FILE" "$SERVICE_GENERATOR_FILE" "$HANDLER_GENERATOR_FILE"; do
    echo "Diff for $file:"
    git diff "$file"
done

echo "Patching done. Run 'swift build' and 'swift test' to validate the changes."

