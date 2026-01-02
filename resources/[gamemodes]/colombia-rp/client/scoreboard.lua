-- Scoreboard personalizado para Colombia RP
local scoreboardVisible = false
local screenWidth, screenHeight = guiGetScreenSize()

-- Deshabilitar completamente el scoreboard por defecto de MTA
addEventHandler("onClientResourceStart", root, function()
    -- Ocultar todos los componentes del HUD por defecto relacionados con el scoreboard
    setPlayerHudComponentVisible("radar", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
end)

-- Asegurar que el scoreboard por defecto esté oculto siempre
setTimer(function()
    setPlayerHudComponentVisible("radar", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
end, 100, 0) -- Verificar cada 100ms para asegurar que esté oculto

-- Toggle del scoreboard con TAB
bindKey("tab", "down", function()
    scoreboardVisible = true
end)

bindKey("tab", "up", function()
    scoreboardVisible = false
end)

-- Interceptar y bloquear el comando scoreboard por defecto
addCommandHandler("scoreboard", function()
    -- Bloquear completamente el scoreboard por defecto
    return false
end, true)

-- Función para obtener lista de jugadores ordenada
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

-- Renderizar scoreboard limpio y organizado
addEventHandler("onClientRender", root, function()
    if not scoreboardVisible then
        return
    end
    
    -- Obtener lista de jugadores
    local playerList = getPlayerList()
    local totalPlayers = #playerList
    
    if totalPlayers == 0 then
        return
    end
    
    -- Dimensiones fijas del scoreboard
    local boardWidth = 650
    local maxRows = 12
    local rowHeight = 32
    local headerHeight = 50
    local footerHeight = 35
    local boardHeight = headerHeight + (math.min(totalPlayers, maxRows) * rowHeight) + footerHeight
    
    local boardX = (screenWidth - boardWidth) / 2
    local boardY = (screenHeight - boardHeight) / 2
    
    -- Fondo principal
    dxDrawRectangle(boardX, boardY, boardWidth, boardHeight, tocolor(20, 20, 20, 240), false)
    
    -- Borde azul
    local borderSize = 2
    dxDrawRectangle(boardX, boardY, boardWidth, borderSize, tocolor(0, 150, 255, 255), false) -- Superior
    dxDrawRectangle(boardX, boardY + boardHeight - borderSize, boardWidth, borderSize, tocolor(0, 150, 255, 255), false) -- Inferior
    dxDrawRectangle(boardX, boardY, borderSize, boardHeight, tocolor(0, 150, 255, 255), false) -- Izquierdo
    dxDrawRectangle(boardX + boardWidth - borderSize, boardY, borderSize, boardHeight, tocolor(0, 150, 255, 255), false) -- Derecho
    
    -- Título
    dxDrawText("COLOMBIA RP", 
               boardX, boardY + 5, boardX + boardWidth, boardY + headerHeight - 5,
               tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Encabezados de columnas
    local headerY = boardY + headerHeight - 5
    local headerColor = tocolor(0, 200, 255, 255)
    
    dxDrawText("ID", boardX + 20, headerY, boardX + 80, headerY + 20,
               headerColor, 1.1, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("NOMBRE", boardX + 100, headerY, boardX + 500, headerY + 20,
               headerColor, 1.1, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("PING", boardX + 520, headerY, boardX + 630, headerY + 20,
               headerColor, 1.1, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Línea separadora
    dxDrawRectangle(boardX + 15, headerY + 20, boardWidth - 30, 1, tocolor(0, 150, 255, 200), false)
    
    -- Lista de jugadores
    local startY = headerY + 25
    local rowsToShow = math.min(totalPlayers, maxRows)
    
    for i = 1, rowsToShow do
        local playerData = playerList[i]
        if not playerData then break end
        
        local rowY = startY + (i - 1) * rowHeight
        
        -- Fondo alternado para mejor legibilidad
        if i % 2 == 0 then
            dxDrawRectangle(boardX + 15, rowY, boardWidth - 30, rowHeight - 2, tocolor(255, 255, 255, 8), false)
        end
        
        -- ID
        dxDrawText(tostring(playerData.id), 
                   boardX + 20, rowY, boardX + 80, rowY + rowHeight - 2,
                   tocolor(200, 200, 200, 255), 1.0, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Nombre (verde si es el jugador local)
        local nameColor = tocolor(255, 255, 255, 255)
        if playerData.player == localPlayer then
            nameColor = tocolor(0, 255, 100, 255)
        end
        
        dxDrawText(playerData.name, 
                   boardX + 100, rowY, boardX + 500, rowY + rowHeight - 2,
                   nameColor, 1.0, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Ping con colores
        local pingColor = tocolor(0, 255, 0, 255) -- Verde
        if playerData.ping > 200 then
            pingColor = tocolor(255, 0, 0, 255) -- Rojo
        elseif playerData.ping > 100 then
            pingColor = tocolor(255, 200, 0, 255) -- Amarillo/Naranja
        end
        
        dxDrawText(tostring(playerData.ping), 
                   boardX + 520, rowY, boardX + 630, rowY + rowHeight - 2,
                   pingColor, 1.0, "default", "center", "center",
                   false, false, false, false, false)
    end
    
    -- Footer
    local footerY = boardY + boardHeight - footerHeight + 5
    dxDrawText("Total: " .. totalPlayers .. " jugador(es)", 
               boardX + 20, footerY, boardX + boardWidth - 20, footerY + 25,
               tocolor(180, 180, 180, 255), 1.0, "default", "left", "center",
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
