addEvent("createSmokeEffect", true)
addEventHandler("createSmokeEffect", root, function(x, y, z)
    createEffect("smoke30lit", x, y, z)
end)

-- Tabla para almacenar los efectos de fuego activos
local efectosFuego = {}

addEvent("createFireEffect", true)
addEventHandler("createFireEffect", root, function(x, y, z, id)
    -- Si ya existe un efecto en esta posición, eliminarlo
    if efectosFuego[id] and isElement(efectosFuego[id]) then
        destroyElement(efectosFuego[id])
    end
    
    -- Crear el nuevo efecto de fuego
    local efecto = createEffect("fire", x, y, z)
    efectosFuego[id] = efecto
end)

addEvent("eliminarFireEffect", true)
addEventHandler("eliminarFireEffect", root, function(id)
    if efectosFuego[id] and isElement(efectosFuego[id]) then
        destroyElement(efectosFuego[id])
        efectosFuego[id] = nil
    end
end)

-- Tabla para almacenar los temporizadores activos
local temporizadoresActivos = {}

-- Función para formatear el tiempo en MM:SS
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-- Evento para mostrar un temporizador avanzado
addEvent("mostrarTemporizadorAvanzado", true)
addEventHandler("mostrarTemporizadorAvanzado", root, function(x, y, z, tiempoTotal)
    -- Crear un identificador único para este temporizador basado en su posición
    local id = tostring(x) .. "_" .. tostring(y) .. "_" .. tostring(z)
    
    -- Si ya existe un temporizador en esta posición, eliminarlo
    if temporizadoresActivos[id] then
        if isElement(temporizadoresActivos[id].texto) then
            destroyElement(temporizadoresActivos[id].texto)
        end
        if isTimer(temporizadoresActivos[id].timer) then
            killTimer(temporizadoresActivos[id].timer)
        end
    end
    
    -- Crear el texto 3D con estilo avanzado
    local texto = createElement("text")
    setElementPosition(texto, x, y, z)
    
    -- Configurar el estilo visual del texto con contornos más visibles
    setElementData(texto, "scale", 4.0)  -- Tamaño más grande
    setElementData(texto, "color", {0, 255, 255, 255})  -- Color cian brillante
    setElementData(texto, "outline", true)  -- Activar contorno
    setElementData(texto, "outlineColor", {0, 0, 0, 255})  -- Contorno negro
    setElementData(texto, "shadow", {4, 4, 0, 0, 0, 255})  -- Sombra más pronunciada
    setElementData(texto, "font", "pricedown")  -- Fuente más estilizada y visible
    
    -- Crear un segundo texto para el efecto de doble contorno
    local textoContorno = createElement("text")
    setElementPosition(textoContorno, x, y, z)
    setElementData(textoContorno, "scale", 4.2)  -- Ligeramente más grande que el texto principal
    setElementData(textoContorno, "color", {0, 0, 0, 200})  -- Negro semi-transparente
    setElementData(textoContorno, "outline", false)
    
    -- Inicializar el tiempo restante
    local tiempoRestante = tiempoTotal
    
    -- Actualizar el texto inicialmente
    local textoBase = "REPARACIÓN EN: "
    setElementData(texto, "text", textoBase .. formatTime(tiempoRestante))
    setElementData(textoContorno, "text", textoBase .. formatTime(tiempoRestante))
    
    -- Crear un timer para actualizar el texto cada segundo
    local timer = setTimer(function()
        tiempoRestante = tiempoRestante - 1
        if tiempoRestante > 0 then
            -- Actualizar el texto con el tiempo restante
            setElementData(texto, "text", textoBase .. formatTime(tiempoRestante))
            setElementData(textoContorno, "text", textoBase .. formatTime(tiempoRestante))
            
            -- Efecto de parpadeo y cambio de color para los últimos 30 segundos
            if tiempoRestante <= 30 then
                local pulso = math.sin(getTickCount() / 200) * 0.5 + 0.5
                local r = 255 * pulso
                local g = 255 * (1 - pulso)
                local b = 0
                setElementData(texto, "color", {r, g, b, 255})
                setElementData(texto, "scale", 4.0 + pulso * 0.5)  -- Efecto de pulsación
            end
        else
            -- Eliminar el temporizador cuando llegue a cero
            if isElement(texto) then
                destroyElement(texto)
            end
            if isElement(textoContorno) then
                destroyElement(textoContorno)
            end
            if isTimer(timer) then
                killTimer(timer)
            end
            temporizadoresActivos[id] = nil
        end
    end, 1000, 0)
    
    -- Guardar referencia al temporizador
    temporizadoresActivos[id] = {
        texto = texto,
        textoContorno = textoContorno,
        timer = timer
    }
end)

-- Evento para eliminar un temporizador específico
addEvent("eliminarTemporizador", true)
addEventHandler("eliminarTemporizador", root, function(x, y, z)
    local id = tostring(x) .. "_" .. tostring(y) .. "_" .. tostring(z)
    if temporizadoresActivos[id] then
        if isElement(temporizadoresActivos[id].texto) then
            destroyElement(temporizadoresActivos[id].texto)
        end
        if isElement(temporizadoresActivos[id].textoContorno) then
            destroyElement(temporizadoresActivos[id].textoContorno)
        end
        if isTimer(temporizadoresActivos[id].timer) then
            killTimer(temporizadoresActivos[id].timer)
        end
        temporizadoresActivos[id] = nil
    end
end) 