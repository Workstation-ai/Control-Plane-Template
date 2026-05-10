#!/bin/bash

set -e

echo "🔍 Verificando configuración de Gentle AI y Engram"
echo "=============================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: Este script debe ejecutarse desde la raíz del proyecto"
    exit 1
fi

echo "✅ Directorio del proyecto verificado"

# Verificar instalación de Gentle AI
if command -v gentle-ai &> /dev/null; then
    echo "✅ Gentle AI instalado"
else
    echo "❌ Gentle AI no está instalado"
    exit 1
fi

# Verificar configuración de Gentle AI
if [ -f "$HOME/.config/opencode/opencode.json" ]; then
    CONFIG_FILE="$HOME/.config/opencode/opencode.json"
elif [ -f ".config/opencode/opencode.json" ]; then
    CONFIG_FILE=".config/opencode/opencode.json"
else
    echo "❌ Configuración de Gentle AI no encontrada"
    exit 1
fi

echo "✅ Archivo de configuración encontrado: $CONFIG_FILE"

# Verificar que los agentes SDD usan los modelos correctos
EXPECTED_MODELS=(
    "gentle-orchestrator:nvidia/minimaxai/minimax-m2.7"
    "sdd-init:alibaba/qwen3.6-max-preview"
    "sdd-explore:alibaba/qwen3.5-plus"
    "sdd-propose:alibaba/qwen3.5-397b-a17b"
    "sdd-spec:alibaba/qwen3.5-35b-a3b"
    "sdd-design:alibaba/qwen3-coder-plus"
    "sdd-tasks:alibaba/qwen3-coder-flash"
    "sdd-apply:alibaba/qwen3-coder-480b-a35b-instruct"
    "sdd-verify:nvidia/moonshotai/kimi-k2-thinking"
    "sdd-archive:alibaba/qwen-plus"
)

ALL_CORRECT=true

for EXPECTED in "${EXPECTED_MODELS[@]}"; do
    AGENT=$(echo "$EXPECTED" | cut -d':' -f1)
    MODEL=$(echo "$EXPECTED" | cut -d':' -f2)
    
    if grep -q "\"$AGENT\"" "$CONFIG_FILE" && grep -A5 -B5 "\"$AGENT\"" "$CONFIG_FILE" | grep -q "\"model\": \"$MODEL\""; then
        echo "✅ $AGENT: configurado con $MODEL"
    else
        echo "❌ $AGENT: NO configurado con $MODEL"
        ALL_CORRECT=false
    fi
done

if [ "$ALL_CORRECT" = true ]; then
    echo "✅ Todos los agentes SDD están configurados con alibaba/qwen3-max"
else
    echo "❌ Algunos agentes SDD no están configurados correctamente"
    exit 1
fi

# Verificar Engram
if [ -f "$HOME/.engram/engram.db" ]; then
    echo "✅ Engram database encontrada en $HOME/.engram/"
elif [ -f ".engram/engram.db" ]; then
    echo "✅ Engram database encontrada en .engram/"
else
    echo "⚠️  Engram database no encontrada"
fi

# Verificar integración de Composio
if [ -f "frontend/src/pages/GeneralSettings/Composio/index.jsx" ]; then
    echo "✅ Integración de Composio en frontend encontrada"
else
    echo "⚠️  Integración de Composio en frontend no encontrada"
fi

if grep -q "ComposioApiKey" "server/utils/helpers/updateENV.js"; then
    echo "✅ Integración de Composio en backend encontrada"
else
    echo "⚠️  Integración de Composio en backend no encontrada"
fi

# Verificar rutas
if grep -q "composio" "frontend/src/utils/paths.js" && grep -q "composio" "frontend/src/main.jsx"; then
    echo "✅ Rutas de Composio configuradas correctamente"
else
    echo "⚠️  Rutas de Composio no configuradas completamente"
fi

echo ""
echo "🎉 Verificación completada exitosamente!"
echo ""
echo "💡 Siguientes pasos:"
echo "   • Ejecutar .dev/setup.sh si es la primera vez"
echo "   • Usar .dev/engram-manager.sh para gestionar el historial"
echo "   • Iniciar Gentle AI con 'gentle-ai'"