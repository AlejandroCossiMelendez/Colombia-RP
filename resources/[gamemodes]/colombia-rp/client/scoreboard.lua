-- Scoreboard personalizado
local scoreboardVisible = false
local screenWidth, screenHeight = guiGetScreenSize()

-- Ocultar el scoreboard por defecto de MTA
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- El scoreboard personalizado reemplazará al por defecto
end)

-- Ocultar el scoreboard por defecto cuando se presiona TAB
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    -- Asegurar que el scoreboard por defecto no interfiera
end)

-- Toggle del scoreboard (TAB)
bindKey("tab", "both", function(key, keyState)
    if keyState == "down" then
        scoreboardVisible = true
    else
        scoreboardVisible = false
    end
end)

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
        if getElementData(player, "character:selected") then
            local charName = getElementData(player, "character:name")
            local charSurname = getElementData(player, "character:surname")
            local charId = getElementData(player, "character:id")
            
            if charName and charSurname and charId then
                table.insert(playerList, {
                    player = player,
                    name = charName .. " " .. charSurname,
                    id = charId,
                    ping = getPlayerPing(player)
                })
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
    local maxVisible = math.floor((boardHeight - startY - 20) / rowHeight)
    local totalPlayers = #playerList
    
    -- Mostrar jugadores
    for i = 1, math.min(maxVisible, totalPlayers) do
        local playerData = playerList[i]
        local rowY = startY + (i - 1) * rowHeight
        
        -- Fondo alternado para mejor legibilidad
        if i % 2 == 0 then
            dxDrawRectangle(boardX + 10, rowY, boardWidth - 20, rowHeight - 2, tocolor(255, 255, 255, 10), false)
        end
        
        -- ID
        dxDrawText(tostring(playerData.id), boardX + 20, rowY, boardX + 80, rowY + rowHeight, 
                   tocolor(255, 255, 255, 255), 1.0, "default", "left", "center", false, false, false, false, false)
        
        -- Nombre del personaje
        local nameColor = tocolor(255, 255, 255, 255)
        if playerData.player == localPlayer then
            nameColor = tocolor(0, 255, 0, 255) -- Verde para el jugador local
        end
        
        dxDrawText(playerData.name, boardX + 100, rowY, boardX + 400, rowY + rowHeight, 
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
        
        dxDrawText(tostring(playerData.ping) .. " ms", boardX + 420, rowY, boardX + 580, rowY + rowHeight, 
                   pingColor, 1.0, "default", "center", "center", false, false, false, false, false)
    end
    
    -- Contador de jugadores
    local footerY = boardY + boardHeight - 30
    dxDrawText("Total: " .. totalPlayers .. " jugador(es)", boardX + 20, footerY, boardX + boardWidth - 20, footerY + 20, 
               tocolor(200, 200, 200, 255), 1.0, "default", "left", "center", false, false, false, false, false)
end)

-- Actualizar nombres de los jugadores para mostrar personaje + ID
function updatePlayerNames()
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "character:selected") then
            local charName = getElementData(player, "character:name")
            local charSurname = getElementData(player, "character:surname")
            local charId = getElementData(player, "character:id")
            
            if charName and charSurname and charId then
                local displayName = charName .. " " .. charSurname .. " (ID: " .. charId .. ")"
                setPlayerNametagText(player, displayName)
            end
        end
    end
end

-- Actualizar nombres cuando un jugador spawnea
addEventHandler("onClientPlayerSpawn", root, function()
    if getElementData(source, "character:selected") then
        setTimer(function()
            updatePlayerNames()
        end, 500, 1)
    end
end)

-- Actualizar nombres periódicamente
setTimer(function()
    updatePlayerNames()
end, 2000, 0) -- Cada 2 segundos

-- Actualizar nombres cuando cambian los datos del personaje
addEventHandler("onClientElementDataChange", root, function(dataName)
    if getElementType(source) == "player" and (dataName == "character:selected" or dataName == "character:name" or dataName == "character:surname" or dataName == "character:id") then
        updatePlayerNames()
    end
end)

