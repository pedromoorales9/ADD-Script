# Script de Administración de Samba

## Autor
Pedro Miguel Morales Calderin

## Descripción
Este script bash proporciona una interfaz interactiva para la administración de Samba en sistemas Linux. Simplifica tareas comunes como la creación de usuarios, grupos y comparticiones Samba.

## Características

- Creación de usuarios Samba
- Creación de grupos Samba
- Gestión de usuarios y grupos
- Creación de comparticiones Samba
- Listado de usuarios, grupos y comparticiones

## Requisitos

- Sistema operativo Linux
- Samba instalado
- Permisos de superusuario (sudo)

## Instalación

1. Clone este repositorio:
   ```
   git clone https://github.com/tu-usuario/samba-admin-script.git
   ```
2. Navegue al directorio del script:
   ```
   cd samba-admin-script
   ```
3. Otorgue permisos de ejecución al script:
   ```
   chmod +x administracion_samba_pedro.sh
   ```

## Uso

Execute el script con privilegios de superusuario:

```
sudo ./administracion_samba_pedro.sh
```

Siga las instrucciones en pantalla para seleccionar las operaciones deseadas.

## Estructura del Script

- `crear_usuario_samba()`: Crea un nuevo usuario Samba
- `crear_grupo_samba()`: Crea un nuevo grupo Samba
- `añadir_usuario_a_grupo()`: Añade un usuario a un grupo existente
- `crear_comparticion_samba()`: Crea una nueva compartición Samba

## Menú de Operaciones

1. Crear usuario Samba
2. Crear grupo Samba
3. Añadir usuario a grupo
4. Crear compartición
5. Listar usuarios Samba
6. Listar grupos
7. Listar comparticiones
8. Salir

## Consideraciones de Seguridad

- Este script debe ejecutarse con privilegios de superusuario.
- Se recomienda su uso en entornos de prueba antes de aplicarlo en sistemas de producción.
- Para entornos de producción, considere implementar medidas de seguridad adicionales en el manejo de contraseñas.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abra un issue primero para discutir lo que le gustaría cambiar.

## Licencia

[MIT](https://choosealicense.com/licenses/mit/)

