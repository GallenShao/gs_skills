#!/bin/bash
# GitHub Commit Data Fetcher
# Usage: ./fetch-commits.sh <repo-path> [hours]
# Output: Commit list (hash + subject) to stdout, stats to stderr

set -e

REPO_PATH="${1:-}"
HOURS="${2:-24}"

if [ -z "$REPO_PATH" ]; then
    echo "Error: REPO_PATH is required" >&2
    echo "Usage: $0 <repo-path> [hours]" >&2
    exit 1
fi

if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Error: Not a git repository: $REPO_PATH" >&2
    exit 1
fi

cd "$REPO_PATH"

# Pull latest (optional - comment out if offline)
git pull --quiet 2>/dev/null || echo "⚠️  Pull failed, using local data" >&2

# Calculate timestamp
HOURS_AGO=$(date -d "$HOURS hours ago" +"%Y-%m-%d %H:%M:%S" 2>/dev/null || date -v-${HOURS}H +"%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$HOURS hours ago")

# Fetch commits (hash + subject only)
git log --since="$HOURS_AGO" --oneline --pretty=format:"%h %s" 2>/dev/null

# Stats to stderr (doesn't interfere with stdout)
TOTAL=$(git log --since="$HOURS_AGO" --oneline 2>/dev/null | wc -l || echo 0)
echo "" >&2
echo "📊 Stats: $TOTAL commits in past $HOURS hours" >&2
