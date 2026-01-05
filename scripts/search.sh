#!/bin/bash
# Open search in Things 3
# things:///search - No auth-token required
#
# Usage: search.sh ["query"]

set -e

QUERY="${1:-}"

# URL encode function
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1''', safe=''))"
}

# Build URL
if [ -n "$QUERY" ]; then
    URL="things:///search?query=$(urlencode "$QUERY")"
else
    URL="things:///search"
fi

# Execute
open "$URL"
sleep 0.3

echo "{\"success\": true, \"message\": \"Search opened\", \"data\": {\"query\": \"$QUERY\"}}"
