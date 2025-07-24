#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔧 Solucionando compatibilidad Docker + Molecule...${NC}\n"

# Verificar que estamos en entorno virtual
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo -e "${RED}❌ Entorno virtual no está activo${NC}"
    echo "Ejecuta: source molecule-env/bin/activate"
    exit 1
fi

# Verificar Docker daemon
echo "🐳 Verificando Docker daemon..."
if ! docker ps >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker daemon no está corriendo o faltan permisos${NC}"
    echo ""
    echo "Soluciones:"
    echo "1. Iniciar daemon: sudo systemctl start docker"
    echo "2. Agregar permisos: sudo usermod -aG docker \$USER && newgrp docker"
    exit 1
fi

echo -e "${GREEN}✅ Docker daemon funcionando${NC}"

# Mostrar versiones actuales
echo -e "\n📊 Versiones actuales:"
echo "Docker engine: $(docker --version)"
echo "Docker Python SDK: $(pip show docker | grep Version || echo 'No instalado')"

# Downgrade Docker Python SDK
echo -e "\n📦 Instalando Docker Python SDK compatible..."
pip uninstall -y docker || true
pip install docker==6.1.3

# Verificar otras dependencias
echo -e "\n🔄 Verificando dependencias..."
pip install --upgrade requests==2.31.0 urllib3==2.0.7

# Test rápido
echo -e "\n🧪 Testing básico..."
python -c "
import docker
client = docker.from_env()
print('✅ Docker Python SDK funcionando')
print(f'Docker API version: {client.api.version()[\"ApiVersion\"]}')
"

echo -e "\n${GREEN}🎉 Compatibilidad Docker + Molecule solucionada!${NC}"
echo -e "\nPróximo paso:"
echo -e "${YELLOW}molecule test -s default${NC}"
