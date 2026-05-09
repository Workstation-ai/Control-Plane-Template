# Workstation Control Plane

> A production-ready template for building and deploying AI-powered applications.

This is a modular, enterprise-ready control plane template for deploying AI applications with built-in support for:

- **Multi-service architecture** (server, frontend, collector)
- **Docker & Docker Compose** for containerization
- **Persistent storage** for data and uploads
- **Document processing** and embeddings pipeline
- **Development tools** for local development

Designed to be **reusable** — clone, customize, and deploy your own AI app.

---

## 🏗️ Architecture

```
workstation-control-plane/
├── server/           # Backend API (Node.js)
├── frontend/         # User interface (React)
├── collector/        # Document processing & embeddings
├── docker/           # Docker configuration
├── extras/           # Additional tools
└── .dev/             # Development scripts & tools
```

---

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- Yarn
- Docker (for production)

### Local Development

```bash
# Install dependencies
cd server && yarn install
cd ../frontend && yarn install
cd ../collector && yarn install

# Terminal 1: Backend
cd server && yarn dev

# Terminal 2: Frontend
cd frontend && yarn dev

# Terminal 3: Collector
cd collector && yarn dev

# Or all together (from root):
yarn dev:all
```

Server runs at `http://localhost:3001`.

### Production with Docker

```bash
# Copy environment template
cp .env.example workstation.env

# Edit workstation.env with your settings

# Start services
docker-compose up -d
```

---

## 🔧 Configuration

### Environment Variables

| File | Description |
|------|-------------|
| `.env.example` | Main environment template |
| `server/.env` | Backend configuration |
| `frontend/.env` | Frontend configuration |
| `collector/.env` | Collector configuration |
| `docker/.env.example` | Docker configuration |

### Database

The project uses SQLite with Prisma. Migrations run automatically on startup.

---

## 📦 Available Scripts

In `.dev/`:

- `setup.sh` — Initial server setup
- `verify-setup.sh` — Health check verification
- `engram-manager.sh` — Persistent memory management

---

## 🐳 Docker

```bash
# Development
docker-compose up

# Production
docker-compose -f docker-compose.yml up -d
```

---

## 📜 License

See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repository
2. Create a branch (`feature/your-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📞 Support

- Open an issue on GitHub
- Join our [Discord](https://discord.gg/workstation-center)

---

**Built for AI teams who want to ship fast — securely.**
