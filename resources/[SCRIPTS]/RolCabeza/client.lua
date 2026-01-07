local TIME_VISIBLE = 8500 -- Tiempo que el mensaje será visible (en milisegundos)
local DISTANCE_VISIBLE = 30 -- Distancia máxima para ver los mensajes
local ROUND = true -- Usar rectángulos redondeados para los mensajes
local ANIMATION_DURATION = 500 -- Duración de la animación de movimiento (en milisegundos)
local messages = {} -- Tabla para almacenar los mensajes flotantes
local nowTick -- Caché del tiempo actual
local x, y, z -- Caché de la posición del jugador local

-- Colores para los mensajes
local ME_COLOR = {255, 0, 0} -- Rojo para /me
local DO_COLOR = {255, 255, 0} -- Amarillo para /do

-- Comando para /me
addCommandHandler("me", function(_, ...)
    local message = table.concat({...}, " ")
    if message and message ~= "" then
        -- Cambiamos para usar un evento personalizado
        triggerServerEvent("rolme", localPlayer, message)
    end
end)

-- Comando para /do
addCommandHandler("do", function(_, ...)
    local message = table.concat({...}, " ")
    if message and message ~= "" then
        -- Cambiamos para usar un evento personalizado
        triggerServerEvent("roldo", localPlayer, message)
    end
end)

-- Evento para manejar los mensajes flotantes
addEvent("onRolReceived", true)
addEventHandler("onRolReceived", root, function(message, messageType, player)
    if messageType == "me" or messageType == "do" then
        local playerName = getPlayerName(player)
        local formattedMessage

        if messageType == "me" then
            formattedMessage = "* " .. playerName .. " " .. message
        elseif messageType == "do" then
            formattedMessage = message .. " "
        end

        -- Agregar burbuja flotante
        addBubble(formattedMessage, player, getTickCount(), messageType)
    end
end)

-- Evento para compatibilidad con el servidor
addEvent("onChatIncome", true)
addEventHandler("onChatIncome", localPlayer, function(text, messageType)
    -- Maneja los mensajes del chat normal del servidor
    -- No necesitamos hacer nada especial aquí ya que el sistema de chat normal se encarga de esto
end)

-- Función para agregar un mensaje flotante
function addBubble(text, player, tick, messageType)
    if not messages[player] then
        messages[player] = {}
    end

    local _texture = nil
    if ROUND then
        local width = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
        _texture = dxCreateRoundedTexture(width + 16, 20, 100)
    end

    -- Insertar el nuevo mensaje al final
    table.insert(messages[player], {
        text = text,
        player = player,
        tick = tick,
        alpha = 0,
        texture = _texture,
        currentY = 0, -- Posición actual para la animación
        targetY = 0, -- Posición objetivo para la animación
        type = messageType -- Guardar el tipo de mensaje para el color
    })

    -- Actualizar las posiciones objetivo de los mensajes existentes
    local totalMessages = #messages[player]
    for i, message in ipairs(messages[player]) do
        message.targetY = (totalMessages - i) * 25 -- Mensajes más antiguos se mueven hacia arriba
    end
end

-- Renderizar los mensajes flotantes
addEventHandler("onClientRender", root, function()
    nowTick = getTickCount()
    x, y, z = getElementPosition(localPlayer)

    for player, playerMessages in pairs(messages) do
        if isElement(player) then
            for index, message in ipairs(playerMessages) do
                handleDrawMessage(message, index, player)
            end
        else
            removePlayerMessages(player)
        end
    end
end)

-- Dibujar un mensaje flotante
function handleDrawMessage(message, index, player)
    if (nowTick - message.tick) > TIME_VISIBLE then
        removePlayerMessage(player, index)
        return
    end

    if not shouldDrawPlayerMessage(player) then
        return
    end

    local bx, by, bz
    -- Verificar si el jugador es un ped válido antes de intentar obtener la posición del hueso
    if isElement(player) and getElementType(player) == "player" or getElementType(player) == "ped" then
        if isPedInVehicle(player) then
            -- Si está en un vehículo, obtener la posición del jugador y ajustar la altura
            bx, by, bz = getElementPosition(player)
            bz = bz + 1.0 -- Ajuste de altura para vehículos
        else
            -- Si no está en un vehículo, obtener la posición del hueso de la cabeza
            bx, by, bz = getPedBonePosition(player, 8) -- Hueso de la cabeza
            bz = bz + 0.6 -- Ajustar altura (incrementado para evitar interferencia con el nombre)
        end
    else
        -- Si el jugador no es un ped válido, salir
        return
    end

    local sx, sy = getScreenFromWorldPosition(bx, by, bz)

    if not sx or not sy then
        return
    end

    -- Animar la posición vertical del mensaje
    if not message.currentY then
        message.currentY = sy -- Inicializar la posición actual
    end
    local progress = math.min((nowTick - message.tick) / ANIMATION_DURATION, 1)
    message.currentY = message.currentY + (sy - message.targetY - message.currentY) * progress

    message.alpha = message.alpha < 200 and message.alpha + 5 or message.alpha

    local textWidth = dxGetTextWidth(message.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
    local finalContainerX, finalContainerY = sx - textWidth / 2 - 10, message.currentY - 16
    local finalContainerWidth, finalContainerHeight = textWidth + 16, 20

    if ROUND and message.texture then
        dxDrawImage(finalContainerX, finalContainerY, finalContainerWidth, finalContainerHeight, message.texture, nil, nil, tocolor(0, 0, 0, message.alpha))
    else
        dxDrawRectangle(finalContainerX, finalContainerY, finalContainerWidth, finalContainerHeight, tocolor(0, 0, 0, message.alpha))
    end

    -- Seleccionar el color basado en el tipo de mensaje
    local textColor
    if message.type == "me" then
        -- Rojo para /me
        textColor = tocolor(ME_COLOR[1], ME_COLOR[2], ME_COLOR[3], message.alpha + 50)
    elseif message.type == "do" then
        -- Amarillo para /do
        textColor = tocolor(DO_COLOR[1], DO_COLOR[2], DO_COLOR[3], message.alpha + 50)
    else
        -- Verde por defecto (original)
        textColor = tocolor(0, 255, 0, message.alpha + 50)
    end
    
    dxDrawText(message.text, finalContainerX, finalContainerY, finalContainerX + finalContainerWidth, finalContainerY + finalContainerHeight, textColor, 1, "default-bold", "center", "center", false, false, false, true)
end

-- Verificar si el mensaje debe ser visible
function shouldDrawPlayerMessage(player)
    if not isElement(player) then return false end
    
    -- Verificar dimensión e interior
    local playerDimension = getElementDimension(player)
    local localDimension = getElementDimension(localPlayer)
    local playerInterior = getElementInterior(player)
    local localInterior = getElementInterior(localPlayer)
    
    -- Si están en diferentes dimensiones o interiores, no mostrar el mensaje
    if playerDimension ~= localDimension or playerInterior ~= localInterior then
        return false
    end
    
    local px, py, pz = getElementPosition(player)
    return getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= DISTANCE_VISIBLE
        and isLineOfSightClear(x, y, z, px, py, pz, true, not isPedInVehicle(player), false, true)
end

-- Eliminar un mensaje flotante
function removePlayerMessage(player, index)
    if not messages[player] or not messages[player][index] then return end
    
    if ROUND and messages[player][index].texture and isElement(messages[player][index].texture) then
        destroyElement(messages[player][index].texture)
    end
    table.remove(messages[player], index)
end

-- Eliminar todos los mensajes de un jugador
function removePlayerMessages(player)
    if not messages[player] then return end
    
    if ROUND then
        for _, message in ipairs(messages[player]) do
            if message.texture and isElement(message.texture) then
                destroyElement(message.texture)
            end
        end
    end
    messages[player] = nil
end

-- Función para permitir a scripts externos mostrar burbujas de rol
function showRoleplayBubble(message, messageType)
    if source and isElement(source) and getElementType(source) == "player" then
        local player = source
        
        -- Verificar dimensión e interior
        local playerDimension = getElementDimension(player)
        local localDimension = getElementDimension(localPlayer)
        local playerInterior = getElementInterior(player)
        local localInterior = getElementInterior(localPlayer)
        
        -- Si están en diferentes dimensiones o interiores, no mostrar el mensaje
        if playerDimension ~= localDimension or playerInterior ~= localInterior then
            return false
        end
        
        -- Verificar distancia
        local px, py, pz = getElementPosition(player)
        local lx, ly, lz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(lx, ly, lz, px, py, pz)
        
        if distance > DISTANCE_VISIBLE then
            return false
        end
        
        local playerName = getPlayerName(player)
        local formattedMessage
        
        if messageType == "me" then
            formattedMessage = "* " .. playerName .. " " .. message
        elseif messageType == "do" then
            formattedMessage = "* " .. message .. " (( " .. playerName .. " ))"
        else
            -- Si no es me/do, simplemente muestra el mensaje como está
            formattedMessage = message
        end
        
        addBubble(formattedMessage, player, getTickCount(), messageType)
        return true
    end
    return false
end
addEvent("showRoleplayBubble", true)
addEventHandler("showRoleplayBubble", root, showRoleplayBubble)

-- Función alternativa que usa eventos del cliente para mostrar burbujas directamente
-- Esta función está duplicada y no se debería usar en el cliente
-- Se ha implementado una versión mejorada en el lado del servidor
function mostrarBurbujaRol(player, mensaje, tipo)
    -- Esta función se removió porque no debería ser necesaria en el cliente
    -- La comunicación ahora se maneja a través de eventos desde el servidor
    return false
end