# ADR-001: Library Knowledge via Skills and Context7

## Status
Proposed

## Context
We need to support specific libraries (Shadcn/UI, Tailwind CSS, Cloudscape Design System) in our AI coding workflow. These libraries have evolving APIs and best practices. Hardcoding knowledge into agents is brittle. We have access to Context7 MCP which can query live documentation.

## Decision
We will create specific **Skills** for each library (e.g., `shadcn-ui`, `tailwind-css`, `cloudscape-design`).
These skills will:
1.  Be loadable by agents when needed.
2.  Explicitly instruct the agent to use the `context7_query-docs` tool to fetch relevant documentation and examples.
3.  Provide the correct Library IDs for Context7.

## Consequences
### Positive
-   **Freshness**: Documentation is always up-to-date via Context7.
-   **Modularity**: New libraries can be added by creating a new Skill file, without modifying agents.
-   **Discoverability**: Agents can "learn" a library by loading the skill.

### Negative
-   **Dependency**: Relies on Context7 availability and network access.
-   **Latency**: Fetching docs adds a step to the workflow.
-   **Cost**: Additional tool calls (Context7) consume tokens/budget.

### Neutral
-   Requires users/agents to know *which* skill to load (can be mitigated by `ux-engineer` agent defaults).
