#!/bin/bash

set -e

echo "🚀 Configurando entorno de desarrollo"
echo "=========================================================="

# Verificar si estamos en el directorio correcto
if [ ! -f "package.json" ] || [ ! -d ".engram" ]; then
    echo "❌ Error: Este script debe ejecutarse desde la raíz del proyecto"
    exit 1
fi

# Función para verificar y mostrar versión
check_version() {
    local tool=$1
    local version_cmd=$2
    if command -v $tool &> /dev/null; then
        echo "✅ $tool: $(eval $version_cmd)"
    else
        echo "❌ $tool no está instalado"
        MISSING_TOOLS="$MISSING_TOOLS $tool"
    fi
}

echo "🔍 Verificando herramientas requeridas..."

# Verificar herramientas esenciales
check_version "node" "node --version"
check_version "npm" "npm --version"
check_version "yarn" "yarn --version"

# Verificar Gentle AI / Opencode
if command -v gentle-ai &> /dev/null; then
    echo "✅ Gentle AI: $(gentle-ai --version 2>/dev/null || echo 'installed')"
else
    echo "⚠️  Gentle AI no está instalado. Instalando..."
    curl -fsSL https://raw.githubusercontent.com/Gentleman-Programming/gentle-ai/main/scripts/install.sh | bash
    echo "✅ Gentle AI instalado"
fi

# Verificar estructura de Engram
ENGRAM_FOUND=false
if [ -f "$HOME/.engram/engram.db" ]; then
    echo "✅ Engram database: encontrada en $HOME/.engram/ (historial persistente disponible)"
    ENGRAM_FOUND=true
elif [ -f ".engram/engram.db" ]; then
    echo "✅ Engram database: encontrada en .engram/ (historial persistente disponible)"
    ENGRAM_FOUND=true
else
    echo "⚠️  Engram database: no encontrada"
    echo "   El historial de desarrollo no estará disponible"
fi

# Verificar Engram
if [ -f ".engram/engram.db" ]; then
    echo "✅ Engram database: encontrada (historial persistente disponible)"
else
    echo "⚠️  Engram database: no encontrada en .engram/engram.db"
    echo "   El historial de desarrollo no estará disponible"
fi

# Verificar configuración de Opencode
if [ -f ".config/opencode/opencode.json" ]; then
    echo "✅ Configuración de Gentle AI: encontrada"
    # Verificar que usa qwen3-max
    if grep -q "alibaba/qwen3-max" .config/opencode/opencode.json; then
        echo "✅ Modelo configurado: alibaba/qwen3-max"
    else
        echo "⚠️  Advertencia: El modelo no es alibaba/qwen3-max"
    fi
else
    echo "❌ Configuración de Gentle AI: no encontrada en .config/opencode/opencode.json"
    echo "   Copia la configuración desde otro desarrollador o configura manualmente"
fi

# Instalar dependencias del proyecto
echo ""
echo "📦 Instalando dependencias del proyecto..."
if [ -f "yarn.lock" ]; then
    yarn install
else
    npm install
fi

# Verificar estructura de frontend
if [ -d "frontend" ]; then
    echo "✅ Frontend: encontrado"
    cd frontend
    if [ -f "yarn.lock" ]; then
        yarn install
    else
        npm install
    fi
    cd ..
else
    echo "⚠️  Frontend: no encontrado"
fi

# Verificar estructura de server
if [ -d "server" ]; then
    echo "✅ Server: encontrado"
    cd server
    if [ -f "yarn.lock" ]; then
        yarn install
    else
        npm install
    fi
    cd ..
else
    echo "⚠️  Server: no encontrado"
fi

# Verificar estructura de collector
if [ -d "collector" ]; then
    echo "✅ Collector: encontrado"
    cd collector
    if [ -f "yarn.lock" ]; then
        yarn install
    else
        npm install
    fi
    cd ..
else
    echo "⚠️  Collector: no encontrado"
fi

echo ""
echo "🔧 Verificando permisos de archivos sensibles..."

# Asegurar que los archivos .env no estén en el repo (deberían estar en .gitignore)
if [ -f ".env" ] || [ -f "server/.env" ] || [ -f "server/.env.development" ]; then
    echo "⚠️  Advertencia: Se encontraron archivos .env en el directorio"
    echo "   Asegúrate de que no contengan credenciales reales antes de compartir"
fi

echo ""
echo "📋 Resumen de configuración:"

# Mostrar estado del historial de Engram
if [ -f ".engram/engram.db" ]; then
    DB_SIZE=$(du -h .engram/engram.db | cut -f1)
    echo "   • Historial Engram: disponible ($DB_SIZE)"
else
    echo "   • Historial Engram: no disponible"
fi

# Mostrar configuración de Gentle AI
if [ -f ".config/opencode/opencode.json" ]; then
    MODEL=$(grep -A5 -B5 "model.*qwen3-max" .config/opencode/opencode.json | head -1 | cut -d'"' -f4 || echo "no detectado")
    echo "   • Modelo Gentle AI: $MODEL"
else
    echo "   • Configuración Gentle AI: no disponible"
fi

echo ""
echo "🎯 Entorno de desarrollo listo para usar!"

echo ""
echo "💡 Comandos útiles:"
echo "   • gentle-ai                    # Iniciar sesión de Gentle AI"
echo "   • engram mem_context           # Ver historial de desarrollo"
echo "   • yarn dev:all                 # Iniciar todos los servicios en desarrollo"
echo "   • yarn test                    # Ejecutar tests"

echo ""
echo "📚 Documentación del proyecto:"
echo "   • Composio integration: Settings → Tools → Composio"
echo "   • MCP architecture: server/utils/MCP/"
echo "   • Agent plugins: server/utils/agents/aibitat/plugins/"

if [ -n "$MISSING_TOOLS" ]; then
    echo ""
    echo "❌ Herramientas faltantes:$MISSING_TOOLS"
    echo "   Por favor instálalas antes de continuar"
    exit 1
fi

echo ""
echo "✨ ¡Listo para desarrollar! 🚀"