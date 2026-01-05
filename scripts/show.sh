#!/bin/bash
# Show an item or list in Things 3
# things:///show - No auth-token required
#
# Usage: show.sh "id or name" [filter:tag1,tag2]
#
# Built-in list names:
#   inbox, today, anytime, upcoming, someday, logbook,
#   tomorrow, deadlines, repeating, all-projects, logged-projects
#
# Can also show projects, areas, or tags by name

set -e

IDENTIFIER="${1:-today}"
FILTER=""

# Parse options
shift 2>/dev/null || true
for arg in "$@"; do
    case "$arg" in
        filter:*) FILTER="${arg#filter:}" ;;
    esac
done

# URL encode function
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1''', safe=''))"
}

# Check if it's a built-in list
BUILTIN_LISTS="inbox today anytime upcoming someday logbook tomorrow deadlines repeating all-projects logged-projects"
IS_BUILTIN=false
for list in $BUILTIN_LISTS; do
    if [ "${IDENTIFIER,,}" = "$list" ]; then
        IS_BUILTIN=true
        break
    fi
done

# Build URL
if [ "$IS_BUILTIN" = true ]; then
    URL="things:///show?id=${IDENTIFIER,,}"
elif [[ "$IDENTIFIER" =~ ^[A-Za-z0-9_-]{20,}$ ]]; then
    # Looks like an ID
    URL="things:///show?id=${IDENTIFIER}"
else
    # Use query for name lookup
    URL="things:///show?query=$(urlencode "$IDENTIFIER")"
fi

[ -n "$FILTER" ] && URL="${URL}&filter=$(urlencode "$FILTER")"

# Execute
open "$URL"
sleep 0.3

echo "{\"success\": true, \"message\": \"Showing: $IDENTIFIER\", \"data\": null}"
