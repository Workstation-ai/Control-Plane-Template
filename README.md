# Workstation Control Plane

> A production-ready template for building and deploying AI-powered applications.

A modular, enterprise-ready control plane template. Clone, customize, and deploy your own AI app.

---

## 🏗️ Architecture

```
workstation-control-plane/
├── .dev/              # Development scripts
├── docker/            # Docker configuration
├── extras/            # Additional tools (optional)
├── server/            # Backend API (implement your own)
├── frontend/          # User interface (implement your own)
├── collector/         # Document processing (implement your own)
├── .env.example       # Environment template
└── docker-compose.yml # Container orchestration
```

---

## 🚀 Quick Start

### 1. Configure

```bash
# Copy environment template
cp .env.example .env
```

Edit `.env` and set:
- `APP_IMAGE` — Your Docker image (e.g., `ghcr.io/your-org/your-app:latest`)
- `APP_PORT` — Your app port (default: 3000)
- LLM provider configuration (OpenAI, Anthropic, Azure, Ollama, etc.)

### 2. Build & Run

```bash
# Development (if you have services running locally)
docker-compose up

# Production
docker-compose up -d
```

### 3. Customize

Implement your own:
- `server/` — Backend API
- `frontend/` — User interface
- `collector/` — Document processing

---

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_IMAGE` | Docker image | `ghcr.io/your-org/your-app:latest` |
| `APP_PORT` | Exposed port | `3000` |
| `COMPOSE_PROJECT_NAME` | Project name | `my-app` |
| `DATABASE_URL` | Database connection | `file:./data/app.db` |

### LLM Providers

Supported providers (configure in `.env`):

- **OpenAI** — `LLM_PROVIDER=openai`
- **Anthropic** — `LLM_PROVIDER=anthropic`
- **Azure OpenAI** — `LLM_PROVIDER=azure`
- **Ollama** — `LLM_PROVIDER=ollama`
- **LMStudio** — `LLM_PROVIDER=lmstudio`

---

## 🐳 Docker

```bash
# Build and start
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Image Distribution

To distribute your built image:

```bash
# Build
docker build -t ghcr.io/your-org/your-app:v1.0.0 .

# Push to GitHub Container Registry
docker push ghcr.io/your-org/your-app:v1.0.0
```

Then update `APP_IMAGE` in your environment to use your image.

---

## 📦 Scripts

In `.dev/`:

- `setup.sh` — Initial server setup
- `verify-setup.sh` — Health check
- `engram-manager.sh` — Persistent memory (optional)

---

## 📜 License

See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repository
2. Create a branch (`feature/your-feature`)
3. Commit your changes
4. Push and open a Pull Request

---

## 📞 Support

- Open an issue on GitHub
- Join our [Discord](https://discord.gg/workstation-center)

---

**Build your AI app — deploy anywhere.**
