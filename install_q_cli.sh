#!/bin/bash

echo "Removendo arquivo incorreto..."
sudo rm -f /usr/local/bin/q

echo "Baixando Amazon Q CLI corretamente..."
# Método 1: Tentar download direto do GitHub
curl -L -o q "https://github.com/aws/amazon-q-developer-cli/releases/latest/download/q-linux-x64"

# Verificar se o download foi bem-sucedido
if [ -f "q" ] && [ $(stat -c%s "q") -gt 1000 ]; then
    echo "Download bem-sucedido via GitHub"
    chmod +x q
    sudo mv q /usr/local/bin/
else
    echo "Download via GitHub falhou, tentando método alternativo..."
    rm -f q
    
    # Método 2: Usar o instalador oficial
    curl -sSL https://aws-q-developer-cli-install.s3.amazonaws.com/install.sh | bash
    
    # Se ainda não funcionar, tentar download direto da versão específica
    if ! command -v q &> /dev/null; then
        echo "Tentando download da versão específica..."
        wget -O q "https://github.com/aws/amazon-q-developer-cli/releases/download/v1.12.3/q-linux-x64"
        if [ -f "q" ] && [ $(stat -c%s "q") -gt 1000 ]; then
            chmod +x q
            sudo mv q /usr/local/bin/
        fi
    fi
fi

echo "Verificando instalação..."
if command -v q &> /dev/null; then
    echo "Amazon Q CLI instalado com sucesso!"
    q --version
else
    echo "Falha na instalação do Amazon Q CLI"
    exit 1
fi
