<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/dark/relatix.svg">
    <source media="(prefers-color-scheme: light)" srcset="public/images/light/relatix.svg">
    <img src="public/images/light/relatix.svg" height="64" alt="Relatix">
  </picture>
</p>

<p align="center">Open-core CRM with an AGPL-licensed Community Edition, AI agents, APIs, MCP, and self-hosting.</p>

<p align="center">
  <a href="https://relatix.com">Website</a> |
  <a href="https://demo.relatix.com/en/w/small-business/dashboard">Demo</a> |
  <a href="https://relatix.com/docs">Documentation</a> |
  <a href="https://github.com/relatix/relatix">GitHub</a> |
  <a href="https://youtu.be/A7juUe3Iaco">Walkthrough</a>
</p>


<p align="center">
  <img src=".github/media/relatix-promo.gif" alt="Relatix: 57 second walkthrough" width="1200">
</p>

Relatix is a CRM for modern teams that want a clear system for contacts, organizations, deals, services, and tasks without the usual enterprise-heavy setup. It combines practical CRM workflows with API access, webhooks, n8n automation, MCP-based tooling, and AI-agent workflows.

You can use the managed cloud version or run Relatix yourself in your own infrastructure with Docker Compose.

## 🚀 Getting Started

There are two ways to start using Relatix:

| Option | Description |
| --- | --- |
| **[Cloud](https://relatix.com)** | Fastest way to get started. Managed by Relatix. |
| **[Self-Hosting](https://relatix.com/docs/self-hosting)** | Run Relatix on your own server with Docker Compose and PostgreSQL. |

Docs entry points:

- [CRM Overview](https://relatix.com/docs)
- [Self-Hosting (install, manage, cloud vs self-host)](https://relatix.com/docs/self-hosting)
- [Connect your AI (Claude)](https://relatix.com/docs/mcp-connect-claude)
- [Webhooks](https://relatix.com/docs/webhooks)

## ⭐ Key Features

- CRM for contacts, organizations, deals, services, and tasks
- API access with OpenAPI documentation
- Webhooks and event-driven integrations
- n8n workflows and automation support
- MCP support for agent tooling and structured tool calling
- Unified inbox for email, LinkedIn, WhatsApp, Instagram, and Telegram (Cloud, from the Pro plan)
- Audit logging
- Single Sign-On and Whitelabeling on the Enterprise plan (self-hosted Enterprise deployments by agreement)
- Role-based access control for teams
- Several isolated workspaces per login, each with its own data model, members, billing, API keys and MCP connections
- Self-hosted deployment with Docker Compose and PostgreSQL
- Cloud uses monthly per-seat pricing; see the [current plans](https://relatix.com/pricing)

## 📊 Comparison

Relatix supports both cloud and self-hosted deployment models.

| Criterion | Cloud | Self-Hosted |
| --- | --- | --- |
| Pricing | [monthly per-seat plans](https://relatix.com/pricing) | free core + infra costs |
| Setup Time | 2 minutes | ~15 minutes |
| Maintenance Required | None | Docker, Postgres, proxy, TLS, backups |
| Updates | Automatic | `docker compose pull && docker compose up -d` |
| EU-hosted | ✅ | wherever you put it |
| Backups | Automatic daily | You configure |
| API and integrations | ✅ | ✅ |
| Unlimited Users | ✅ | ✅ |
| Unlimited Records | ✅ | ✅ |
| Several workspaces per login | ✅ (each with its own plan) | ✅ |
| n8n and automation workflows | ✅ | ✅ |
| Unified inbox and calendar sync | from the Pro plan | ❌ (Cloud feature) |
| Audit log | Included | Included |
| Enterprise (SSO, Whitelabeling) | Enterprise plan | By agreement |

If you want the full decision guide, see the [Self-hosting docs](https://relatix.com/docs/self-hosting).

## 🐳 Self-Hosting

Self-hosting is two files (`docker-compose.yml` and `.env`) plus `docker compose up -d`. No `git clone`, no build step. The published image at `ghcr.io/relatix/relatix:latest` applies pending migrations every time it starts.

### Prerequisites

- Docker and Docker Compose v2.
- A domain name if you want TLS (optional for local).
- ~2 GB RAM and a couple of GB of disk per thousand records.

### Setup

```bash
mkdir relatix && cd relatix
curl -fsSL https://raw.githubusercontent.com/relatix/relatix/main/docker-compose.yml -o docker-compose.yml
curl -fsSL https://raw.githubusercontent.com/relatix/relatix/main/.env.selfhost.template -o .env
# edit .env with real values
docker compose up -d
```

Required `.env` values:

- `BETTER_AUTH_SECRET`: long random string (`openssl rand -hex 32`).
- `POSTGRES_PASSWORD`: change the default.
- `BASE_URL`: your public URL (e.g. `https://crm.example.com`).
- `RESEND_API_KEY` and `RESEND_OPERATOR_EMAIL`: for signup verification, password reset, and invitation emails.

Optional: uncomment `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`, or `AZURE_AD_CLIENT_ID` and `AZURE_AD_CLIENT_SECRET`, to offer sign-in with Google or Microsoft. See [Can users sign in with Google or Microsoft?](https://relatix.com/docs/self-hosting#can-users-sign-in-with-google-or-microsoft).

Set `CRON_SECRET` (`openssl rand -hex 32`) and call `/api/cron/lifecycle` daily with it, or Trash is never emptied after 30 days. See [Which scheduled jobs must I run?](https://relatix.com/docs/self-hosting#scheduled-jobs).

First boot takes ~1 minute while Prisma applies migrations. Watch with `docker compose logs -f app`, then open `<BASE_URL>/auth/signup`.

### Day-to-day

```bash
docker compose pull && docker compose up -d   # update
docker compose up -d                           # apply .env changes
docker compose logs -f app                     # logs
```

Front the app with a reverse proxy (Caddy, nginx, Traefik) for TLS and set `BASE_URL` to the public `https://` address. Relatix takes the scheme and host for its links from `BASE_URL` and sets secure cookies when it uses `https://`, so `X-Forwarded-Proto` is not required. The proxy must pass on the original `Host` header, because the app rejects form submissions whose origin does not match it, including sign-in and sign-up.

More docs:

- [Self-Hosting (install and manage)](https://relatix.com/docs/self-hosting)
- [Architecture and security](https://relatix.com/docs/architecture-security)

## 🛠️ Development

Create an isolated worktree and run Relatix locally:

```bash
git fetch origin main
git worktree add ../relatix-my-change -b feat/my-change origin/main
cd ../relatix-my-change
nvm use
yarn db:provision
cp .env.cloud.template .env
# Paste the printed DATABASE_URL and DIRECT_URL into .env.
yarn install --frozen-lockfile
yarn db:reset
yarn dev
```

`yarn db:provision` creates a PostgreSQL 17 container and named volume owned by the current worktree. Re-running it is idempotent. `yarn db:reset` applies the migrations, seeds the database, and prepares the workflow schemas. Replacing the database volume is destructive and only happens with `yarn db:provision --recreate`; use `yarn db:provision --destroy` to remove the worktree's owned database when the worktree is retired.

Useful scripts:

- `yarn dev`
- `yarn build`
- `yarn lint`
- `yarn openapi:generate`
- `yarn db:provision`
- `yarn db:reset`

For configurable CRM architecture review, isolated databases, production-build browser journeys and SSH verification, see [the browser verification guide](tests/e2e/README.md).

## 📚 Documentation

The docs cover:

- product overview and CRM comparison
- self-hosting and operations
- API integrations and OpenAPI
- MCP and n8n
- architecture and security

Start here: [relatix.com/docs](https://relatix.com/docs)

## 📄 License

Relatix uses an open-core licensing model.

The Community Edition (all first-party code outside `ee/`) is licensed under [AGPL-3.0-only](./LICENSE).

Other first-party files in `ee/` are source-available under the [Relatix Commercial License](./ee/LICENSE.md), subject to its AGPL client-material exception. Production use of Commercial Software outside the limited Community Build permission, including any Enterprise Feature, requires a Commercial Agreement.

The official Community image at `ghcr.io/relatix/relatix` is built from the shared codebase and contains compiled Commercial Software. The limited Community Build permission allows anyone to run its unmodified commercial support components where documented `APP_MODE=self-hosted` operation necessarily executes them; it does not license Enterprise Feature use.

Contributor terms are available in [`.github/CLA.md`](./.github/CLA.md).

Third-party data keeps its own license: the address formats from Google libaddressinput that ship with Relatix and the postal codes it downloads from GeoNames are licensed under CC BY 4.0, see [`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md).
