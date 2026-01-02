-- Scoreboard personalizado para Colombia RP - Versión Simple y Responsive
local scoreboardVisible = false

-- Deshabilitar scoreboard por defecto de MTA
addEventHandler("onClientResourceStart", root, function()
    setPlayerHudComponentVisible("radar", false)
    setPlayerHudComponentVisible("area_name", false)
    setPlayerHudComponentVisible("vehicle_name", false)
end)

setTimer(function()
    setPlayerHudComponentVisible("radar", false)
end, 100, 0)

-- Toggle con TAB
bindKey("tab", "down", function()
    scoreboardVisible = true
end)

bindKey("tab", "up", function()
    scoreboardVisible = false
end)

addCommandHandler("scoreboard", function()
    return false
end, true)

-- Función para obtener jugadores
function getPlayerList()
    local players = getElementsByType("player")
    local playerList = {}
    
    for _, player in ipairs(players) do
        if isElement(player) then
            local selected = getElementData(player, "character:selected")
            if selected == true then
                local name = getElementData(player, "character:name")
                local surname = getElementData(player, "character:surname")
                local id = getElementData(player, "character:id")
                
                if name and surname and id then
                    table.insert(playerList, {
                        player = player,
                        name = name .. " " .. surname,
                        id = id,
                        ping = getPlayerPing(player) or 0
                    })
                end
            end
        end
    end
    
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
    
    -- Obtener dimensiones de pantalla
    local sw, sh = guiGetScreenSize()
    
    -- Obtener lista de jugadores
    local playerList = getPlayerList()
    local total = #playerList
    
    -- Debug: mostrar información en pantalla
    if total == 0 then
        -- Mostrar mensaje si no hay jugadores
        dxDrawText("No hay jugadores con personaje seleccionado", 
                   sw/2 - 200, sh/2 - 20, sw/2 + 200, sh/2 + 20,
                   tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center",
                   false, false, false, false, false)
        
        -- Debug: mostrar cuántos jugadores hay en total
        local allPlayers = getElementsByType("player")
        local debugText = "Total jugadores: " .. #allPlayers .. " | Con personaje: 0"
        dxDrawText(debugText, 
                   sw/2 - 200, sh/2 + 30, sw/2 + 200, sh/2 + 50,
                   tocolor(255, 0, 0, 255), 1.0, "default", "center", "center",
                   false, false, false, false, false)
        return
    end
    
    -- Calcular dimensiones responsivas
    local boardWidth = math.max(500, math.min(800, sw * 0.5))
    local rowHeight = 35
    local headerHeight = 50
    local footerHeight = 35
    local maxRows = math.floor((sh * 0.7) / rowHeight)  -- 70% de la altura disponible
    maxRows = math.max(5, math.min(20, maxRows))  -- Entre 5 y 20 filas
    
    local rowsToShow = math.min(total, maxRows)
    local boardHeight = headerHeight + (rowsToShow * rowHeight) + footerHeight
    
    -- Centrar
    local boardX = (sw - boardWidth) / 2
    local boardY = (sh - boardHeight) / 2
    
    -- Fondo
    dxDrawRectangle(boardX, boardY, boardWidth, boardHeight, tocolor(0, 0, 0, 200), false)
    
    -- Bordes
    local border = 2
    dxDrawRectangle(boardX, boardY, boardWidth, border, tocolor(0, 150, 255, 255), false)
    dxDrawRectangle(boardX, boardY + boardHeight - border, boardWidth, border, tocolor(0, 150, 255, 255), false)
    dxDrawRectangle(boardX, boardY, border, boardHeight, tocolor(0, 150, 255, 255), false)
    dxDrawRectangle(boardX + boardWidth - border, boardY, border, boardHeight, tocolor(0, 150, 255, 255), false)
    
    -- Título
    dxDrawText("COLOMBIA RP", 
               boardX, boardY + 10, boardX + boardWidth, boardY + headerHeight - 5,
               tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Encabezados
    local headerY = boardY + headerHeight - 8
    local headerColor = tocolor(0, 200, 255, 255)
    
    -- Posiciones de columnas (usando porcentajes del ancho)
    local colIdX = boardX + 20
    local colIdW = 60
    local colNameX = boardX + 100
    local colNameW = boardWidth - 220
    local colPingX = boardX + boardWidth - 100
    local colPingW = 80
    
    dxDrawText("ID", colIdX, headerY, colIdX + colIdW, headerY + 25,
               headerColor, 1.0, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("NOMBRE", colNameX, headerY, colNameX + colNameW, headerY + 25,
               headerColor, 1.0, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("PING", colPingX, headerY, colPingX + colPingW, headerY + 25,
               headerColor, 1.0, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Línea separadora
    dxDrawRectangle(boardX + 15, headerY + 25, boardWidth - 30, 1, tocolor(0, 150, 255, 180), false)
    
    -- Lista de jugadores
    local startY = headerY + 30
    
    for i = 1, rowsToShow do
        local playerData = playerList[i]
        if not playerData then break end
        
        local rowY = startY + (i - 1) * rowHeight
        
        -- Fondo alternado
        if i % 2 == 0 then
            dxDrawRectangle(boardX + 15, rowY, boardWidth - 30, rowHeight - 2, tocolor(255, 255, 255, 10), false)
        end
        
        -- ID
        dxDrawText(tostring(playerData.id), 
                   colIdX, rowY, colIdX + colIdW, rowY + rowHeight - 2,
                   tocolor(200, 200, 200, 255), 1.0, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Nombre
        local nameColor = tocolor(255, 255, 255, 255)
        if playerData.player == localPlayer then
            nameColor = tocolor(0, 255, 100, 255)
        end
        
        -- Truncar nombre si es muy largo
        local displayName = playerData.name
        if string.len(displayName) > 30 then
            displayName = string.sub(displayName, 1, 27) .. "..."
        end
        
        dxDrawText(displayName, 
                   colNameX, rowY, colNameX + colNameW, rowY + rowHeight - 2,
                   nameColor, 1.0, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Ping
        local pingColor = tocolor(0, 255, 0, 255)
        if playerData.ping > 200 then
            pingColor = tocolor(255, 0, 0, 255)
        elseif playerData.ping > 100 then
            pingColor = tocolor(255, 200, 0, 255)
        end
        
        dxDrawText(tostring(playerData.ping), 
                   colPingX, rowY, colPingX + colPingW, rowY + rowHeight - 2,
                   pingColor, 1.0, "default", "center", "center",
                   false, false, false, false, false)
    end
    
    -- Footer
    local footerY = boardY + boardHeight - footerHeight + 5
    dxDrawText("Total: " .. total .. " jugador(es)", 
               boardX + 20, footerY, boardX + boardWidth - 20, footerY + 25,
               tocolor(180, 180, 180, 255), 1.0, "default", "left", "center",
               false, false, false, false, false)
end)

-- Actualizar nametags
function updatePlayerNames()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) and getElementData(player, "character:selected") then
            local name = getElementData(player, "character:name")
            local surname = getElementData(player, "character:surname")
            local id = getElementData(player, "character:id")
            
            if name and surname and id then
                local displayName = name .. " " .. surname .. " (ID: " .. id .. ")"
                setPlayerNametagText(player, displayName)
                setPlayerNametagShowing(player, true)
            end
        end
    end
end

addEventHandler("onClientPlayerSpawn", root, function()
    if isElement(source) and getElementData(source, "character:selected") then
        setTimer(function()
            if isElement(source) then
                updatePlayerNames()
            end
        end, 500, 1)
    end
end)

setTimer(function()
    updatePlayerNames()
end, 3000, 0)

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

addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        updatePlayerNames()
    end, 1000, 1)
end)
