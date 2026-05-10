# Directorio .dev

Este directorio contiene scripts y herramientas para configurar y mantener el entorno de desarrollo.

## Archivos

### `setup.sh`
Script principal para configurar el entorno de desarrollo:

- Verifica herramientas necesarias (Node.js, yarn, etc.)
- Instala dependencias del proyecto (frontend, server, collector)
- Verifica la presencia del historial de Engram

### `engram-manager.sh`
Gestión del historial de Engram:

- **backup**: Crea un respaldo del historial actual
- **restore**: Restaura un historial desde un respaldo
- **list**: Lista los respaldos disponibles
- **status**: Muestra el estado actual de Engram

### `verify-setup.sh`
Verifica que la configuración esté correctamente aplicada.

## Uso

```bash
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

- Node.js 18+
- Yarn
- Acceso a internet para instalar dependencias

## Seguridad

⚠️ **Importante**:
- Verifica que no haya credenciales sensibles en los archivos
- Los archivos `.env` deben estar en `.gitignore`
- La base de datos de Engram (`engram.db`) no contiene información sensible

## Comandos útiles después del setup

```bash
# Iniciar sesión de Gentle AI
gentle-ai

# Ver historial de desarrollo
engram mem_context --project your-project-name

# Ejecutar todos los servicios en desarrollo
yarn dev:all

# Ejecutar tests
yarn test
```
