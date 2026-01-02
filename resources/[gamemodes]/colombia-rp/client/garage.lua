-- Sistema de Garaje - Cliente
-- Panel para ver y pedir vehículos

local screenW, screenH = guiGetScreenSize()
local garagePanel = nil
local garageListGrid = nil

-- Función para abrir el panel del garaje
addEvent("garage:openPanel", true)
addEventHandler("garage:openPanel", root, function(vehicles)
    -- Cerrar panel anterior si existe
    if garagePanel and isElement(garagePanel) then
        destroyElement(garagePanel)
    end
    
    local windowWidth = 700
    local windowHeight = 500
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2
    
    garagePanel = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Mi Garaje", false)
    guiWindowSetSizable(garagePanel, false)
    
    -- Label informativo
    local labelInfo = guiCreateLabel(10, 30, windowWidth - 20, 20, "Selecciona un vehículo y presiona 'Pedir Vehículo' (Costo: $10,000,000)", false, garagePanel)
    guiLabelSetHorizontalAlign(labelInfo, "center", false)
    guiSetFont(labelInfo, "default-bold")
    
    -- Grid list para vehículos
    garageListGrid = guiCreateGridList(10, 60, windowWidth - 20, 350, false, garagePanel)
    guiGridListAddColumn(garageListGrid, "ID", 0.08)
    guiGridListAddColumn(garageListGrid, "Vehículo", 0.35)
    guiGridListAddColumn(garageListGrid, "Matrícula", 0.15)
    guiGridListAddColumn(garageListGrid, "Combustible", 0.12)
    guiGridListAddColumn(garageListGrid, "Estado", 0.15)
    
    -- Cargar vehículos en el grid
    for _, vehicleData in ipairs(vehicles) do
        local row = guiGridListAddRow(garageListGrid)
        local vehicleName = getVehicleNameFromModel(vehicleData.model) or "Vehículo " .. vehicleData.model
        local fuelText = string.format("%.0f%%", vehicleData.fuel or 100)
        local lockedText = (vehicleData.locked == 1) and "Bloqueado" or "Desbloqueado"
        
        guiGridListSetItemText(garageListGrid, row, 1, tostring(vehicleData.id), false, false)
        guiGridListSetItemText(garageListGrid, row, 2, vehicleName, false, false)
        guiGridListSetItemText(garageListGrid, row, 3, vehicleData.plate or "N/A", false, false)
        guiGridListSetItemText(garageListGrid, row, 4, fuelText, false, false)
        guiGridListSetItemText(garageListGrid, row, 5, lockedText, false, false)
        
        -- Guardar el ID del vehículo en los datos de la fila
        guiGridListSetItemData(garageListGrid, row, 1, vehicleData.id)
    end
    
    -- Botones
    local requestBtn = guiCreateButton(10, 420, 200, 35, "Pedir Vehículo ($10,000,000)", false, garagePanel)
    local cancelBtn = guiCreateButton(220, 420, 200, 35, "Cerrar", false, garagePanel)
    
    -- Eventos
    addEventHandler("onClientGUIClick", requestBtn, function()
        local row = guiGridListGetSelectedItem(garageListGrid)
        if row and row >= 0 then
            local vehicleId = guiGridListGetItemData(garageListGrid, row, 1)
            if vehicleId then
                -- Enviar solicitud al servidor
                triggerServerEvent("garage:requestVehicle", localPlayer, vehicleId)
                destroyElement(garagePanel)
                garagePanel = nil
                garageListGrid = nil
                showCursor(false)
            else
                outputChatBox("Error al obtener el ID del vehículo.", 255, 0, 0)
            end
        else
            outputChatBox("Selecciona un vehículo de la lista.", 255, 255, 0)
        end
    end, false)
    
    addEventHandler("onClientGUIClick", cancelBtn, function()
        destroyElement(garagePanel)
        garagePanel = nil
        garageListGrid = nil
        showCursor(false)
    end, false)
    
    showCursor(true)
end)
