# OpenAPI Handler Generator

The **OpenAPI Handler Generator** is a Swift-based tool designed to streamline the process of generating server-side code, including **handlers**, **services**, **models**, and **migrations**, based on OpenAPI specifications.

## Key Features

- **Handler Generation**: Create route handlers automatically from OpenAPI endpoint definitions.
- **Service Layer Creation**: Build corresponding service logic for each route handler.
- **Model Generation**: Generate models to represent request and response structures.
- **Migration Scaffolding**: Automatically scaffold database migrations for models.
- **Hybrid Approach**: Combines the use of OpenAPI files and server/Type extractors for flexibility.

## How It Works

This tool uses a combination of:
- **Apple's OpenAPI Generator Output**: Uses the generated output, including request/response models and server stubs, as the basis for further code generation.
- **Custom Extractors**: These include:
  - `OpenAPIFileEndpointExtractor` - Parses OpenAPI files to extract endpoint definitions.
  - `ServerFileExtractor` - Analyzes existing server-side code to integrate new handlers seamlessly.
  - `TypesFileExtractor` - Extracts complex type definitions for models.

The tool harmonizes the output of Apple's generator with its extractors to ensure consistency and accuracy.

## Requirements

- macOS
- Xcode and Swift (latest stable version)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Contexter/OpenAPI-Handler-Gen.git
   cd OpenAPI-Handler-Gen
   ```
2. Build the project:
   ```bash
   swift build
   ```

## Usage

### Generating Handlers and Services

To generate handlers and services:
```bash
swift run OpenAPIHandlerGen <path_to_openapi_file> <path_to_server_code> <path_to_types_code> <output_path>
```

Example:
```bash
swift run OpenAPIHandlerGen ./openapi.yaml ./Server ./Types ./Output
```

### Running Tests

Run the test suite to validate functionality:
```bash
swift test
```

### Directory Structure

- **Sources**: The main implementation files for the generator.
  - `Core/`: Core logic and orchestration.
  - `Extractors/`: Logic for extracting endpoints, routes, and types.
  - `Generators/`: Logic for generating handlers, services, and migrations.
- **Tests**: Unit and integration tests.

### Integration with Apple's OpenAPI Generator

This tool does not directly run the Apple OpenAPI Generator but instead utilizes its output as a foundation for additional processing and customization. Users must run the generator separately and provide its output to the **OpenAPI Handler Generator** for further processing.

## Contributing

Contributions are welcome! Please fork the repository, make changes, and submit a pull request. Ensure all tests pass before submitting your PR.

## License

This project is licensed under the MIT License.

