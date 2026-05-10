# Development Tools

Este documento describe las herramientas de desarrollo disponibles para este proyecto.

## Herramientas Recomendadas

### Gentle AI / Opencode

Framework de desarrollo AI con:
- **SDD (Spec-Driven Development)**: Metodología de desarrollo orientada a specs
- **Engram**: Memoria persistente entre sesiones

### Configuración

Edita `.config/opencode/opencode.json` para personalizar los modelos de los agentes.

## Estructura del Proyecto

```
.dev/              # Scripts y herramientas de desarrollo
.config/opencode/ # Configuración de Opencode
.engram/           # Memoria persistente (opcional)
```

## Primeros Pasos

1. Ejecuta `./dev/setup.sh` para configurar el entorno
2. Configura tu proveedor de LLM en `.env`
3. Implementa tu aplicación en `server/`, `frontend/`, `collector/`

## Scripts Disponibles

- `./dev/setup.sh` — Configuración inicial
- `./dev/verify-setup.sh` — Verificar configuración
- `./dev/engram-manager.sh` — Gestionar historial de Engram
