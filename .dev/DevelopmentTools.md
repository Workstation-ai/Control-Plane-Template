# Development Tools Roadmap

## Vision: Developer Central Control-Plane

### 🎯 Objective

Transform the local Opencode instance into a **multi-user Control-Plane Server** that serves as the core infrastructure for collaborative AI-assisted development across the Workstation Center team.

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                  Developer Central Server                    │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Opencode Control-Plane                      │ │
│  │  ┌───────────┐  ┌───────────┐  ┌─────────────────────┐ │ │
│  │  │  Session   │  │  Session   │  │   Session           │ │ │
│  │  │  (Dev 1)   │  │  (Dev 2)   │  │   (PR Review Agent) │ │ │
│  │  └─────┬─────┘  └─────┬─────┘  └──────────┬──────────┘ │ │
│  │        │              │                    │             │ │
│  │  ┌─────┴──────────────┴────────────────────┴───────────┐ │ │
│  │  │           Shared Resources                          │ │ │
│  │  │  • Engram (persistent memory)                       │ │ │
│  │  │  • SDD Configuration (models, prompts, skills)      │ │ │
│  │  │  • Project Context (anything-llm)                   │ │ │
│  │  │  • MCP Servers (Composio, etc.)                     │ │ │
│  │  └─────────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
└────────────────────────┬────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
   ┌──────┴──────┐ ┌─────┴──────┐ ┌────┴─────────┐
   │  Developer 1 │ │ Developer 2 │ │  GitHub      │
   │  (attach)    │ │ (attach)    │ │  Actions     │
   └─────────────┘ └─────────────┘ └──────────────┘
```

---

## 📋 Roadmap

### Phase 1: Server Foundation (Current)

**Status**: ✅ Completed

- [x] Opencode configuration with SDD agent models
- [x] Engram persistent memory setup
- [x] Skill registry and openspec configuration
- [x] Development scripts (`.dev/setup.sh`, `.dev/verify-setup.sh`)
- [x] Engram backup/restore tooling (`.dev/engram-manager.sh`)

### Phase 2: Control-Plane Server

**Status**: 📋 Planned

**Goal**: Expose Opencode as a headless server that multiple developers can connect to simultaneously.

#### 2.1 Server Mode Setup

```bash
# Start the Control-Plane server
opencode serve \
  --hostname 0.0.0.0 \
  --port 4096 \
  --mdns \
  --mdns-domain "workstation-center.local"
```

**Requirements**:
- [ ] Configure `OPENCODE_SERVER_USERNAME` and `OPENCODE_SERVER_PASSWORD`
- [ ] Set up reverse proxy (Caddy) with HTTPS for remote access
- [ ] Configure firewall rules (port 4096 for LAN, 443 for WAN)
- [ ] Create systemd service for auto-start on boot
- [ ] Document connection instructions for developers

#### 2.2 Multi-User Session Management

**Goal**: Allow multiple developers to work concurrently with isolated sessions but shared context.

**Features**:
- [ ] Each developer gets an isolated session via `opencode attach`
- [ ] Shared Engram memory across all sessions (project-level knowledge)
- [ ] Shared SDD configuration (models, prompts, skills)
- [ ] Session naming convention: `dev-{username}-{date}` or `pr-{number}-review`
- [ ] Session isolation: each developer has their own working directory state

**Connection flow**:
```bash
# Developer connects from their machine
opencode attach https://workstation-center.local:4096 \
  --username dev-juan \
  --password $WORKSTATION_PASSWORD \
  --dir /home/workstation/anything-llm
```

#### 2.3 Security Hardening

- [ ] Basic Auth with strong passwords per developer
- [ ] TLS/HTTPS via Caddy reverse proxy
- [ ] IP whitelist for server access
- [ ] Rate limiting on API endpoints
- [ ] Audit logging for all sessions
- [ ] Separate credentials for human devs vs CI/CD agents

---

### Phase 3: GitHub Actions Integration (Automated PR Reviews)

**Status**: 📋 Planned

**Goal**: Automatically connect to the Control-Plane server from GitHub Actions to run AI-powered PR reviews.

#### 3.1 PR Review Agent

**Concept**: When a PR is opened, a GitHub Action connects to the Control-Plane server and spawns a dedicated review session.

```yaml
# .github/workflows/ai-pr-review.yml
name: AI PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout PR
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Connect to Control-Plane and run review
        env:
          OPENCODE_SERVER_URL: ${{ secrets.WORKSTATION_SERVER_URL }}
          OPENCODE_SERVER_USERNAME: ${{ secrets.WORKSTATION_CI_USERNAME }}
          OPENCODE_SERVER_PASSWORD: ${{ secrets.WORKSTATION_CI_PASSWORD }}
          PR_NUMBER: ${{ github.event.pull_request.number }}
          PR_DIFF_URL: ${{ github.event.pull_request.diff_url }}
        run: |
          # Connect to the Control-Plane server and spawn a review session
          opencode attach $OPENCODE_SERVER_URL \
            --username ci-pr-reviewer \
            --password $OPENCODE_SERVER_PASSWORD \
            --session "pr-${PR_NUMBER}-review" \
            --prompt "Review PR #${PR_NUMBER}. Analyze the diff for:
              1. Code quality and best practices
              2. Security vulnerabilities
              3. Performance issues
              4. Test coverage gaps
              5. Architecture alignment with Workstation Center standards
              
              Post your review as GitHub PR comments."
```

#### 3.2 Review Agent Capabilities

The PR Review Agent running on the Control-Plane should:

- [ ] **Read the PR diff** and understand the changes
- [ ] **Access project context** via Engram (previous decisions, conventions, architecture)
- [ ] **Apply SDD standards** (check if specs/designs were followed)
- [ ] **Run tests** on the PR branch before reviewing
- [ ] **Post structured reviews** as GitHub PR comments
- [ ] **Check for common issues**:
  - Missing tests
  - Breaking changes without migration
  - Security vulnerabilities (secrets, injection, etc.)
  - Performance regressions
  - Code style violations
  - Missing documentation
- [ ] **Approve or request changes** based on configurable thresholds

#### 3.3 Agent Skill Specialization

Different agents for different review types:

| Agent | Purpose | Model | Trigger |
|-------|---------|-------|---------|
| `pr-reviewer-general` | Code quality, style, best practices | `qwen3-coder-plus` | Every PR |
| `pr-reviewer-security` | Security audit | `kimi-k2-thinking` | PRs touching auth, API, env |
| `pr-reviewer-architecture` | Architecture alignment | `qwen3.5-397b-a17b` | PRs with structural changes |
| `pr-reviewer-tests` | Test coverage validation | `qwen3-coder-flash` | PRs missing tests |

#### 3.4 CI/CD Integration Flow

```
PR Opened
    │
    ▼
GitHub Action Triggered
    │
    ▼
Action connects to Control-Plane via `opencode attach`
    │
    ▼
Spawns dedicated review session: `pr-{number}-review`
    │
    ▼
Agent reads PR diff + Engram context + project standards
    │
    ▼
Agent runs tests, analyzes code, checks architecture
    │
    ▼
Agent posts review comments via GitHub API
    │
    ▼
Session archived, Engram updated with review findings
    │
    ▼
PR status updated (approved / changes requested)
```

---

### Phase 4: Advanced Features

**Status**: 💡 Future

#### 4.1 Developer Dashboard

- [ ] Web UI showing active sessions and their status
- [ ] Real-time session monitoring (token usage, cost, progress)
- [ ] Session history and replay
- [ ] Resource usage metrics (CPU, memory, GPU)

#### 4.2 Collaborative Features

- [ ] Shared whiteboard for architecture discussions
- [ ] Session handoff (dev A can transfer session to dev B)
- [ ] Pair programming mode (two devs in same session)
- [ ] Session templates for common tasks (feature, bugfix, refactor)

#### 4.3 Agent Marketplace

- [ ] Pre-configured agent profiles for different tasks
- [ ] Custom agent skills that can be shared across the team
- [ ] Agent performance tracking and optimization
- [ ] Cost allocation per developer/project

---

## 🔧 Technical Requirements

### Server Infrastructure

| Component | Specification |
|-----------|---------------|
| **Host** | DigitalOcean droplet or dedicated server |
| **OS** | Debian 12+ |
| **RAM** | 8GB+ (for concurrent sessions) |
| **CPU** | 4+ cores |
| **Storage** | 50GB+ SSD (for Engram, logs, sessions) |
| **Network** | Static IP or DNS + HTTPS |

### Software Stack

| Component | Purpose |
|-----------|---------|
| **Opencode** | Core AI development server |
| **Engram** | Persistent memory across sessions |
| **Caddy** | Reverse proxy with auto-HTTPS |
| **systemd** | Service management and auto-restart |
| **UFW** | Firewall for access control |
| **GitHub Actions** | CI/CD integration for PR reviews |

### Security

| Layer | Implementation |
|-------|----------------|
| **Authentication** | Basic Auth + per-user credentials |
| **Encryption** | TLS via Let's Encrypt (Caddy) |
| **Network** | Firewall rules, IP whitelisting |
| **Audit** | Session logging, access tracking |
| **Secrets** | GitHub Secrets for CI/CD credentials |

---

## 📊 Success Metrics

| Metric | Target |
|--------|--------|
| **Concurrent developers** | 5+ simultaneous sessions |
| **PR review time** | < 5 minutes from PR open to AI review |
| **Session uptime** | 99.9% server availability |
| **Engram accuracy** | > 95% context recall across sessions |
| **Cost per review** | < $0.50 per automated PR review |

---

## 🚀 Getting Started (For Developers)

### Prerequisites

1. Install Opencode:
   ```bash
   curl -fsSL https://opencode.ai/install | bash
   ```

2. Get credentials from the team admin:
   - Server URL
   - Username
   - Password

3. Connect to the Control-Plane:
   ```bash
   opencode attach https://workstation-center.local:4096 \
     --username your-username \
     --password your-password \
     --dir /path/to/anything-llm
   ```

### First Session

```bash
# Start a new development session
opencode attach https://workstation-center.local:4096 \
  --username dev-juan \
  --password $PASSWORD \
  --session feature-composio-integration

# The server will provide:
# - Full project context from Engram
# - SDD configuration with correct models
# - Access to MCP servers (Composio, etc.)
# - Shared team knowledge and conventions
```

---

## 📝 Notes

- This roadmap is a living document and will evolve as we learn
- Priority is Phase 2 (Control-Plane) → Phase 3 (GitHub Actions) → Phase 4 (Advanced)
- All phases should maintain backward compatibility with local development
- Security is paramount — never expose the server without authentication and HTTPS
