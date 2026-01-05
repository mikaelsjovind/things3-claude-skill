---
name: things3
description: This skill should be used when the user asks to "create a task in Things", "add a todo to Things 3", "manage Things projects", "schedule a task", "complete a todo", "move task to Today", "add to Things inbox", "create a project in Things", "list tasks", "search Things", or mentions Things 3 task management.
version: 1.0.0
---

# Things 3 Task Management

Interact with Things 3 on macOS using the Things URL Scheme and AppleScript.

## Prerequisites

- Things 3 installed on macOS
- **Auth token** required for update operations (see Setup)

## Setup

Some scripts require an authorization token from Things 3:

1. Open Things 3 → Settings → General
2. Enable "Things URLs"
3. Click "Manage" and copy the token
4. Save token to `~/.claude/skills/things3/auth-token`

Or set environment variable: `export THINGS3_AUTH_TOKEN="your-token"`

## Available Scripts

All scripts output JSON and are in `scripts/` directory.

### Creating Items

#### add-todo.sh
Add a new to-do. No auth required.
```bash
add-todo.sh "title" [options]
# Options: notes:"text" when:DATE deadline:DATE tags:a,b list:Name checklist:a,b reveal:true
```

#### add-project.sh
Add a new project. No auth required.
```bash
add-project.sh "title" [options]
# Options: notes:"text" when:DATE deadline:DATE tags:a,b area:Name todos:a,b reveal:true
```

### Updating Items (auth required)

#### update-todo.sh
Update an existing to-do.
```bash
update-todo.sh "id or name" [options]
# Options: title:"new" notes:"text" when:DATE deadline:DATE tags:a,b list:Name completed:true canceled:true
```

#### update-project.sh
Update an existing project.
```bash
update-project.sh "id or name" [options]
# Options: title:"new" notes:"text" when:DATE deadline:DATE tags:a,b area:Name completed:true canceled:true
```

### Convenience Wrappers

#### complete-todo.sh
Mark a to-do as complete.
```bash
complete-todo.sh "id or name"
```

#### schedule-todo.sh
Schedule a to-do for a date.
```bash
schedule-todo.sh "id or name" "DATE"
# DATE: today, tomorrow, evening, anytime, someday, or YYYY-MM-DD
```

### Reading Data (AppleScript)

#### list-todos.sh
List to-dos from a list, project, or area.
```bash
list-todos.sh [list_name]
# list_name: Today, Inbox, Upcoming, Anytime, Someday, or project/area name
```

#### list-today-by-area.sh
List today's to-dos grouped by area.
```bash
list-today-by-area.sh
```

#### get-todo.sh
Get details of a specific to-do.
```bash
get-todo.sh "id or name"
```

### Navigation

#### show.sh
Navigate to an item or list in Things.
```bash
show.sh "id or name" [filter:tag1,tag2]
# Built-in: inbox, today, anytime, upcoming, someday, logbook, tomorrow, deadlines
```

#### search.sh
Open search in Things.
```bash
search.sh ["query"]
```

## Date Formats

The `when` and `deadline` parameters accept:
- Keywords: `today`, `tomorrow`, `evening`, `anytime`, `someday`
- ISO date: `YYYY-MM-DD` (e.g., `2026-01-15`)
- Date-time: `YYYY-MM-DD@HH:MM` (e.g., `2026-01-15@14:00`)

## Examples

### Add task to Today
```bash
add-todo.sh "Review report" "notes:Check figures" "when:today"
```

### Create project with tasks
```bash
add-project.sh "Website Redesign" "todos:Design mockups,Build prototype,Test"
```

### Schedule and complete
```bash
schedule-todo.sh "Prepare presentation" "2026-01-10"
complete-todo.sh "Prepare presentation"
```

### Move task to project
```bash
update-todo.sh "My Task" "list:Website Redesign"
```

## Error Handling

All scripts return JSON:
```json
{"success": true, "message": "To-do added", "data": {"title": "My Task"}}
{"success": false, "message": "Auth token required", "data": null}
```

## Reference

- **`references/applescript-api.md`** - AppleScript API documentation
- [Things URL Scheme](https://culturedcode.com/things/support/articles/2803573/)
