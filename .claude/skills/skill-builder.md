---
name: skill-builder
description: Create production-ready Claude Code skills with guided workflow, templates, and best practices. Generate SKILL.md files with optimized YAML frontmatter, proper structure, and discovery-optimized descriptions. Use when creating new skills, scaffolding skill directories, building skills from scratch, or need expert guidance on skill design.
triggers:
  - skill-builder
  - create skill
  - new skill
  - build skill
  - scaffold skill
  - skill template
  - make a skill
---

# Skill Builder

Expert-guided skill creation system combining template generation with best practices for building discoverable, effective Claude Code skills.

## Quick Start

```bash
# Interactive skill creation
/skill-builder

# Create specific skill
/skill-builder api-client-generator

# Create with type hint
/skill-builder --type analysis security-scanner
```

---

## Core Principles

### 1. Discovery is Everything

Skills are **model-invoked** - Claude autonomously decides when to use them based on:
- Your request context
- The skill's `description` field
- Keyword matching and semantic understanding

**The description MUST include BOTH:**
- **What** the skill does (capabilities)
- **When** to use it (triggers, file types, keywords)

### 2. Description Formula

```
[Action verbs] + [Specific capabilities] + [File types/formats] + [Use case triggers]
```

**Example:**
```yaml
description: Analyze code complexity, detect anti-patterns, suggest refactoring opportunities. Works with .js, .ts, .py, .java files. Use when reviewing code quality, performing technical debt analysis, or need complexity metrics.
```

---

## Interactive Workflow

When invoked, ask these questions:

### Question 1: Purpose
**"What should this skill do?"** (1-2 sentences)
- Listen for domain clues (analyze, generate, transform, validate, orchestrate)

### Question 2: Domain Type
**"What type of skill is this?"**

| Type | Description | Example |
|------|-------------|---------|
| **Analysis** | Examine code/data/systems | Code quality, security audit |
| **Generation** | Create files/code/content | API client, test suite |
| **Transformation** | Convert between formats | JSON→YAML, JS→TS |
| **Validation** | Check correctness/compliance | Schema validator |
| **Orchestration** | Coordinate multiple operations | Deploy pipeline |

### Question 3: File Types
**"What file types or formats will it work with?"**
- Add to description for discovery
- Include extensions: .js, .ts, .py, .md, .json, .yaml

### Question 4: Use Cases
**"When would someone use this skill? What problems does it solve?"**
- Extract trigger keywords
- Include problem scenarios

### Question 5: Supporting Files
**"Do you need supporting files?"**
- Templates, examples, scripts, reference docs

---

## Skill Templates

### Minimal Skill Structure

```
skill-name/
└── SKILL.md
```

### Full Skill Structure

```
skill-name/
├── SKILL.md              # Required: Main skill definition
├── reference.md          # Optional: Detailed documentation
├── examples/             # Optional: Example outputs
│   ├── example-1.md
│   └── example-2.md
├── templates/            # Optional: Code/file templates
│   └── template.txt
└── scripts/              # Optional: Helper scripts
    └── helper.py
```

---

## YAML Frontmatter Reference

### Required Fields

```yaml
---
name: Skill Display Name
description: "What it does + when to use it (critical for discovery!)"
---
```

### YAML Safety Rules (CRITICAL)

**ALWAYS quote the `description` field.** Unquoted descriptions with colons, arrows, or special characters will silently break YAML parsing, making the skill invisible.

```yaml
# BROKEN - colon after "approach" breaks YAML parsing
description: 4-layer approach: Trust → Structure → Calibration → Psychology

# FIXED - quoted string handles all special characters
description: "4-layer approach (Trust, Structure, Calibration, Psychology)"
```

**Characters that require quoting:**
- Colons (`:`) — YAML interprets as key-value separator
- Arrows (`→`, `←`) — Unicode can cause issues
- Hash (`#`) — YAML interprets as comment
- Curly braces (`{}`) — YAML interprets as flow mapping
- Square brackets (`[]`) — YAML interprets as flow sequence
- Em-dashes (`—`) — sometimes problematic

**Validation command:**

```bash
python3 -c "import yaml; yaml.safe_load(open('SKILL.md').read().split('---')[1])"
```

If this throws an error, your frontmatter is broken and the skill won't load.

### Optional Fields

```yaml
---
name: Skill Display Name
description: "Complete description with capabilities and triggers"
triggers:            # Alternative invocations
  - skill-name
  - alternate-name
allowed-tools: Read, Grep, Glob, Bash  # Restrict Claude's tool access
---
```

---

## Domain-Specific Templates

### Analysis Skill Template

```markdown
---
name: [Target] Analyzer
description: "Analyze [target] for [aspects]. Detect [issues], identify [patterns], measure [metrics]. Works with [file types]. Use when reviewing [context], investigating [problems], or need [specific insights]."
---

# [Target] Analyzer

Examines [target] to provide insights on [aspects].

## When to Use
- When you need to understand [target] quality
- When investigating [specific problems]
- When working with [file types or systems]

## Analysis Process

### 1. Data Collection
Gather [target] information using [tools/methods]

### 2. Analysis Execution
Apply [analysis techniques]:
- [Technique 1]
- [Technique 2]
- [Technique 3]

### 3. Results Interpretation
Interpret findings:
- [Metric 1]: [What it means]
- [Metric 2]: [What it means]

### 4. Recommendations
Provide actionable insights based on analysis

## Examples
[Concrete examples with real data]

## Best Practices
- [Best practice 1]
- [Best practice 2]

## Common Pitfalls
- [Common mistake] → [Correct approach]
```

### Generation Skill Template

```markdown
---
name: [Output] Generator
description: "Generate [output type] from [input]. Create [artifacts], scaffold [structures], build [components]. Works with [formats]. Use when creating [specific things], need [output format], or building [project type]."
---

# [Output] Generator

Creates [output type] following [standards/patterns].

## When to Use
- Creating new [artifact type]
- Scaffolding [structure type]
- Need [specific output format]

## Generation Process

### 1. Input Requirements
Gather required information:
- [Input 1]
- [Input 2]
- [Input 3]

### 2. Template Selection
Choose appropriate template based on [criteria]

### 3. Generation Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### 4. Output Validation
Verify generated content meets requirements

## Templates
Available templates:
- [Template 1]: For [use case]
- [Template 2]: For [use case]

## Examples
[Real-world generation examples]
```

### Transformation Skill Template

```markdown
---
name: [Source] to [Target] Transformer
description: "Transform [source format] to [target format]. Convert [file types], migrate [systems], adapt [structures]. Works with [formats]. Use when converting between [formats], migrating from [old] to [new], or need [target format]."
---

# [Source] to [Target] Transformer

Converts [source] into [target] while preserving [important aspects].

## When to Use
- Converting [source format] files to [target format]
- Migrating from [old system] to [new system]
- Need [target format] output

## Transformation Process

### 1. Source Validation
Verify input [source] is valid and complete

### 2. Mapping
Map [source] elements to [target]:
- [Source element 1] → [Target element 1]
- [Source element 2] → [Target element 2]

### 3. Conversion
Apply transformation rules

### 4. Target Validation
Ensure output [target] is correct

## Examples
[Before/after transformation examples]
```

### Validation Skill Template

```markdown
---
name: [Target] Validator
description: "Validate [target] against [criteria/standards]. Check [aspects], verify [requirements], ensure [compliance]. Works with [formats]. Use when validating [target type], ensuring [standards], or checking [requirements]."
---

# [Target] Validator

Validates [target] against [criteria] to ensure correctness.

## When to Use
- Validating [target type] meets standards
- Ensuring compliance with [requirements]
- Checking [aspects] are correct

## Validation Process

### 1. Load Validation Rules
Apply [standards/criteria]

### 2. Execute Checks
Run validation:
- [Check 1]
- [Check 2]
- [Check 3]

### 3. Report Results
Provide validation report:
- Pass/fail status
- Specific violations
- Suggested fixes

### 4. Suggest Fixes
For failed checks, recommend corrections

## Examples
[Validation examples with results]
```

### Orchestration Skill Template

```markdown
---
name: [Workflow] Orchestrator
description: "Orchestrate [workflow] by coordinating [actions]. Automate [process], manage [steps], handle [dependencies]. Use when automating [workflow], coordinating [tasks], or managing [pipeline]."
---

# [Workflow] Orchestrator

Automates [workflow] by orchestrating multiple steps.

## When to Use
- Automating [multi-step process]
- Coordinating [related tasks]
- Managing [complex workflow]

## Orchestration Process

### 1. Workflow Definition
Define steps:
1. [Step 1]
2. [Step 2]
3. [Step 3]

### 2. Dependency Management
Handle dependencies:
- [Step X] requires [Step Y]
- [Parallel steps]
- [Sequential steps]

### 3. Execution
Run workflow with error handling

### 4. Monitoring
Track progress and handle failures

## Examples
[Complete workflow examples]
```

---

## Best Practices

### DO
- Write specific, actionable descriptions
- Include file extensions and formats in description
- Use clear, imperative instructions
- Provide concrete examples
- Organize complex skills with supporting files
- Test that Claude discovers your skill

### DON'T
- Write vague descriptions like "helps with files"
- Assume Claude knows when to use your skill
- Put everything in one massive skill
- Forget to include trigger keywords in description
- Skip examples (they're critical for understanding)

---

## Output Format

After gathering requirements, provide:

```markdown
## Generated Skill

Save this to: `~/.claude/skills/[skill-name]/SKILL.md`

\`\`\`markdown
---
name: [Generated Name]
description: [Optimized description]
---

[Full skill content based on template]
\`\`\`

## Verification Checklist

- [ ] YAML frontmatter parses without errors (run validation command)
- [ ] Description field is QUOTED (wrapped in double quotes)
- [ ] Description includes action verbs
- [ ] Description mentions file types/formats
- [ ] Description includes use cases and triggers
- [ ] Name is clear and specific
- [ ] Instructions are step-by-step
- [ ] Examples are concrete
- [ ] Best practices included

## Test Discovery

Try these phrases to verify Claude finds your skill:
1. "[Direct trigger phrase]"
2. "[Problem-based phrase]"
3. "[File type phrase]"
```

---

## Example: Creating a Python Code Analyzer

**User:** Create a skill to analyze Python code quality

**Generated:**

```markdown
---
name: Python Code Quality Analyzer
description: Analyze Python code for complexity, PEP 8 compliance, code smells, and test coverage. Detect anti-patterns, measure cyclomatic complexity, suggest refactoring. Works with .py files. Use when reviewing Python code quality, performing code reviews, or investigating technical debt.
---

# Python Code Quality Analyzer

Comprehensive Python code quality analysis tool.

## When to Use This Skill
- Reviewing Python code quality
- Performing code reviews on .py files
- Investigating technical debt in Python projects
- Need metrics on code complexity
- Checking PEP 8 compliance

## Instructions

### Step 1: Code Collection
Identify Python files to analyze using Glob tool:
- Single file: `.py` file path
- Project: `**/*.py` pattern

### Step 2: Quality Analysis
Execute analysis:
- **Complexity**: Calculate cyclomatic complexity
- **Code Smells**: Detect anti-patterns
- **Style**: Check PEP 8 compliance
- **Coverage**: Assess test coverage (if tests exist)

### Step 3: Report Generation
Generate comprehensive report:
- Complexity scores per function
- Identified code smells with locations
- Style violations with fix suggestions
- Overall quality grade

### Step 4: Recommendations
Provide prioritized improvement suggestions

## Examples

### Example 1: Simple Function Analysis
**Input:** `utils.py` with helper functions
**Process:** Analyze complexity and style
**Output:** Report showing complexity scores, style violations, refactoring suggestions

### Example 2: Project-Wide Analysis
**Input:** Entire Python project (`**/*.py`)
**Process:** Analyze all files, aggregate metrics
**Output:** Project quality dashboard with trends

## Best Practices
- Run on changed files during code review
- Set complexity thresholds appropriate for project
- Fix high-priority issues first
- Track quality metrics over time

## Common Pitfalls
- Analyzing generated code (migrations, etc.) → Use .gitignore patterns to exclude
- Ignoring context (some complexity is necessary) → Review suggestions, don't blindly apply
```

---

**Version:** 1.0.0
**Created:** 2026-01-23
**Replaces:** skill-template-generator, claude-code-skills-expert
