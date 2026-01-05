#!/bin/bash
# Mark a to-do as complete in Things 3
# Wrapper for update-todo.sh with completed:true
#
# Usage: complete-todo.sh "id or name"

set -e

IDENTIFIER="${1:-}"
if [ -z "$IDENTIFIER" ]; then
    echo '{"success": false, "message": "To-do ID or name is required", "data": null}'
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/update-todo.sh" "$IDENTIFIER" "completed:true"
