# Directorio .dev

Este directorio contiene scripts y herramientas para configurar y mantener el entorno de desarrollo del proyecto **Workstation Center**.

## Archivos

### `setup.sh`
Script principal para configurar el entorno de desarrollo. Este script:

- Verifica e instala las herramientas necesarias (Gentle AI, Node.js, etc.)
- Configura Gentle AI con el modelo `alibaba/qwen3-max`
- Instala dependencias del proyecto (frontend, server, collector)
- Verifica la presencia del historial de Engram
- Asegura que la configuración esté correcta para desarrollo colaborativo

### `engram-manager.sh`
Herramienta para gestionar el historial de Engram:

- **backup**: Crea un respaldo del historial actual
- **restore**: Restaura un historial desde un respaldo
- **list**: Lista los respaldos disponibles  
- **status**: Muestra el estado actual de Engram

### `verify-setup.sh`
Verifica que toda la configuración esté correctamente aplicada:

- Confirma que Gentle AI esté instalado y configurado
- Verifica que todos los agentes SDD usen `alibaba/qwen3-max`
- Comprueba la presencia del historial de Engram
- Valida la integración de Composio en frontend y backend

## Uso

```bash
# Desde la raíz del proyecto anything-llm

# Configurar entorno de desarrollo
cd .dev
./setup.sh

# Gestionar historial de Engram
./engram-manager.sh backup
./engram-manager.sh restore .engram_backup_20240508_143022

# Verificar configuración
./verify-setup.sh
```

## Requisitos previos

- Acceso al repositorio con los directorios `.engram/` y `.config/opencode/`
- Permisos de escritura en el directorio del proyecto
- Conexión a internet para instalar dependencias

## Seguridad

⚠️ **Importante**: Antes de compartir este repositorio:
- Verifica que no haya credenciales sensibles en los archivos
- Los archivos `.env` deben estar en `.gitignore`
- La base de datos de Engram (`engram.db`) no contiene información sensible por las reglas de permisos

## Desarrollo colaborativo

Este setup permite que múltiples desarrolladores:
- Compartan el mismo historial de desarrollo a través de Engram
- Usen la misma configuración de Gentle AI/SDD
- Tengan un entorno consistente para trabajar en la integración de Composio y otras features

## Comandos útiles después del setup

```bash
# Iniciar sesión de Gentle AI
gentle-ai

# Ver historial de desarrollo
engram mem_context --project anything-llm

# Ejecutar todos los servicios en desarrollo
yarn dev:all

# Ejecutar tests
yarn test
```