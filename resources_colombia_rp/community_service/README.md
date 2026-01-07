# SISTEMA DE TRABAJO COMUNITARIO

Sistema de sanciones comunitarias optimizado para MTA:SA

## Instalación

### 1. Base de Datos
✅ **YA IMPORTADO** - La tabla `community_service` ya existe en tu base de datos

### 2. Configuración
1. Copiar carpeta `community_service` a recursos de MTA
2. Añadir a `mtaserver.conf`:
```xml
<resource src="community_service" startup="1" />
```

### 3. Dependencias
- `sql` (conexiones MySQL) - **OBLIGATORIO**
- `players` (gestión de jugadores) - **OBLIGATORIO**

## Comandos

### Staff:
- `/comunitaria <jugador> <basuras> <razón>` - Asignar trabajo comunitario
- `/vercomunitaria [jugador]` - Verificar estado
- `/restaurarcomunitaria <jugador>` - Restaurar sanción (anti-evasión)
- `/listarcomunitarias` - Ver todas las sanciones activas

### Jugadores:
- `/togglehud` - Activar/desactivar interfaz
- **Tecla F** - Recoger basura

## Funcionamiento

1. **Asignación**: Staff asigna trabajo comunitario
2. **Teletransporte**: Jugador va automáticamente a zona de trabajo
3. **Recolección**: Buscar bolsas de basura y presionar F (5 segundos por basura)
4. **Progreso**: HUD muestra progreso en tiempo real
5. **Zona**: No salir del área marcada (penalización +2 basuras)
6. **Finalización**: Al completar, permanece donde terminó (sin TP ni cambio de skin)

## Zona de Trabajo

- **Centro**: 1477.89, -1659.09, 13.54
- **Radio**: 70 metros
- **Posiciones**: 12 ubicaciones fijas para bolsas de basura

## Anti-Evasión

El sistema es **100% anti-evasión**:
- Base de datos preservada siempre
- Restauración automática al reconectar
- Sistema de backup cada 60 segundos
- Herramientas de detección para staff

## Interfaz

- **HUD Principal**: Centrado en parte inferior, responsive
- **Barra de Progreso**: Pequeña barra al lado del personaje durante recolección
- **Compatible**: Todas las resoluciones (720p a 4K)

## Exports Disponibles

```lua
-- Asignar desde otro recurso
exports.community_service:assignCommunityService(player, cantidad, razon, staff)

-- Verificar estado
local estado = exports.community_service:getCommunityServiceStatus(player)

-- Verificar si está en servicio
local enServicio = exports.community_service:isPlayerInCommunityService(player)

-- Añadir basuras
exports.community_service:addTrashToPlayer(player, cantidad)

-- Completar manualmente
exports.community_service:completeCommunityService(player)
```

## Soporte

Sistema completamente optimizado y libre de bugs.
Versión de producción sin elementos de debug.
Rendimiento maximizado para servidores grandes.
