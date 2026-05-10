#!/bin/bash

set -e

echo "📦 Script de gestión de historial Engram"
echo "======================================"

ACTION=${1:-help}

case $ACTION in
    backup)
        echo "💾 Creando respaldo del historial de Engram..."
        
        # Verificar si existe la base de datos en el home
        if [ -f "$HOME/.engram/engram.db" ]; then
            BACKUP_DIR=".engram_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            
            # Copiar todos los archivos de la base de datos
            cp "$HOME/.engram/engram.db" "$BACKUP_DIR/"
            if [ -f "$HOME/.engram/engram.db-shm" ]; then
                cp "$HOME/.engram/engram.db-shm" "$BACKUP_DIR/"
            fi
            if [ -f "$HOME/.engram/engram.db-wal" ]; then
                cp "$HOME/.engram/engram.db-wal" "$BACKUP_DIR/"
            fi
            
            echo "✅ Respaldo creado en: $BACKUP_DIR"
            echo "   Tamaño: $(du -h "$BACKUP_DIR/engram.db" | cut -f1)"
            
            # Crear archivo de metadatos
            cat > "$BACKUP_DIR/metadata.json" << EOF
{
  "backup_date": "$(date -Iseconds)",
  "project": "your-project",
  "engram_version": "$(engram --version 2>/dev/null || echo "unknown")",
  "description": "Respaldo del historial de desarrollo"
}
EOF
            
            echo "📄 Metadatos guardados en: $BACKUP_DIR/metadata.json"
            
        elif [ -f ".engram/engram.db" ]; then
            BACKUP_DIR=".engram_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            cp .engram/engram.db "$BACKUP_DIR/"
            if [ -f ".engram/engram.db-shm" ]; then
                cp .engram/engram.db-shm "$BACKUP_DIR/"
            fi
            if [ -f ".engram/engram.db-wal" ]; then
                cp .engram/engram.db-wal "$BACKUP_DIR/"
            fi
            
            echo "✅ Respaldo creado en: $BACKUP_DIR"
            echo "   Tamaño: $(du -h "$BACKUP_DIR/engram.db" | cut -f1)"
            
            cat > "$BACKUP_DIR/metadata.json" << EOF
{
  "backup_date": "$(date -Iseconds)",
  "project": "your-project",
  "engram_version": "$(engram --version 2>/dev/null || echo "unknown")",
  "description": "Respaldo del historial de desarrollo"
}
EOF
            
            echo "📄 Metadatos guardados en: $BACKUP_DIR/metadata.json"
        else
            echo "❌ Error: No se encontró la base de datos de Engram"
            exit 1
        fi
        ;;
        
    restore)
        if [ -z "$2" ]; then
            echo "❌ Uso: $0 restore <directorio_de_respaldo>"
            echo "   Ejemplo: $0 restore .engram_backup_20240508_143022"
            exit 1
        fi
        
        BACKUP_DIR="$2"
        
        if [ ! -d "$BACKUP_DIR" ]; then
            echo "❌ Error: Directorio de respaldo no encontrado: $BACKUP_DIR"
            exit 1
        fi
        
        if [ ! -f "$BACKUP_DIR/engram.db" ]; then
            echo "❌ Error: No se encontró engram.db en el directorio de respaldo"
            exit 1
        fi
        
        echo "🔄 Restaurando historial de Engram desde: $BACKUP_DIR"
        
        # Crear directorio .engram si no existe
        mkdir -p "$HOME/.engram"
        
        # Restaurar archivos
        cp "$BACKUP_DIR/engram.db" "$HOME/.engram/"
        if [ -f "$BACKUP_DIR/engram.db-shm" ]; then
            cp "$BACKUP_DIR/engram.db-shm" "$HOME/.engram/"
        fi
        if [ -f "$BACKUP_DIR/engram.db-wal" ]; then
            cp "$BACKUP_DIR/engram.db-wal" "$HOME/.engram/"
        fi
        
        echo "✅ Historial restaurado en: $HOME/.engram/"
        echo "   Tamaño: $(du -h "$HOME/.engram/engram.db" | cut -f1)"
        
        # Mostrar metadatos si existen
        if [ -f "$BACKUP_DIR/metadata.json" ]; then
            echo ""
            echo "📊 Metadatos del respaldo:"
            cat "$BACKUP_DIR/metadata.json" | jq '.' 2>/dev/null || cat "$BACKUP_DIR/metadata.json"
        fi
        ;;
        
    list)
        echo "📋 Respaldos disponibles:"
        ls -la .engram_backup_* 2>/dev/null || echo "   No se encontraron respaldos"
        ;;
        
    status)
        echo "🔍 Estado actual de Engram:"
        if [ -f "$HOME/.engram/engram.db" ]; then
            echo "   Ubicación: $HOME/.engram/engram.db"
            echo "   Tamaño: $(du -h "$HOME/.engram/engram.db" | cut -f1)"
            echo "   Última modificación: $(stat -c %y "$HOME/.engram/engram.db" 2>/dev/null || stat -f %Sm "$HOME/.engram/engram.db" 2>/dev/null || echo "desconocida")"
        elif [ -f ".engram/engram.db" ]; then
            echo "   Ubicación: .engram/engram.db"
            echo "   Tamaño: $(du -h ".engram/engram.db" | cut -f1)"
            echo "   Última modificación: $(stat -c %y ".engram/engram.db" 2>/dev/null || stat -f %Sm ".engram/engram.db" 2>/dev/null || echo "desconocida")"
        else
            echo "   ❌ No se encontró la base de datos de Engram"
        fi
        ;;
        
    help|*)
        echo "Uso: $0 <acción> [parámetros]"
        echo ""
        echo "Acciones disponibles:"
        echo "  backup    - Crea un respaldo del historial actual de Engram"
        echo "  restore   - Restaura un historial desde un directorio de respaldo"
        echo "  list      - Lista los respaldos disponibles"
        echo "  status    - Muestra el estado actual de Engram"
        echo "  help      - Muestra esta ayuda"
        echo ""
        echo "Ejemplos:"
        echo "  $0 backup"
        echo "  $0 restore .engram_backup_20240508_143022"
        echo "  $0 status"
        ;;
esac