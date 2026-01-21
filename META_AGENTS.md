# OpenCode Configuration Repository

This repository contains a collection of OpenCode configuration files, including agents, skills, and configuration for AI coding assistants.

## Repository Structure

```
.
├── agent/           # Agent definitions (markdown files)
├── skills/          # Skill definitions (SKILL.md inside named directories)
├── opencode.json    # Main OpenCode configuration
├── META_AGENTS.md   # Meta documentation about building this config collection
└── README.md        # Project readme
```

## Build, Lint, and Test Commands

This is a configuration repository with no build process. Changes are validated by:

```bash
# Validate JSON configuration
cat opencode.json  # Should be valid JSON

# Check file structure
ls -la agent/ skills/

# Verify agent frontmatter is valid
grep -A 5 "^---" agent/*.md

# Verify skill frontmatter is valid
find skills -name "SKILL.md" -exec grep -A 5 "^---" {} +
```

## Code Style Guidelines

### File Organization

- **Agents**: Place in `agent/` directory as `.md` files
  - Use kebab-case naming: `ux-pilot.md`, `ui-designer.md`
  - Each agent must have YAML frontmatter with required fields
  - Each agent should be a standalone markdown file

- **Skills**: Place in `skills/{skill-name}/SKILL.md` structure
  - Directory name must match the `name` in frontmatter
  - Use kebab-case for directory names: `git-release/`, `typescript-expert/`
  - Each skill must have `SKILL.md` (all caps) with YAML frontmatter

- **Configuration**: Main config in `opencode.json`
  - Use JSON format
  - Follow existing structure with plugins, instructions, permissions, and MCP servers

### Naming Conventions

- **Files**: Use kebab-case for all filenames and directories
  - ✅ `typescript-expert.md`, `api-design/`, `git-release/`
  - ❌ `TypeScriptExpert.md`, `API_Design/`, `gitRelease/`

- **Agents**: Descriptive role-based names
  - Format: `{role}-{specialty}` (e.g., `ux-pilot`, `backend-developer`)
  - Keep names concise but clear

- **Skills**: Capability-based names (must be 1-64 chars, lowercase alphanumeric with single hyphens)
  - Format: `{technology}-{focus}` (e.g., `typescript-advanced-types`, `nextjs-patterns`)
  - Or domain-based: `atomic-design`, `api-design`, `git-release`
  - Regex validation: `^[a-z0-9]+(-[a-z0-9]+)*$`

### Agent File Structure

Agents use YAML frontmatter with these options:

```markdown
---
description: Reviews code for quality and best practices
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
permission:
  edit: deny
  bash:
    "*": ask
    "git diff": allow
    "git log*": allow
---

You are in code review mode. Focus on:

- Code quality and best practices
- Potential bugs and edge cases
- Performance implications
- Security considerations

Provide constructive feedback without making direct changes.
```

**Required frontmatter fields for agents**:

- `description`: Brief description of what the agent does (required for subagents)
- `mode`: Either `primary`, `subagent`, or `all` (defaults to `all` if not specified)

**Optional frontmatter fields**:

- `model`: Override model for this agent
- `temperature`: Control response randomness (0.0-1.0)
- `tools`: Enable/disable specific tools
- `permission`: Set permissions for tools (allow/deny/ask)
- `hidden`: Hide subagent from @ autocomplete (subagents only)
- `maxSteps`: Limit agentic iterations
- `prompt`: Reference to prompt file: `{file:./prompts/custom.txt}`

### Skill File Structure

Skills must be in `skills/{name}/SKILL.md` format with YAML frontmatter:

```markdown
---
name: git-release
description: Create consistent releases and changelogs
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Draft release notes from merged PRs
- Propose a version bump
- Provide a copy-pasteable `gh release create` command

## When to use me

Use this when you are preparing a tagged release.
Ask clarifying questions if the target versioning scheme is unclear.
```

**Required frontmatter fields for skills**:

- `name`: Skill identifier (must match directory name, 1-64 chars, lowercase with hyphens)
- `description`: Brief description (1-1024 chars)

**Optional frontmatter fields**:

- `license`: License identifier (e.g., MIT, Apache-2.0)
- `compatibility`: Compatibility info (e.g., opencode)
- `metadata`: String-to-string map for additional context

### Configuration Style

When editing `opencode.json`:

1. **Indentation**: 2 spaces (no tabs)
2. **Quotes**: Use double quotes for strings
3. **Structure**: Maintain existing sections:
   - `$schema`: Reference to schema
   - `plugin`: Array of plugin strings
   - `instructions`: Array of instruction file references
   - `permission`: Object with command permissions
   - `agent`: Object defining agents (can override built-in agents)
   - `mcp`: Object with MCP server configurations

Example with agent configuration:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["@tarquinen/opencode-dcp@latest"],
  "instructions": ["CLAUDE.md"],
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "permission": {
        "bash": {
          "git push": "ask",
        },
      },
    },
    "code-reviewer": {
      "description": "Reviews code for best practices",
      "mode": "subagent",
      "tools": {
        "write": false,
        "edit": false,
      },
    },
  },
  "permission": {
    "bash": {
      "git *": "allow",
      "git push *": "deny",
    },
    "skill": {
      "*": "allow",
      "internal-*": "deny",
    },
  },
}
```

### Error Handling

Since this is a configuration repository:

- Validate JSON syntax before committing
- Ensure file references in config exist
- Verify frontmatter YAML is valid
- Check skill directory names match frontmatter `name` field
- Verify agent/skill files are not empty
- Ensure skill names follow regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

### Git Workflow

- Always commit with descriptive messages
- Reference the agent/skill being added/modified
- Group related changes (e.g., agent + its dependencies)

Example commit messages:

```bash
feat: add typescript-expert agent with advanced types skill
docs: update api-design skill with REST patterns
fix: correct nextjs-patterns skill file path
refactor: restructure git-release skill to use SKILL.md format
```

### Adding New Agents

1. Create file in `agent/` directory with `.md` extension
2. Add YAML frontmatter with required fields (`description` for subagents, `mode`)
3. Write agent instructions in markdown body
4. Define tool permissions if needed
5. Test by switching to agent (Tab key) or invoking with `@agent-name`

### Adding New Skills

1. Create directory in `skills/` with kebab-case name
2. Create `SKILL.md` file inside that directory (must be all caps)
3. Add YAML frontmatter with `name` and `description`
4. Ensure `name` matches directory name exactly
5. Write skill content explaining what it does and when to use it
6. Configure skill permissions in `opencode.json` if needed

## Special Notes

- **META_AGENTS.md**: Contains the strategic plan for building this config collection
- **Symlink**: `AGENTS.md` → `META_AGENTS.md` for local development
- **Context7**: MCP server configured for documentation queries
- **Permissions**: Git commands allowed, but `git push` requires explicit permission

## References

- OpenCode Config Schema: https://opencode.ai/config.json
- This repository serves as dotfiles that can be:
  - Installed globally at `~/.config/opencode`
  - Cloned as a submodule for project-specific config
- Use context7 to search for updated documentation
