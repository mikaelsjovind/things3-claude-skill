#!/bin/bash
# Add a new project to Things 3
# things:///add-project - No auth-token required
#
# Usage: add-project.sh "title" [options]
# Options:
#   notes:"text"              - Add notes
#   when:today|tomorrow|DATE  - Schedule date
#   deadline:DATE             - Due date
#   tags:tag1,tag2            - Add tags
#   area:AreaName             - Add to area
#   todos:task1,task2         - Add to-dos (comma-separated)
#   reveal:true               - Show in Things after creation

set -e

TITLE="${1:-}"
if [ -z "$TITLE" ]; then
    echo '{"success": false, "message": "Title is required", "data": null}'
    exit 1
fi

# URL encode function
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1''', safe=''))"
}

# Parse options
shift
NOTES="" WHEN="" DEADLINE="" TAGS="" AREA="" TODOS="" REVEAL=""

for arg in "$@"; do
    case "$arg" in
        notes:*) NOTES="${arg#notes:}" ;;
        when:*) WHEN="${arg#when:}" ;;
        deadline:*) DEADLINE="${arg#deadline:}" ;;
        tags:*) TAGS="${arg#tags:}" ;;
        area:*) AREA="${arg#area:}" ;;
        todos:*) TODOS="${arg#todos:}" ;;
        reveal:*) REVEAL="${arg#reveal:}" ;;
        *) [ -z "$NOTES" ] && NOTES="$arg" ;;
    esac
done

# Build URL
URL="things:///add-project?title=$(urlencode "$TITLE")"

[ -n "$NOTES" ] && URL="${URL}&notes=$(urlencode "$NOTES")"
[ -n "$WHEN" ] && URL="${URL}&when=${WHEN}"
[ -n "$DEADLINE" ] && URL="${URL}&deadline=${DEADLINE}"
[ -n "$TAGS" ] && URL="${URL}&tags=$(urlencode "$TAGS")"
[ -n "$AREA" ] && URL="${URL}&area=$(urlencode "$AREA")"
[ -n "$REVEAL" ] && URL="${URL}&reveal=${REVEAL}"

# Convert todos commas to newlines
if [ -n "$TODOS" ]; then
    TODO_ITEMS=$(echo "$TODOS" | tr ',' '\n')
    URL="${URL}&to-dos=$(urlencode "$TODO_ITEMS")"
fi

# Execute
open "$URL"
sleep 0.3

echo "{\"success\": true, \"message\": \"Project added\", \"data\": {\"title\": \"$TITLE\"}}"
