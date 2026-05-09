# Workstation Control Plane - Roadmap

> Template para construir y desplegar aplicaciones AI propias.

Este template proporciona la estructura base. Personaliza según las necesidades de tu proyecto.

---

## Quick Start

1. **Configura tu imagen Docker**
   - Edita `APP_IMAGE` en `.env` o `docker-compose.yml`
   - Ejemplo: `ghcr.io/your-org/your-app:latest`

2. **Configura tu proveedor de LLM**
   - Descomenta y completa las variables en `.env`
   - OpenAI, Anthropic, Azure, Ollama, LMStudio disponibles

3. **Desarrolla tu aplicación**
   - Implementa tu lógica en `server/`, `frontend/`, `collector/`
   - Cada servicio es independiente

4. **Despliega**
   - `docker-compose up -d`
   - O construye tu propia imagen y despliegala

---

## Estructura de Desarrollo

```
server/      → Backend API (Node.js, Python, Go, etc.)
frontend/    → Interfaz de usuario (React, Vue, Svelte, etc.)
collector/   → Procesamiento de documentos (opcional)
```

---

## Próximos Pasos Sugeridos

- [ ] Configurar imagen Docker personalizada
- [ ] Elegir e integrar proveedor de LLM
- [ ] Implementar autenticación si es necesario
- [ ] Configurar base de datos
- [ ] Desplegar a producción
