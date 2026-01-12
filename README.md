# Things 3 CLI for Claude Code

A unified command-line interface for Things 3 on macOS, with bidirectional sync to markdown task files.

## Features

- **Unified CLI**: Single `things` command with subcommands
- **Bidirectional sync**: Sync tasks between Things 3 and `tasks.md` files
- **ID-based linking**: Tasks are linked by Things ID for reliable sync
- **JSON output**: All commands return JSON for easy parsing

## Prerequisites

- macOS with [Things 3](https://culturedcode.com/things/) installed
- [Claude Code](https://claude.com/claude-code) CLI

## Installation

1. Copy to your Claude skills directory:
```bash
mkdir -p ~/.claude/skills
cp -r things3 ~/.claude/skills/
```

2. Make the CLI executable:
```bash
chmod +x ~/.claude/skills/things3/things
```

3. **Set up auth token** (required for update operations):
   - Open Things 3 → Settings → General
   - Enable "Things URLs" and click "Manage"
   - Copy your token to `~/.claude/skills/things3/auth-token`

## Usage

### With Claude Code

Use natural language:

- "Add a task to Things to review the report"
- "Show me my tasks for today"
- "Complete the presentation task"
- "Sync my tasks with Things"
- "Initialize tasks.md for my project"

### Direct CLI Usage

```bash
# Add a task
things todo add "Review report" --when today --list "My Project"

# List tasks
things todo list "Bellman: Fakturakontroll"

# Complete a task
things todo complete "Review report"

# Initialize a tasks.md
things init ./project/tasks.md "My Project" --populate

# Sync tasks.md with Things
things sync ./tasks.md "My Project"
```

## Commands

### Todo Commands

| Command | Description |
|---------|-------------|
| `things todo add "title"` | Add a new to-do |
| `things todo list [name]` | List to-dos from list/project/area |
| `things todo get "name"` | Get details of a to-do |
| `things todo update "name"` | Update a to-do (auth required) |
| `things todo complete "name"` | Mark as complete (auth required) |

### Project Commands

| Command | Description |
|---------|-------------|
| `things project add "title"` | Add a new project |
| `things project update "name"` | Update a project (auth required) |

### Navigation

| Command | Description |
|---------|-------------|
| `things show [list]` | Navigate to item or list in Things |
| `things search [query]` | Open search in Things |

### Sync Commands

| Command | Description |
|---------|-------------|
| `things init <file> <project>` | Initialize a tasks.md linked to Things |
| `things sync <file> <project>` | Bidirectional sync with Things |

## tasks.md Format

The sync feature uses markdown files with this structure:

```markdown
# Tasks - Project Name

**Synkad med:** Things 3 → Things Project Name
**Senast synkad:** 2026-01-12

---

## Väntar på externa

- [ ] Task waiting on external `waiting` `tag1`
  - things:THINGS_ID
  - Notes about this task

---

## Att göra

- [ ] Task to do `tag1`
  - things:THINGS_ID

---

## Klart

- [x] Completed task `done:2026-01`
  - things:THINGS_ID
```

### Sync Behavior

- **First sync**: Tasks matched by title, IDs added automatically
- **Subsequent syncs**: Tasks matched by `things:ID`
- **Things → MD**: New tasks added, completed tasks marked `[x]`
- **MD → Things**: (Future) New tasks without ID created in Things

## Date Formats

For `--when` and `--deadline`:
- Keywords: `today`, `tomorrow`, `evening`, `anytime`, `someday`
- ISO date: `YYYY-MM-DD`
- Date-time: `YYYY-MM-DD@HH:MM`

## Resources

- [Things URL Scheme](https://culturedcode.com/things/support/articles/2803573/)
- [Things AppleScript Guide](https://culturedcode.com/things/support/articles/2803572/)

## License

MIT License
