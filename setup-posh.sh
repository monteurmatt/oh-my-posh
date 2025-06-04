#!/bin/bash

set -e

curl -s https://ohmyposh.dev/install.sh | bash -s

echo "📥 Baixando fonte Hack Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -O Hack.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip"
unzip -o Hack.zip -d HackFont

echo "📂 Instalando 'Hack Nerd Font Regular'..."
cp "HackFont/HackNerdFont-Regular.ttf" ~/.local/share/fonts/
fc-cache -fv

echo "🧹 Limpando arquivos temporários..."
rm -rf Hack.zip HackFont

echo "🖥️ Tentando configurar fonte no terminal Gnome Terminal..."
if command -v gnome-terminal >/dev/null 2>&1; then
    dconf write /com/github/stunkymonkey/gnome-terminal/profiles/default/font "'Hack Nerd Font Regular 12'"
    echo "✅ Fonte configurada no gnome-terminal."
else
    echo "⚠️ Terminal gnome-terminal não encontrado. Pulei essa etapa."
fi

echo "📄 Garantindo que .bashrc existe..."
touch ~/.bashrc

echo "📁 Criando diretório .poshthemes..."
mkdir -p ~/.poshthemes

echo "📄 Adicionando configurações do Oh My Posh ao .bashrc..."
POSH_LINES='
eval "$(oh-my-posh init bash)"
eval "$(oh-my-posh init bash --config ~/.poshthemes/dark_atomic.json)"'

# Adiciona apenas se as linhas ainda não estiverem no arquivo
grep -qxF 'eval "$(oh-my-posh init bash)"' ~/.bashrc || echo "$POSH_LINES" >> ~/.bashrc

echo "🌐 Baixando tema dark_atomic.json..."
wget -O ~/.poshthemes/dark_atomic.json "https://raw.githubusercontent.com/monteurmatt/oh-my-posh/main/dark-atomic.json"

echo "✅ Finalizado! Reinicie o terminal para aplicar as mudanças."
