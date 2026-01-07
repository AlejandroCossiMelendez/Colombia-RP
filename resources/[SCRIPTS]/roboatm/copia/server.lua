local OBJETO_ID_ESPECIFICO = 2942
local DISTANCIA_MAXIMA = 1
local TIEMPO_ENTRE_ROBOS = 10 * 60 * 1000  -- 10 minutos
local TIEMPO_REPARACION_CAJERO = 10 * 60 * 1000  -- 10 minutos para que el cajero se repare

local ultimoRobo = {}
local cajerosRobados = {}
local cajerosDanados = {}

-- Función para obtener el número de policías y militares en línea
local function getPoliciasYMilitares()
    local n = 0
    for _, v in ipairs(getElementsByType("player")) do
        -- Facción 1 (policía) y facción 10 (ejército/militar)
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 10) then
            n = n + 1
        end
    end
    return n
end

-- Función para crear una alerta para policías y militares
local function alertarAutoridades(x, y, z)
    -- Crear blips para las facciones de policía (1) y militar (10)
    exports.factions:createFactionBlip2(x, y, z, 1)  -- Blip para la facción de policía
    exports.factions:createFactionBlip2(x, y, z, 10)  -- Blip para la facción militar
    
    -- Enviar mensaje de alerta a todos los jugadores de las facciones correspondientes
    for _, player in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 10) then
            outputChatBox("[ALERTA] Se reporta un robo de cajero automático en curso. ¡Acuda inmediatamente!", player, 200, 255, 18)
            exports._infobox:addNotification(player, "Robo de cajero en progreso. Ubicación marcada en el mapa.", "warning")
        end
    end
end

-- Función para dañar visualmente el cajero
local function danarCajero(cajero)
    -- Guardar el estado original del cajero
    local originalX, originalY, originalZ = getElementPosition(cajero)
    local originalRX, originalRY, originalRZ = getElementRotation(cajero)
    
    -- Crear un identificador único para este cajero
    local cajeroID = tostring(cajero)
    
    -- Marcar el cajero como robado
    cajerosRobados[cajero] = getTickCount()
    
    -- Almacenar información detallada del cajero dañado
    cajerosDanados[cajeroID] = {
        x = originalX,
        y = originalY,
        z = originalZ,
        tiempoInicio = getTickCount(),
        tiempoReparacion = TIEMPO_REPARACION_CAJERO
    }
    
    -- Cambiar la apariencia del cajero (cambiar su alpha)
    setElementAlpha(cajero, 255)
    
    -- Disparar evento para crear efecto de fuego en el cliente con ID único
    triggerClientEvent("createFireEffect", root, originalX, originalY, originalZ + 1, cajeroID)
    
    -- Enviar evento al cliente para mostrar el temporizador con mejor estilo visual
    triggerClientEvent("mostrarTemporizadorAvanzado", root, originalX, originalY, originalZ + 1.5, TIEMPO_REPARACION_CAJERO / 1000)
    
    -- Programar la reparación del cajero
    setTimer(function()
        if isElement(cajero) then
            -- Restaurar el cajero a su estado original
            setElementAlpha(cajero, 255)
            cajerosRobados[cajero] = nil
            cajerosDanados[cajeroID] = nil
            
            -- Eliminar el temporizador y el efecto de fuego
            triggerClientEvent("eliminarTemporizador", root, originalX, originalY, originalZ + 1.5)
            triggerClientEvent("eliminarFireEffect", root, cajeroID)
        end
    end, TIEMPO_REPARACION_CAJERO, 1)
end

function handleRobATMCommand(player, command)
    -- Verificar si el jugador es policía (facción 1) o militar (facción 10) y cancelar el robo si lo es
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 10) then
        exports._infobox:addNotification(player, "¡Eres una autoridad! ¿Qué crees que haces?", "error")
        return -- Cancelar el robo si es policía o militar
    end

    -- Verificar si el jugador pertenece a una facción de tipo 3 (banda o cartel oficial)
    if not exports.factions:isPlayerInFactionType(player, 3) then
        exports._infobox:addNotification(player, "Debes estar en una banda o cartel oficial para robar un cajero", "error")
        return -- Cancelar el robo si no pertenece a una facción de tipo 3
    end
    
    -- Verificar si hay suficientes policías/militares en línea
    local autoridadesOnline = getPoliciasYMilitares()
    if autoridadesOnline < 0 then
        exports._infobox:addNotification(player, "Para robar un cajero deben haber al menos 2 policías o militares en servicio", "error")
        return
    end

    -- Verificar si el jugador está en un vehículo
    if isPedInVehicle(player) then
        exports._infobox:addNotification(player, "No puedes robar un cajero desde un vehículo", "error")
        return
    end

    -- Verificar si ya está en proceso de robo
    if getElementData(player, "roboAtm") then
        outputChatBox("¡Debes terminar primero el robo para iniciar otro!", player)
        return
    end

    -- Obtener la posición del jugador y los cajeros automáticos cercanos
    local playerX, playerY, playerZ = getElementPosition(player)
    local objects = getElementsByType("object")
    local nearATM = false
    local cajeroObjetivo = nil
    
    -- Buscar un cajero cercano
    for i, object in ipairs(objects) do
        local objectID = getElementModel(object)
        if objectID == OBJETO_ID_ESPECIFICO then
            local objectX, objectY, objectZ = getElementPosition(object)
            local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, objectX, objectY, objectZ)
            if distance <= DISTANCIA_MAXIMA then
                -- Verificar si el cajero ya está robado
                if cajerosRobados[object] then
                    exports._infobox:addNotification(player, "Este cajero ya ha sido robado y está dañado", "error")
                    return
                end
                nearATM = true
                cajeroObjetivo = object
                break
            end
        end
    end
    
    -- Si no está cerca de un cajero, mostrar mensaje de error
    if not nearATM or not cajeroObjetivo then
        exports._infobox:addNotification(player, "Debes estar muy cerca de un cajero para iniciar el robo.", "error")
        return
    end
    
    -- Marcar el cajero como robado
    cajerosRobados[cajeroObjetivo] = getTickCount()
    
    -- Si tiene una palanca, permitir el robo
    if getPedWeapon(player) == 11 then  -- Verificar si tiene una palanca
        setElementFrozen(player, true) 
        setElementData(player, "roboAtm", true)
        exports.chat:me(player, "Agarra la palanca y empieza a forzar el cajero")
        exports._infobox:addNotification(player, "¡Estás robando un cajero! Espera el conteo y escapa.", "success")
        triggerClientEvent(player, "progressBar", player, 55000, "RobandoATM")
        setPedAnimation(player, "BD_FIRE", "wash_up", -1, true, false, false, false)
        setPedAnimationProgress(player, "wash_up", 1) 
        setElementData(player, "animationInProgress", true)
        
        -- Obtener la posición del cajero para la alerta
        local cajeroX, cajeroY, cajeroZ = getElementPosition(cajeroObjetivo)
        
        -- Alertar a las autoridades después de 10 segundos (tiempo para que lleguen)
        setTimer(function()
            alertarAutoridades(cajeroX, cajeroY, cajeroZ)
        end, 10000, 1)

        -- Temporizador para completar el robo después de 55 segundos
        setTimer(function()
            if isElement(player) and not isPedDead(player) then
                setElementFrozen(player, false)
                local dinero = math.random(500000, 1200000)
                exports.players:giveMoney(player, dinero)
                exports.chat:me(player, "Rompe el cajero y saca los billetes")
                exports._infobox:addNotification(player, "Lograste robar $" .. dinero .. " del cajero. ¡Escapa ahora!", "info")
                setElementData(player, "animationInProgress", false)
                setPedAnimation(player)
                setElementData(player, "roboAtm", false)
                
                -- Dañar visualmente el cajero
                if isElement(cajeroObjetivo) then
                    danarCajero(cajeroObjetivo)
                end

                -- Contador de robos exitosos
                local robosExitosos = getElementData(player, "robosExitosos") or 0
                robosExitosos = robosExitosos + 1
                setElementData(player, "robosExitosos", robosExitosos)
            end
        end, 55000, 1)
        
        -- Manejar si el jugador muere durante el robo
        local function checkPlayerDeath()
            if isPedDead(player) and getElementData(player, "roboAtm") then
                exports._infobox:addNotification(player, "El robo ha sido interrumpido porque has muerto", "error")
                setElementData(player, "roboAtm", false)
                setElementData(player, "animationInProgress", false)
                removeEventHandler("onPlayerWasted", player, checkPlayerDeath)
            end
        end
        addEventHandler("onPlayerWasted", player, checkPlayerDeath)
        
        -- Manejar si el jugador se desconecta durante el robo
        local function checkPlayerQuit()
            if getElementData(player, "roboAtm") then
                setElementData(player, "roboAtm", false)
                setElementData(player, "animationInProgress", false)
            end
        end
        addEventHandler("onPlayerQuit", player, checkPlayerQuit)

        -- Actualizar el tiempo del último robo
        ultimoRobo[player] = getTickCount()
    else
        exports._infobox:addNotification(player, "Debes tener una palanca para poder forzar el cajero", "error")
    end
end

-- Asignar el comando "robaratm" a la función handleRobATMCommand
addCommandHandler("robaratm", handleRobATMCommand)

-- Función para sincronizar los cajeros dañados con un jugador que se conecta
function sincronizarCajerosDanados(player)
    -- Enviar información de todos los cajeros dañados al jugador que se conecta
    for id, info in pairs(cajerosDanados) do
        -- Calcular el tiempo restante de reparación
        local tiempoTranscurrido = getTickCount() - info.tiempoInicio
        local tiempoRestante = info.tiempoReparacion - tiempoTranscurrido
        
        -- Solo sincronizar si aún queda tiempo de reparación
        if tiempoRestante > 0 then
            -- Crear efecto de fuego
            triggerClientEvent(player, "createFireEffect", player, info.x, info.y, info.z + 1, id)
            
            -- Mostrar temporizador
            triggerClientEvent(player, "mostrarTemporizadorAvanzado", player, info.x, info.y, info.z + 1.5, tiempoRestante / 1000)
        end
    end
end

-- Evento para cuando un jugador se conecta al servidor
addEventHandler("onPlayerJoin", root, function()
    -- Esperar un momento para asegurarse de que el cliente está listo
    setTimer(function(player)
        if isElement(player) then
            sincronizarCajerosDanados(player)
        end
    end, 5000, 1, source)
end)

-- Evento para cuando un jugador hace spawn (útil para reconexiones)
addEventHandler("onPlayerSpawn", root, function()
    -- Esperar un momento para asegurarse de que el cliente está listo
    setTimer(function(player)
        if isElement(player) then
            sincronizarCajerosDanados(player)
        end
    end, 3000, 1, source)
end)



