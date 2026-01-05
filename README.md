# Things 3 Skill for Claude Code

A Claude Code skill for managing Things 3 tasks on macOS using the [Things URL Scheme](https://culturedcode.com/things/support/articles/2803573/).

## Features

- Create and update tasks and projects via URL Scheme
- Read task data via AppleScript
- Schedule, complete, and organize tasks
- All operations return JSON for easy parsing

## Prerequisites

- macOS with [Things 3](https://culturedcode.com/things/) installed
- [Claude Code](https://claude.com/claude-code) CLI

## Installation

1. Clone this repository:
```bash
git clone https://github.com/mikaelsjovind/things3-claude-skill.git
```

2. Copy to your Claude skills directory:
```bash
mkdir -p ~/.claude/skills
cp -r things3-claude-skill ~/.claude/skills/things3
```

3. Make scripts executable:
```bash
chmod +x ~/.claude/skills/things3/scripts/*.sh
```

4. **Set up auth token** (required for update operations):
   - Open Things 3 → Settings → General
   - Enable "Things URLs" and click "Manage"
   - Copy your token to `~/.claude/skills/things3/auth-token`

## Usage

Use natural language with Claude Code:

- "Add a task to Things to review the report"
- "Create a project called Website Redesign with tasks"
- "Show me my tasks for today"
- "Complete the presentation task"
- "Schedule the meeting for next Monday"

## Available Scripts

### Creating Items (no auth required)

| Script | Description |
|--------|-------------|
| `add-todo.sh` | Add a new to-do |
| `add-project.sh` | Add a new project |

### Updating Items (auth required)

| Script | Description |
|--------|-------------|
| `update-todo.sh` | Update an existing to-do |
| `update-project.sh` | Update an existing project |
| `complete-todo.sh` | Mark a to-do as complete |
| `schedule-todo.sh` | Schedule a to-do for a date |

### Reading Data (AppleScript)

| Script | Description |
|--------|-------------|
| `list-todos.sh` | List to-dos from a list/project |
| `list-today-by-area.sh` | List today's tasks by area |
| `get-todo.sh` | Get details of a to-do |

### Navigation

| Script | Description |
|--------|-------------|
| `show.sh` | Navigate to item or list |
| `search.sh` | Open search in Things |

## Examples

### Add a task to Today
```bash
./scripts/add-todo.sh "Review report" "notes:Check figures" "when:today"
```

### Create a project with tasks
```bash
./scripts/add-project.sh "Website Redesign" "todos:Design,Build,Test"
```

### Schedule and complete
```bash
./scripts/schedule-todo.sh "Presentation" "2026-01-10"
./scripts/complete-todo.sh "Presentation"
```

### Move task to project
```bash
./scripts/update-todo.sh "My Task" "list:Website Redesign"
```

## Date Formats

The `when` and `deadline` parameters accept:
- Keywords: `today`, `tomorrow`, `evening`, `anytime`, `someday`
- ISO date: `YYYY-MM-DD`
- Date-time: `YYYY-MM-DD@HH:MM`

## Response Format

All scripts return JSON:
```json
{"success": true, "message": "To-do added", "data": {"title": "My Task"}}
{"success": false, "message": "Auth token required", "data": null}
```

## Resources

- [Things URL Scheme Documentation](https://culturedcode.com/things/support/articles/2803573/)
- [Things AppleScript Guide](https://culturedcode.com/things/support/articles/2803572/)

### Reference Files
- `references/url-scheme-reference.md` - Complete URL Scheme API documentation
- `references/applescript-api.md` - AppleScript API for reading data

## License

MIT License - see LICENSE file for details
