---
name: skill-validator
description: Validate and optimize existing Claude Code skills. Test discovery, check YAML frontmatter, analyze descriptions, suggest improvements, verify file structure, generate test phrases. Use when skills aren't being discovered, validating new skills, debugging skill issues, optimizing discoverability, or testing skill installation.
triggers:
  - skill-validator
  - validate skill
  - test skill
  - optimize skill
  - skill not found
  - skill not working
  - check skill
  - debug skill
---

# Skill Validator

Comprehensive skill validation and optimization system that tests discovery, validates structure, and improves discoverability.

## Quick Start

```bash
# Validate a skill
/skill-validator my-skill-name

# Optimize description only
/skill-validator --optimize my-skill-name

# Full test report
/skill-validator --full my-skill-name
```

---

## Validation Process

### Step 1: File Structure Validation

Check that the skill follows proper structure:

**Required:**
- Skill is in `.claude/skills/` or `~/.claude/skills/`
- Directory name is kebab-case
- `SKILL.md` file exists (exactly this name, case-sensitive)
- YAML frontmatter is present and valid

**Common Issues:**

| Problem | Solution |
|---------|----------|
| `skill.md` (lowercase) | Rename to `SKILL.md` |
| Wrong directory location | Move to `.claude/skills/` |
| Missing frontmatter `---` | Add YAML delimiters |
| No `name:` field | Add required field |
| No `description:` field | Add required field |

**Correct Structure:**
```
.claude/skills/my-skill/
├── SKILL.md              # Required (exact case!)
├── reference.md          # Optional
├── examples/             # Optional
└── templates/            # Optional
```

### Step 2: YAML Frontmatter Validation

Parse and validate the YAML:

**Required Fields:**
```yaml
---
name: [Must be present]
description: [Must be present and not empty]
---
```

**Common YAML Errors:**

```yaml
# Missing colon
name My Skill  # FIX: name: My Skill

# Wrong spacing
name:My Skill  # FIX: name: My Skill

# Special chars not quoted
description: Contains: colons  # FIX: "Contains: colons"

# Missing closing ---
---
name: My Skill
description: Things
# FIX: Add closing ---
```

### Step 3: Description Quality Analysis

Analyze the description for discoverability:

**Check for presence of:**

| Element | Weight | Example |
|---------|--------|---------|
| **Action verbs** | +20% | analyze, generate, transform, validate |
| **File types** | +20% | .js, .ts, .py, .md, .json |
| **Use case triggers** | +20% | "Use when...", problem scenarios |
| **Domain keywords** | +20% | API, database, test, security |
| **Specific capabilities** | +10% | concrete features listed |
| **Optimal length** | +10% | 40-100 words |

**Scoring:**

| Score | Quality | Discovery Likelihood |
|-------|---------|---------------------|
| 90-100% | Excellent | Very likely discovered |
| 70-89% | Good | Likely discovered |
| 50-69% | Fair | Sometimes discovered |
| 30-49% | Poor | Rarely discovered |
| 0-29% | Critical | Won't be discovered |

### Step 4: Generate Test Phrases

Based on the skill's description, generate phrases to test discovery:

**Test Categories:**

1. **Direct Triggers** (HIGH confidence)
   - Phrases using exact keywords from description
   - File type mentions
   - Domain-specific terms

2. **Indirect Triggers** (MEDIUM confidence)
   - Problem descriptions the skill solves
   - Related workflows
   - Semantic equivalents

3. **Should NOT Trigger** (verify scope)
   - Different domain requests
   - Different file types
   - Unrelated problems

### Step 5: Generate Recommendations

Provide actionable improvements based on findings.

---

## Output Format

```markdown
# Skill Validation Report

## Skill: [Skill Name]
**Location:** `~/.claude/skills/[skill-directory]/SKILL.md`
**Date:** [Current date]

---

## File Structure: [PASSED/WARNING/FAILED]

- [Check 1]: [result]
- [Check 2]: [result]
- [Check 3]: [result]

---

## YAML Frontmatter: [PASSED/FAILED]

```yaml
---
name: [Extracted name]
description: [Extracted description]
---
```

**Validation:**
- Required fields: [result]
- YAML syntax: [result]
- Description length: [result]

---

## Description Quality: [Score]% ([Rating])

**Present:**
- [element]: [found in description]

**Missing:**
- [element]: [recommendation]

---

## Test Phrases

### Direct Triggers (HIGH confidence)
1. "[Phrase 1]"
2. "[Phrase 2]"
3. "[Phrase 3]"

### Indirect Triggers (MEDIUM confidence)
1. "[Phrase 4]"
2. "[Phrase 5]"

### Should NOT Trigger
1. "[Phrase 6]" - Wrong domain
2. "[Phrase 7]" - Different file type

---

## Recommendations

### Critical (Must Fix)
1. [Critical issue]: [Fix]

### Suggested Improvements
1. [Suggestion]: [Benefit]

---

## Summary

**Overall Status:** [READY/NEEDS IMPROVEMENT/CRITICAL ISSUES]
**Discovery Confidence:** [High/Medium/Low]

**Next Steps:**
1. [Action 1]
2. [Action 2]
```

---

## Description Optimization

When optimizing descriptions, apply this formula:

```
[Action verbs] + [Specific capabilities] + [File types/formats] + [Use case triggers]
```

### Optimization Patterns

#### Pattern 1: Too Vague → Specific

**Before:**
```yaml
description: Helps with code analysis
```

**Problems:**
- No action verbs
- "Helps" is weak
- "Code" is too broad
- No file types
- No use cases

**After:**
```yaml
description: Analyze JavaScript and TypeScript code for complexity, maintainability, and code smells. Detect anti-patterns, measure cyclomatic complexity, suggest refactoring. Works with .js, .ts, .jsx, .tsx files. Use when reviewing code quality, performing code reviews, or investigating technical debt.
```

#### Pattern 2: Missing File Types → Explicit Extensions

**Before:**
```yaml
description: Converts configuration files between different formats
```

**After:**
```yaml
description: Convert configuration files between JSON, YAML, TOML, and INI formats. Transform .json to .yaml, .toml to .json, .ini to .yaml. Preserve structure, handle edge cases, validate output. Use when migrating configs, converting between .json/.yaml/.toml/.ini files.
```

#### Pattern 3: No Use Cases → Explicit Triggers

**Before:**
```yaml
description: Generates API documentation from code
```

**After:**
```yaml
description: Generate API documentation from TypeScript, Python, or Java code. Create Markdown, HTML, or OpenAPI specs from code comments and type definitions. Works with .ts, .py, .java files. Use when documenting APIs, need OpenAPI specs, creating README files.
```

#### Pattern 4: Too Broad → Focused Scope

**Before:**
```yaml
description: Helps with testing in any programming language
```

**After:**
```yaml
description: Generate unit tests for JavaScript and TypeScript functions using Jest and Vitest. Create test cases, mock dependencies, assert behaviors. Works with .js, .ts files. Use when writing tests, need test coverage, or practicing TDD with Jest/Vitest.
```

---

## Common Discovery Problems

### Problem 1: Skill File Not Found

**Symptoms:**
- Skill should work but Claude doesn't see it
- No errors, just doesn't activate

**Diagnosis:**
```bash
# Check if file exists
ls -la .claude/skills/my-skill/SKILL.md

# Common issues:
# - .claude/skill/ instead of .claude/skills/
# - skill.md instead of SKILL.md
```

**Fix:**
1. Verify path: `.claude/skills/[skill-name]/SKILL.md`
2. Check capitalization: `SKILL.md` not `skill.md`

### Problem 2: YAML Parsing Error

**Symptoms:**
- Skill file exists but doesn't work
- Frontmatter looks correct

**Diagnosis:**
```yaml
# Check for:
name My Skill     # Missing colon
name:My Skill     # Missing space
---
name: My Skill
[No closing ---]  # Missing delimiter
```

**Fix:**
```yaml
---
name: My Skill
description: "If description has colons: use quotes"
---
```

### Problem 3: Description Too Vague

**Symptoms:**
- Skill exists, YAML valid, but never discovered
- Works when explicitly invoked

**Fix:**
- Add specific keywords to description
- Include file types
- Add use case triggers
- Run `/skill-validator --optimize`

### Problem 4: Skill Too Broad

**Symptoms:**
- Skill activates when it shouldn't
- Gets invoked for unrelated tasks

**Fix:**
- Narrow description scope
- Add qualifying context
- Be specific about domain

---

## Quick Validation Commands

```bash
# Check file exists (correct case)
ls -la ~/.claude/skills/[name]/SKILL.md

# View frontmatter
head -15 ~/.claude/skills/[name]/SKILL.md

# Count description elements
# (Run this skill for automated analysis)
```

---

## Interactive Optimization

When asked to optimize a skill, follow this workflow:

1. **Read current SKILL.md**
2. **Analyze description** for missing elements
3. **Ask clarifying questions:**
   - "What file types does this skill work with?"
   - "What specific capabilities does it have?"
   - "When would someone naturally ask for this?"
   - "What problems does it solve?"

4. **Generate optimized description** with before/after comparison
5. **Provide test phrases** for verification

---

## Anti-Patterns to Detect

### Marketing Speak
```yaml
# BAD: No concrete capabilities
description: The ultimate solution for all your code analysis needs.
```

### Feature List Without Use Cases
```yaml
# BAD: No "when to use"
description: Has many features including analysis, generation, and more.
```

### Acronyms Without Expansion
```yaml
# BAD: User might not know "OAS"
description: Works with OAS and RAML specs.
# GOOD: Include full names
description: Works with OpenAPI (OAS) and RAML specifications.
```

---

## Validation Checklist

Before marking a skill as validated:

### File Structure
- [ ] Skill directory in `.claude/skills/` or `~/.claude/skills/`
- [ ] Directory name is kebab-case
- [ ] `SKILL.md` file exists (correct capitalization)

### YAML Frontmatter
- [ ] Starts with `---`
- [ ] Ends with `---`
- [ ] `name:` field present
- [ ] `description:` field present and not empty
- [ ] Valid YAML syntax

### Description Quality
- [ ] Contains action verbs
- [ ] Mentions file types (if applicable)
- [ ] Includes use case triggers
- [ ] Has domain-specific keywords
- [ ] Is 40-100 words (optimal)
- [ ] No marketing fluff

### Discovery Test
- [ ] Test with direct trigger phrase - skill activates
- [ ] Test with indirect phrase - skill may activate
- [ ] Test with unrelated phrase - skill does NOT activate

---

**Version:** 1.0.0
**Created:** 2026-01-23
**Replaces:** skill-description-optimizer, skill-discovery-tester
