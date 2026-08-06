# ADR-004: Support Claude Code (Primary) and Codex — No Other Agents

## Status

Accepted (2026-08-06)

## Context

The template shipped config stubs for seven agents (Claude Code, Copilot, Cursor, Codex, Gemini, Windsurf, Aider) and marketed the count as its differentiator. In practice: five of the seven files were shallow mirrors that init-template asked users to keep in sync by hand, the sync chore was skipped (files drifted), and maintenance effort spread thin produced breadth without depth — while the genuinely deep support (Claude-native commands, skills, hooks) went undersold.

## Decision

Exactly two agent configs: `CLAUDE.md` for Claude Code (primary — carries the full `.claude/` toolkit: slash commands, auto-discovered skills, security hook templates, example sub-agent) and `AGENTS.md` for Codex via the open AGENTS.md standard. The other five configs and every reference to them were removed (maintainer decision, executed 2026-08-06). A self-test gate greps the tracked tree for removed-agent tokens (CHANGELOG history and CONTRIBUTORS bot names exempt) and fails CI if any reference resurfaces.

## Consequences

### Positive

- One sync relationship (CLAUDE ↔ AGENTS) instead of a 7-file chore nobody performed
- Depth as the honest differentiator; docs claim only what is maintained
- AGENTS.md being an open standard means other adopting tools still benefit at zero cost
- Regression-proof: the gate makes the descope permanent

### Negative

- Users of removed tools must author their own config (AGENTS.md is a good starting point)
- Historical marketing claims ("7 agents") in old releases/posts no longer describe the template
