# Sistema de Asalto al Barco

## Descripción
Este recurso implementa un sistema de asalto a un barco donde los jugadores pueden hackear un sistema para obtener recompensas (armas y cargadores). El sistema requiere la presencia de facciones ilegales y policía para funcionar correctamente.

## Inicio Rápido

### Configuración Básica (3 pasos)

1. **Crear el interior del barco:**
   ```
   /createinterior barco 0 0 Barco Asalto
   ```
   (Ejecuta esto en la posición X: 358.97, Y: 2548.63, Z: 24.54)

2. **Obtener el ID del interior creado:**
   - Entra al interior creado
   - Ejecuta: `/getinterior`
   - Anota el ID que aparece (ejemplo: ID 5)

3. **Actualizar `config.lua`:**
   - Abre `resources/[Fabrica-Armas]/asaltobarco/config.lua`
   - Cambia `dimension = 14` por `dimension = [ID_QUE_OBTUVISTE]`
   - Ejemplo: `dimension = 5`
   - Reinicia el recurso: `/restart asaltobarco`

¡Listo! El sistema debería funcionar correctamente.

## Configuración de Interiores

### Paso 1: Verificar la posición del marker
El marker está configurado en `config.lua` con las siguientes coordenadas:
- **Posición exterior**: X: 358.97, Y: 2548.63, Z: 24.54
- **Interior**: 10
- **Dimension**: 14

### Paso 2: Crear el interior del barco

**¡IMPORTANTE!** Ya existe un interior llamado `barco` en `interiorpositions.lua` (línea 187) con coordenadas:
- X: 420.69, Y: 2548.97, Z: 33.87, Interior: 10

#### Opción A: Usar el interior existente "barco" (RECOMENDADO)
1. Ve a la posición del marker en el juego (X: 358.97, Y: 2548.63, Z: 24.54)
2. Ejecuta el comando:
   ```
   /createinterior barco 0 0 Barco Asalto
   ```
   Esto creará el interior usando las coordenadas del interior `barco` definido en `interiorpositions.lua`.

#### Opción B: Usar otro interior existente
Si prefieres usar otro interior de `interiorpositions.lua`:

1. Ve a la posición del marker en el juego (X: 358.97, Y: 2548.63, Z: 24.54)
2. Ejecuta el comando:
   ```
   /createinterior [id_interior] [precio] [tipo] [Nombre del Barco]
   ```
   Ejemplo:
   ```
   /createinterior barco1 0 0 Barco Asalto
   ```
   - `[id_interior]`: ID del interior desde `interiorpositions.lua` (ej: `barco`, `ship1`, etc.)
   - `[precio]`: 0 (ya que no es comprable)
   - `[tipo]`: 0 (genérico)
   - `[Nombre del Barco]`: Nombre que aparecerá en el sistema

#### Opción C: Agregar un nuevo interior al sistema
Si necesitas agregar un nuevo interior para el barco (no recomendado, ya existe `barco`):

1. Abre `resources/interiors/interiorpositions.lua`
2. Agrega una nueva entrada en la tabla `interiorPositions` (antes de la línea 194 que cierra la tabla):
   ```lua
   barcoasalto = { 
       x = [coordenada_x_del_interior], 
       y = [coordenada_y_del_interior], 
       z = [coordenada_z_del_interior], 
       interior = [numero_de_interior], 
       price = 0 
   },
   ```
   Ejemplo (usando las coordenadas del marker):
   ```lua
   barcoasalto = { 
       x = 358.97, 
       y = 2548.63, 
       z = 24.54, 
       interior = 10, 
       price = 0 
   },
   ```
3. Reinicia el recurso `interiors`:
   ```
   restart interiors
   ```
4. Crea el interior usando el comando:
   ```
   /createinterior barcoasalto 0 0 Barco Asalto
   ```

### Paso 3: Configurar la dimensión del interior
El marker está configurado para usar la dimensión 14. Asegúrate de que:

1. **Después de crear el interior**, verifica su ID ejecutando:
   ```
   /getinterior
   ```
   (debes estar dentro del interior creado)

2. **Importante**: El interior creado tendrá un ID único (por ejemplo, ID 1, 2, 3, etc.). Este ID será la dimensión del interior.

3. **Actualiza `config.lua`** con el ID del interior creado:
   ```lua
   MARKER = {
       x = 358.97247314453,
       y = 2548.6342773438,
       z = 24.542186737061,
       interior = 10,
       dimension = [ID_DEL_INTERIOR_CREADO],  -- Cambia esto por el ID del interior que creaste
       color = {r = 255, g = 0, b = 0, a = 100}
   },
   ```
   Ejemplo: Si creaste el interior y tiene ID 5, cambia `dimension = 14` a `dimension = 5`

4. Reinicia el recurso:
   ```
   restart asaltobarco
   ```

### Paso 4: Verificar que el marker esté en el lugar correcto
1. Ve a la posición del marker (X: 358.97, Y: 2548.63, Z: 24.54)
2. Deberías ver un marker rojo
3. Si no lo ves, verifica que:
   - El recurso esté iniciado: `/start asaltobarco`
   - Las coordenadas en `config.lua` sean correctas
   - El interior y la dimensión coincidan

## Configuración del Sistema

### Facciones
En `config.lua` puedes configurar qué facciones pueden participar:

```lua
FACCIONES = {
    ILEGALES = {5, 10, 11, 12},  -- IDs de facciones ilegales
    POLICIA = 1,                  -- ID de la facción policial
    EJERCITO = 4,                 -- ID de la facción del ejército
    MIN_POLICIAS = 3,             -- Mínimo de policías requeridos
    MIN_ILEGALES = 3              -- Mínimo de ilegales requeridos
}
```

**Para encontrar los IDs de las facciones:**
1. Ejecuta `/factions` en el juego
2. O revisa la base de datos en la tabla `factions`

### Items Requeridos
Los items necesarios para el hackeo están configurados en:

```lua
ITEMS = {
    PORTATIL = {id = 91, nombre = "Portátil de Hackeo"},
    USB = {id = 92, nombre = "USB de Hackeo"}
}
```

**Asegúrate de que estos items existan en tu sistema de items.**

### Tiempos
Puedes ajustar los tiempos del sistema:

```lua
TIEMPOS = {
    HACKEO = 180000,      -- Tiempo de hackeo (3 minutos en milisegundos)
    COOLDOWN = 2100000,   -- Tiempo de espera entre asaltos (35 minutos)
    SONIDO_DURACION = 11000  -- Duración del sonido (11 segundos)
}
```

### Recompensas
Las recompensas se configuran en:

```lua
RECOMPENSAS = {
    ARMAS = {
        {id = 29, data = "30", nombre = "Ak-47", cantidad = 5},
        -- Agrega más armas aquí
    },
    CARGADORES = {
        {id = 43, data = "22", nombre = "Cargador Colt-45", balas = 12, cantidad = 3},
        -- Agrega más cargadores aquí
    }
}
```

**Nota:** Los IDs y data deben coincidir con tu sistema de items.

## Comandos Útiles

### Para administradores:
- `/createinterior [id] [precio] [tipo] [nombre]` - Crear un nuevo interior
- `/getinterior` - Ver información del interior actual
- `/setinterior [id]` - Cambiar el interior actual (debes estar dentro)
- `/setinteriorinside` - Establecer la posición interior actual como interior
- `/nearbyints` - Ver interiores cercanos

### Para verificar la configuración:
- `/gotointerior [id]` - Ir a un interior específico
- `/getpos` - Obtener tu posición actual (útil para configurar coordenadas)

## Solución de Problemas

### El marker no aparece
1. Verifica que el recurso esté iniciado: `/start asaltobarco`
2. Verifica las coordenadas en `config.lua`
3. Asegúrate de estar en el interior y dimensión correctos

### El hackeo no funciona
1. Verifica que los items requeridos existan en tu sistema
2. Verifica que las facciones estén correctamente configuradas
3. Asegúrate de que haya suficientes jugadores de cada facción conectados

### El interior no se crea
1. Verifica que tengas permisos de administrador
2. Verifica que el ID del interior exista en `interiorpositions.lua`
3. Revisa los logs del servidor para errores

## Estructura de Archivos

```
asaltobarco/
├── meta.xml              # Configuración del recurso
├── config.lua            # Configuración principal (EDITAR AQUÍ)
├── asalto_barco.luac     # Script del servidor (compilado)
├── asalto_barco_c.luac   # Script del cliente (compilado)
├── sonidos/
│   └── hackeo.mp3        # Sonido del hackeo
└── README.md             # Este archivo
```

## Notas Importantes

1. **Los archivos `.luac` están compilados**: No puedes editarlos directamente. Si necesitas modificar la lógica, necesitarás los archivos `.lua` originales.

2. **Dimensiones**: El sistema usa la dimensión 14 para el marker. Asegúrate de que no haya conflictos con otros recursos.

3. **Interiores**: El interior 10 está configurado por defecto. Puedes cambiarlo en `config.lua` si es necesario.

4. **Items**: Los IDs de items (91 y 92) deben existir en tu sistema de items. Si usas IDs diferentes, actualiza `config.lua`.

## Soporte

Si tienes problemas con la configuración:
1. Revisa los logs del servidor: `mtaserver.conf` → `logfile`
2. Verifica que todos los recursos dependientes estén iniciados
3. Asegúrate de tener los permisos necesarios para crear interiores
