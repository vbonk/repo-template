# Architecture

> High-level architecture of this project. Keep this document updated as the system evolves.

> [!NOTE]
> This is a **template document**. Replace the TODO placeholders with your project's actual architecture. The Mermaid diagrams, component tables, and constraint sections are structured starting points -- customize them to match your system.

<!-- TODO: Brief system description -->

## System Diagram

<!-- TODO: Replace with your system's architecture -->
```mermaid
graph TD
    A[Client] --> B[API Server]
    B --> C[Database]
    B --> D[Cache]
    D --> B
```

## Key Components

| Component | Purpose | Location |
|-----------|---------|----------|
| <!-- TODO --> | | |

## Data Flow

<!-- TODO: Describe how data moves through the system -->

```mermaid
sequenceDiagram
    participant C as Client
    participant A as API
    participant D as Database
    C->>A: Request
    A->>D: Query
    D-->>A: Result
    A-->>C: Response
```

## Technology Choices

| Decision | Choice | Rationale |
|----------|--------|-----------|
| <!-- TODO: e.g., Language --> | <!-- e.g., TypeScript --> | <!-- e.g., Type safety, ecosystem --> |
| <!-- TODO: e.g., Database --> | <!-- e.g., PostgreSQL --> | <!-- e.g., Relational, ACID --> |
| <!-- TODO: e.g., Hosting --> | <!-- e.g., Railway --> | <!-- e.g., Simple deploys, good DX --> |

> [!TIP]
> Record each major technology decision as an ADR in [docs/decisions/](decisions/). The table above is a summary -- the ADRs capture full context and alternatives considered.

## Constraints

<!-- TODO: What constraints affect the architecture? -->

- **Performance:** <!-- e.g., <200ms p99 latency -->
- **Security:** <!-- e.g., SOC2 compliance required -->
- **Budget:** <!-- e.g., <$50/month infrastructure -->
- **Team:** <!-- e.g., Solo developer, async-first -->

## Architecture Decision Records

Major decisions are tracked as ADRs using the template at [decisions/000-template.md](decisions/000-template.md).

See [docs/decisions/](decisions/) for the full list.

| ADR | Date | Decision | Status |
|-----|------|----------|--------|
| [000](decisions/000-template.md) | -- | Template | -- |

---

> [!NOTE]
> Keep this document in sync with the codebase. Review during major changes.

See also: [README.md](../README.md) | [CLAUDE.md](../CLAUDE.md) | [decisions/](decisions/)
