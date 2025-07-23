#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔍 Verificación rápida del setup...${NC}\n"

# Verificar entorno virtual
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo -e "${GREEN}✅ Entorno virtual activo${NC}"
    echo "   Ubicación: $VIRTUAL_ENV"
else
    echo -e "${RED}❌ Entorno virtual NO activo${NC}"
    echo "   Ejecuta: source molecule-env/bin/activate"
    exit 1
fi

# Verificar herramientas
echo -e "\n🧪 Herramientas:"
for tool in molecule ansible-lint yamllint docker; do
    if command -v $tool >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $tool${NC}"
    else
        echo -e "${RED}❌ $tool NO encontrado${NC}"
    fi
done

# Verificar estructura
echo -e "\n📁 Estructura del proyecto:"
if [[ -f "roles/webserver/meta/main.yml" ]]; then
    echo -e "${GREEN}✅ Role webserver encontrado${NC}"
else
    echo -e "${RED}❌ Role webserver NO encontrado${NC}"
    echo "   ¿Estás en el directorio correcto?"
fi

if [[ -f "requirements.yml" ]]; then
    echo -e "${GREEN}✅ requirements.yml encontrado${NC}"
else
    echo -e "${RED}❌ requirements.yml NO encontrado${NC}"
fi

# Verificar Docker
echo -e "\n🐳 Docker:"
if docker ps >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker funcionando${NC}"
else
    echo -e "${RED}❌ Docker NO funciona${NC}"
    echo "   Posibles soluciones:"
    echo "   - sudo systemctl start docker"
    echo "   - sudo usermod -aG docker \$USER && newgrp docker"
fi

echo -e "\n📋 Próximo paso:"
if [[ "$VIRTUAL_ENV" != "" ]] && command -v molecule >/dev/null 2>&1; then
    echo -e "${GREEN}🎉 ¡Listo para crear archivos Molecule!${NC}"
else
    echo -e "${YELLOW}⚠️  Completar setup primero${NC}"
fi