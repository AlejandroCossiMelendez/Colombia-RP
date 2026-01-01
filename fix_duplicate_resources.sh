#!/bin/bash
# Script para renombrar meta.xml de recursos duplicados en [gamemodes]
# Esto evita que MTA detecte recursos duplicados

RESOURCES_DIR="resources/[gamemodes]"
DUPLICATE_RESOURCES=("admin" "freecam" "glue" "interiors" "realdriveby" "runcode" "scoreboard" "superman")

echo "Renombrando meta.xml de recursos duplicados en [gamemodes]..."

for resource in "${DUPLICATE_RESOURCES[@]}"; do
    META_FILE="${RESOURCES_DIR}/${resource}/meta.xml"
    BACKUP_FILE="${RESOURCES_DIR}/${resource}/meta.xml.disabled"
    
    if [ -f "$META_FILE" ]; then
        echo "Renombrando: ${META_FILE} -> ${BACKUP_FILE}"
        mv "$META_FILE" "$BACKUP_FILE"
        echo "  ✓ ${resource} deshabilitado"
    else
        echo "  ⚠ ${resource} no encontrado (puede que ya esté deshabilitado)"
    fi
done

echo ""
echo "¡Completado! Los recursos duplicados han sido deshabilitados."
echo "Para reactivarlos, renombra meta.xml.disabled de vuelta a meta.xml"

