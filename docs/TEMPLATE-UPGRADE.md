# Template Upgrade

This document defines how an existing repository descended from `vbonk/repo-template` can be compared with a newer template baseline while keeping project-specific work authoritative.

Phase 0 applies to fresh template instances. Template Upgrade applies after project-specific history exists.

Repository classes:
- PRISTINE: no meaningful project work; the inherited substrate can be refreshed before Phase 0.
- LIGHTLY CUSTOMIZED: reconcile inherited material with project edits.
- PROJECT MATURE: treat repo-template as ancestry and evaluate newer capabilities selectively.

Current instances carry `.repo-template.yaml` with a stable `baseline_id`. Older repositories without the marker are supported by identifying the closest historical template baseline from repository history and inherited files.

Use a three-way model: A = historical template baseline, B = current project, C = current template. Compare A→B with A→C so template evolution can be considered without erasing project evolution.

After a successful reconciliation, the provenance marker identifies the newest baseline reconciled into the project. The marker records ancestry only; it is not lifecycle state.

Current baseline: `agent-native-phase0-v1` (2026-08-13).
