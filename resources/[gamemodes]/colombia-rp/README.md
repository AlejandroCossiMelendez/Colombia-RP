# Colombia RP - Gamemode Moderno

Gamemode completo para MTA:SA con sistema de login, personajes, inventario y necesidades, integrado con MySQL.

## Características

- ✅ Sistema de Login/Registro con MySQL
- ✅ Sistema de Personajes (crear, seleccionar, eliminar)
- ✅ Sistema de Inventario
- ✅ Sistema de Dinero
- ✅ Sistema de Necesidades (Hambre, Sed, Salud)
- ✅ Sistema de Spawn automático
- ✅ GUI moderna con navegador integrado
- ✅ HUD en tiempo real

## Requisitos

1. **MySQL/MariaDB** instalado y funcionando
2. **Base de datos** `mta_login` creada
3. **Tablas** creadas según el esquema proporcionado
4. **MTA Server** con soporte para MySQL

## Instalación

### 1. Configurar Base de Datos

Asegúrate de tener las siguientes tablas en tu base de datos `mta_login`:

```sql
-- Tabla users (ya debería existir)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registerDate DATETIME NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    INDEX idx_role (role)
);

-- Tabla characters (ya debería existir)
CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 18,
    gender INT NOT NULL DEFAULT 0,
    skin INT NOT NULL DEFAULT 0,
    money INT NOT NULL DEFAULT 5000,
    created DATETIME NOT NULL,
    posX FLOAT DEFAULT 1959.55,
    posY FLOAT DEFAULT -1714.46,
    posZ FLOAT DEFAULT 10,
    rotation FLOAT DEFAULT 0,
    interior INT DEFAULT 0,
    dimension INT DEFAULT 0,
    lastLogin DATETIME,
    hunger INT NOT NULL DEFAULT 100,
    thirst INT NOT NULL DEFAULT 100,
    health FLOAT DEFAULT 100,
    INDEX idx_username (username)
);

-- Tabla inventory (ya debería existir con esta estructura)
-- La tabla ya existe con la siguiente estructura:
-- id, character_id, slot, item_id, item_name, quantity, item_data
-- No es necesario crearla si ya existe
```

### 2. Configurar el Gamemode

Edita el archivo `server/config.lua` y ajusta las credenciales de MySQL:

```lua
Config.Database = {
    host = "127.0.0.1",
    port = 3306,
    database = "mta_login",
    username = "root",
    password = "tu_contraseña",  -- Cambiar aquí
    charset = "utf8"
}
```

### 3. Agregar al mtaserver.conf

Agrega el gamemode a tu `mtaserver.conf`:

```xml
<resource src="colombia-rp" startup="1" protected="0"/>
```

**Nota:** Asegúrate de comentar o eliminar la línea del gamemode `play` si quieres usar este como principal.

### 4. Iniciar el Servidor

1. Inicia tu servidor MTA
2. El gamemode se cargará automáticamente
3. Verifica en los logs que la conexión a MySQL sea exitosa

## Comandos Disponibles

- `/dinero` - Ver tu dinero actual
- `/dar [jugador] [cantidad]` - Dar dinero a otro jugador
- `/comer` - Comer (aumenta hambre)
- `/beber` - Beber (aumenta sed)
- `/respawn` - Reaparecer en tu última ubicación

## Estructura de Archivos

```
colombia-rp/
├── meta.xml                 # Configuración del recurso
├── server/
│   ├── config.lua          # Configuración del servidor
│   ├── database.lua        # Sistema de base de datos
│   ├── login.lua           # Sistema de login/registro
│   ├── characters.lua      # Sistema de personajes
│   ├── inventory.lua       # Sistema de inventario
│   ├── money.lua           # Sistema de dinero
│   ├── needs.lua           # Sistema de necesidades
│   ├── spawn.lua           # Sistema de spawn
│   └── main.lua            # Archivo principal del servidor
├── client/
│   ├── main.lua            # Archivo principal del cliente
│   ├── login_gui.lua       # GUI de login
│   ├── character_gui.lua   # GUI de personajes
│   ├── hud.lua             # HUD del juego
│   ├── login.html          # HTML de login
│   ├── character.html      # HTML de personajes
│   └── hud.html            # HTML del HUD
└── README.md               # Este archivo
```

## Características Técnicas

### Seguridad
- Contraseñas hasheadas (SHA256 con salt)
- Validación de datos en servidor
- Protección contra SQL injection (usando parámetros preparados)

### Rendimiento
- Guardado automático de posiciones cada 5 minutos
- Actualización de necesidades cada 60 segundos
- Consultas optimizadas con índices

### Personalización
- Configuración fácil en `server/config.lua`
- Máximo de personajes por usuario configurable
- Valores por defecto personalizables

## Solución de Problemas

### Error de conexión a MySQL
- Verifica que MySQL esté corriendo
- Revisa las credenciales en `server/config.lua`
- Asegúrate de que la base de datos `mta_login` exista

### El GUI no aparece
- Verifica que los archivos HTML estén en la carpeta `client/`
- Revisa los logs del servidor para errores
- Asegúrate de que el navegador esté habilitado en MTA

### Los personajes no se guardan
- Verifica que la tabla `characters` exista
- Revisa los permisos de la base de datos
- Comprueba los logs del servidor

## Notas Importantes

1. **Hash de Contraseñas**: El sistema actual usa SHA256 con salt. Para producción, se recomienda usar bcrypt (requiere módulo adicional).

2. **Navegador**: El sistema usa el navegador integrado de MTA. Asegúrate de que esté habilitado.

3. **MySQL Module**: Asegúrate de tener el módulo MySQL habilitado en tu servidor MTA.

## Soporte

Para problemas o preguntas, revisa los logs del servidor en `logs/server.log` y `logs/scripts.log`.

## Licencia

Este gamemode es de código abierto y puede ser modificado según tus necesidades.

