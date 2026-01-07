-- Registrar eventos al inicio del archivo
addEvent("minijuegoCompletado", true)
addEvent("hackingCompletado", true)
addEvent("hackingFallado", true)
addEvent("hackingCancelado", true)
addEvent("liberarJugadorEmergencia", true)



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
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
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
        if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 4) then
            outputChatBox("[ALERTA] Se reporta un robo de cajero automático en curso. ¡Acuda inmediatamente!", player, 200, 255, 18)
            exports.a_infobox:addBox(player, "Robo de cajero en progreso. Ubicación marcada en el mapa.", "warning")
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
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 4) then
        exports.a_infobox:addBox(player, "¡Eres una autoridad! ¿Qué crees que haces?", "error")
        return -- Cancelar el robo si es policía o militar
    end

    -- Verificar si el jugador pertenece a una facción de tipo 3 (banda o cartel oficial)
    if not exports.factions:isPlayerInFactionType(player, 3) then
        exports.a_infobox:addBox(player, "Debes estar en una banda o cartel oficial para robar un cajero", "error")
        return -- Cancelar el robo si no pertenece a una facción de tipo 3
    end
    
    -- Verificar si hay suficientes policías/militares en línea
    local autoridadesOnline = getPoliciasYMilitares()
    if autoridadesOnline < 0 then
        exports.a_infobox:addBox(player, "Para robar un cajero deben haber al menos 2 policías o militares en servicio", "error")
        return
    end

    -- Verificar si el jugador está en un vehículo
    if isPedInVehicle(player) then
        exports.a_infobox:addBox(player, "No puedes robar un cajero desde un vehículo", "error")
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
                    exports.a_infobox:addBox(player, "Este cajero ya ha sido robado y está dañado", "error")
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
        exports.a_infobox:addBox(player, "Debes estar muy cerca de un cajero para iniciar el robo.", "error")
        return
    end
    
    -- Si tiene una palanca, iniciar el minijuego
    if getPedWeapon(player) == 11 then  -- Verificar si tiene una palanca
        setElementFrozen(player, true)
        setElementData(player, "roboAtm", true)
        exports.chat:me(player, "Agarra la palanca y empieza a forzar el cajero")
        exports.a_infobox:addBox(player, "Primero debes hackear el sistema del cajero", "info")
        
        -- Guardar el cajero objetivo para usarlo después de completar el minijuego
        setElementData(player, "cajeroObjetivo", cajeroObjetivo)
        
        -- 🚀 NUEVA OPCIÓN: Elegir tipo de minijuego
        exports.a_infobox:addBox(player, "Selecciona tu método de hackeo:", "info")
        exports.a_infobox:addBox(player, "Método 1: Terminal Hacker Épico (Nuevo)", "success")
        exports.a_infobox:addBox(player, "Método 2: Conexión de Cables (Clásico)", "info")
        
        outputChatBox("🔥 NUEVO: ¿Qué método de hackeo prefieres?", player, 255, 255, 0)
        outputChatBox("💻 Escribe /terminal para el NUEVO minijuego hacker épico", player, 0, 255, 255)
        outputChatBox("🔌 Escribe /cables para el minijuego clásico de cables", player, 0, 255, 255)
        
        -- El jugador debe elegir ahora, no iniciamos automáticamente
    else
        exports.a_infobox:addBox(player, "Debes tener una palanca para poder forzar el cajero", "error")
    end
end

-- ========================================
-- 🚀 MANEJADORES DE EVENTOS ÉPICOS 🚀
-- ========================================

-- Función común para proceder con el robo físico después del hackeo
local function procederConRoboFisico(player, cajeroObjetivo, tipoMinijuego)
    -- Marcar el cajero como robado
    cajerosRobados[cajeroObjetivo] = getTickCount()
    
    local tipoTexto = tipoMinijuego == "terminal" and "hackeado" or "hackeado"
    exports.a_infobox:addBox(player, "¡Sistema " .. tipoTexto .. "! Ahora comienza el robo del cajero", "success")
    exports.chat:me(player, "Termina de hackear el sistema y comienza a extraer el dinero")
    
    -- Iniciar la animación y el proceso de robo
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
            -- Bonus por usar terminal hacker
            local bonusMultiplier = tipoMinijuego == "terminal" and 1.5 or 1.0
            local dinero = math.random(500000, 1200000) * bonusMultiplier
            dinero = math.floor(dinero)
            
            exports.players:giveMoney(player, dinero)
            exports.chat:me(player, "Rompe el cajero y saca los billetes")
            
            local mensaje = tipoMinijuego == "terminal" and 
                "¡HACK ÉPICO! Lograste robar $" .. dinero .. " (Bonus: +50% por usar terminal hacker)" or 
                "Lograste robar $" .. dinero .. " del cajero. ¡Escapa ahora!"
                
            exports.a_infobox:addBox(player, mensaje, "info")
            setElementData(player, "animationInProgress", false)
            setPedAnimation(player)
            setElementData(player, "roboAtm", false)
            setElementData(player, "cajeroObjetivo", nil)
            
            -- Dañar visualmente el cajero
            if isElement(cajeroObjetivo) then
                danarCajero(cajeroObjetivo)
            end

            -- Contador de robos exitosos con bonificación por tipo
            local robosExitosos = getElementData(player, "robosExitosos") or 0
            local robosTerminal = getElementData(player, "robosTerminal") or 0
            robosExitosos = robosExitosos + 1
            
            if tipoMinijuego == "terminal" then
                robosTerminal = robosTerminal + 1
                setElementData(player, "robosTerminal", robosTerminal)
                outputChatBox("🔥 ¡Eres un hacker élite! Robos con terminal: " .. robosTerminal, player, 255, 255, 0)
            end
            
            setElementData(player, "robosExitosos", robosExitosos)
        end
    end, 55000, 1)
end

-- Registrar el evento para cuando el jugador completa el minijuego de cables
addEvent("minijuegoCompletado", true)
addEventHandler("minijuegoCompletado", root, function()
    local player = source
    
    -- Verificar si el jugador está en proceso de robo
    if not getElementData(player, "roboAtm") then
        return
    end
    
    -- Obtener el cajero objetivo guardado anteriormente
    local cajeroObjetivo = getElementData(player, "cajeroObjetivo")
    if not isElement(cajeroObjetivo) then
        setElementFrozen(player, false)
        setElementData(player, "roboAtm", false)
        exports.a_infobox:addBox(player, "El cajero ya no existe", "error")
        return
    end
    
    procederConRoboFisico(player, cajeroObjetivo, "cables")
end)

-- 🚀 EVENTO PARA TERMINAL HACKER COMPLETADO EXITOSAMENTE
addEventHandler("hackingCompletado", root, function()
    local player = source
    
    -- Verificar si el jugador está en proceso de robo
    if not getElementData(player, "roboAtm") then
        return
    end
    
    -- Obtener el cajero objetivo guardado anteriormente
    local cajeroObjetivo = getElementData(player, "cajeroObjetivo")
    if not isElement(cajeroObjetivo) then
        setElementFrozen(player, false)
        setElementData(player, "roboAtm", false)
        exports.a_infobox:addBox(player, "El cajero ya no existe", "error")
        return
    end
    
    procederConRoboFisico(player, cajeroObjetivo, "terminal")
end)

-- 🚨 EVENTO PARA TERMINAL HACKER FALLADO
addEventHandler("hackingFallado", root, function()
    local player = source
    
    if getElementData(player, "roboAtm") then
        setElementFrozen(player, false)
        setElementData(player, "roboAtm", false)
        setElementData(player, "animationInProgress", false)
        setElementData(player, "cajeroObjetivo", nil)
        
        exports.a_infobox:addBox(player, "💀 HACKEO FALLIDO - El sistema te detectó", "error")
        exports.chat:me(player, "Desconecta rápidamente el equipo de hacking y huye")
        
        -- Obtener posición para alerta inmediata
        local playerX, playerY, playerZ = getElementPosition(player)
        alertarAutoridades(playerX, playerY, playerZ)
        
        -- Penalización más severa por fallar el hackeo
        outputChatBox("🚔 ¡Alerta inmediata enviada a la policía por hackeo fallido!", player, 255, 0, 0)
    end
end)

-- ⚠️ EVENTO PARA TERMINAL HACKER CANCELADO (MEJORADO)
addEventHandler("hackingCancelado", root, function()
    local player = source
    
    if getElementData(player, "roboAtm") then
        -- 🔓 LIBERACIÓN COMPLETA DEL JUGADOR
        setElementFrozen(player, false)
        
        -- 🧹 LIMPIAR TODOS LOS DATOS DEL ROBO
        setElementData(player, "roboAtm", false)
        setElementData(player, "animationInProgress", false)
        setElementData(player, "cajeroObjetivo", nil)
        
        -- 🚨 VERIFICACIÓN ADICIONAL DE LIBERACIÓN (por si acaso)
        setTimer(function()
            if isElement(player) then
                setElementFrozen(player, false) -- Segunda verificación
            end
        end, 100, 1)
        
        -- 📋 MENSAJES Y NOTIFICACIONES
        exports.a_infobox:addBox(player, "⚠️ Hackeo cancelado - Movimiento restaurado", "warning")
        exports.chat:me(player, "Desconecta el equipo de hacking y recupera la movilidad")
        
        outputChatBox("🔌 Conexión de hackeo terminada - Ya puedes moverte", player, 255, 165, 0)
        outputChatBox("🎮 Todos los controles han sido restaurados", player, 0, 255, 0)
        

    else
        -- Si no estaba en proceso de robo, solo liberar por si acaso
        setElementFrozen(player, false)
        outputChatBox("🔧 Controles restaurados por precaución", player, 255, 255, 0)
    end
end)

-- 🚨 EVENTO DE EMERGENCIA PARA LIBERAR JUGADOR COMPLETAMENTE
addEventHandler("liberarJugadorEmergencia", root, function()
    local player = source
    

    
    -- 🔓 LIBERACIÓN FORZADA TOTAL
    setElementFrozen(player, false)
    
    -- 🧹 LIMPIAR ABSOLUTAMENTE TODOS LOS DATOS
    setElementData(player, "roboAtm", false)
    setElementData(player, "animationInProgress", false)
    setElementData(player, "cajeroObjetivo", nil)
    
    -- 🔄 VERIFICACIÓN MÚLTIPLE (por si hay lag de red)
    setTimer(function()
        if isElement(player) then
            setElementFrozen(player, false)
        end
    end, 100, 1)
    
    setTimer(function()
        if isElement(player) then
            setElementFrozen(player, false)
        end
    end, 500, 1)
    
    -- 📋 NOTIFICACIONES DE ÉXITO
    exports.a_infobox:addBox(player, "🚨 Restauración de emergencia completada", "success")
    exports.chat:me(player, "Se libera de cualquier restricción de movimiento")
    
    outputChatBox("🔓 LIBERACIÓN DE EMERGENCIA APLICADA", player, 0, 255, 0)
    outputChatBox("🎮 Si tenías problemas de movimiento, ya están solucionados", player, 255, 255, 255)
    

end)

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

addCommandHandler("robaratm", handleRobATMCommand)

-- 🚀 COMANDOS PARA ELEGIR TIPO DE MINIJUEGO
addCommandHandler("terminal", function(player)
    if getElementData(player, "roboAtm") and getElementData(player, "cajeroObjetivo") then
        exports.a_infobox:addBox(player, "🔥 Iniciando Terminal Hacker Épico...", "success")
        triggerClientEvent(player, "minijuegoTerminal", player)
    else
        exports.a_infobox:addBox(player, "Primero debes usar /robaratm cerca de un cajero", "error")
    end
end)

addCommandHandler("cables", function(player)
    if getElementData(player, "roboAtm") and getElementData(player, "cajeroObjetivo") then
        exports.a_infobox:addBox(player, "🔌 Iniciando minijuego clásico de cables...", "info")
        triggerClientEvent(player, "minijuego", player)
    else
        exports.a_infobox:addBox(player, "Primero debes usar /robaratm cerca de un cajero", "error")
    end
end)

addEventHandler("onResourceStart", resourceRoot, function()
end)






