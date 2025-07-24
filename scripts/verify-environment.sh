#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Verificación completa del entorno Molecule${NC}\n"

# Entorno virtual
echo -e "${YELLOW}🐍 Python y entorno virtual:${NC}"
echo "   Entorno activo: ${VIRTUAL_ENV:-'❌ No activo'}"
echo "   Python: $(python --version)"
echo "   Ubicación: $(which python)"
echo ""

# Herramientas instaladas
echo -e "${YELLOW}🧪 Herramientas instaladas:${NC}"
for tool in molecule ansible-lint yamllint docker; do
    if command -v $tool >/dev/null 2>&1; then
        version=$($tool --version 2>/dev/null | head -1 || echo "Instalado")
        echo -e "   ${GREEN}✅ $tool${NC}: $version"
    else
        echo -e "   ${RED}❌ $tool${NC}: No encontrado"
    fi
done
echo ""

# Python packages
echo -e "${YELLOW}📦 Paquetes Python relevantes:${NC}"
pip list | grep -E "(molecule|docker|ansible)" | while read line; do
    echo "   $line"
done
echo ""

# Docker
echo -e "${YELLOW}🐳 Docker:${NC}"
echo "   Engine: $(docker --version)"
if docker ps >/dev/null 2>&1; then
    echo -e "   ${GREEN}✅ Daemon funcionando${NC}"
    echo "   Contenedores activos: $(docker ps | wc -l) (incluyendo header)"
else
    echo -e "   ${RED}❌ Daemon no funcionando o sin permisos${NC}"
fi
echo ""

# Test de conectividad Docker Python
echo -e "${YELLOW}🔗 Conectividad Docker Python:${NC}"
python -c "
try:
    import docker
    client = docker.from_env()
    info = client.version()
    print(f'   ✅ Docker API: {info[\"ApiVersion\"]}')
    print(f'   ✅ Docker Version: {info[\"Version\"]}')
except Exception as e:
    print(f'   ❌ Error: {e}')
" 2>/dev/null
echo ""

# Estructura del proyecto
echo -e "${YELLOW}📁 Estructura del proyecto:${NC}"
if [[ -f "meta/main.yml" ]]; then
    echo -e "   ${GREEN}✅ En directorio del role${NC}"
elif [[ -f "roles/webserver/meta/main.yml" ]]; then
    echo -e "   ${GREEN}✅ En directorio raíz del proyecto${NC}"
else
    echo -e "   ${RED}❌ Ubicación incorrecta${NC}"
fi

if [[ -f "molecule/default/molecule.yml" ]]; then
    echo -e "   ${GREEN}✅ Configuración Molecule encontrada${NC}"
else
    echo -e "   ${RED}❌ Configuración Molecule NO encontrada${NC}"
fi
echo ""

# Molecule escenarios
echo -e "${YELLOW}🎭 Escenarios Molecule:${NC}"
if command -v molecule >/dev/null 2>&1; then
    molecule list 2>/dev/null | tail -n +2 | while read line; do
        echo "   $line"
    done
else
    echo "   ❌ Molecule no disponible"
fi
echo ""

# Limpieza de contenedores anteriores
echo -e "${YELLOW}🧹 Contenedores Molecule anteriores:${NC}"
molecule_containers=$(docker ps -a | grep molecule | wc -l)
if [[ $molecule_containers -gt 0 ]]; then
    echo -e "   ${YELLOW}⚠️  $molecule_containers contenedores molecule encontrados${NC}"
    echo "   Limpiar con: docker rm -f \$(docker ps -a | grep molecule | awk '{print \$1}')"
else
    echo -e "   ${GREEN}✅ No hay contenedores molecule anteriores${NC}"
fi
echo ""

echo -e "${BLUE}📋 Resumen:${NC}"
if [[ "$VIRTUAL_ENV" != "" ]] && command -v molecule >/dev/null 2>&1; then
    echo -e "${GREEN}🎉 Entorno listo para Molecule testing!${NC}"
    echo ""
    echo "Próximos pasos:"
    echo "1. molecule test -s default"
    echo "2. Si falla, revisar logs y ajustar configuración"
else
    echo -e "${RED}❌ Entorno necesita configuración${NC}"
    echo ""
    echo "Pasos faltantes:"
    [[ "$VIRTUAL_ENV" == "" ]] && echo "- Activar entorno virtual: source molecule-env/bin/activate"
    ! command -v molecule >/dev/null 2>&1 && echo "- Instalar Molecule: pip install 'molecule[docker]'"
fi