---
name: task-cleanup
description: Archive or remove completed tasks from the task list. Use when task list grows large or to clean up after a project phase. Invoke with "/task-cleanup" or "clean up tasks".
triggers:
  - task-cleanup
  - clean up tasks
  - archive completed tasks
  - clear completed tasks
---

# Task Cleanup Skill

Manage task list hygiene by archiving or removing completed tasks.

## When to Use

- Task list has many completed tasks cluttering the view
- End of a project phase or milestone
- Starting fresh on a new focus area
- Before handing off to another session

## Execution Steps

### 1. Assess Current State

```
TaskList()
→ Count: pending, in_progress, completed
→ Identify tasks completed more than 24 hours ago
```

### 2. Present Options

**Option A: Archive All Completed**
- Move all completed tasks to archive
- Keep pending and in_progress

**Option B: Archive Old Completed**
- Only archive completed tasks older than 24 hours
- Keep recent completions for reference

**Option C: Full Reset**
- Archive everything except in_progress
- Use when starting completely fresh

### 3. Execute Cleanup

For each task to archive:
```
TaskUpdate({
  taskId: "<id>",
  metadata: { archived: true, archivedAt: "<ISO-8601>" }
})
```

Or mark completed with archive note:
```
TaskUpdate({
  taskId: "<id>",
  status: "completed",
  description: "[ARCHIVED] " + original_description
})
```

### 4. Report Results

```
## Task Cleanup Complete

**Before:** X total (Y pending, Z in_progress, W completed)
**After:** X total (Y pending, Z in_progress, 0 completed)
**Archived:** W tasks

Archive location: ~/.claude/tasks/{taskListId}/
```

## Notes

- Tasks are never truly deleted - metadata marks them archived
- Archived tasks don't appear in normal TaskList output
- Use for housekeeping, not for hiding incomplete work
- Consider running weekly or at project milestones

---

**Created:** 2026-01-23
**Part of:** Task Management System v2.1.16
