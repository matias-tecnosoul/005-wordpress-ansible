#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/molecule-env/bin/activate" ]]; then
    source "$SCRIPT_DIR/molecule-env/bin/activate"
    echo "✅ Entorno Molecule activado desde $(pwd)"
else
    echo "❌ Entorno no encontrado"
fi
