# Configuración del Sistema de Login con MySQL

## Requisitos Previos

1. **Servidor MySQL** instalado y funcionando
2. **Base de datos MySQL** creada (o usar la que se crea automáticamente)
3. **Usuario MySQL** con permisos para crear tablas

## Pasos de Configuración

### 1. Configurar MySQL en server.lua

Abre el archivo `resources/login/server.lua` y modifica estas líneas según tu configuración:

```lua
local MYSQL_HOST = "localhost"      -- IP o hostname del servidor MySQL
local MYSQL_USER = "root"           -- Usuario de MySQL
local MYSQL_PASS = ""               -- Contraseña de MySQL
local MYSQL_DB = "mta_login"        -- Nombre de la base de datos
local MYSQL_PORT = 3306             -- Puerto de MySQL (default: 3306)
```

### 2. Crear la Base de Datos (Opcional)

Puedes crear la base de datos manualmente ejecutando el script `database.sql`:

```bash
mysql -u root -p < database.sql
```

O el sistema la creará automáticamente si tienes permisos (aunque es mejor crearla manualmente).

### 3. Verificar Permisos del Usuario MySQL

Asegúrate de que el usuario MySQL tenga permisos para:
- CREATE DATABASE (si quieres que se cree automáticamente)
- CREATE TABLE
- INSERT, UPDATE, SELECT, DELETE

```sql
GRANT ALL PRIVILEGES ON mta_login.* TO 'tu_usuario'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Iniciar el Recurso

Una vez configurado, inicia el recurso:

```
start login
```

O reinicia el servidor completo.

## Características Implementadas

✅ **Sistema de Login/Registro** con MySQL
✅ **Panel de Selección de Personajes** después del login
✅ **Guardado Automático de Posición** cada 30 segundos
✅ **Spawn en Última Posición** al seleccionar personaje
✅ **Máximo 3 personajes** por cuenta
✅ **Guardado al desconectarse** automáticamente

## Flujo del Sistema

1. **Jugador se conecta** → Panel de Login aparece automáticamente
2. **Login exitoso** → Panel de Selección de Personajes
3. **Selecciona personaje** → Spawn en última posición guardada
4. **Durante el juego** → Posición se guarda cada 30 segundos
5. **Al desconectarse** → Posición final se guarda automáticamente

## Comandos Disponibles

- `/changechar` - Cambiar de personaje (guarda posición actual antes de cambiar)

## Solución de Problemas

### Error: "No se pudo conectar a la base de datos MySQL"

- Verifica que MySQL esté corriendo
- Verifica las credenciales en `server.lua`
- Verifica que el usuario tenga permisos
- Verifica que el puerto sea correcto

### Error: "Access denied"

- Verifica usuario y contraseña
- Verifica permisos del usuario MySQL
- Verifica que el host sea correcto (localhost o IP)

### Los personajes no se guardan

- Verifica que las tablas se hayan creado correctamente
- Revisa los logs del servidor para errores SQL
- Verifica permisos de INSERT/UPDATE en la base de datos

