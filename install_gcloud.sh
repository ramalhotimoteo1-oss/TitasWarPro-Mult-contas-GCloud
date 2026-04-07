#!/bin/sh
# install_gcloud.sh — Instala dependências do TWM no Google Cloud (Debian/Ubuntu)
# Execute uma vez antes de rodar o bot

set -e

printf "=== TWM — Instalação Google Cloud ===\n\n"

# Verifica se é root ou tem sudo
if [ "$(id -u)" = "0" ]; then
    SUDO=""
else
    SUDO="sudo"
fi

printf "[1/3] Atualizando pacotes...\n"
$SUDO apt-get update -y -q

printf "[2/3] Instalando dependências...\n"
$SUDO apt-get install -y -q \
    curl \
    wget \
    git \
    screen \
    tmux \
    dos2unix \
    grep \
    sed \
    coreutils \
    openssl \
    ca-certificates

printf "[3/3] Verificando curl...\n"
curl --version | head -1

printf "\n=== Instalação concluída! ===\n"
printf "Próximo passo: execute  ./setup.sh  para cadastrar suas contas.\n"
printf "Depois rode:   screen -S twm ./play.sh\n\n"
