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

The sync feature uses a markdown file to track todos linked to a Things project.

### Sections and Things Mapping

| Sektion | Beskrivning | Things when | Things tag |
|---------|-------------|-------------|------------|
| **Att göra** | Mina uppgifter (Mikael) | anytime | (ingen) |
| **Väntar på externa** | Uppgifter för externa parter | someday | `väntar` |
| **Blockerad** | Uppgifter blockerade av annat | someday | `blockerad` |
| **Idéer** | Framtida idéer | someday | `idé` |
| **Klart** | Avslutade uppgifter | - | - |

### Title Format

- **Mina uppgifter (Att göra)**: Aktiv verbform utan @person
  - `Skapa rapport för Q2 försäljning`
  - `Förbered presentation för kundmöte`

- **Externa uppgifter**: Aktiv verbform + @Person
  - `Skicka resurslista till Mikael @Patrik`
  - `Synka med Robin och Nina @Mathias`
  - `Återkoppla om Azure-miljö @Nordlo`

### Template

```markdown
# Tasks - Project Name

**Synkad med:** Things 3 → Things Project Name
**Senast synkad:** YYYY-MM-DD

---

## Att göra

- [ ] Skapa rapport för Q2 försäljning
  - things:THINGS_ID
  - Anteckningar om uppgiften

---

## Väntar på externa

- [ ] Skicka resurslista till Mikael @Patrik
  - things:THINGS_ID
  - Anteckningar

- [ ] Återkoppla om Azure-miljö @Nordlo
  - things:THINGS_ID

---

## Blockerad

- [ ] Ta fram prisförslag @Mikael
  - things:THINGS_ID
  - Blockerad av: Kartläggning måste slutföras först

---

## Idéer

- [ ] Ta fram koncept på QR-kod
  - things:THINGS_ID

---

## Klart

- [x] Slutför budgetplanering `done:2024-07`
  - things:THINGS_ID
```

### Sync Behavior

- **ID-based matching**: Each task has a `things:ID` line linking it to Things
- **Title matching**: Tasks without IDs are matched by title on first sync
- **Status sync**: Completed tasks in Things are marked `[x]` in markdown
- **New tasks**: Tasks in Things not in markdown are added automatically
- **Section mapping**: Section determines `when` and `tag` in Things

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
