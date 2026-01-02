-- Scoreboard personalizado para Colombia RP
local scoreboardVisible = false
local screenWidth, screenHeight = guiGetScreenSize()

-- Ocultar componentes del HUD por defecto de MTA
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Ocultar el scoreboard por defecto
    setPlayerHudComponentVisible("radar", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
end)

-- Asegurar que el scoreboard por defecto esté oculto
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    setPlayerHudComponentVisible("radar", false)
end)

-- Toggle del scoreboard con TAB
bindKey("tab", "down", function()
    scoreboardVisible = true
end)

bindKey("tab", "up", function()
    scoreboardVisible = false
end)

-- Interceptar el comando scoreboard para evitar el por defecto
addCommandHandler("scoreboard", function()
    -- No hacer nada, nuestro scoreboard se maneja con TAB
end, true)

-- Función para obtener lista de jugadores
function getPlayerList()
    local players = getElementsByType("player")
    local playerList = {}
    
    for _, player in ipairs(players) do
        if isElement(player) then
            local characterSelected = getElementData(player, "character:selected")
            
            if characterSelected == true then
                local charName = getElementData(player, "character:name")
                local charSurname = getElementData(player, "character:surname")
                local charId = getElementData(player, "character:id")
                
                if charName and charSurname and charId then
                    table.insert(playerList, {
                        player = player,
                        name = charName .. " " .. charSurname,
                        id = charId,
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
    
    return playerList
end

-- Renderizar scoreboard
addEventHandler("onClientRender", root, function()
    if not scoreboardVisible then
        return
    end
    
    -- Obtener lista de jugadores
    local playerList = getPlayerList()
    local totalPlayers = #playerList
    
    -- Dimensiones del scoreboard
    local boardWidth = 700
    local boardHeight = math.min(500, 100 + (totalPlayers * 35) + 50)
    local boardX = (screenWidth - boardWidth) / 2
    local boardY = (screenHeight - boardHeight) / 2
    
    -- Fondo principal con transparencia
    dxDrawRectangle(boardX, boardY, boardWidth, boardHeight, tocolor(0, 0, 0, 220), false)
    
    -- Bordes
    local borderColor = tocolor(0, 150, 255, 255)
    dxDrawRectangle(boardX, boardY, boardWidth, 3, borderColor, false) -- Superior
    dxDrawRectangle(boardX, boardY + boardHeight - 3, boardWidth, 3, borderColor, false) -- Inferior
    dxDrawRectangle(boardX, boardY, 3, boardHeight, borderColor, false) -- Izquierdo
    dxDrawRectangle(boardX + boardWidth - 3, boardY, 3, boardHeight, borderColor, false) -- Derecho
    
    -- Título
    dxDrawText("COLOMBIA RP - JUGADORES ONLINE", 
               boardX, boardY + 10, boardX + boardWidth, boardY + 45,
               tocolor(255, 255, 255, 255), 1.8, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Encabezados
    local headerY = boardY + 55
    local headerColor = tocolor(0, 200, 255, 255)
    
    dxDrawText("ID", boardX + 25, headerY, boardX + 100, headerY + 30,
               headerColor, 1.3, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("NOMBRE", boardX + 120, headerY, boardX + 450, headerY + 30,
               headerColor, 1.3, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("PING", boardX + 480, headerY, boardX + 675, headerY + 30,
               headerColor, 1.3, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Línea separadora
    dxDrawRectangle(boardX + 15, headerY + 30, boardWidth - 30, 2, tocolor(0, 150, 255, 180), false)
    
    -- Lista de jugadores
    local startY = headerY + 40
    local rowHeight = 35
    local maxVisible = math.floor((boardHeight - startY - 50) / rowHeight)
    
    for i = 1, math.min(maxVisible, totalPlayers) do
        local playerData = playerList[i]
        if not playerData then break end
        
        local rowY = startY + (i - 1) * rowHeight
        
        -- Fondo alternado
        if i % 2 == 0 then
            dxDrawRectangle(boardX + 15, rowY, boardWidth - 30, rowHeight - 3, tocolor(255, 255, 255, 15), false)
        end
        
        -- ID
        dxDrawText(tostring(playerData.id), 
                   boardX + 25, rowY, boardX + 100, rowY + rowHeight,
                   tocolor(255, 255, 255, 255), 1.1, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Nombre (verde si es el jugador local)
        local nameColor = tocolor(255, 255, 255, 255)
        if playerData.player == localPlayer then
            nameColor = tocolor(0, 255, 0, 255)
        end
        
        dxDrawText(playerData.name, 
                   boardX + 120, rowY, boardX + 450, rowY + rowHeight,
                   nameColor, 1.1, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Ping con colores
        local pingColor = tocolor(0, 255, 0, 255) -- Verde por defecto
        if playerData.ping > 200 then
            pingColor = tocolor(255, 0, 0, 255) -- Rojo
        elseif playerData.ping > 100 then
            pingColor = tocolor(255, 165, 0, 255) -- Naranja
        end
        
        dxDrawText(tostring(playerData.ping) .. " ms", 
                   boardX + 480, rowY, boardX + 675, rowY + rowHeight,
                   pingColor, 1.1, "default", "center", "center",
                   false, false, false, false, false)
    end
    
    -- Footer con contador
    local footerY = boardY + boardHeight - 35
    dxDrawText("Total: " .. totalPlayers .. " jugador(es) conectado(s)", 
               boardX + 25, footerY, boardX + boardWidth - 25, footerY + 25,
               tocolor(200, 200, 200, 255), 1.0, "default", "left", "center",
               false, false, false, false, false)
    
    -- Instrucción
    dxDrawText("Presiona TAB para ocultar", 
               boardX + 25, footerY, boardX + boardWidth - 25, footerY + 25,
               tocolor(150, 150, 150, 255), 0.9, "default", "right", "center",
               false, false, false, false, false)
end)

-- Actualizar nametags de los jugadores
function updatePlayerNames()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and getElementData(player, "character:selected") then
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

-- Actualizar nombres cuando un jugador spawnea
addEventHandler("onClientPlayerSpawn", root, function()
    if isElement(source) and getElementData(source, "character:selected") then
        setTimer(function()
            if isElement(source) then
                updatePlayerNames()
            end
        end, 500, 1)
    end
end)

-- Actualizar nombres periódicamente
setTimer(function()
    updatePlayerNames()
end, 3000, 0)

-- Actualizar nombres cuando cambian los datos
addEventHandler("onClientElementDataChange", root, function(dataName)
    if isElement(source) and getElementType(source) == "player" then
        if dataName == "character:selected" or 
           dataName == "character:name" or 
           dataName == "character:surname" or 
           dataName == "character:id" then
            updatePlayerNames()
        end
    end
end)

-- Inicializar al cargar
addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        updatePlayerNames()
    end, 1000, 1)
end)
