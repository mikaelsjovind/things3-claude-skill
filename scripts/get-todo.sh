#!/bin/bash
# Get details of a to-do from Things 3
# Uses AppleScript (URL scheme cannot read data)
#
# Usage: get-todo.sh "id or name"

set -e

IDENTIFIER="${1:-}"
if [ -z "$IDENTIFIER" ]; then
    echo '{"success": false, "message": "To-do ID or name is required", "data": null}'
    exit 1
fi

SCRIPT="tell application \"Things3\"
    set t to missing value

    -- Try by name first
    try
        set t to to do \"$IDENTIFIER\"
    end try

    -- Try by ID
    if t is missing value then
        try
            set t to to do id \"$IDENTIFIER\"
        end try
    end if

    -- Search through all to dos
    if t is missing value then
        set allTodos to to dos
        repeat with todo in allTodos
            if name of todo is \"$IDENTIFIER\" then
                set t to todo
                exit repeat
            end if
        end repeat
    end if

    if t is missing value then
        return \"NOT_FOUND\"
    end if

    -- Build result
    set todoId to id of t
    set todoName to name of t
    set todoNotes to notes of t
    set todoStatus to status of t as string
    
    set todoDue to \"null\"
    try
        set d to due date of t
        if d is not missing value then
            set todoDue to \"\\\"\" & (year of d) & \"-\" & (text -2 thru -1 of (\"0\" & ((month of d) as integer))) & \"-\" & (text -2 thru -1 of (\"0\" & (day of d))) & \"\\\"\"
        end if
    end try
    
    set todoWhen to \"null\"
    try
        set w to activation date of t
        if w is not missing value then
            set todoWhen to \"\\\"\" & (year of w) & \"-\" & (text -2 thru -1 of (\"0\" & ((month of w) as integer))) & \"-\" & (text -2 thru -1 of (\"0\" & (day of w))) & \"\\\"\"
        end if
    end try
    
    set todoTags to tag names of t
    
    set todoProject to \"null\"
    try
        set p to project of t
        if p is not missing value then
            set todoProject to \"\\\"\" & (name of p) & \"\\\"\"
        end if
    end try

    return \"{\\\"id\\\": \\\"\" & todoId & \"\\\", \\\"name\\\": \\\"\" & todoName & \"\\\", \\\"notes\\\": \\\"\" & todoNotes & \"\\\", \\\"status\\\": \\\"\" & todoStatus & \"\\\", \\\"due\\\": \" & todoDue & \", \\\"when\\\": \" & todoWhen & \", \\\"tags\\\": \\\"\" & todoTags & \"\\\", \\\"project\\\": \" & todoProject & \"}\"
end tell"

RESULT=$(osascript -e "$SCRIPT" 2>&1) || {
    echo "{\"success\": false, \"message\": \"AppleScript error: $RESULT\", \"data\": null}"
    exit 1
}

if [ "$RESULT" = "NOT_FOUND" ]; then
    echo "{\"success\": false, \"message\": \"To-do not found: $IDENTIFIER\", \"data\": null}"
    exit 1
fi

echo "{\"success\": true, \"message\": \"To-do found\", \"data\": $RESULT}"
