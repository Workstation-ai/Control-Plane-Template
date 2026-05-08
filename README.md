# Workstation Center

> Transformar AnythingLLM (MIT) en **Workstation Center**, una plataforma B2B white-label de Agentes AI para empresas.

Workstation Center es un producto B2B que ofrece **soluciones de Agentes AI para empresas**. Basado en AnythingLLM (MIT), lo extendemos con arquitectura multi-tenencia, branding white-label, y capacidades enterprise — todo corriendo on-premise o en nube privada.

---

## 🏗️ Arquitectura

```
workstation-center/
├── server/           # Backend Node.js (API, base de datos, agentes)
├── frontend/         # Frontend React (interfaz de usuario)
├── collector/        # Procesamiento de documentos y embeddings
├── docker/           # Configuración Docker
├── extras/           # Herramientas adicionales (translator)
└── .dev/             # Scripts de desarrollo y setup
```

---

## 🚀 Getting Started

### Prerrequisitos

- Node.js 18+
- Yarn
- Docker (para producción)

### Desarrollo Local

```bash
# Instalar dependencias
cd server && yarn install
cd ../frontend && yarn install
cd ../collector && yarn install

# Terminal 1: Backend
cd server && yarn dev

# Terminal 2: Frontend
cd frontend && yarn dev

# Terminal 3: Collector
cd collector && yarn dev

# O todo junto (desde raíz):
yarn dev:all
```

El servidor estará disponible en `http://localhost:3001`.

### Producción con Docker

```bash
# Copiar variables de entorno
cp .env.example workstation.env

# Editar workstation.env con tus configuraciones

# Iniciar servicios
docker-compose up -d
```

---

## 🔧 Configuración

### Variables de Entorno

| Archivo | Descripción |
|---------|-------------|
| `.env.example` | Template de variables principal |
| `server/.env` | Configuración del backend |
| `frontend/.env` | Configuración del frontend |
| `collector/.env` | Configuración del collector |
| `docker/.env.example` | Configuración Docker |

### Base de Datos

El proyecto usa SQLite con Prisma. Las migraciones se ejecutan automáticamente en startup.

---

## 📦 Scripts Disponibles

En `.dev/` encontrarás:

- `setup.sh` — Configuración inicial del servidor
- `verify-setup.sh` — Verificación de salud del sistema
- `engram-manager.sh` — Gestión de memoria persistente

---

## 🐳 Docker

El proyecto incluye configuración Docker para despliegue on-premise:

```bash
# Desarrollo
docker-compose up

# Producción
docker-compose -f docker-compose.yml up -d
```

---

## 📜 Licencia

Este proyecto está basado en AnythingLLM (MIT). Ver [LICENSE](LICENSE) para detalles.

---

## 🤝 Contribuciones

1. Fork el repositorio
2. Crea una rama (`feature/tu-feature`)
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

---

## 📞 Soporte

- Abre un issue en GitHub
- Únete a nuestro [Discord](https://discord.gg/workstation-center)

---

**Made with ❤️ for AI teams who want to ship fast — securely.**
