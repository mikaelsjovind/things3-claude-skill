---
name: things3
description: This skill should be used when the user asks to "create a task in Things", "add a todo to Things 3", "manage Things projects", "schedule a task", "complete a todo", "move task to Today", "add to Things inbox", "create a project in Things", "list tasks", "search Things", "sync tasks", "create tasks.md", or mentions Things 3 task management.
version: 2.0.0
---

# Things 3 CLI

Unified command-line interface for Things 3 on macOS.

## Prerequisites

- Things 3 installed on macOS
- **Auth token** required for update operations (see Setup)

## Setup

For update operations, you need an authorization token:

1. Open Things 3 → Settings → General
2. Enable "Things URLs"
3. Click "Manage" and copy the token
4. Save token to `~/.claude/skills/things3/auth-token`

Or set: `export THINGS3_AUTH_TOKEN="your-token"`

## Commands

### Todo Commands

```bash
# Add a new todo
things todo add "title" [--notes "text"] [--when DATE] [--deadline DATE] [--tags a,b] [--list "Project"] [--checklist "a,b"] [--reveal]

# List todos from a list/project/area
things todo list ["Today"|"Inbox"|"Project Name"]

# Get details of a todo
things todo get "id-or-name"

# Update a todo (requires auth)
things todo update "id-or-name" [--title "new"] [--notes "text"] [--when DATE] [--completed] [--canceled]

# Mark as complete (requires auth)
things todo complete "id-or-name"
```

### Project Commands

```bash
# Add a new project
things project add "title" [--notes "text"] [--area "Area"] [--todos "a,b,c"] [--reveal]

# Update a project (requires auth)
things project update "id-or-name" [--title "new"] [--completed]
```

### Navigation

```bash
# Show a list or item in Things
things show [inbox|today|anytime|upcoming|someday|logbook|"Project Name"]

# Open search
things search ["query"]
```

### Sync with tasks.md

```bash
# Initialize a new tasks.md linked to a Things project
things init <tasks.md> <Things-project> [--populate]

# Sync tasks.md with Things (bidirectional)
things sync <tasks.md> <Things-project> [--dry-run]
```

## tasks.md Structure

The sync feature uses a markdown file to track todos linked to a Things project:

```markdown
# Tasks - Project Name

**Synkad med:** Things 3 → Things Project Name
**Senast synkad:** YYYY-MM-DD

---

## Väntar på externa

- [ ] Task waiting on external `tag1` `waiting`
  - things:THINGS_ID
  - Notes about this task

---

## Att göra

- [ ] Task to do `tag1`
  - things:THINGS_ID
  - More notes

---

## Klart

- [x] Completed task `done:YYYY-MM`
  - things:THINGS_ID
```

### Sync Behavior

- **ID-based matching**: Each task has a `things:ID` line linking it to Things
- **Title matching**: Tasks without IDs are matched by title on first sync
- **Status sync**: Completed tasks in Things are marked `[x]` in markdown
- **New tasks**: Tasks in Things not in markdown are added automatically

## Date Formats

For `--when` and `--deadline`:
- Keywords: `today`, `tomorrow`, `evening`, `anytime`, `someday`
- ISO date: `YYYY-MM-DD`
- Date-time: `YYYY-MM-DD@HH:MM`

## Examples

```bash
# Add task to Today
things todo add "Review report" --notes "Check figures" --when today

# Add task to specific project
things todo add "Fix bug" --list "My Project" --tags "Dev"

# List todos from a project
things todo list "Bellman: Fakturakontroll"

# Mark complete
things todo complete "Review report"

# Initialize and populate a tasks.md
things init ./project/tasks.md "My Project" --populate

# Sync existing tasks.md
things sync ./tasks.md "My Project"
```

## JSON Output

All commands return JSON:
```json
{"success": true, "message": "To-do added", "data": {"title": "My Task"}}
{"success": false, "message": "Auth token required", "data": null}
```

## Reference

- **`references/url-scheme-reference.md`** - Things URL Scheme API
- **`references/applescript-api.md`** - AppleScript API (for reading data)
- [Official Things URL Scheme](https://culturedcode.com/things/support/articles/2803573/)
