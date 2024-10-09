#!/bin/bash

# Función para crear usuario Samba
create_samba_user() {
    if ! id "$1" &>/dev/null; then
        sudo useradd "$1"
        echo "Usuario $1 creado"
    else
        echo "Usuario $1 ya existe"
    fi
    echo -e "$2\n$2" | sudo smbpasswd -a "$1" -s
    echo "Contraseña Samba establecida para $1"
}

# Función para crear grupo Samba
create_samba_group() {
    if ! getent group "$1" &>/dev/null; then
        sudo groupadd "$1"
        echo "Grupo Samba $1 creado"
    else
        echo "Grupo $1 ya existe"
    fi
}

# Función para añadir usuario a grupo
add_user_to_group() {
    if getent group "$2" &>/dev/null; then
        sudo usermod -aG "$2" "$1"
        echo "Usuario $1 añadido al grupo $2"
    else
        echo "Error: El grupo $2 no existe"
    fi
}

# Función para crear compartición Samba
create_samba_share() {
    local sharename=$1
    local path=$2
    sudo mkdir -p "$path"
    echo -e "\n[$sharename]\n  path = $path\n  read only = no\n  browsable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
    sudo systemctl restart smbd
    echo "Compartición Samba $sharename creada en $path"
}

# Bucle principal de operaciones
while true; do
    echo -e "\n--- Menú de Operaciones ---"
    echo "1: Crear usuario Samba"
    echo "2: Crear grupo Samba"
    echo "3: Añadir usuario a grupo"
    echo "4: Crear compartición"
    echo "5: Listar usuarios Samba"
    echo "6: Listar grupos"
    echo "7: Listar comparticiones"
    echo "8: Salir"
    
    read -p "Elige una operación (1-8): " operacion
    
    case $operacion in
        1)
            read -p "Nombre del nuevo usuario: " new_user
            read -s -p "Contraseña para el nuevo usuario: " new_password
            echo
            create_samba_user "$new_user" "$new_password"
            ;;
        2)
            read -p "Nombre del nuevo grupo: " new_group
            create_samba_group "$new_group"
            ;;
        3)
            read -p "Nombre de usuario: " user
            read -p "Nombre de grupo: " group
            add_user_to_group "$user" "$group"
            ;;
        4)
            read -p "Nombre de la compartición: " share_name
            read -p "Ruta de la compartición: " share_path
            create_samba_share "$share_name" "$share_path"
            ;;
        5)
            echo "Usuarios Samba:"
            sudo pdbedit -L | cut -d: -f1
            ;;
        6)
            echo "Grupos:"
            getent group | grep 'samba\|smb' || echo "No hay grupos específicos de Samba"
            ;;
        7)
            echo "Comparticiones:"
            grep "\[" /etc/samba/smb.conf | grep -v "\[global\]"
            ;;
        8)
            echo "Saliendo del script..."
            break
            ;;
        *)
            echo "Operación no válida"
            ;;
    esac
done

# Reiniciar el servicio Samba para aplicar todos los cambios
sudo systemctl restart smbd
echo "Servicio Samba reiniciado"
