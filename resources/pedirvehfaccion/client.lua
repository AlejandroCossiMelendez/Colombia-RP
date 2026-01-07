--loadstring(exports.dxLibrary:dxGetLibrary())() -- Cargar dxLibrary correctamente
local sx, sy = guiGetScreenSize()
local sw, sh = sx/1920, sy/1080

-- Variables globales
local panelVisible = false
local vehiclesList = {}
local selectedVehicle = nil
local factionID = nil
local scrollOffset = 0
local maxVisibleItems = 5 -- Reducido para más espacio entre elementos
local itemHeight = 70*sh -- Aumentado para más espacio vertical
local vehiclesInfo = {} -- Almacena la información de los vehículos
local lastRefreshTime = 0 -- Para controlar la frecuencia de actualización
local forceRefreshTimer = nil -- Timer para forzar actualización completa

-- Rutas de las imágenes
local imagePaths = {
    background = "Assets/background.png",
    item = "Assets/item.png",
    button = "Assets/button.png",
    icon = "Assets/icon.png",
    available = "Assets/available.png",
    notAvailable = "Assets/notavailable.png"
}

-- Colores para los botones (RGB) - Nuevos colores más atractivos
local buttonColors = {
    regenerar = tocolor(0, 120, 215, 255), -- Azul más moderno (estilo Windows 10)
    sacar = tocolor(0, 170, 80, 255),      -- Verde más vibrante (estilo Xbox)
    actualizar = tocolor(230, 120, 0, 255) -- Naranja para el botón de actualizar
}

-- Factores de escala para el texto (aumentados para texto más grande)
local textScales = {
    title = 2.5*sw,       -- Título principal
    faction = 1.8*sw,     -- Nombre de facción
    headers = 1.6*sw,     -- Encabezados de columnas
    items = 1.5*sw,       -- Texto de los ítems
    buttons = 1.6*sw,     -- Texto de los botones
    vehicleID = 1.2*sw,   -- ID del vehículo
    noVehicles = 1.8*sw   -- Mensaje de no hay vehículos
}

-- Tabla con los nombres de facciones
local factionVehicleNames = {
    [1] = "POLICÍA NACIONAL",
    [2] = "SURA EPS",
    [3] = "TALLER MECÁNICO",
    [4] = "HUGO BOSS",
    [5] = "AMPER",
    [6] = "COCA-COLA",
    [7] = "PEPSI",
    [8] = "SERVIENTREGA",
    [9] = "ZENÚ",
    [10] = "EJÉRCITO NACIONAL",
    [11] = "TRÁNSITO DE COLOMBIA",
    [12] = "CARTEL DE MEDELLÍN",
    [13] = "FARC",
    [14] = "LA TERRAZA",
    [15] = "CARTEL DE CALI",
    [16] = "CLAN DEL GOLFO",
    [17] = "CALAMAR EVENTO",
    [18] = "CALAMAR EVENTO 2",
    [19] = "GOBIERNO NACIONAL",
    [20] = "GOBIERNO NACIONAL",
    [21] = "LAS HABICHUELAS",
    [22] = "BANCOLOMBIA"

}

-- Función para mostrar el panel de vehículos
function showPanel(vehicles, faction, vehInfo)
    if panelVisible then return end
    
    vehiclesList = vehicles or {}
    factionID = faction
    vehiclesInfo = vehInfo or {}
    selectedVehicle = nil
    scrollOffset = 0
    panelVisible = true
    lastRefreshTime = getTickCount()
    
    -- Añadir el renderizado
    addEventHandler("onClientRender", root, renderPanel)
    
    -- Añadir eventos de mouse y teclado
    addEventHandler("onClientClick", root, handleClick)
    addEventHandler("onClientKey", root, handleKey)
    
    -- Mostrar el cursor
    showCursor(true)
    
    -- Configurar un temporizador para actualizar la información de los vehículos cada 10 segundos
    setTimer(function()
        if panelVisible then
            refreshVehicleInfo()
        end
    end, 10000, 0) -- 10 segundos
    
    -- Forzar una actualización completa cada 30 segundos para asegurar que los estados sean correctos
    forceRefreshTimer = setTimer(function()
        if panelVisible then
            forceRefreshAllVehicles()
        end
    end, 30000, 0) -- 30 segundos
    
    -- Hacer una actualización completa inicial (silenciosa)
    triggerServerEvent("forceRefreshAllVehicles", localPlayer, vehiclesList)
end

-- Función para actualizar la información de los vehículos
function refreshVehicleInfo()
    if not panelVisible or #vehiclesList == 0 then return end
    
    -- Solicitar información actualizada de todos los vehículos
    for _, vehID in ipairs(vehiclesList) do
        triggerServerEvent("requestVehicleInfo", localPlayer, vehID)
    end
    
    lastRefreshTime = getTickCount()
end

-- Función para forzar una actualización completa de todos los vehículos
function forceRefreshAllVehicles()
    if not panelVisible or #vehiclesList == 0 then return end
    
    -- Solicitar una actualización completa al servidor
    triggerServerEvent("forceRefreshAllVehicles", localPlayer, vehiclesList)
    
    -- Mostrar mensaje de actualización solo si se hace manualmente (no en actualizaciones automáticas)
    if not isTimer(forceRefreshTimer) then
        outputChatBox("Actualizando estado de vehículos...", 0, 200, 255)
    end
    
    lastRefreshTime = getTickCount()
    
    -- Añadir un efecto visual de actualización
    local refreshIconSize = 30*sw
    local refreshIconX = sx/2 + 900*sw/2 - 60*sw
    local refreshIconY = sy/2 - 750*sh/2 + 20*sh
    
    -- Crear un efecto de "flash" en el icono de actualización
    local alpha = 255
    local flashTimer = setTimer(function()
        if not panelVisible then return end
        
        alpha = alpha - 25
        if alpha < 50 then
            killTimer(flashTimer)
        end
    end, 50, 10)
end

-- Función para cerrar el panel
function closePanel()
    if not panelVisible then return end
    
    panelVisible = false
    
    -- Quitar eventos
    removeEventHandler("onClientRender", root, renderPanel)
    removeEventHandler("onClientClick", root, handleClick)
    removeEventHandler("onClientKey", root, handleKey)
    
    -- Detener el timer de actualización forzada
    if forceRefreshTimer and isTimer(forceRefreshTimer) then
        killTimer(forceRefreshTimer)
        forceRefreshTimer = nil
    end
    
    -- Ocultar el cursor
    showCursor(false)
end

-- Función para crear texto con sombra y contorno mejorado
function drawTextWithShadow(text, x, y, width, height, color, scale, font, alignX, alignY, shadowDistance, shadowColor, outlineSize)
    shadowDistance = shadowDistance or 2
    shadowColor = shadowColor or tocolor(0, 0, 0, 150)
    outlineSize = outlineSize or 1
    
    -- Contorno (8 direcciones)
    for offsetX = -outlineSize, outlineSize, outlineSize do
        for offsetY = -outlineSize, outlineSize, outlineSize do
            if not (offsetX == 0 and offsetY == 0) then
                dxDrawText(text, x + offsetX*sw, y + offsetY*sh, width + offsetX*sw, height + offsetY*sh, shadowColor, scale, font, alignX, alignY)
            end
        end
    end
    
    -- Sombra principal
    dxDrawText(text, x + shadowDistance*sw, y + shadowDistance*sh, width + shadowDistance*sw, height + shadowDistance*sh, shadowColor, scale, font, alignX, alignY)
    
    -- Texto principal
    dxDrawText(text, x, y, width, height, color, scale, font, alignX, alignY)
end

-- Función para renderizar el panel
function renderPanel()
    -- Fondo principal (ajustado para que todo quepa dentro)
    local panelWidth = 900*sw
    local panelHeight = 750*sh -- Aumentado para que los botones quepan dentro
    dxDrawImage(sx/2 - panelWidth/2, sy/2 - panelHeight/2, panelWidth, panelHeight, imagePaths.background, 0, 0, 0, tocolor(255, 255, 255, 255))
    
    -- Título con sombra mejorada
    local titleY = sy/2 - panelHeight/2 + 50*sh
    drawTextWithShadow("Vehículos Faccionarios", sx/2, titleY, sx/2, titleY, tocolor(255, 255, 255, 255), textScales.title, "default-bold", "center", "center", 3, tocolor(0, 0, 0, 200), 1.5)
    
    -- Icono de facción
    dxDrawImage(sx/2 - panelWidth/2 + 70*sw, titleY - 20*sh, 80*sw, 80*sh, imagePaths.icon, 0, 0, 0, tocolor(255, 255, 255, 255))
    
    -- Nombre de la facción con sombra mejorada
    local factionName = factionVehicleNames[math.abs(factionID)] or "DESCONOCIDO"
    local factionY = titleY + 60*sh
    drawTextWithShadow(factionName, sx/2, factionY, sx/2, factionY, tocolor(255, 255, 255, 255), textScales.faction, "default-bold", "center", "center", 3, tocolor(0, 0, 0, 200), 1.5)
    
    -- Línea separadora con mejor visibilidad
    local lineY = factionY + 40*sh
    dxDrawRectangle(sx/2 - panelWidth/2 + 50*sw, lineY, panelWidth - 100*sw, 3*sh, tocolor(255, 255, 255, 180))
    
    -- Encabezados de la tabla con sombra mejorada
    local headerY = lineY + 30*sh
    drawTextWithShadow("Modelo", sx/2 - 320*sw, headerY, sx/2 - 320*sw, headerY, tocolor(255, 255, 255, 255), textScales.headers, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
    drawTextWithShadow("Matrícula", sx/2 - 100*sw, headerY, sx/2 - 100*sw, headerY, tocolor(255, 255, 255, 255), textScales.headers, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
    drawTextWithShadow("Gasolina", sx/2 + 100*sw, headerY, sx/2 + 100*sw, headerY, tocolor(255, 255, 255, 255), textScales.headers, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
    drawTextWithShadow("Estado", sx/2 + 300*sw, headerY, sx/2 + 300*sw, headerY, tocolor(255, 255, 255, 255), textScales.headers, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
    
    -- Lista de vehículos
    local startY = headerY + 30*sh
    
    -- Verificar si hay vehículos
    if #vehiclesList == 0 then
        drawTextWithShadow("No hay vehículos disponibles para esta facción", sx/2, sy/2, sx/2, sy/2, tocolor(255, 255, 255, 255), textScales.noVehicles, "default-bold", "center", "center", 3, tocolor(0, 0, 0, 200), 1.5)
    else
        -- Dibujar cada vehículo en la lista con más espacio entre elementos
        for i = 1, maxVisibleItems do
            local index = i + scrollOffset
            if index <= #vehiclesList then
                local vehID = vehiclesList[index]
                local vehInfo = vehiclesInfo[tostring(vehID)]
                
                -- Fondo del item con mejor contraste y mayor separación
                local itemY = startY + (i-1)*(itemHeight + 15*sh) -- Aumentado el espacio entre elementos
                local itemColor
                
                if selectedVehicle == index then
                    -- Item seleccionado con gradiente para mejor visibilidad
                    itemColor = tocolor(100, 150, 255, 230)
                    -- Borde para el item seleccionado más visible
                    dxDrawRectangle(sx/2 - panelWidth/2 + 45*sw, itemY - 3*sh, panelWidth - 90*sw, itemHeight + 6*sh, tocolor(150, 200, 255, 150))
                else
                    -- Item normal con mejor contraste
                    itemColor = tocolor(255, 255, 255, 180)
                end
                
                -- Fondo del item con borde para mejor visibilidad
                dxDrawImage(sx/2 - panelWidth/2 + 50*sw, itemY, panelWidth - 100*sw, itemHeight, imagePaths.item, 0, 0, 0, itemColor)
                
                -- Información del vehículo con sombra mejorada
                if vehInfo then
                    -- Modelo con sombra mejorada
                    drawTextWithShadow(vehInfo.modelName or "Desconocido", sx/2 - 320*sw, itemY + itemHeight/2, sx/2 - 100*sw, itemY + itemHeight/2, tocolor(255, 255, 255, 255), textScales.items, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
                    
                    -- Matrícula con sombra mejorada
                    drawTextWithShadow(vehInfo.plate or "N/A", sx/2 - 100*sw, itemY + itemHeight/2, sx/2, itemY + itemHeight/2, tocolor(255, 255, 255, 255), textScales.items, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
                    
                    -- Gasolina con sombra mejorada
                    drawTextWithShadow(vehInfo.fuel or "N/A", sx/2 + 100*sw, itemY + itemHeight/2, sx/2 + 200*sw, itemY + itemHeight/2, tocolor(255, 255, 255, 255), textScales.items, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
                    
                    -- Icono de disponibilidad con tamaño mejorado
                    local statusImage = vehInfo.inUse and imagePaths.notAvailable or imagePaths.available
                    dxDrawImage(sx/2 + 280*sw, itemY + itemHeight/2 - 15*sh, 30*sw, 30*sh, statusImage, 0, 0, 0, tocolor(255, 255, 255, 255))
                    
                    -- Texto de estado (ajustado para que sea más grande)
                    local statusText = vehInfo.inUse and "En uso" or "Libre"
                    local statusColor = vehInfo.inUse and tocolor(255, 80, 80, 255) or tocolor(80, 255, 80, 255)
                    -- Aumentamos el tamaño del texto y lo movemos más a la derecha
                    local statusScale = textScales.items * 0.9
                    drawTextWithShadow(statusText, sx/2 + 320*sw, itemY + itemHeight/2, sx/2 + 320*sw, itemY + itemHeight/2, statusColor, statusScale, "default-bold", "left", "center", 2, tocolor(0, 0, 0, 200), 1)
                else
                    -- Mensaje de vehículo no disponible con sombra mejorada
                    drawTextWithShadow("Vehículo no disponible", sx/2, itemY + itemHeight/2, sx/2, itemY + itemHeight/2, tocolor(255, 100, 100, 255), textScales.items, "default-bold", "center", "center", 2, tocolor(0, 0, 0, 200), 1)
                end
                
                -- ID del vehículo en una esquina con mejor visibilidad
                drawTextWithShadow("#" .. tostring(vehID), sx/2 + panelWidth/2 - 70*sw, itemY + 10*sh, sx/2 + panelWidth/2 - 70*sw, itemY + 10*sh, tocolor(200, 200, 200, 230), textScales.vehicleID, "default-bold", "right", "top", 1, tocolor(0, 0, 0, 150), 0.5)
            end
        end
        
        -- Indicadores de scroll si hay más vehículos que los visibles
        if #vehiclesList > maxVisibleItems then
            if scrollOffset > 0 then
                drawTextWithShadow("▲", sx/2, startY - 25*sh, sx/2, startY - 25*sh, tocolor(255, 255, 255, 255), 2.0*sw, "default-bold", "center", "center", 2, tocolor(0, 0, 0, 150), 1)
            end
            
            local lastItemY = startY + maxVisibleItems*(itemHeight + 15*sh) -- Ajustado para el nuevo espaciado
            if scrollOffset + maxVisibleItems < #vehiclesList then
                drawTextWithShadow("▼", sx/2, lastItemY + 15*sh, sx/2, lastItemY + 15*sh, tocolor(255, 255, 255, 255), 2.0*sw, "default-bold", "center", "center", 2, tocolor(0, 0, 0, 150), 1)
            end
        end
    end
    
    -- Área para los botones (ajustada para que queden dentro del panel)
    local lastItemY = startY + maxVisibleItems*(itemHeight + 15*sh) -- Ajustado para el nuevo espaciado
    local buttonY = lastItemY + 40*sh -- Más espacio adicional después de la lista
    
    -- Asegurarse de que los botones queden dentro del panel
    local buttonBottom = buttonY + 60*sh -- Botones más altos
    local panelBottom = sy/2 + panelHeight/2
    
    if buttonBottom > panelBottom - 30*sh then
        buttonY = panelBottom - 90*sh -- Ajustar para que queden dentro con margen
    end
    
    -- Botones más grandes y con colores más intensos
    local buttonWidth = 220*sw -- Botones más anchos
    local buttonHeight = 60*sh -- Botones más altos
    
    -- Botón Regenerar Vehículo con efecto mejorado y nuevo color
    dxDrawImage(sx/2 - 250*sw, buttonY, buttonWidth, buttonHeight, imagePaths.button, 0, 0, 0, buttonColors.regenerar)
    drawTextWithShadow("Regenerar Vehículo", sx/2 - 140*sw, buttonY + buttonHeight/2, sx/2 - 140*sw, buttonY + buttonHeight/2, tocolor(255, 255, 255, 255), textScales.buttons, "default-bold", "center", "center", 2, tocolor(0, 0, 0, 200), 1)
    
    -- Botón Sacar Vehículo con efecto mejorado y nuevo color
    dxDrawImage(sx/2 + 50*sw, buttonY, buttonWidth, buttonHeight, imagePaths.button, 0, 0, 0, buttonColors.sacar)
    drawTextWithShadow("Sacar Vehículo", sx/2 + 160*sw, buttonY + buttonHeight/2, sx/2 + 160*sw, buttonY + buttonHeight/2, tocolor(255, 255, 255, 255), textScales.buttons, "default-bold", "center", "center", 2, tocolor(0, 0, 0, 200), 1)
    
    -- Reemplazamos el botón grande de actualizar por un pequeño icono de actualización
    local refreshIconSize = 30*sw
    local refreshIconX = sx/2 + panelWidth/2 - 60*sw
    local refreshIconY = sy/2 - panelHeight/2 + 20*sh
    
    -- Dibujar un pequeño círculo como botón de actualización
    dxDrawRectangle(refreshIconX, refreshIconY, refreshIconSize, refreshIconSize, tocolor(0, 0, 0, 100))
    
    -- Añadir un efecto de rotación al icono de actualización
    local rotation = (getTickCount() % 3600) / 10
    if isTimer(forceRefreshTimer) and (getTickCount() - lastRefreshTime) < 1000 then
        -- Si se está actualizando, mostrar un color más brillante
        dxDrawText("↻", refreshIconX, refreshIconY, refreshIconX + refreshIconSize, refreshIconY + refreshIconSize, tocolor(255, 255, 255, 255), 1.2*sw, "default-bold", "center", "center", false, false, false, false, false, rotation)
    else
        -- Color normal
        dxDrawText("↻", refreshIconX, refreshIconY, refreshIconX + refreshIconSize, refreshIconY + refreshIconSize, tocolor(255, 255, 255, 200), 1.2*sw, "default-bold", "center", "center")
    end
    
    -- Mostrar tiempo desde la última actualización
    local timeSinceRefresh = math.floor((getTickCount() - lastRefreshTime) / 1000)
    local refreshText = "Auto: " .. (timeSinceRefresh < 60 and (timeSinceRefresh .. "s") or (math.floor(timeSinceRefresh/60) .. "m"))
    drawTextWithShadow(refreshText, refreshIconX - 5*sw, refreshIconY + refreshIconSize/2, refreshIconX - 5*sw, refreshIconY + refreshIconSize/2, tocolor(200, 200, 200, 150), 0.8*sw, "default-bold", "right", "center", 1, tocolor(0, 0, 0, 100), 0.5)
end

-- Función para manejar clics del mouse
function handleClick(button, state)
    if not panelVisible or button ~= "left" or state ~= "down" then return end
    
    local panelWidth = 900*sw
    local panelHeight = 750*sh
    local headerY = sy/2 - panelHeight/2 + 180*sh
    local startY = headerY + 30*sh
    
    -- Botones más grandes
    local buttonWidth = 220*sw
    local buttonHeight = 60*sh
    
    -- Calcular la posición de los botones
    local lastItemY = startY + maxVisibleItems*(itemHeight + 15*sh) -- Ajustado para el nuevo espaciado
    local buttonY = lastItemY + 40*sh
    
    -- Asegurarse de que los botones queden dentro del panel
    local buttonBottom = buttonY + buttonHeight
    local panelBottom = sy/2 + panelHeight/2
    
    if buttonBottom > panelBottom - 30*sh then
        buttonY = panelBottom - 90*sh
    end
    
    -- Verificar clic en el pequeño botón de actualización
    local refreshIconSize = 30*sw
    local refreshIconX = sx/2 + panelWidth/2 - 60*sw
    local refreshIconY = sy/2 - panelHeight/2 + 20*sh
    
    if isMouseInPosition(refreshIconX, refreshIconY, refreshIconSize, refreshIconSize) then
        forceRefreshAllVehicles()
        return
    end
    
    -- Verificar clic en los vehículos con áreas de clic mejoradas
    for i = 1, maxVisibleItems do
        local index = i + scrollOffset
        if index <= #vehiclesList then
            local itemY = startY + (i-1)*(itemHeight + 15*sh) -- Ajustado para el nuevo espaciado
            
            -- Área de clic para todo el ítem
            if isMouseInPosition(sx/2 - panelWidth/2 + 50*sw, itemY, panelWidth - 100*sw, itemHeight) then
                selectedVehicle = index
                return
            end
        end
    end

    -- Verificar clic en el botón Regenerar Vehículo (área ajustada para botones más grandes)
    if isMouseInPosition(sx/2 - 250*sw, buttonY, buttonWidth, buttonHeight) then
        if selectedVehicle and selectedVehicle > 0 and selectedVehicle <= #vehiclesList then
            local vehID = vehiclesList[selectedVehicle]
            
            -- Verificar si el vehículo está en uso antes de intentar regenerarlo
            local vehInfo = vehiclesInfo[tostring(vehID)]
            if vehInfo and vehInfo.inUse then
                outputChatBox("No se puede regenerar un vehículo que está en uso.", 255, 0, 0)
                return
            end
            
            -- Enviar evento al servidor para regenerar el vehículo
            triggerServerEvent("regenerarVehiculoFaccion", localPlayer, vehID)
            outputChatBox("Solicitando regeneración del vehículo #" .. vehID .. "...", 0, 255, 0)
            
            -- Actualizar la información después de un breve retraso
            setTimer(function()
                triggerServerEvent("requestVehicleInfo", localPlayer, vehID)
            end, 2000, 1)
        else
            outputChatBox("Selecciona un vehículo primero.", 255, 0, 0)
        end
        return
    end
    
    -- Verificar clic en el botón Sacar Vehículo (área ajustada para botones más grandes)
    if isMouseInPosition(sx/2 + 50*sw, buttonY, buttonWidth, buttonHeight) then
        if selectedVehicle and selectedVehicle > 0 and selectedVehicle <= #vehiclesList then
            local vehID = vehiclesList[selectedVehicle]
            
            -- Verificar si el vehículo está en uso antes de intentar sacarlo
            local vehInfo = vehiclesInfo[tostring(vehID)]
            if vehInfo and vehInfo.inUse then
                outputChatBox("No se puede sacar un vehículo que está en uso.", 255, 0, 0)
                return
            end
            
            -- Enviar evento al servidor para sacar el vehículo
            triggerServerEvent("pedirvehf", localPlayer, vehID)
            outputChatBox("Solicitando vehículo #" .. vehID .. "...", 0, 255, 0)
            closePanel()
        else
            outputChatBox("Selecciona un vehículo primero.", 255, 0, 0)
        end
        return
    end
    
    -- Verificar clic fuera del panel para cerrarlo
    if not isMouseInPosition(sx/2 - panelWidth/2, sy/2 - panelHeight/2, panelWidth, panelHeight) then
        closePanel()
    end
end

-- Función para manejar teclas
function handleKey(button, press)
    if not panelVisible or not press then return end
    
    if button == "mouse_wheel_up" then
        if scrollOffset > 0 then
            scrollOffset = scrollOffset - 1
        end
        return true
    elseif button == "mouse_wheel_down" then
        if scrollOffset + maxVisibleItems < #vehiclesList then
            scrollOffset = scrollOffset + 1
        end
        return true
    elseif button == "escape" or button == "delete" or button == "backspace" then
        closePanel()
        return true
    elseif button == "r" then
        -- Tecla R para actualizar la información
        forceRefreshAllVehicles()
        return true
    end
end

-- Función auxiliar para verificar si el mouse está en una posición
function isMouseInPosition(x, y, width, height)
    local mouseX, mouseY = getCursorPosition()
    if not mouseX then return false end
    
    mouseX, mouseY = mouseX * sx, mouseY * sy
    return (mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height)
end

-- Evento para recibir la información actualizada de un vehículo
addEvent("receiveVehicleInfo", true)
addEventHandler("receiveVehicleInfo", root, function(vehID, vehInfo)
    if vehID and vehInfo then
        vehiclesInfo[tostring(vehID)] = vehInfo
    end
end)

-- Evento para recibir la lista de vehículos desde el servidor
addEvent("showFactionVehiclesPanel", true)
addEventHandler("showFactionVehiclesPanel", root, function(vehicles, faction, vehInfo)
    showPanel(vehicles, faction, vehInfo)
end)

-- Evento para recibir actualizaciones masivas de vehículos
addEvent("receiveAllVehiclesInfo", true)
addEventHandler("receiveAllVehiclesInfo", root, function(allVehInfo)
    if not allVehInfo then return end
    
    for vehID, vehInfo in pairs(allVehInfo) do
        vehiclesInfo[tostring(vehID)] = vehInfo
    end
    
    lastRefreshTime = getTickCount()
    -- Eliminamos el mensaje de actualización para evitar spam
end)

-- Evento para detectar cuando el jugador sale de un vehículo
addEventHandler("onClientVehicleExit", root, function(player)
    if player ~= localPlayer then return end
    
    -- Actualizar la información después de un breve retraso
    setTimer(function()
        if panelVisible and #vehiclesList > 0 then
            -- Forzar una actualización completa
            forceRefreshAllVehicles()
        end
    end, 1000, 1)
end)

-- Comando para abrir el panel de vehículos de facción
addCommandHandler("panelvehfaccion", function()
    triggerServerEvent("sacarvehfaccion", localPlayer)
end)
