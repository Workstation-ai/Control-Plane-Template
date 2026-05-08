# Workstation Center — Roadmap

> Transformar AnythingLLM (MIT) en **Workstation Center**, una plataforma B2B white-label de Agentes AI para empresas.

## Visión

Workstation Center es un producto B2B que ofrece **soluciones de Agentes AI para empresas**. Basado en AnythingLLM (MIT), lo extendemos con arquitectura multi-tenencia, branding white-label, y capacidades enterprise — todo corriendo on-premise o en nube privada.

---

## Fases

### Fase 0 — ✅ Fundación (completada)

| Hito | Estado |
|------|--------|
| Repositorio clonado | ✅ |
| Dependencias instaladas (server, frontend, collector) | ✅ |
| Base de datos SQLite creada + migraciones Prisma | ✅ |
| Servidor dev arranca en `localhost:3001` | ✅ |
| Frontend Vite configurado con proxy a API | ✅ |

**Comandos de desarrollo:**
```bash
# Terminal 1: Backend
cd server && yarn dev

# Terminal 2: Frontend
cd frontend && yarn dev

# Terminal 3: Collector (procesamiento de documentos)
cd collector && yarn dev

# O todo junto:
yarn dev:all
```

---

### Fase 1 — Rebranding & White-Label

**Objetivo:** Reemplazar toda la identidad visual de AnythingLLM por Workstation Center.

#### Branding core

| Archivo | Cambio |
|---------|--------|
| `frontend/index.html` | `<title>`, meta tags, favicon, manifest |
| `frontend/src/LogoContext.jsx` | Imagen default del logo |
| `frontend/src/media/logo/anything-llm.png` | Reemplazar por logo Workstation Center |
| `frontend/src/media/logo/anything-llm-dark.png` | Reemplazar por logo versión dark |
| `frontend/src/media/illustrations/login-logo.svg` | Reemplazar ilustraciones de login |
| `frontend/public/favicon.png` | Nuevo favicon |
| `frontend/public/manifest.json` | Nombre, descripción, iconos PWA |
| `package.json` | `name`, `description` |
| `server/package.json` | `name`, `description` |
| `frontend/package.json` | `name`, `description` |

#### Textos y copy

| Área | Cambio |
|------|--------|
| `frontend/src/locales/` | Traducciones — reemplazar referencias a "AnythingLLM" |
| `server/utils/boot/MetaGenerator.js` | Meta tags dinámicos del servidor |
| Componentes de UI | Mensajes default, tooltips, onboarding |
| Página de login | Subtítulo, descripción |
| Página de onboarding | Flujo de bienvenida personalizado |

#### Assets adicionales

- [ ] Generar logo "Workstation Center" (PNG + SVG, light/dark)
- [ ] Diseñar favicon (favicon.ico + PNG variants)
- [ ] Crear ilustraciones de login propias
- [ ] Definir paleta de colores corporativa (tailwind.config.js)
- [ ] Actualizar screenshot de producto en README

---

### Fase 2 — Multi-Tenencia B2B

**Objetivo:** Soportar múltiples empresas (workspaces aislados) desde una sola instancia.

| Funcionalidad | Descripción |
|---------------|-------------|
| **Multi-workspace por instancia** | Cada empresa tiene su propio workspace aislado con datos, agentes y configuraciones separadas |
| **Super-admin** | Usuario root que gestiona todas las empresas |
| **Admin de empresa** | Administra usuarios, facturación, límites de su tenant |
| **Aislamiento de datos** | Cada tenant tiene su propia base de datos o esquema separado |
| **Registro de empresas** | Flujo de onboarding para nuevas empresas con auto-registro |

#### Arquitectura propuesta

```
Workstation Center Instance
├── Empresa A (tenant_id: a_xxx)
│   ├── Admin empresa
│   ├── Usuarios (5-50)
│   ├── Workspaces internos
│   ├── Agentes propios
│   └── Documentos / Vectores
├── Empresa B (tenant_id: b_xxx)
│   ├── Admin empresa
│   ├── Usuarios (10-200)
│   ├── Workspaces internos
│   └── ...
└── Super Admin
    └── Gestiona todas las empresas
```

#### Cambios técnicos

- [ ] Modelo `tenants` en Prisma (name, slug, settings, is_active)
- [ ] Relación `users → tenants` (cada usuario pertenece a un tenant)
- [ ] Middleware de routing por tenant (subdominio o header)
- [ ] Aislamiento de vectorstore (colección por tenant)
- [ ] API keys con scope de tenant
- [ ] Límites de uso por tenant (documentos, usuarios, storage)

---

### Fase 3 — Enterprise Agent Platform

**Objetivo:** Posicionar Workstation Center como plataforma de Agentes B2B.

#### Agentes B2B

| Funcionalidad | Prioridad |
|---------------|-----------|
| Agentes pre-configurados para casos de uso empresarial | Alta |
| Catálogo de agentes por industria (ventas, soporte, RH) | Alta |
| Flujos de aprobación humana en agentes (human-in-the-loop) | Alta |
| Integración con herramientas empresariales (Slack, Teams, email) | Alta |
| Webhooks de eventos de agente | Media |
| Auditoría de acciones de agente (log completo) | Media |
| Reportes de uso por agente/empresa | Media |

#### Casos de uso B2B target

1. **Soporte técnico automatizado** — Agente que lee documentación interna y responde tickets
2. **Asistente de ventas** — Consulta catálogos, precios, disponibilidad
3. **HR bot** — Políticas internas, beneficios, onboarding
4. **Analista de documentos** — Procesa contratos, facturas, informes
5. **Workstation personal** — Cada empleado tiene su "estación de trabajo AI"

#### Integraciones enterprise

- [ ] SSO (SAML, OIDC, Google Workspace, Microsoft Entra ID)
- [ ] LDAP / Active Directory
- [ ] Auditoría centralizada (export a SIEM)
- [ ] Backup automatizado de configuraciones y datos
- [ ] Rate limiting por tenant
- [ ] Roles personalizados (RBAC avanzado)

---

### Fase 4 — Operaciones & Escalabilidad

**Objetivo:** Preparar la plataforma para producción con clientes reales.

| Área | Acción |
|------|--------|
| **Base de datos** | Migrar de SQLite a PostgreSQL en producción |
| **Vector store** | LanceDB local → Qdrant/Pinecone/AstraDB gestionado |
| **Almacenamiento** | Documentos en S3-compatible (MinIO, AWS S3, GCS) |
| **Cache** | Redis para sesiones y rate limiting |
| **Cola de trabajos** | Bull/Redis para procesamiento async de documentos |
| **Monitoreo** | Métricas de uso, alertas, dashboards |
| **Logs** | Logs estructurados (JSON) con correlación por tenant |
| **Health checks** | Endpoints de health check para orquestación |
| **Backup** | Estrategia de backup y restore |
| **Deploy** | Docker Compose → Kubernetes (Helm chart) |

#### Infraestructura target

```
                    ┌─────────────┐
                    │  LB / CDN   │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────┴────┐ ┌────┴────┐ ┌────┴────┐
         │ Server  │ │ Server  │ │ Server  │ (scale horizontal)
         └────┬────┘ └────┬────┘ └────┬────┘
              │            │            │
         ┌────┴────────────┴────────────┴────┐
         │         PostgreSQL (RDS)          │
         └───────────────────────────────────┘
              │            │
         ┌────┴────┐ ┌────┴────┐
         │  Redis  │ │ Qdrant  │ (vector store)
         └─────────┘ └─────────┘
              │
         ┌────┴────┐
         │ S3/MinIO │ (documentos)
         └─────────┘
```

---

### Fase 5 — Go-to-Market

**Objetivo:** Preparar el producto para ofrecerlo a clientes empresariales.

- [ ] **Pricing tiers:** definir planes (Starter, Business, Enterprise)
- [ ] **Portal de clientes:**自助servicio, facturación, gestión de cuenta
- [ ] **Documentación pública:** docs.workstationcenter.com
- [ ] **Demo pública:** instancia demo con agentes pre-configurados
- [ ] **Cumplimiento:** GDPR, SOC2, data residency
- [ ] **SLA:** definir niveles de servicio
- [ ] **Onboarding de clientes:** flujo guiado + kickoff call
- [ ] **Branding completo:** sitio web, dominio, email marketing

---

## Stack técnico actual

| Componente | Tecnología |
|------------|------------|
| Frontend | React 18, Vite, Tailwind CSS |
| Backend | Node.js, Express |
| ORM | Prisma (SQLite → PostgreSQL) |
| Vector DB | LanceDB (default), Qdrant, Pinecone, etc. |
| Collector | Node.js, Puppeteer, document parsing |
| LLMs | OpenAI, Anthropic, Ollama, AWS Bedrock +20 más |
| Agentes | Built-in con MCP compatibilidad |
| Auth | JWT, SSO simple |

## Notas sobre la licencia

AnythingLLM es **MIT License**. Esto permite:
- ✅ Uso comercial
- ✅ Modificación y redistribución
- ✅ White-label / rebranding
- ✅ Vender el producto modificado
- ❌ No podemos usar la marca registrada "AnythingLLM" ni el nombre "Mintplex Labs"

---

## Cómo contribuir a este roadmap

1. Cada fase puede dividirse en cambios atómicos usando SDD (Spec-Driven Development)
2. Los cambios se priorizan por: **impacto al cliente > esfuerzo > dependencias**
3. Usar `/sdd-new <change>` para proponer un cambio nuevo dentro de una fase
4. Verificar con `/sdd-verify <change>` antes de dar por terminado

---

> **Próximo paso:** Comenzar con Fase 1 — Rebranding. ¿Empezamos por el `index.html` y los logos?
