-- Scoreboard personalizado
local scoreboardVisible = false
local screenWidth, screenHeight = guiGetScreenSize()

-- Función para actualizar nombres de los jugadores (definida primero para que esté disponible)
function updatePlayerNames()
    -- Primero actualizar el jugador local
    if getElementData(localPlayer, "character:selected") then
        local charName = getElementData(localPlayer, "character:name")
        local charSurname = getElementData(localPlayer, "character:surname")
        local charId = getElementData(localPlayer, "character:id")
        
        if charName and charSurname and charId then
            local displayName = charName .. " " .. charSurname .. " (ID: " .. charId .. ")"
            setPlayerNametagText(localPlayer, displayName)
            setPlayerNametagShowing(localPlayer, true)
        end
    end
    
    -- Luego actualizar otros jugadores
    for _, player in ipairs(getElementsByType("player")) do
        if player ~= localPlayer and getElementData(player, "character:selected") then
            local charName = getElementData(player, "character:name")
            local charSurname = getElementData(player, "character:surname")
            local charId = getElementData(player, "character:id")
            
            if charName and charSurname and charId then
                local displayName = charName .. " " .. charSurname .. " (ID: " .. charId .. ")"
                setPlayerNametagText(player, displayName)
                setPlayerNametagShowing(player, true)
            end
        end
    end
end

-- El radar se maneja en radar.lua, no lo ocultamos aquí
-- Solo ocultamos el scoreboard por defecto de MTA
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- El radar se mostrará automáticamente cuando haya un personaje seleccionado
end)

-- Ocultar el scoreboard por defecto cuando se presiona TAB
addCommandHandler("scoreboard", function()
    -- Este comando se ejecuta cuando se presiona TAB, pero lo manejamos manualmente
end, false)

-- Toggle del scoreboard (TAB)
bindKey("tab", "both", function(key, keyState)
    if keyState == "down" then
        scoreboardVisible = true
    else
        scoreboardVisible = false
    end
end)

-- Interceptar el comando scoreboard para evitar que se muestre el por defecto
addCommandHandler("scoreboard", function()
    -- No hacer nada, nuestro scoreboard personalizado se maneja con bindKey
    -- Esto previene que se muestre el scoreboard por defecto
end, true)

-- Renderizar scoreboard personalizado
addEventHandler("onClientRender", root, function()
    if not scoreboardVisible then
        return
    end
    
    -- Obtener todos los jugadores
    local players = getElementsByType("player")
    local playerList = {}
    
    -- Filtrar solo jugadores con personaje seleccionado
    for _, player in ipairs(players) do
        if isElement(player) then
            local selected = getElementData(player, "character:selected")
            if selected == true then
                local charName = getElementData(player, "character:name")
                local charSurname = getElementData(player, "character:surname")
                local charId = getElementData(player, "character:id")
                
                -- Validar que todos los datos estén presentes
                if charName and charName ~= "" and 
                   charSurname and charSurname ~= "" and 
                   charId and charId ~= nil then
                    table.insert(playerList, {
                        player = player,
                        name = charName .. " " .. charSurname,
                        id = tonumber(charId) or 0,
                        ping = getPlayerPing(player) or 0
                    })
                end
            end
        end
    end
    
    -- Ordenar por ID
    table.sort(playerList, function(a, b)
        return a.id < b.id
    end)
    
    -- Dimensiones del scoreboard
    local boardWidth = 600
    local boardHeight = 400
    local boardX = (screenWidth - boardWidth) / 2
    local boardY = (screenHeight - boardHeight) / 2
    
    -- Fondo del scoreboard
    dxDrawRectangle(boardX, boardY, boardWidth, boardHeight, tocolor(0, 0, 0, 200), false)
    
    -- Borde
    dxDrawRectangle(boardX, boardY, boardWidth, 2, tocolor(0, 150, 255, 255), false) -- Borde superior
    dxDrawRectangle(boardX, boardY + boardHeight - 2, boardWidth, 2, tocolor(0, 150, 255, 255), false) -- Borde inferior
    dxDrawRectangle(boardX, boardY, 2, boardHeight, tocolor(0, 150, 255, 255), false) -- Borde izquierdo
    dxDrawRectangle(boardX + boardWidth - 2, boardY, 2, boardHeight, tocolor(0, 150, 255, 255), false) -- Borde derecho
    
    -- Título
    dxDrawText("COLOMBIA RP - JUGADORES", boardX, boardY + 10, boardX + boardWidth, boardY + 40, 
               tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center", false, false, false, false, false)
    
    -- Encabezados de columnas
    local headerY = boardY + 50
    dxDrawText("ID", boardX + 20, headerY, boardX + 80, headerY + 25, 
               tocolor(0, 150, 255, 255), 1.2, "default-bold", "left", "center", false, false, false, false, false)
    dxDrawText("Nombre", boardX + 100, headerY, boardX + 400, headerY + 25, 
               tocolor(0, 150, 255, 255), 1.2, "default-bold", "left", "center", false, false, false, false, false)
    dxDrawText("Ping", boardX + 420, headerY, boardX + 580, headerY + 25, 
               tocolor(0, 150, 255, 255), 1.2, "default-bold", "center", "center", false, false, false, false, false)
    
    -- Línea separadora
    dxDrawRectangle(boardX + 10, headerY + 25, boardWidth - 20, 2, tocolor(0, 150, 255, 150), false)
    
    -- Lista de jugadores
    local startY = headerY + 35
    local rowHeight = 30
    local footerHeight = 30
    local availableHeight = boardHeight - startY - footerHeight - 10
    local maxVisible = math.max(1, math.floor(availableHeight / rowHeight))
    local totalPlayers = #playerList
    
    -- Mostrar jugadores
    if totalPlayers > 0 then
        for i = 1, math.min(maxVisible, totalPlayers) do
            local playerData = playerList[i]
            if not playerData then
                break
            end
            
            local rowY = startY + (i - 1) * rowHeight
            
            -- Verificar que la fila esté dentro del área visible
            if rowY < boardY + boardHeight - footerHeight then
                -- Fondo alternado para mejor legibilidad
                if i % 2 == 0 then
                    dxDrawRectangle(boardX + 10, rowY, boardWidth - 20, rowHeight - 2, tocolor(255, 255, 255, 10), false)
                end
                
                -- ID
                dxDrawText(tostring(playerData.id), 
                           boardX + 20, rowY, boardX + 80, rowY + rowHeight, 
                           tocolor(255, 255, 255, 255), 1.0, "default", "left", "center", false, false, false, false, false)
                
                -- Nombre del personaje
                local nameColor = tocolor(255, 255, 255, 255)
                if playerData.player == localPlayer then
                    nameColor = tocolor(0, 255, 0, 255) -- Verde para el jugador local
                end
                
                dxDrawText(playerData.name, 
                           boardX + 100, rowY, boardX + 400, rowY + rowHeight, 
                           nameColor, 1.0, "default", "left", "center", false, false, false, false, false)
                
                -- Ping
                local pingColor = tocolor(255, 255, 255, 255)
                if playerData.ping > 200 then
                    pingColor = tocolor(255, 0, 0, 255) -- Rojo si ping alto
                elseif playerData.ping > 100 then
                    pingColor = tocolor(255, 165, 0, 255) -- Naranja si ping medio
                else
                    pingColor = tocolor(0, 255, 0, 255) -- Verde si ping bajo
                end
                
                dxDrawText(tostring(playerData.ping) .. " ms", 
                           boardX + 420, rowY, boardX + 580, rowY + rowHeight, 
                           pingColor, 1.0, "default", "center", "center", false, false, false, false, false)
            end
        end
    else
        -- Mensaje si no hay jugadores
        dxDrawText("No hay jugadores con personaje seleccionado", 
                   boardX + 20, startY, boardX + boardWidth - 20, startY + 50,
                   tocolor(200, 200, 200, 255), 1.0, "default", "center", "center", false, false, false, false, false)
    end
    
    -- Contador de jugadores
    local footerY = boardY + boardHeight - 30
    dxDrawText("Total: " .. totalPlayers .. " jugador(es)", boardX + 20, footerY, boardX + boardWidth - 20, footerY + 20, 
               tocolor(200, 200, 200, 255), 1.0, "default", "left", "center", false, false, false, false, false)
end)


-- Actualizar nombres cuando un jugador spawnea
addEventHandler("onClientPlayerSpawn", root, function()
    if getElementData(source, "character:selected") then
        setTimer(function()
            if isElement(source) then
                updatePlayerNames()
            end
        end, 500, 1)
    end
end)

-- Actualizar nombres cuando el jugador local spawnea (con múltiples intentos)
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    -- Intentar actualizar inmediatamente
    setTimer(function()
        updatePlayerNames()
    end, 500, 1)
    
    -- Intentar de nuevo después de más tiempo para asegurar sincronización
    setTimer(function()
        updatePlayerNames()
    end, 1500, 1)
    
    -- Un último intento
    setTimer(function()
        updatePlayerNames()
    end, 3000, 1)
end)

-- Actualizar nombres periódicamente (más frecuente para el jugador local)
setTimer(function()
    updatePlayerNames()
end, 1000, 0) -- Cada 1 segundo para mejor sincronización

-- Actualizar nombres cuando cambian los datos del personaje
addEventHandler("onClientElementDataChange", root, function(dataName)
    if getElementType(source) == "player" and (dataName == "character:selected" or dataName == "character:name" or dataName == "character:surname" or dataName == "character:id") then
        updatePlayerNames()
    end
end)

