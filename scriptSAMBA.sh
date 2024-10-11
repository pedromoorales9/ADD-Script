#!/bin/bash

# Función para crear usuario Samba
crear_usuario_samba() {
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
crear_grupo_samba() {
    if ! getent group "$1" &>/dev/null; then
        sudo groupadd "$1"
        echo "Grupo Samba $1 creado"
    else
        echo "Grupo $1 ya existe"
    fi
}

# Función para añadir usuario a grupo
añadir_usuario_a_grupo() {
    if getent group "$2" &>/dev/null; then
        sudo usermod -aG "$2" "$1"
        echo "Usuario $1 añadido al grupo $2"
    else
        echo "Error: El grupo $2 no existe"
    fi
}

# Función para crear compartición Samba
crear_comparticion_samba() {
    local nombre_comparticion=$1
    local ruta=$2
    sudo mkdir -p "$ruta"
    echo -e "\n[$nombre_comparticion]\n  path = $ruta\n  read only = no\n  browsable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
    sudo systemctl restart smbd
    echo "Compartición Samba $nombre_comparticion creada en $ruta"
}

# funcion para listar usuarios de un grupo
listar_usuarios_en_grupo() {
    local grupo=$1
    if getent group "$grupo" &>/dev/null; then
        echo "Usuarios en el grupo $grupo:"
        getent group "$grupo" | cut -d: -f4 | tr ',' '\n' | sort
    else
        echo "El grupo $grupo no existe"
    fi
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
    echo "8: Listar usuarios de un grupo"
    echo "9: Salir"
    
    read -p "Elige una operación (1-9): " operacion
    
    case $operacion in
        1)
            read -p "Nombre del nuevo usuario: " nuevo_usuario
            read -s -p "Contraseña para el nuevo usuario: " nueva_contraseña
            echo
            crear_usuario_samba "$nuevo_usuario" "$nueva_contraseña"
            ;;
        2)
            read -p "Nombre del nuevo grupo: " nuevo_grupo
            crear_grupo_samba "$nuevo_grupo"
            ;;
        3)
            read -p "Nombre de usuario: " usuario
            read -p "Nombre de grupo: " grupo
            añadir_usuario_a_grupo "$usuario" "$grupo"
            ;;
        4)
            read -p "Nombre de la compartición: " nombre_comparticion
            read -p "Ruta de la compartición: " ruta_comparticion
            crear_comparticion_samba "$nombre_comparticion" "$ruta_comparticion"
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
            read -p "Nombre del grupo: " nombre_grupo
            listar_usuarios_en_grupo "$nombre_grupo"
            ;;
        9)
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
