#!/bin/bash

# Función para verificar si Go está instalado y, si no lo está, instalarlo
install_go() {
    if ! command -v go &>/dev/null; then
        echo "Go no está instalado. Instalando la última versión..."
        # Instalar Go
        sudo apt-get update
        sudo apt-get install -y golang
        echo "Go se ha instalado correctamente."
    else
        echo "Go ya está instalado."
    fi
}

# Función para verificar si pip3 está instalado y, si no lo está, instalarlo
install_pip3() {
    if ! command -v pip3 &>/dev/null; then
        echo "pip3 no está instalado. Instalando pip3..."
        # Instalar pip3
        sudo apt-get update
        sudo apt-get install -y python3-pip
        echo "pip3 se ha instalado correctamente."
    else
        echo "pip3 ya está instalado."
    fi
}

# Función para leer el archivo de configuración y realizar las instalaciones
install_tools_from_config() {
    # Lee el archivo de configuración línea por línea
    while IFS='=' read -r tool command url; do
        # Verifica si la línea no está vacía y no es un comentario
        if [[ ! -z "$tool" && ! "$tool" =~ ^\s*# ]]; then
            echo "Instalando $tool desde $url..."
            # Ejecuta el comando de instalación
            $command
            if [ $? -eq 0 ]; then
                echo "$tool se ha instalado correctamente."
            else
                echo "Error al instalar $tool."
            fi
        fi
    done < "tools.conf"  # Cambia "tools.conf" por el nombre de tu archivo de configuración
}

# Llamadas a las funciones
install_go
install_pip3
install_tools_from_config
