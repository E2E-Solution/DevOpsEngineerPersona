# 🎁 Zava Gift Exchange

Gift exchange web application built with React + Vite, Azure Functions, and Azure Cosmos DB.

[![CI/CD](https://github.com/Azure-Samples/DevOpsEngineerPersona/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Azure-Samples/DevOpsEngineerPersona/actions/workflows/ci-cd.yml)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Azure-Samples/DevOpsEngineerPersona?quickstart=1)

## ✨ Features

- 🌍 **Multilingual**: Full support for 9 languages - English, Spanish, Portuguese, Italian, French, Japanese, Chinese, German, and Dutch
- 🎲 **Crypto-Secure Assignments**: Fair circular shuffle using `crypto.randomInt` + Fisher-Yates algorithm
- 🔒 **Protected Games**: Optional participant tokens with timing-safe comparison
- 📧 **Email Notifications**: Optional Azure Communication Services integration with 13+ notification types
- 🔄 **Reassignment**: Organizers can reassign individual participants or all at once; participants can request new assignments
- 👤 **Organizer Panel**: Full game management with individual/bulk reassignment, participant editing, and status tracking
- 🚫 **Exclusion Rules**: Prevent specific pairs from being matched (e.g., couples) — currently API-only; UI configuration planned
- 📅 **Date Validation**: Games can only be created for today or future dates with input length limits
- ⏱️ **Event Countdown**: Live countdown timer showing time until the event
- 📅 **Calendar Integration**: Download `.ics` files to add events to any calendar app
- 📱 **QR Code Sharing**: Generate QR codes for invitation links with invite-only labels
- 🌙 **Dark Mode**: Toggle dark theme on all pages with OS preference detection
- 📱 **PWA Support**: Installable as a Progressive Web App with offline caching
- 🔐 **API Rate Limiting**: IP-based rate limiting on all API endpoints (game creation, retrieval, updates, email)
- 🛡️ **Hardened CSP & HSTS**: Strict CSP, HSTS, `Permissions-Policy`, no `unsafe-eval`, `frame-ancestors 'none'`
- 🧹 **Auto-Cleanup**: Games archived 3 days after event, permanently deleted after 30 days (GDPR compliant)
- 📤 **Web Share API**: Native mobile sharing via `navigator.share()` when available
- 📊 **Application Insights**: Frontend and backend monitoring, error tracking, and performance telemetry
- ♿ **Accessibility Testing**: Automated WCAG 2.0 AA checks via axe-core in E2E tests
- 🧪 **Cross-Browser E2E**: Playwright tests support Chromium, Firefox, and WebKit locally; CI runs Chromium by default

## 🏗️ Environment Strategy

| Environment | Resource Group | Static Web App | Cosmos DB | Lifecycle |
|-------------|----------------|----------------|-----------|------------|
| **PR Preview** | `ZavaGiftExchange-pr-{number}` | Standard | Serverless | Created on PR open, deleted on close |
| **QA** | `ZavaGiftExchange-qa` | Standard | Serverless | Persistent (isolated from prod) |
| **Production** | `ZavaGiftExchange` | Standard | Serverless | Persistent (unlimited scaling) |

All environments use **Standard tier Static Web Apps** and **Cosmos DB Serverless** (pay-per-request) for maximum Azure subscription compatibility. If your subscription supports it, you can downgrade PR/QA to the Free SWA tier by changing `staticWebAppSku` in the parameter files, and enable [Cosmos DB Free Tier](https://learn.microsoft.com/azure/cosmos-db/free-tier) by adding `"enableFreeTier": { "value": true }` to `infra/parameters.qa.json`.

Each environment has its **own Static Web App** and **own Cosmos DB** (QA is completely isolated).
All environments are **automatically configured** with:
- Cosmos DB connection
- Application Insights
- Azure Communication Services (QA/prod)

## � Prerequisites

Before you begin, ensure you have the following installed on your system (macOS, Windows, or Linux):

### Required

- **Node.js 20+** - [Download](https://nodejs.org/)
  - Verify: `node --version` (should be v20 or higher)
  
- **Docker & Docker Compose** - [Download](https://www.docker.com/products/docker-desktop)
  - Verify: `docker --version` and `docker-compose --version`
  - **Windows Users**: Docker Desktop for Windows recommended
  - **Linux Users**: Install Docker Engine and Docker Compose separately
  - **macOS Users**: Docker Desktop for Mac recommended

- **Git** - [Download](https://git-scm.com/)
  - Verify: `git --version`

- **VS Code** - [Download](https://code.visualstudio.com/)
  - Install extension: **Azure Functions** (ms-azuretools.vscode-azurefunctions)

### Optional (for Azure deployment)

- **Azure CLI** - [Download](https://learn.microsoft.com/cli/azure/install-azure-cli)
  - Only needed if deploying to Azure
  - Verify: `az --version`

### Verify All Prerequisites

```bash
node --version      # Should be v20+
docker --version    # Docker version
docker-compose --version  # Docker Compose version
git --version       # Git version
```

All prerequisites work the same way on **Windows, macOS, and Linux**.

---

## �🚀 Quick Start

### Option 1: Cloud Development (Recommended for Beginners)

**GitHub Codespaces** - No installation required, develop entirely in the browser:

1. Click: [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Azure-Samples/DevOpsEngineerPersona?quickstart=1)
2. Wait ~60 seconds for container to build
3. Press **F5** in VS Code (browser-based)
4. Click notification to open frontend in browser

✅ **Zero setup!** Everything pre-configured and running.

[📖 Full Codespaces Guide](docs/codespaces-setup.md)

### Option 2: Local Development (Docker Required)

Run everything on your machine:

```bash
# Clone repository
git clone https://github.com/Azure-Samples/DevOpsEngineerPersona.git
cd DevOpsEngineerPersona

# Start full-stack (Docker + API + Frontend)
npm install
cd api && npm install
cd ..
# Then press F5 in VS Code to debug, OR:
docker-compose up -d    # Start Docker containers
npm run dev             # Frontend dev server
cd api && npm start     # API in separate terminal
```

Open: http://localhost:5173

[📖 Full Local Development Guide](docs/getting-started.md)

### Option 3: Deploy to Azure

1. **Fork this repository**

2. **Configure GitHub OIDC Authentication**:
   ```bash
   # Create service principal
   az ad sp create-for-rbac --name "ZavaGiftExchange-github" \
     --role contributor \
     --scopes /subscriptions/{subscription-id}
   ```

3. **Add GitHub Secret** (Settings → Secrets):
   - `AZURE_CREDENTIALS` - Paste the entire JSON output from the command above

4. **Create Production Resource Group**:
   ```bash
   az group create --name ZavaGiftExchange --location eastus2
   ```

5. **Open a PR** - Full infrastructure is created automatically!

See [docs/github-deployment.md](docs/github-deployment.md) for detailed setup instructions.

## 📁 Project Structure

```
├── src/                 # React frontend
│   ├── components/      # UI components (views, forms, dialogs)
│   ├── lib/            # Utilities, types, translations, calendar, sharing
│   ├── hooks/          # Custom React hooks (dark mode, localStorage, mobile)
│   └── styles/         # CSS theme (light/dark mode)
├── api/                # Azure Functions backend
│   └── src/
│       ├── functions/  # HTTP endpoints
│       └── shared/     # Cosmos DB, email, telemetry, rate limiter
├── e2e/                # Playwright E2E tests (Chromium, Firefox, WebKit)
├── tests/load/         # Azure Load Testing (JMeter + config)
├── infra/              # Bicep infrastructure templates
│   └── modules/        # Monitoring alerts module
├── public/             # PWA manifest, service worker, static assets
├── scripts/            # Utility scripts (type validation, setup)
├── docs/
│   └── runbooks/       # SRE runbooks (error rate, DB outage, rollback)
└── .github/
    ├── copilot-instructions.md  # Global project context
    ├── copilot-constitution.md  # Non-negotiable rules for all agents
    ├── copilot-memory.md        # Architecture decisions & known gotchas
    ├── agents/                  # 6 specialized Copilot agents
    ├── specs/                   # Specification templates & examples
    ├── prompts/                 # Reusable prompt library
    ├── CODEOWNERS               # File ownership mapping
    └── workflows/               # CI/CD pipelines (5)
```

### Frontend Views
- **HomeView**: Landing page with game code entry and dark mode toggle
- **CreateGameView**: Game creation form with date validation and exclusion rules
- **GameCreatedView**: Success page with organizer token and QR code sharing
- **ParticipantSelectionView**: Participant login for protected games
- **AssignmentView**: Shows assignment with event countdown, calendar download, and wish editing
- **OrganizerPanelView**: Full game management (includes delete)
- **PrivacyView**: Data handling and retention policy
- **GameNotFoundView**: Error page for deleted/invalid games

## 🔧 Configuration

### Environment Variables (Auto-configured in Azure)

| Variable | Description | Auto-Set |
|----------|-------------|:--------:|
| `COSMOS_ENDPOINT` | Cosmos DB endpoint URL | ✅ |
| `COSMOS_KEY` | Cosmos DB primary key | ✅ |
| `COSMOS_DATABASE_NAME` | Database name | ✅ |
| `COSMOS_CONTAINER_NAME` | Container name | ✅ |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | App Insights connection | ✅ |
| `APPINSIGHTS_INSTRUMENTATIONKEY` | App Insights key | ✅ |
| `APP_BASE_URL` | Application URL | ✅ |
| `ACS_CONNECTION_STRING` | Email service connection | ✅* |
| `ACS_SENDER_ADDRESS` | Email sender address | ✅* |
| `ENVIRONMENT` | Environment name (pr/qa/prod) | ✅ |
| `BUILD_VERSION` | Build version identifier | ✅ |
| `BUILD_DATE` | Deployment timestamp | ✅ |
| `CLEANUP_SECRET` | Secret for cleanup endpoint authentication | ✅ |

*Only in QA/production with email enabled

### GitHub Secrets (Required)

| Secret | Description |
|--------|-------------|
| `AZURE_CREDENTIALS` | Complete JSON from `az ad sp create-for-rbac` command (includes appId, tenant, subscriptionId, password) |
| `CLEANUP_SECRET` | Shared secret for cleanup HTTP endpoint. Generate a strong random value (e.g., `openssl rand -base64 32`). Used by GitHub Actions scheduled cleanup job running daily at 2:00 AM UTC. |

### No Variables Needed

Resource group names and deployment URLs are now dynamically generated and output from the infrastructure deployment steps.

## 🧪 Testing

```bash
# API unit tests (332 tests across 15 suites)
cd api && npm test

# Validate shared types stay in sync between frontend and API
npm run validate:types

# E2E tests (runs in Chromium, Firefox, and WebKit)
npm run test:e2e

# E2E with UI
npm run test:e2e:ui
```

E2E tests include automated accessibility scanning with [axe-core](https://github.com/dequelabs/axe-core) for WCAG 2.0 AA compliance.

## 🔄 CI/CD Pipeline

| Stage | Trigger | Description |
|-------|---------|-------------|
| Build & Test | All PRs and main | Lint, build, unit tests |
| **PR Infrastructure** | PR opened | Create resource group + dedicated SWA |
| Preview | PRs | Deploy to PR Static Web App |
| **Close PR** | PR closed | Delete resource group |
| QA Infrastructure | Main merge | Deploy QA Static Web App + Load Testing resource |
| QA | Main merge | Deploy to QA |
| E2E (QA) | After QA deploy | Run E2E against QA |
| **Load Test (QA)** | After QA E2E | Run Azure Load Testing against QA API |
| Production Infrastructure | After load tests | Deploy production SWA |
| Production | After prod infra | Manual approval required |

## 📊 Monitoring

Each environment includes Application Insights for:
- Error tracking and diagnostics
- Performance monitoring
- Custom event logging

### Health Endpoints

- `GET /api/health` - Full diagnostics (version, uptime, dependencies)
- `GET /api/health/live` - Liveness probe
- `GET /api/health/ready` - Readiness probe (checks database)

## 🗑️ Data Retention

- **Auto-Deletion**: Games are automatically deleted 3 days after their event date via a GitHub Actions scheduled workflow that calls the `/api/games/cleanup` HTTP endpoint daily at 2:00 AM UTC. Authentication is via the `x-cleanup-secret` request header, whose value must match the `CLEANUP_SECRET` app setting.
- **Manual Deletion**: Organizers can delete games at any time from the Organizer Panel
- **Privacy**: See the in-app Privacy page for full data handling details
- **No External Sharing**: Data is never shared with third parties
## 🔒 Security Highlights

- **Crypto-secure randomness**: All tokens, game codes, and assignments use `crypto.randomInt` / `crypto.randomUUID` — including client-side offline operations
- **Timing-safe comparisons**: All token validations use `crypto.timingSafeEqual` with dummy comparison on length mismatch to prevent timing side-channels
- **Input validation & length limits**: Max lengths enforced on all fields (names: 80 chars, notes: 2000 chars, max 100 participants)
- **Rate limiting**: IP-based rate limiting on all API endpoints — game creation (10/min), email (20/min), general (60/min)
- **Content Security Policy**: Strict CSP with HSTS, no `unsafe-eval`, `frame-ancestors 'none'`, and `Permissions-Policy`
- **No error leaking**: API error responses never expose internal details or stack traces
- **HTML-escaped emails**: All user content is HTML-escaped before embedding in email templates
- **Game code collision detection**: New game codes are checked against existing codes to prevent collisions
- **Production TLS guard**: Cosmos DB emulator's TLS bypass is blocked in production environments
- **GDPR-compliant data retention**: Archived games are permanently deleted after 30 days
- **Service worker safety**: Only static assets are cached — never API responses or dynamic content
- **localStorage TTL**: Old game data is automatically cleaned up after 30 days

See [SECURITY.md](SECURITY.md) for vulnerability reporting and full security policy.

## 🤖 GitHub Copilot Agents

This project includes **6 specialized Copilot agents** in `.github/agents/` that demonstrate how to scope AI assistants to specific roles with appropriate access levels:

| Agent | Role | Access Level |
|-------|------|--------------|
| **Documentation Writer** | Updates docs, README, guides | Write `.md` files only |
| **Test Engineer** | Writes and maintains unit & E2E tests | Write test files only |
| **Feature Analyst** | Analyzes feature requests, proposes improvements | Read-only |
| **Security Reviewer** | OWASP audits, vulnerability analysis | Read-only |
| **DevOps Engineer** | CI/CD, Bicep, Docker, deployment configs | Write infra/workflow files |
| **Localization Expert** | Manages translations across 9 languages | Write translation files only |

Each agent has:
- **Scoped permissions** — can only modify files relevant to its role
- **Domain context** — understands the project architecture and conventions
- **Task patterns** — includes templates and examples for common tasks

### Agentic DevOps Framework

Beyond agents, this repository demonstrates the full **Agentic DevOps** approach outlined in the [DevOps Playbook for the Agentic Era](https://devblogs.microsoft.com/all-things-azure/agentic-devops-practices-principles-strategic-direction/):

| Asset | Purpose | Playbook Section |
|-------|---------|-----------------|
| **Constitution** (`.github/copilot-constitution.md`) | Non-negotiable rules all agents must follow | §4 Designing for Agent-First |
| **Memory** (`.github/copilot-memory.md`) | Architecture decisions, known gotchas, anti-patterns | §4 Repository as Interface |
| **Spec Kit** (`.github/specs/`) | Structured specification templates for features, bugs, infra | §5 From Prompts to Specifications |
| **Prompt Library** (`.github/prompts/`) | Reusable prompts for common dev tasks | §6 Building Agent Teams |
| **CODEOWNERS** (`.github/CODEOWNERS`) | File ownership mapped to agent scopes | §6 Governance Frameworks |
| **Load Testing** (`tests/load/`) | Azure Load Testing config + JMeter plan | §7 Pipelines as Active Verifiers |
| **SRE Runbooks** (`docs/runbooks/`) | Incident response procedures | §7 Production Readiness |
| **Monitoring Alerts** (`infra/modules/monitoring.bicep`) | Azure Monitor alert rules (error rate, latency, availability) | §7 Active Verification |

## 📜 License

MIT - See [LICENSE](LICENSE)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.