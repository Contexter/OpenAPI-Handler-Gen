import os
import shutil
from datetime import datetime

def find_repo_root():
    """
    Find the root of the repository by looking for a .git directory.
    Returns the absolute path to the repository root.
    """
    current_dir = os.getcwd()
    while current_dir != os.path.dirname(current_dir):  # Stop at the root directory
        if os.path.isdir(os.path.join(current_dir, ".git")):
            return current_dir
        current_dir = os.path.dirname(current_dir)
    raise FileNotFoundError("Repository root not found. Make sure this script is in a Git repository.")

def backup_migrations_tests():
    """
    Backup the MigrationsGeneratorTests directory into a timestamped folder at the repo root.
    """
    try:
        # Find the repository root
        repo_root = find_repo_root()
        print(f"Repository root detected at: {repo_root}")

        # Define source and backup paths
        source_dir = os.path.join(repo_root, "OpenAPIHandlerGen", "Tests", "MigrationsGeneratorTests")
        if not os.path.exists(source_dir):
            raise FileNotFoundError(f"Source directory '{source_dir}' does not exist.")

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_dir = os.path.join(repo_root, f"MigrationsGeneratorTestsBackup_{timestamp}")

        # Perform the backup
        shutil.copytree(source_dir, backup_dir)
        print(f"Migrations Generator Tests successfully backed up to '{backup_dir}'.")

    except Exception as e:
        print(f"Error during backup: {e}")

if __name__ == "__main__":
    backup_migrations_tests()

