#!/bin/bash

# Función para agregar un directorio al PATH si no está presente y existe
add_to_path_if_not_exists() {
    local dir=$1
    if [[ -d "$dir" ]]; then
        echo "Agregando $dir al PATH en ~/.zshrc..."
        # Agregar export al archivo .zshrc si no está presente
        if ! grep -qE "export PATH=.*$dir.*" ~/.zshrc; then
            echo "export PATH=\$PATH:$dir" >> ~/.zshrc
        fi
    fi
}

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

# Función para verificar si una herramienta está instalada
tool_is_installed() {
    local tool_name=$1
    if command -v "$tool_name" &>/dev/null; then
        echo "$tool_name ya está instalado."
        return 0  # Éxito
    else
        echo "$tool_name no está instalado."
        return 1  # Error
    fi
}

# Función para leer el archivo de configuración y realizar las instalaciones
install_tools_from_config() {
    local config_file="tools.conf"
    # Lee el archivo de configuración línea por línea
    while IFS='=' read -r tool command url; do
        # Verifica si la línea no está vacía y no es un comentario
        if [[ ! -z "$tool" && ! "$tool" =~ ^\s*# ]]; then
            # Verifica si la herramienta ya está instalada
            if tool_is_installed "$tool"; then
                continue  # Salta a la próxima herramienta
            fi
            
            echo "Instalando $tool desde $url..."
            # Ejecuta el comando de instalación
            $command
            if [ $? -eq 0 ]; then
                echo "$tool se ha instalado correctamente."
            else
                echo "Error al instalar $tool."
            fi
        fi
    done < "$config_file"
}

# Llamadas a las funciones
install_go
install_pip3
sudo bash -c 'add_to_path_if_not_exists "$HOME/go/bin"'
install_tools_from_config
