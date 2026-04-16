---
name: cot
description: Chain-of-thought analysis before action. Forces structured reasoning, risk assessment, and explicit plan before execution. Use for any complex, destructive, or important request. Invoke with "/cot [request]" or "use cot: [request]".
triggers:
  - cot
  - use cot
  - chain of thought
  - think through
---

# Chain-of-Thought (COT) Skill

Force structured reasoning before action. Prevents rushing into execution.

## When to Use

- Any destructive operation (delete, remove, refactor)
- Complex multi-step tasks
- Decisions with significant consequences
- When you want explicit reasoning visible
- Any time "think carefully" would normally be said

## The Pattern

When this skill is invoked, analyze the request using this structure:

### 1. What is being asked
Restate the request in clear terms. What is the actual goal?

### 2. What are the considerations
- What files/systems are involved?
- What are the dependencies?
- What context matters?
- Are there multiple valid approaches?

### 3. What could go wrong
- What are the risks?
- What's irreversible?
- What assumptions are being made?
- What information is missing?

### 4. Step-by-step plan
Numbered list of discrete actions to accomplish the request.

### 5. STOP for approval
Do NOT proceed to execution. Wait for explicit:
- "proceed"
- "approved"
- "go ahead"
- "yes"

## Invocation

```
/cot remove all deprecated API endpoints

use cot: refactor the authentication module

/cot what's the best way to restructure this database schema
```

## Example Output

```
**COT:**
- **Asked:** Remove deprecated API endpoints from the codebase
- **Considerations:**
  - Need to identify which endpoints are deprecated
  - Check for internal consumers
  - May need migration path for external users
  - Tests reference these endpoints
- **Risk:**
  - Breaking changes for API consumers
  - Dead code might still be imported elsewhere
- **Plan:**
  1. Grep for @deprecated annotations
  2. List all deprecated endpoints with their consumers
  3. Check for external API documentation references
  4. Create removal plan with each file
  5. Stop for approval before any deletion

Awaiting approval to proceed.
```

## Why This Exists

"Think carefully" and "plan thoroughly" don't change Claude's behavior.
Concrete output requirements do.

This skill creates a mandatory structured output before any action,
making the reasoning visible and creating an approval gate.

---

**Origin:** 2025-12-29 session where files were deleted without analysis despite explicit request to "think hard, plan carefully"
