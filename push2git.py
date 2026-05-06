"""
push2git.py  —  Push an HTML file to AndreKnoesen/eec1-widgets on GitHub Pages.

Usage:
    python push2git.py "path\to\file.html"

If no argument is given the script will prompt for the path.

The script maintains a persistent local clone of the repo at:
    %LOCALAPPDATA%\eec1-widgets-clone
so it only clones once; subsequent runs do a fast `git pull` instead.
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path
from datetime import datetime

# ── Configuration ────────────────────────────────────────────────────────────
REPO_URL   = "git@github.com:aknoesen/eec1-widgets.git"
REPO_OWNER = "aknoesen"
REPO_NAME  = "eec1-widgets"
BRANCH     = "main"

# Persistent clone lives next to LOCALAPPDATA so it survives reboots
LOCAL_CLONE = Path(os.environ.get("LOCALAPPDATA", Path.home())) / "eec1-widgets-clone"
# ─────────────────────────────────────────────────────────────────────────────


def run(cmd: list[str], cwd: Path) -> str:
    """Run a git command, print it, raise on failure."""
    print("  git", " ".join(cmd[1:]))
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        print(result.stderr.strip())
        raise RuntimeError(f"Command failed: {' '.join(cmd)}")
    return result.stdout.strip()


def ensure_clone() -> Path:
    """Clone the repo if it doesn't exist locally, otherwise pull latest."""
    if LOCAL_CLONE.exists():
        print(f"[INFO] Using existing clone at {LOCAL_CLONE}")
        run(["git", "pull", "--ff-only", "origin", BRANCH], cwd=LOCAL_CLONE)
    else:
        print(f"[INFO] Cloning {REPO_URL} -> {LOCAL_CLONE}")
        subprocess.run(
            ["git", "clone", REPO_URL, str(LOCAL_CLONE)],
            check=True
        )
    return LOCAL_CLONE


def push_file(src: Path) -> None:
    if not src.exists():
        print(f"[ERROR] File not found: {src}")
        sys.exit(1)

    if src.suffix.lower() not in (".html", ".m"):
        print(f"[WARN] Unexpected file type: {src.name}")

    repo = ensure_clone()
    dest = repo / src.name

    # Copy file into repo root
    shutil.copy2(src, dest)
    print(f"[INFO] Copied  {src.name}  ->  {dest}")

    # Stage
    run(["git", "add", src.name], cwd=repo)

    # Check if there is actually a diff to commit
    status = subprocess.run(
        ["git", "status", "--porcelain", src.name],
        cwd=repo, capture_output=True, text=True
    ).stdout.strip()

    if not status:
        print("[INFO] No changes detected — file already up to date on GitHub.")
        return

    # Commit
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    msg = (
        f"Update {src.name}\n\n"
        f"Pushed via push2git.py at {timestamp}\n\n"
        f"Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
    )
    run(["git", "commit", "-m", msg], cwd=repo)

    # Push
    run(["git", "push", "origin", BRANCH], cwd=repo)

    pages_url = f"https://{REPO_OWNER.lower()}.github.io/{REPO_NAME}/{src.name.replace(' ', '%20')}"
    print()
    print(f"[OK]  {src.name}  pushed to GitHub Pages.")
    print(f"      URL: {pages_url}")


def main():
    if len(sys.argv) > 1:
        src = Path(sys.argv[1])
    else:
        raw = input("Enter path to HTML file: ").strip().strip('"')
        src = Path(raw)

    push_file(src)


if __name__ == "__main__":
    main()
