#!/bin/bash

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
