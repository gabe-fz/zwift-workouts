#!/bin/zsh
# Copy all workouts to each Zwift user custom workouts directory on macOS.
# Zwift stores user-specific workouts under:
#   ~/Documents/Zwift/Workouts/<zwift_user_id>/
# This script will replicate the workouts into every user id folder.

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")/../workouts" && pwd)"
ZWIFT_WORKOUTS_ROOT="$HOME/Documents/Zwift/Workouts"

if [ ! -d "$ZWIFT_WORKOUTS_ROOT" ]; then
  echo "Zwift workouts root not found: $ZWIFT_WORKOUTS_ROOT" >&2
  exit 1
fi

user_dirs=($(find "$ZWIFT_WORKOUTS_ROOT" -maxdepth 1 -type d -mindepth 1))

if [ ${#user_dirs[@]} -eq 0 ]; then
  echo "No user workout directories found under $ZWIFT_WORKOUTS_ROOT" >&2
  exit 1
fi

echo "Installing workouts from $SOURCE_DIR into:"
for ud in "$user_dirs[@]"; do
  echo "  $ud"
  mkdir -p "$ud"
  # Remove all existing .zwo files
  rm -f "$ud"/*.zwo
  # Copy new workouts
  cp "$SOURCE_DIR"/*.zwo "$ud"/
done

echo "Done. Restart Zwift if it's running to see new workouts."
