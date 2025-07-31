#!/bin/bash

echo "=== Instalação do Amazon Q CLI na instância EC2 ==="

# Remover arquivo incorreto
echo "1. Removendo arquivo incorreto..."
sudo rm -f /usr/local/bin/q

# Criar diretório temporário
echo "2. Criando diretório temporário..."
mkdir -p ~/tmp_q_install
cd ~/tmp_q_install

# Método 1: Download direto com wget
echo "3. Tentando download com wget..."
wget -O q "https://github.com/aws/amazon-q-developer-cli/releases/download/v1.12.3/q-linux-x64"

# Verificar se o download foi bem-sucedido
if [ -f "q" ] && [ $(stat -c%s "q") -gt 1000000 ]; then
    echo "✓ Download bem-sucedido!"
    echo "4. Instalando..."
    chmod +x q
    sudo mv q /usr/local/bin/
    echo "✓ Amazon Q CLI instalado!"
else
    echo "✗ Download falhou, tentando método alternativo..."
    rm -f q
    
    # Método 2: Usar curl com diferentes flags
    echo "5. Tentando com curl e flags diferentes..."
    curl -L --fail --show-error -o q "https://github.com/aws/amazon-q-developer-cli/releases/download/v1.12.3/q-linux-x64"
    
    if [ -f "q" ] && [ $(stat -c%s "q") -gt 1000000 ]; then
        echo "✓ Download alternativo bem-sucedido!"
        chmod +x q
        sudo mv q /usr/local/bin/
        echo "✓ Amazon Q CLI instalado!"
    else
        echo "✗ Todos os métodos de download falharam"
        echo "Tentando instalação via npm..."
        
        # Método 3: Via npm (se disponível)
        if command -v npm &> /dev/null; then
            sudo npm install -g @aws/amazon-q-developer-cli
        else
            echo "✗ npm não disponível"
            exit 1
        fi
    fi
fi

# Limpeza
cd ~
rm -rf ~/tmp_q_install

# Verificação final
echo "6. Verificando instalação..."
if command -v q &> /dev/null; then
    echo "✓ Amazon Q CLI instalado com sucesso!"
    echo "Versão: $(q --version)"
    echo ""
    echo "Para fazer login, execute:"
    echo "q login"
else
    echo "✗ Falha na instalação do Amazon Q CLI"
    exit 1
fi
