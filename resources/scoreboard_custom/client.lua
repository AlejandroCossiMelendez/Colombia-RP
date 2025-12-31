-- Scoreboard mejorado con diseño profesional
local screenWidth, screenHeight = guiGetScreenSize()
local scoreboardWindow = nil
local scoreboardGrid = nil
local isScoreboardVisible = false
local updateScoreboardTimer = nil

-- Colores del tema
local colors = {
    background = {30, 30, 30, 240},      -- Fondo oscuro
    header = {41, 128, 185, 255},        -- Azul header
    text = {255, 255, 255, 255},         -- Texto blanco
    textSecondary = {200, 200, 200, 255}, -- Texto gris
    border = {60, 60, 60, 255},          -- Borde
    rowEven = {40, 40, 40, 200},         -- Fila par
    rowOdd = {50, 50, 50, 200}          -- Fila impar
}

-- Crear ventana del scoreboard
function createScoreboard()
    if scoreboardWindow then
        destroyElement(scoreboardWindow)
    end
    
    local windowWidth = 900
    local windowHeight = 500
    local x = (screenWidth - windowWidth) / 2
    local y = (screenHeight - windowHeight) / 2
    
    -- Ventana principal
    scoreboardWindow = guiCreateWindow(x, y, windowWidth, windowHeight, "Colombia RP - Jugadores Online", false)
    guiWindowSetMovable(scoreboardWindow, true)
    guiWindowSetSizable(scoreboardWindow, false)
    guiSetAlpha(scoreboardWindow, 0.95)
    guiSetVisible(scoreboardWindow, false)
    
    -- Grid list para mostrar jugadores
    scoreboardGrid = guiCreateGridList(10, 30, windowWidth - 20, windowHeight - 40, false, scoreboardWindow)
    
    -- Columnas
    guiGridListAddColumn(scoreboardGrid, "ID", 0.05)
    guiGridListAddColumn(scoreboardGrid, "Nombre", 0.25)
    guiGridListAddColumn(scoreboardGrid, "Rol", 0.12)
    guiGridListAddColumn(scoreboardGrid, "Ping", 0.08)
    guiGridListAddColumn(scoreboardGrid, "FPS", 0.08)
    guiGridListAddColumn(scoreboardGrid, "Dinero", 0.15)
    guiGridListAddColumn(scoreboardGrid, "Estado", 0.25)
    
    -- Estilo del grid
    guiGridListSetSortingEnabled(scoreboardGrid, true)
    guiGridListSetHorizontalScrollBar(scoreboardGrid, false)
end

-- Actualizar lista de jugadores
function updateScoreboard()
    if not scoreboardGrid then return end
    
    guiGridListClear(scoreboardGrid)
    
    local players = getElementsByType("player")
    local playerData = {}
    
    -- Recopilar datos de todos los jugadores
    for _, player in ipairs(players) do
        if isElement(player) then
            local playerID = getElementData(player, "playerID") or 0
            local playerName = getPlayerName(player)
            local role = getElementData(player, "userRole") or "user"
            local ping = getPlayerPing(player)
            local money = getPlayerMoney(player)
            local characterSelected = getElementData(player, "characterSelected") or false
            
            -- Obtener FPS del jugador (si está disponible)
            local fps = getElementData(player, "fps") or "N/A"
            
            -- Estado del jugador
            local status = "Desconectado"
            if characterSelected then
                status = "En línea"
            elseif getElementData(player, "loggedIn") then
                status = "Seleccionando personaje"
            else
                status = "Sin iniciar sesión"
            end
            
            -- Formatear dinero
            local moneyFormatted = "$" .. tostring(money)
            
            -- Formatear rol
            local roleFormatted = role
            if role == "admin" then
                roleFormatted = "Admin"
            elseif role == "staff" then
                roleFormatted = "Staff"
            else
                roleFormatted = "Usuario"
            end
            
            table.insert(playerData, {
                id = playerID,
                name = playerName,
                role = roleFormatted,
                ping = ping,
                fps = fps,
                money = moneyFormatted,
                status = status,
                player = player
            })
        end
    end
    
    -- Ordenar por ID
    table.sort(playerData, function(a, b)
        return a.id < b.id
    end)
    
    -- Agregar jugadores al grid
    for i, data in ipairs(playerData) do
        local row = guiGridListAddRow(scoreboardGrid)
        guiGridListSetItemText(scoreboardGrid, row, 1, tostring(data.id), false, false)
        guiGridListSetItemText(scoreboardGrid, row, 2, data.name, false, false)
        guiGridListSetItemText(scoreboardGrid, row, 3, data.role, false, false)
        guiGridListSetItemText(scoreboardGrid, row, 4, tostring(data.ping), false, false)
        guiGridListSetItemText(scoreboardGrid, row, 5, tostring(data.fps), false, false)
        guiGridListSetItemText(scoreboardGrid, row, 6, data.money, false, false)
        guiGridListSetItemText(scoreboardGrid, row, 7, data.status, false, false)
        
        -- Guardar referencia al jugador
        guiGridListSetItemData(scoreboardGrid, row, 1, data.player)
        
        -- Colorear filas según el rol
        if data.role == "Admin" then
            guiGridListSetItemColor(scoreboardGrid, row, 3, 255, 0, 0) -- Rojo para admin
        elseif data.role == "Staff" then
            guiGridListSetItemColor(scoreboardGrid, row, 3, 0, 255, 255) -- Cyan para staff
        end
    end
end

-- Mostrar/ocultar scoreboard
function toggleScoreboard()
    if not scoreboardWindow then
        createScoreboard()
    end
    
    isScoreboardVisible = not isScoreboardVisible
    guiSetVisible(scoreboardWindow, isScoreboardVisible)
    showCursor(isScoreboardVisible)
    guiSetInputEnabled(isScoreboardVisible)
    
    if isScoreboardVisible then
        updateScoreboard()
        -- Actualizar cada segundo mientras esté visible
        if updateScoreboardTimer then
            killTimer(updateScoreboardTimer)
        end
        updateScoreboardTimer = setTimer(function()
            if isScoreboardVisible then
                updateScoreboard()
            else
                killTimer(updateScoreboardTimer)
                updateScoreboardTimer = nil
            end
        end, 1000, 0)
    else
        if updateScoreboardTimer then
            killTimer(updateScoreboardTimer)
            updateScoreboardTimer = nil
        end
    end
end

-- Evento cuando se presiona TAB
bindKey("tab", "both", function(key, state)
    if state == "down" then
        toggleScoreboard()
    elseif state == "up" then
        if isScoreboardVisible then
            toggleScoreboard()
        end
    end
end)

-- Inicializar cuando el recurso inicia
addEventHandler("onClientResourceStart", resourceRoot, function()
    createScoreboard()
end)

-- Actualizar cuando un jugador se conecta/desconecta
addEventHandler("onClientPlayerJoin", root, function()
    if isScoreboardVisible then
        updateScoreboard()
    end
end)

addEventHandler("onClientPlayerQuit", root, function()
    if isScoreboardVisible then
        updateScoreboard()
    end
end)

