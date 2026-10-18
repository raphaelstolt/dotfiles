#!/usr/bin/env bash

set -u

found=0
successful=0
failed=0

echo "========================================"
echo "Git Pull - All Repositories"
echo "========================================"
echo

for directory in */; do
    # Skip if the glob didn't match anything.
    [[ -d "$directory" ]] || continue

    # Remove trailing slash for display.
    repository="${directory%/}"

    # Ask Git whether this directory is a work tree.
    if ! git -C "$directory" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        continue
    fi

    ((found++))

    echo "----------------------------------------"
    echo "Repository: $repository"
    echo "----------------------------------------"

    if git -C "$directory" pull; then
        echo "[OK] $repository"
        ((successful++))
    else
        echo "[FAILED] $repository"
        ((failed++))
    fi

    echo
done

echo "========================================"
echo "Summary"
echo "========================================"
echo "Repositories found : $found"
echo "Successful pulls   : $successful"
echo "Failed pulls       : $failed"
echo

if (( failed > 0 )); then
    exit 1
fi
