#!/bin/bash

cmdn=">/dev/null 2>&1"

check(){
    eval "command -v $1 $cmdn" || { echo "Instalando $1..."; eval "apt install $1 -y $cmdn"; }
}

formatPath(){
    sed -i '/export PATH="\$PATH:\/root\/.local\/bin"/d' ~/.bashrc
}

formatTheme(){
    sed -i '/oh-my-posh init bash/d' ~/.bashrc
}


case "$1" in
  "")
    check unzip &&  check curl
    eval "command -v oh-my-posh $cmdn" || curl -s https://ohmyposh.dev/install.sh | bash -s &&
    echo "Se ha instalado oh-my-nya..." &&
    formatPath &&
    echo 'export PATH="$PATH:/root/.local/bin"' >> ~/.bashrc &&
    echo 'eval "$(oh-my-posh init bash --config /root/.cache/oh-my-posh/themes/atomic.omp.json)"' >> ~/.bashrc &&
    source ~/.bashrc
    echo ". ~/.bashrc"
    cp "$0" /usr/bin/ohmynya
    chmod +x /usr/bin/ohmynya
    ;;
  themes)
    ls -1 ~/.cache/oh-my-posh/themes | sed 's/\.omp\..*//' | nl -w1 -s'. '
    ;;
  install)
    echo "instalado tema $2:"
    pkg=$(ls -1 ~/.cache/oh-my-posh/themes | sed -n "${2}p")

    if [ -z "$pkg" ]; then
      echo "Selecciona una opcion valida"
    else
      formatTheme
      echo "$pkg" | sed 's/\.omp\..*//'
      echo "eval \"\$(oh-my-posh init bash --config /root/.cache/oh-my-posh/themes/$pkg)\"" >> ~/.bashrc
      source ~/.bashrc
    fi
    ;;
  *)
    echo "Comando no reconocido"
    ;;
esac
