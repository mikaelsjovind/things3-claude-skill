#!/bin/bash
# Schedule a to-do for a specific date in Things 3
# Wrapper for update-todo.sh with when:DATE
#
# Usage: schedule-todo.sh "id or name" "DATE"
# DATE: today, tomorrow, evening, anytime, someday, or YYYY-MM-DD

set -e

IDENTIFIER="${1:-}"
DATE="${2:-}"

if [ -z "$IDENTIFIER" ]; then
    echo '{"success": false, "message": "To-do ID or name is required", "data": null}'
    exit 1
fi

if [ -z "$DATE" ]; then
    echo '{"success": false, "message": "Date is required (today, tomorrow, YYYY-MM-DD)", "data": null}'
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/update-todo.sh" "$IDENTIFIER" "when:${DATE}"
