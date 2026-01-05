#!/bin/bash
# Add a new to-do to Things 3
# things:///add - No auth-token required
#
# Usage: add-todo.sh "title" [options]
# Options:
#   notes:"text"              - Add notes
#   when:today|tomorrow|DATE  - Schedule date (DATE = YYYY-MM-DD)
#   deadline:DATE             - Due date
#   tags:tag1,tag2            - Add tags
#   list:ListName             - Add to list/project/area
#   checklist:item1,item2     - Add checklist items
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
NOTES="" WHEN="" DEADLINE="" TAGS="" LIST="" CHECKLIST="" REVEAL=""

for arg in "$@"; do
    case "$arg" in
        notes:*) NOTES="${arg#notes:}" ;;
        when:*) WHEN="${arg#when:}" ;;
        deadline:*) DEADLINE="${arg#deadline:}" ;;
        tags:*) TAGS="${arg#tags:}" ;;
        list:*) LIST="${arg#list:}" ;;
        checklist:*) CHECKLIST="${arg#checklist:}" ;;
        reveal:*) REVEAL="${arg#reveal:}" ;;
        *) [ -z "$NOTES" ] && NOTES="$arg" ;;
    esac
done

# Build URL
URL="things:///add?title=$(urlencode "$TITLE")"

[ -n "$NOTES" ] && URL="${URL}&notes=$(urlencode "$NOTES")"
[ -n "$WHEN" ] && URL="${URL}&when=${WHEN}"
[ -n "$DEADLINE" ] && URL="${URL}&deadline=${DEADLINE}"
[ -n "$TAGS" ] && URL="${URL}&tags=$(urlencode "$TAGS")"
[ -n "$LIST" ] && URL="${URL}&list=$(urlencode "$LIST")"
[ -n "$REVEAL" ] && URL="${URL}&reveal=${REVEAL}"

# Convert checklist commas to newlines
if [ -n "$CHECKLIST" ]; then
    CHECKLIST_ITEMS=$(echo "$CHECKLIST" | tr ',' '\n')
    URL="${URL}&checklist-items=$(urlencode "$CHECKLIST_ITEMS")"
fi

# Execute
open "$URL"
sleep 0.3

echo "{\"success\": true, \"message\": \"To-do added\", \"data\": {\"title\": \"$TITLE\"}}"
