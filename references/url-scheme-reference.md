# Things 3 URL Scheme Reference

Complete reference for Things 3 URL Scheme commands. This is the primary API used by this skill for creating and updating items.

## Overview

Things 3 supports a URL scheme for automation:
- **No auth required**: `add`, `add-project`, `show`, `search`
- **Auth required**: `update`, `update-project`

Base URL: `things:///`

## Authentication

Operations that modify existing items require an auth token:

1. Open Things 3 → Settings → General
2. Enable "Things URLs"
3. Click "Manage" to get your token

Include token in URL: `things:///update?auth-token=YOUR_TOKEN&id=...`

## Commands

### add
Create a new to-do. No authentication required.

```
things:///add?title=TITLE&PARAMETERS
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `title` | Task title (required) | `title=Buy%20groceries` |
| `notes` | Task notes | `notes=Don%27t%20forget%20milk` |
| `when` | Schedule date | `when=today`, `when=2026-01-15` |
| `deadline` | Due date | `deadline=2026-01-20` |
| `tags` | Comma-separated tags | `tags=work,urgent` |
| `list` | Target list/project/area | `list=Inbox`, `list=My%20Project` |
| `list-id` | Target by ID | `list-id=ABC123` |
| `heading` | Project heading | `heading=Phase%201` |
| `checklist-items` | Checklist (newline-separated) | `checklist-items=Item%201%0AItem%202` |
| `completed` | Mark complete | `completed=true` |
| `canceled` | Mark canceled | `canceled=true` |
| `reveal` | Show in Things | `reveal=true` |
| `creation-date` | Backdate creation | `creation-date=2026-01-01` |
| `completion-date` | Set completion date | `completion-date=2026-01-05` |

**When values:**
- `today` - Today list
- `tomorrow` - Tomorrow
- `evening` - This evening
- `anytime` - Anytime list
- `someday` - Someday list
- `YYYY-MM-DD` - Specific date
- `YYYY-MM-DD@HH:MM` - Date with reminder time

### add-project
Create a new project. No authentication required.

```
things:///add-project?title=TITLE&PARAMETERS
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `title` | Project title (required) | `title=Website%20Redesign` |
| `notes` | Project notes | `notes=Q1%20goal` |
| `when` | Start date | `when=2026-02-01` |
| `deadline` | Due date | `deadline=2026-03-31` |
| `tags` | Comma-separated tags | `tags=work` |
| `area` | Parent area name | `area=Work` |
| `area-id` | Parent area by ID | `area-id=ABC123` |
| `to-dos` | Tasks (newline-separated) | `to-dos=Design%0ABuild%0ATest` |
| `completed` | Mark complete | `completed=true` |
| `canceled` | Mark canceled | `canceled=true` |
| `reveal` | Show in Things | `reveal=true` |

### update
Modify an existing to-do. **Requires authentication.**

```
things:///update?auth-token=TOKEN&id=ID&PARAMETERS
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `auth-token` | Auth token (required) | `auth-token=abc123` |
| `id` | Task ID (required) | `id=XYZ789` |
| `title` | New title | `title=Updated%20Task` |
| `notes` | New notes | `notes=Updated%20notes` |
| `prepend-notes` | Add to start of notes | `prepend-notes=Added%20info` |
| `append-notes` | Add to end of notes | `append-notes=More%20info` |
| `when` | Reschedule | `when=tomorrow` |
| `deadline` | New due date | `deadline=2026-01-25` |
| `tags` | Replace tags | `tags=new,tags` |
| `add-tags` | Add tags | `add-tags=extra` |
| `list` | Move to list/project | `list=Another%20Project` |
| `list-id` | Move by ID | `list-id=ABC123` |
| `heading` | Move to heading | `heading=Phase%202` |
| `completed` | Mark complete | `completed=true` |
| `canceled` | Mark canceled | `canceled=true` |
| `reveal` | Show in Things | `reveal=true` |

### update-project
Modify an existing project. **Requires authentication.**

```
things:///update-project?auth-token=TOKEN&id=ID&PARAMETERS
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `auth-token` | Auth token (required) | `auth-token=abc123` |
| `id` | Project ID (required) | `id=XYZ789` |
| `title` | New title | `title=Updated%20Project` |
| `notes` | New notes | `notes=Updated%20notes` |
| `prepend-notes` | Add to start of notes | `prepend-notes=Added` |
| `append-notes` | Add to end of notes | `append-notes=More` |
| `when` | Reschedule | `when=2026-02-15` |
| `deadline` | New deadline | `deadline=2026-04-30` |
| `tags` | Replace tags | `tags=updated` |
| `add-tags` | Add tags | `add-tags=extra` |
| `area` | Move to area | `area=Personal` |
| `area-id` | Move by ID | `area-id=ABC123` |
| `completed` | Mark complete | `completed=true` |
| `canceled` | Mark canceled | `canceled=true` |
| `reveal` | Show in Things | `reveal=true` |

### show
Navigate to an item or list. No authentication required.

```
things:///show?id=ID
things:///show?query=QUERY
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `id` | Item/list ID or name | `id=today`, `id=ABC123` |
| `query` | List name | `query=inbox` |
| `filter` | Filter by tags | `filter=work,urgent` |

**Built-in list IDs:**
- `inbox` - Inbox
- `today` - Today
- `anytime` - Anytime
- `upcoming` - Upcoming
- `someday` - Someday
- `logbook` - Logbook
- `tomorrow` - Tomorrow
- `deadlines` - Deadlines
- `repeating` - Repeating
- `all-projects` - All Projects
- `logged-projects` - Logged Projects

### search
Open search with optional query. No authentication required.

```
things:///search?query=QUERY
```

**Parameters:**
| Parameter | Description | Example |
|-----------|-------------|---------|
| `query` | Search terms | `query=meeting%20notes` |

## URL Encoding

All parameter values must be URL-encoded:
- Space → `%20`
- Newline → `%0A`
- Quote → `%27`
- Ampersand → `%26`

Python example:
```python
import urllib.parse
encoded = urllib.parse.quote("My Task", safe='')
```

Bash example:
```bash
python3 -c "import urllib.parse; print(urllib.parse.quote('My Task', safe=''))"
```

## Examples

### Create task for today
```
things:///add?title=Review%20report&when=today&tags=work
```

### Create project with tasks
```
things:///add-project?title=Website%20Redesign&to-dos=Design%0ABuild%0ATest&area=Work
```

### Complete a task
```
things:///update?auth-token=TOKEN&id=ABC123&completed=true
```

### Schedule for specific date
```
things:///update?auth-token=TOKEN&id=ABC123&when=2026-01-15
```

### Move to project
```
things:///update?auth-token=TOKEN&id=ABC123&list=Website%20Redesign
```

## Limitations

- **Cannot read data**: URL Scheme can only write/modify, not read. Use AppleScript for reading.
- **Auth token required for updates**: Existing items can only be modified with authentication.
- **No bulk operations**: Each item requires a separate URL call.
- **ID lookup**: To update by name, first use AppleScript to find the ID.

## Sources

- [Things URL Scheme Documentation](https://culturedcode.com/things/support/articles/2803573/)
