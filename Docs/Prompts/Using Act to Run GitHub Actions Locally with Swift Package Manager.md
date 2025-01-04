

# Using Act to Run GitHub Actions Locally with Swift Package Manager

*Date: January 4, 2025*

---

## Table of Contents

1. [Introduction](#introduction)
2. [What is `act`?](#what-is-act)
3. [Prerequisites](#prerequisites)
4. [Installing `act`](#installing-act)
5. [Setting Up GitHub Actions for SwiftPM](#setting-up-github-actions-for-swiftpm)
6. [Running Workflows Locally with `act`](#running-workflows-locally-with-act)
7. [Example: SwiftPM Project with `act`](#example-swiftpm-project-with-act)
8. [Advanced Configuration](#advanced-configuration)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Conclusion](#conclusion)

---

## Introduction

When working with Swift projects managed by Swift Package Manager (SwiftPM), setting up continuous integration (CI) workflows is essential for ensuring code quality and reliability. While GitHub Actions provides a robust CI/CD platform, there are scenarios where running these workflows locally can enhance development efficiency. This guide explores how to use [`act`](https://github.com/nektos/act), a tool that emulates GitHub Actions locally, enabling you to develop, test, and debug your CI/CD pipelines without pushing changes to your repository.

---

## What is `act`?

[`act`](https://github.com/nektos/act) is an open-source tool that allows you to run your GitHub Actions workflows locally using Docker. It emulates the GitHub Actions runner environment, enabling you to:

- **Test workflows** before pushing them to GitHub.
- **Debug actions** interactively.
- **Speed up development** by iterating locally without committing.

---

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

1. **Git:** Version control system.
2. **Docker:** Required by `act` to emulate the GitHub Actions environment.
3. **`act`:** The tool itself.
4. **Swift and Swift Package Manager (SwiftPM):** For managing your Swift projects.

---

## Installing `act`

### Using Homebrew (macOS and Linux)

If you're on macOS or Linux, you can install `act` using [Homebrew](https://brew.sh/):

```bash
brew install act
```

### Using Binary Releases

Alternatively, you can download pre-built binaries from the [act Releases](https://github.com/nektos/act/releases) page:

1. Go to the [act Releases](https://github.com/nektos/act/releases) page.
2. Download the appropriate binary for your operating system.
3. Make the binary executable and move it to a directory in your `PATH`:

    ```bash
    chmod +x act_<version>_<os>_<arch>
    sudo mv act_<version>_<os>_<arch> /usr/local/bin/act
    ```

### Verifying Installation

After installation, verify that `act` is installed correctly:

```bash
act --version
```

You should see output similar to:

```
0.2.25
```

---

## Setting Up GitHub Actions for SwiftPM

To use `act`, you need to have GitHub Actions workflows defined in your repository. Here's how to set up a basic workflow for a SwiftPM project.

### 1. Create a GitHub Actions Workflow

In your Swift project repository, create a directory for workflows if it doesn't exist:

```bash
mkdir -p .github/workflows
```

### 2. Define a Workflow YAML File

Create a workflow file, e.g., `swift.yml`:

```yaml
# .github/workflows/swift.yml
name: Swift CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Swift
        uses: actions/setup-swift@v3
        with:
          swift-version: '5.7' # Specify your Swift version

      - name: Build
        run: swift build -v

      - name: Run Tests
        run: swift test -v
```

**Explanation:**

- **`on`**: Triggers the workflow on pushes and pull requests to the `main` branch.
- **`jobs.build`**: Defines a job named `build`.
- **`runs-on`**: Specifies the runner environment (`ubuntu-latest`).
- **`steps`**: Defines the sequence of steps to execute:
  - **Checkout** the repository.
  - **Set up Swift** environment.
  - **Build** the project.
  - **Run Tests**.

### 3. Commit and Push

Commit your workflow file and push it to GitHub:

```bash
git add .github/workflows/swift.yml
git commit -m "Add Swift CI workflow"
git push origin main
```

GitHub Actions will automatically run this workflow on the specified triggers.

---

## Running Workflows Locally with `act`

Now, let's run the above workflow locally using `act`.

### 1. Initialize `act` in Your Repository

Navigate to your project's root directory (where `.github/workflows` is located).

### 2. List Available Workflows

To see the available workflows, run:

```bash
act -l
```

**Example Output:**

```
Available workflows:
  1. name: Swift CI
     event: push
     jobs: build
```

### 3. Run a Specific Workflow

To run the `Swift CI` workflow, execute:

```bash
act push
```

**Explanation:**

- **`push`**: Simulates a `push` event, triggering workflows that respond to `push` events.

### 4. Specify a Workflow File (Optional)

If you have multiple workflows or want to run a specific one, you can specify the workflow file:

```bash
act -e push --job build
```

**Note:** The `-e` flag can be used to specify a custom event payload, but for most standard events like `push`, you don't need to provide an event file.

### 5. Use a Specific Runner

By default, `act` uses `ubuntu-latest`. To specify a different runner, use the `-P` flag:

```bash
act push -P ubuntu-latest=nektos/act-environments-ubuntu:18.04
```

**Note:** Ensure that the Docker image corresponds to the runner specified in your workflow (`ubuntu-latest` in this case).

### 6. Interactive Mode

For an interactive experience, especially useful for debugging, use:

```bash
act -i
```

This allows you to inspect logs and outputs in real-time.

---

## Example: SwiftPM Project with `act`

Let's walk through a complete example of setting up `act` with a SwiftPM project.

### 1. Initialize a SwiftPM Project

If you don't already have a SwiftPM project, create one:

```bash
swift package init --type executable
```

### 2. Create the GitHub Actions Workflow

As described earlier, create `.github/workflows/swift.yml` with the following content:

```yaml
name: Swift CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Swift
        uses: actions/setup-swift@v3
        with:
          swift-version: '5.7'

      - name: Build
        run: swift build -v

      - name: Run Tests
        run: swift test -v
```

### 3. Install `act` and Docker

Ensure Docker is running on your machine. Install `act` as per the [Installing `act`](#installing-act) section.

### 4. Run the Workflow Locally

Execute the workflow:

```bash
act push
```

**Expected Output:**

`act` will:

1. Pull the necessary Docker images (if not already present).
2. Checkout your repository.
3. Set up the specified Swift version.
4. Build your project using `swift build`.
5. Run tests using `swift test`.

**Sample Output:**

```
[Build] 🚀  Start image=node:12.18.3
[Build]   🐳  docker pull nektos/act-environments-ubuntu:18.04
[Build]   🐳  docker pull ghcr.io/actions/checkout:3
[Build]   🐳  docker pull ghcr.io/actions/setup-swift:3
[Build]   🐳  docker pull nektos/act-environments-ubuntu:18.04
[Build]   🐳  docker pull ghcr.io/actions/setup-swift:3
[Build]   🐳  docker pull ghcr.io/actions/checkout:3
[Build]   🐳  docker pull ghcr.io/actions/setup-swift:3
[Build]   🐳  docker pull ghcr.io/actions/checkout:3
[Build]   🐳  docker pull ghcr.io/actions/setup-swift:3
[Build]   🐳  docker pull ghcr.io/actions/setup-swift:3
[Build] ⭐  Run actions/checkout@v3
[Build]   ...
[Build] ⭐  Run actions/setup-swift@v3
[Build]   ...
[Build] ⭐  Run swift build -v
[Build]   ...
[Build] ⭐  Run swift test -v
[Build]   ...
[Build] ✅  Complete job
```

**Note:** The actual output will include detailed logs of each step.

---

## Advanced Configuration

### 1. Customizing the Event Payload

By default, `act` uses a standard event payload. To customize it, create a JSON file representing the event and use the `-e` flag:

```json
// .act/event.json
{
  "ref": "refs/heads/main",
  "head_commit": {
    "message": "Add new feature",
    "author": {
      "name": "Your Name",
      "email": "you@example.com"
    }
  }
}
```

Run `act` with the custom event:

```bash
act push -e .act/event.json
```

### 2. Passing Secrets and Environment Variables

If your workflows use secrets, you can pass them to `act` using environment variables or a secrets file.

#### Using Environment Variables

Set secrets as environment variables with the `ACTIONS_SECRET_` prefix:

```bash
export ACTIONS_SECRET_MY_SECRET="supersecretvalue"
act push
```

#### Using a Secrets File

Create a `.secrets` file:

```bash
# .secrets
MY_SECRET=supersecretvalue
```

Run `act` with the secrets file:

```bash
act push --secret-file .secrets
```

### 3. Specifying a Docker Image for Runners

If you need a specific runner environment, specify it with the `-P` flag:

```bash
act push -P ubuntu-latest=nektos/act-environments-ubuntu:18.04
```

**Note:** Ensure the Docker image matches the runner environment required by your workflows.

### 4. Running Specific Jobs

If your workflow has multiple jobs, you can run a specific job:

```bash
act push --job build
```

---

## Troubleshooting

### 1. Docker Not Running

Ensure Docker is installed and running. `act` relies on Docker to emulate GitHub Actions runners.

**Solution:**

- Start Docker Desktop (macOS/Windows) or ensure the Docker daemon is running (Linux):

    ```bash
    sudo systemctl start docker
    ```

### 2. Permission Issues

Sometimes, Docker may require elevated permissions.

**Solution:**

- Run `act` with `sudo` (not recommended for regular use):

    ```bash
    sudo act push
    ```

- **Better Solution:** Add your user to the `docker` group:

    ```bash
    sudo usermod -aG docker $USER
    newgrp docker
    ```

### 3. Missing Docker Images

If `act` cannot find the required Docker images, it will attempt to pull them. Ensure you have a stable internet connection.

**Solution:**

- Manually pull the necessary images:

    ```bash
    docker pull nektos/act-environments-ubuntu:18.04
    docker pull ghcr.io/actions/checkout:3
    docker pull ghcr.io/actions/setup-swift:3
    ```

### 4. Workflow Errors

If your workflow fails when running with `act` but works on GitHub, check the following:

- **Differences in Environment:** Ensure the Docker image matches the GitHub runner.
- **Secrets and Environment Variables:** Ensure all required secrets are provided.
- **Network Access:** Some actions may require network access that might be restricted in Docker.

**Solution:**

- Compare the environment setups.
- Provide necessary secrets.
- Adjust Docker settings if needed.

---

## Best Practices

1. **Keep Workflows Modular:**
   - Break down complex workflows into smaller, manageable jobs.

2. **Use Caching:**
   - Utilize caching actions to speed up builds (note that caching with `act` might require additional configuration).

3. **Leverage `act` for Development:**
   - Regularly test and debug workflows locally with `act` before pushing to GitHub.

4. **Maintain Parity Between Local and CI Environments:**
   - Ensure the Docker images and environment configurations used by `act` match those used by GitHub Actions to prevent discrepancies.

5. **Version Control Your Workflows:**
   - Keep your workflow YAML files under version control to track changes and collaborate effectively.

6. **Document Secrets and Environment Variables:**
   - Clearly document required secrets and environment variables to streamline local testing.

---

## Conclusion

Using `act` to run GitHub Actions workflows locally can significantly enhance your development and CI/CD pipeline experience for SwiftPM projects. It allows for rapid iteration, debugging, and ensures that your workflows behave as expected before deploying them to GitHub. By following this guide, you should be well-equipped to integrate `act` into your Swift development workflow effectively.

