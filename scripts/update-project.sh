#!/bin/bash
# Update an existing project in Things 3
# things:///update-project - Requires auth-token
#
# Usage: update-project.sh "id or name" [options]
# Options:
#   title:"new title"         - Change title
#   notes:"text"              - Replace notes
#   append-notes:"text"       - Append to notes
#   when:today|tomorrow|DATE  - Schedule date
#   deadline:DATE             - Due date
#   tags:tag1,tag2            - Replace tags
#   add-tags:tag1,tag2        - Add tags
#   area:AreaName             - Move to area
#   completed:true            - Mark complete
#   canceled:true             - Mark canceled
#   reveal:true               - Show in Things

set -e

IDENTIFIER="${1:-}"
if [ -z "$IDENTIFIER" ]; then
    echo '{"success": false, "message": "Project ID or name is required", "data": null}'
    exit 1
fi

# Get auth token
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../auth-token"

if [ -n "${THINGS3_AUTH_TOKEN:-}" ]; then
    AUTH_TOKEN="$THINGS3_AUTH_TOKEN"
elif [ -f "$CONFIG_FILE" ]; then
    AUTH_TOKEN=$(cat "$CONFIG_FILE" | tr -d '[:space:]')
else
    echo '{"success": false, "message": "Auth token required. Set THINGS3_AUTH_TOKEN or create auth-token file", "data": null}'
    exit 1
fi

# URL encode function
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1''', safe=''))"
}

# If identifier doesn't look like an ID, look it up via AppleScript
if [[ ! "$IDENTIFIER" =~ ^[A-Za-z0-9_-]{20,}$ ]]; then
    PROJECT_ID=$(osascript -e "tell application \"Things3\"
        try
            set p to project \"$IDENTIFIER\"
            return id of p
        on error
            return \"NOT_FOUND\"
        end try
    end tell" 2>&1)

    if [ "$PROJECT_ID" = "NOT_FOUND" ]; then
        echo "{\"success\": false, \"message\": \"Project not found: $IDENTIFIER\", \"data\": null}"
        exit 1
    fi
else
    PROJECT_ID="$IDENTIFIER"
fi

# Parse options
shift
TITLE="" NOTES="" APPEND_NOTES="" WHEN="" DEADLINE="" TAGS="" ADD_TAGS=""
AREA="" COMPLETED="" CANCELED="" REVEAL=""

for arg in "$@"; do
    case "$arg" in
        title:*) TITLE="${arg#title:}" ;;
        notes:*) NOTES="${arg#notes:}" ;;
        append-notes:*) APPEND_NOTES="${arg#append-notes:}" ;;
        when:*) WHEN="${arg#when:}" ;;
        deadline:*) DEADLINE="${arg#deadline:}" ;;
        tags:*) TAGS="${arg#tags:}" ;;
        add-tags:*) ADD_TAGS="${arg#add-tags:}" ;;
        area:*) AREA="${arg#area:}" ;;
        completed:*) COMPLETED="${arg#completed:}" ;;
        canceled:*) CANCELED="${arg#canceled:}" ;;
        reveal:*) REVEAL="${arg#reveal:}" ;;
    esac
done

# Build URL
URL="things:///update-project?auth-token=${AUTH_TOKEN}&id=${PROJECT_ID}"

[ -n "$TITLE" ] && URL="${URL}&title=$(urlencode "$TITLE")"
[ -n "$NOTES" ] && URL="${URL}&notes=$(urlencode "$NOTES")"
[ -n "$APPEND_NOTES" ] && URL="${URL}&append-notes=$(urlencode "$APPEND_NOTES")"
[ -n "$WHEN" ] && URL="${URL}&when=${WHEN}"
[ -n "$DEADLINE" ] && URL="${URL}&deadline=${DEADLINE}"
[ -n "$TAGS" ] && URL="${URL}&tags=$(urlencode "$TAGS")"
[ -n "$ADD_TAGS" ] && URL="${URL}&add-tags=$(urlencode "$ADD_TAGS")"
[ -n "$AREA" ] && URL="${URL}&area=$(urlencode "$AREA")"
[ -n "$COMPLETED" ] && URL="${URL}&completed=${COMPLETED}"
[ -n "$CANCELED" ] && URL="${URL}&canceled=${CANCELED}"
[ -n "$REVEAL" ] && URL="${URL}&reveal=${REVEAL}"

# Execute
open "$URL"
sleep 0.3

echo "{\"success\": true, \"message\": \"Project updated\", \"data\": {\"id\": \"$PROJECT_ID\"}}"
