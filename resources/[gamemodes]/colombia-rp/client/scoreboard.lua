-- Scoreboard personalizado para Colombia RP - Responsive
local scoreboardVisible = false

-- Función para obtener dimensiones responsivas
function getResponsiveSize()
    local screenWidth, screenHeight = guiGetScreenSize()
    
    -- Calcular dimensiones basadas en porcentajes de la pantalla
    local boardWidth = screenWidth * 0.45  -- 45% del ancho de pantalla
    local minWidth = 500  -- Ancho mínimo
    local maxWidth = 800  -- Ancho máximo
    boardWidth = math.max(minWidth, math.min(maxWidth, boardWidth))
    
    return screenWidth, screenHeight, boardWidth
end

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

-- Renderizar scoreboard limpio y organizado - RESPONSIVE
addEventHandler("onClientRender", root, function()
    if not scoreboardVisible then
        return
    end
    
    -- Obtener dimensiones responsivas
    local screenWidth, screenHeight, boardWidth = getResponsiveSize()
    
    -- Obtener lista de jugadores
    local playerList = getPlayerList()
    local totalPlayers = #playerList
    
    if totalPlayers == 0 then
        return
    end
    
    -- Calcular dimensiones responsivas
    local rowHeight = math.max(28, screenHeight * 0.04)  -- 4% de altura, mínimo 28px
    local headerHeight = math.max(45, screenHeight * 0.06)  -- 6% de altura, mínimo 45px
    local footerHeight = math.max(30, screenHeight * 0.04)  -- 4% de altura, mínimo 30px
    
    -- Calcular máximo de filas visibles basado en la altura de pantalla
    local availableHeight = screenHeight * 0.6  -- 60% de la altura disponible
    local maxRows = math.floor((availableHeight - headerHeight - footerHeight) / rowHeight)
    maxRows = math.max(5, math.min(15, maxRows))  -- Entre 5 y 15 filas
    
    local rowsToShow = math.min(totalPlayers, maxRows)
    local boardHeight = headerHeight + (rowsToShow * rowHeight) + footerHeight
    
    -- Centrar el scoreboard
    local boardX = (screenWidth - boardWidth) / 2
    local boardY = (screenHeight - boardHeight) / 2
    
    -- Fondo principal
    dxDrawRectangle(boardX, boardY, boardWidth, boardHeight, tocolor(20, 20, 20, 240), false)
    
    -- Borde azul
    local borderSize = math.max(2, screenWidth * 0.001)  -- Responsive border
    dxDrawRectangle(boardX, boardY, boardWidth, borderSize, tocolor(0, 150, 255, 255), false) -- Superior
    dxDrawRectangle(boardX, boardY + boardHeight - borderSize, boardWidth, borderSize, tocolor(0, 150, 255, 255), false) -- Inferior
    dxDrawRectangle(boardX, boardY, borderSize, boardHeight, tocolor(0, 150, 255, 255), false) -- Izquierdo
    dxDrawRectangle(boardX + boardWidth - borderSize, boardY, borderSize, boardHeight, tocolor(0, 150, 255, 255), false) -- Derecho
    
    -- Título con tamaño responsivo
    local titleSize = math.max(1.2, math.min(1.8, screenWidth / 800))
    dxDrawText("COLOMBIA RP", 
               boardX, boardY + 5, boardX + boardWidth, boardY + headerHeight - 5,
               tocolor(255, 255, 255, 255), titleSize, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Encabezados de columnas con tamaño responsivo
    local headerY = boardY + headerHeight - 5
    local headerColor = tocolor(0, 200, 255, 255)
    local headerFontSize = math.max(0.9, math.min(1.2, screenWidth / 1000))
    
    -- Calcular posiciones de columnas basadas en porcentajes
    local colIdX = boardX + (boardWidth * 0.03)  -- 3% desde la izquierda
    local colIdW = boardWidth * 0.08  -- 8% de ancho
    local colNameX = boardX + (boardWidth * 0.15)  -- 15% desde la izquierda
    local colNameW = boardWidth * 0.65  -- 65% de ancho
    local colPingX = boardX + (boardWidth * 0.82)  -- 82% desde la izquierda
    local colPingW = boardWidth * 0.15  -- 15% de ancho
    
    dxDrawText("ID", colIdX, headerY, colIdX + colIdW, headerY + 20,
               headerColor, headerFontSize, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("NOMBRE", colNameX, headerY, colNameX + colNameW, headerY + 20,
               headerColor, headerFontSize, "default-bold", "left", "center",
               false, false, false, false, false)
    
    dxDrawText("PING", colPingX, headerY, colPingX + colPingW, headerY + 20,
               headerColor, headerFontSize, "default-bold", "center", "center",
               false, false, false, false, false)
    
    -- Línea separadora
    dxDrawRectangle(boardX + (boardWidth * 0.02), headerY + 20, boardWidth - (boardWidth * 0.04), 1, tocolor(0, 150, 255, 200), false)
    
    -- Lista de jugadores
    local startY = headerY + 25
    local fontSize = math.max(0.85, math.min(1.1, screenWidth / 1200))
    
    for i = 1, rowsToShow do
        local playerData = playerList[i]
        if not playerData then break end
        
        local rowY = startY + (i - 1) * rowHeight
        
        -- Fondo alternado para mejor legibilidad
        if i % 2 == 0 then
            dxDrawRectangle(boardX + (boardWidth * 0.02), rowY, boardWidth - (boardWidth * 0.04), rowHeight - 2, tocolor(255, 255, 255, 8), false)
        end
        
        -- ID
        dxDrawText(tostring(playerData.id), 
                   colIdX, rowY, colIdX + colIdW, rowY + rowHeight - 2,
                   tocolor(200, 200, 200, 255), fontSize, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Nombre (verde si es el jugador local)
        local nameColor = tocolor(255, 255, 255, 255)
        if playerData.player == localPlayer then
            nameColor = tocolor(0, 255, 100, 255)
        end
        
        -- Truncar nombre si es muy largo
        local displayName = playerData.name
        local maxNameLength = math.floor(boardWidth * 0.6 / (fontSize * 8))  -- Aproximado
        if string.len(displayName) > maxNameLength then
            displayName = string.sub(displayName, 1, maxNameLength - 3) .. "..."
        end
        
        dxDrawText(displayName, 
                   colNameX, rowY, colNameX + colNameW, rowY + rowHeight - 2,
                   nameColor, fontSize, "default", "left", "center",
                   false, false, false, false, false)
        
        -- Ping con colores
        local pingColor = tocolor(0, 255, 0, 255) -- Verde
        if playerData.ping > 200 then
            pingColor = tocolor(255, 0, 0, 255) -- Rojo
        elseif playerData.ping > 100 then
            pingColor = tocolor(255, 200, 0, 255) -- Amarillo/Naranja
        end
        
        dxDrawText(tostring(playerData.ping), 
                   colPingX, rowY, colPingX + colPingW, rowY + rowHeight - 2,
                   pingColor, fontSize, "default", "center", "center",
                   false, false, false, false, false)
    end
    
    -- Footer
    local footerY = boardY + boardHeight - footerHeight + 5
    local footerFontSize = math.max(0.85, math.min(1.0, screenWidth / 1200))
    dxDrawText("Total: " .. totalPlayers .. " jugador(es)", 
               boardX + (boardWidth * 0.03), footerY, boardX + boardWidth - (boardWidth * 0.03), footerY + 25,
               tocolor(180, 180, 180, 255), footerFontSize, "default", "left", "center",
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
