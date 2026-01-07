--[[
==============================================
SISTEMA DE TRABAJO COMUNITARIO - CLIENTE OPTIMIZADO
==============================================
Copyright (c) 2025 Community Service System
Versión de producción optimizada

Funcionalidades:
- HUD principal centrado inferior responsive
- Barra de progreso pequeña al lado del personaje
- Sistema de zona visual optimizado
- Interfaz adaptable a todas las resoluciones
==============================================
]]

-- ===================================
-- VARIABLES GLOBALES OPTIMIZADAS
-- ===================================

local isInCommunityService = false
local workZoneData = nil
local trashPending = 0
local totalTrash = 0
local showHUD = false

local isCollecting = false
local collectionStartTime = 0
local collectionDuration = 5000
local showCollectionBar = false

local workZoneBlip = nil
local workZoneMarker = nil
local hudFont = nil

-- ===================================
-- FUNCIONES DE ESCALADO RESPONSIVE
-- ===================================

local function getScaleFactor()
    local screenW, screenH = guiGetScreenSize()
    local scaleX = screenW / 1920
    local scaleY = screenH / 1080
    return math.min(scaleX, scaleY)
end

local function scale(value)
    return value * getScaleFactor()
end

-- ===================================
-- CONFIGURACIÓN DE INTERFAZ
-- ===================================

local function getMainHUDConfig()
    local screenW, screenH = guiGetScreenSize()
    local width = scale(350)
    local height = scale(100)
    
    return {
        x = (screenW - width) / 2,
        y = screenH - height - scale(50),
        width = width,
        height = height,
        bgColor = {0, 0, 0, 160},
        borderColor = {40, 120, 200},
        textColor = {255, 255, 255},
        titleColor = {255, 200, 50},
        progressColor = {50, 200, 50},
        warningColor = {255, 100, 100}
    }
end

local function getProgressBarConfig()
    return {
        offsetX = scale(30),
        offsetY = scale(-60),
        width = scale(120),
        height = scale(20),
        bgColor = {0, 0, 0, 180},
        barColor = {0, 150, 255},
        textColor = {255, 255, 255},
        borderColor = {255, 255, 255}
    }
end

-- ===================================
-- FUNCIONES DE INTERFAZ
-- ===================================

local function initializeFonts()
    hudFont = dxCreateFont("default-bold", scale(10))
    if not hudFont then
        hudFont = "default-bold"
    end
end

local function drawCommunityServiceHUD()
    if not showHUD or not isInCommunityService then return end
    
    local config = getMainHUDConfig()
    local x, y, w, h = config.x, config.y, config.width, config.height
    
    -- Fondo con bordes
    dxDrawRectangle(x, y, w, h, tocolor(unpack(config.bgColor)), false)
    dxDrawRectangle(x-2, y-2, w+4, h+4, tocolor(unpack(config.borderColor), 100), false)
    dxDrawRectangle(x, y, w, 2, tocolor(unpack(config.borderColor), 180), false)
    
    -- Título
    dxDrawText("TRABAJO COMUNITARIO", x, y + scale(8), x + w, y + scale(25), 
              tocolor(unpack(config.titleColor)), scale(1.1), hudFont, "center", "top", false, false, false, true)
    
    -- Información de progreso
    local progressText = string.format("Basuras pendientes: %d/%d", trashPending, totalTrash)
    dxDrawText(progressText, x, y + scale(30), x + w, y + scale(50), 
              tocolor(unpack(config.textColor)), scale(1.0), hudFont, "center", "center", false, false, false, true)
    
    -- Barra de progreso (clamp 0..1)
    local progressPercent = totalTrash > 0 and (totalTrash - trashPending) / totalTrash or 0
    if progressPercent < 0 then progressPercent = 0 end
    if progressPercent > 1 then progressPercent = 1 end
    
    local barX, barY = x + scale(20), y + scale(55)
    local barW, barH = w - scale(40), scale(12)
    
    dxDrawRectangle(barX-1, barY-1, barW+2, barH+2, tocolor(255, 255, 255, 100), false)
    dxDrawRectangle(barX, barY, barW, barH, tocolor(30, 30, 30, 200), false)
    
    local progressW = barW * progressPercent
    local barColor = progressPercent >= 0.7 and config.progressColor or 
                    progressPercent >= 0.3 and {200, 200, 50} or config.warningColor
    
    if progressW > 0 then
        dxDrawRectangle(barX, barY, progressW, barH, tocolor(unpack(barColor), 220), false)
        dxDrawRectangle(barX, barY, progressW, barH/3, tocolor(unpack(barColor), 100), false)
    end
    
    local percentText = string.format("%.1f%%", progressPercent * 100)
    dxDrawText(percentText, barX, barY + scale(15), barX + barW, barY + scale(35), 
              tocolor(255, 255, 255), scale(0.9), hudFont, "center", "top", false, false, false, true)
    
    dxDrawText("Presiona F cerca de las bolsas de basura", x, y + scale(78), x + w, y + h, 
              tocolor(200, 200, 200), scale(0.8), hudFont, "center", "center", false, false, false, true)
end

local function drawCollectionProgressBar()
    if not showCollectionBar or not isCollecting then return end
    
    local px, py, pz = getElementPosition(localPlayer)
    local screenX, screenY = getScreenFromWorldPosition(px, py, pz + 1)
    
    if not screenX or not screenY then return end
    
    local elapsed = getTickCount() - collectionStartTime
    local progress = math.min(elapsed / collectionDuration, 1.0)
    
    local config = getProgressBarConfig()
    local x = screenX + config.offsetX
    local y = screenY + config.offsetY
    local w, h = config.width, config.height
    
    -- Ajustar si sale de pantalla
    local screenW, screenH = guiGetScreenSize()
    if x + w > screenW then x = screenW - w - scale(10) end
    if x < 0 then x = scale(10) end
    if y < 0 then y = scale(10) end
    if y + h > screenH then y = screenH - h - scale(10) end
    
    -- Dibujar barra
    dxDrawRectangle(x+2, y+2, w, h, tocolor(0, 0, 0, 100), false) -- Sombra
    dxDrawRectangle(x, y, w, h, tocolor(unpack(config.bgColor)), false)
    dxDrawRectangle(x-1, y-1, w+2, h+2, tocolor(unpack(config.borderColor), 150), false)
    
    local progressWidth = (w - scale(4)) * progress
    if progressWidth > 0 then
        dxDrawRectangle(x + scale(2), y + scale(2), progressWidth, h - scale(4), tocolor(unpack(config.barColor), 200), false)
        dxDrawRectangle(x + scale(2), y + scale(2), progressWidth, scale(3), tocolor(255, 255, 255, 80), false)
    end
    
    local progressText = "Recolectando " .. string.format("%.0f%%", progress * 100)
    dxDrawText(progressText, x, y + scale(2), x + w, y + h - scale(2), 
              tocolor(unpack(config.textColor)), scale(0.8), hudFont, "center", "center", false, false, false, true)
end

-- ===================================
-- FUNCIONES DE MARCADORES
-- ===================================

local function destroyWorkZoneMarkers()
    if workZoneMarker and isElement(workZoneMarker) then
        destroyElement(workZoneMarker)
        workZoneMarker = nil
    end
    
    if workZoneBlip and isElement(workZoneBlip) then
        destroyElement(workZoneBlip)
        workZoneBlip = nil
    end
end

local function createWorkZoneMarkers(zoneData)
    if not zoneData then return end
    
    destroyWorkZoneMarkers()
    
    local markerSize = zoneData.radius or 70.0
    workZoneMarker = createMarker(zoneData.x, zoneData.y, zoneData.z - 1, "cylinder", markerSize, 255, 255, 0, 50)
    workZoneBlip = createBlip(zoneData.x, zoneData.y, zoneData.z, 38, 2, 255, 255, 0)
    
    if workZoneBlip and setBlipVisibleDistance then
        setBlipVisibleDistance(workZoneBlip, 300)
    end
end

-- ===================================
-- FUNCIONES DE GESTIÓN DE ESTADO
-- ===================================

local function pickupTrashKey()
    if not isInCommunityService then return end
    if isCollecting then
        outputChatBox("Ya estas recogiendo basura. Espera a terminar.", 255, 200, 0)
        return
    end
    
    triggerServerEvent("communityService:pickupTrash", localPlayer, localPlayer)
end

local function initializeCommunityService(zoneData, pendingTrash, totalCount)
    if isInCommunityService then
        trashPending = pendingTrash or 0
        totalTrash = totalCount or pendingTrash or 0
        workZoneData = zoneData
        return
    end
    
    workZoneData = zoneData
    trashPending = pendingTrash or 0
    totalTrash = totalCount or pendingTrash or 0
    isInCommunityService = true
    showHUD = true
    
    createWorkZoneMarkers(zoneData)
    
    removeEventHandler("onClientRender", root, drawCommunityServiceHUD)
    addEventHandler("onClientRender", root, drawCommunityServiceHUD)
    
    unbindKey("f", "down", pickupTrashKey)
    bindKey("f", "down", pickupTrashKey)
    
    outputChatBox("Interfaz de trabajo comunitario activada", 100, 255, 100)
    outputChatBox("Presiona F cerca de una bolsa de basura para recogerla", 255, 255, 0)
end

local function updateTrashProgress(newPendingCount)
    local oldPendingCount = trashPending
    trashPending = newPendingCount
    
    if newPendingCount < oldPendingCount then
        local progressPercent = totalTrash > 0 and ((totalTrash - trashPending) / totalTrash) * 100 or 0
        if progressPercent < 0 then progressPercent = 0 end
        if progressPercent > 100 then progressPercent = 100 end
        outputChatBox(string.format("Progreso: %.1f%% (%d basuras restantes)", progressPercent, trashPending), 100, 255, 255)
    end
end

local function finishCommunityService()
    isInCommunityService = false
    showHUD = false
    
    removeEventHandler("onClientRender", root, drawCommunityServiceHUD)
    unbindKey("f", "down", pickupTrashKey)
    
    if isCollecting then
        isCollecting = false
        showCollectionBar = false
        removeEventHandler("onClientRender", root, drawCollectionProgressBar)
    end
    
    destroyWorkZoneMarkers()
    
    outputChatBox("Trabajo comunitario completado!", 100, 255, 100)
    
    workZoneData = nil
    trashPending = 0
    totalTrash = 0
    collectionStartTime = 0
end

-- ===================================
-- EVENTOS DE SERVIDOR
-- ===================================

local function onCommunityServiceInitialize(zoneData, pendingTrash, totalCount)
    local totalFromServer = totalCount or getElementData(localPlayer, "trash_total")
    local total = totalFromServer or pendingTrash
    initializeCommunityService(zoneData, pendingTrash, total)
end

local function onCommunityServiceUpdateTrash(newCount)
    updateTrashProgress(newCount)
end

local function onCommunityServiceFinish()
    finishCommunityService()
end

local function onStartCollection(duration)
    collectionDuration = duration or 5000
    collectionStartTime = getTickCount()
    isCollecting = true
    showCollectionBar = true
    
    addEventHandler("onClientRender", root, drawCollectionProgressBar)
end

local function onFinishCollection()
    isCollecting = false
    showCollectionBar = false
    
    removeEventHandler("onClientRender", root, drawCollectionProgressBar)
end

local function onCancelCollection()
    isCollecting = false
    showCollectionBar = false
    
    removeEventHandler("onClientRender", root, drawCollectionProgressBar)
    outputChatBox("Recoleccion cancelada", 255, 200, 0)
end

-- ===================================
-- COMANDO ESENCIAL PARA JUGADORES
-- ===================================

local function toggleCommunityServiceHUD()
    if not isInCommunityService then
        outputChatBox("ERROR: No estas en trabajo comunitario.", 255, 100, 100)
        return
    end
    
    showHUD = not showHUD
    
    if showHUD then
        outputChatBox("[OK] HUD de trabajo comunitario activado", 100, 255, 100)
        removeEventHandler("onClientRender", root, drawCommunityServiceHUD)
        addEventHandler("onClientRender", root, drawCommunityServiceHUD)
    else
        outputChatBox("HUD de trabajo comunitario desactivado", 255, 200, 0)
        removeEventHandler("onClientRender", root, drawCommunityServiceHUD)
    end
end

-- ===================================
-- INICIALIZACIÓN Y FINALIZACIÓN
-- ===================================

addEventHandler("onClientResourceStart", resourceRoot, function()
    initializeFonts()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    destroyWorkZoneMarkers()
    
    if isInCommunityService then
        removeEventHandler("onClientRender", root, drawCommunityServiceHUD)
    end
    
    if isCollecting then
        removeEventHandler("onClientRender", root, drawCollectionProgressBar)
    end
    
    if hudFont and hudFont ~= "default-bold" and isElement(hudFont) then
        destroyElement(hudFont)
    end
end)

-- ===================================
-- EVENTOS DE ELEMENT DATA
-- ===================================

addEventHandler("onClientElementDataChange", localPlayer, function(dataName, oldValue)
    if dataName == "community_service" then
        local newValue = getElementData(source, dataName)
        if newValue and not isInCommunityService then
            local pendingTrash = getElementData(localPlayer, "trash_pending") or 0
            if pendingTrash > 0 then
                -- El servidor enviará communityService:initialize
            end
        elseif not newValue and isInCommunityService then
            finishCommunityService()
        end
    elseif dataName == "trash_pending" and isInCommunityService then
        local newCount = getElementData(source, dataName) or 0
        updateTrashProgress(newCount)
    end
end)

-- ===================================
-- REGISTRAR EVENTOS DE SERVIDOR
-- ===================================

addEvent("communityService:initialize", true)
addEventHandler("communityService:initialize", localPlayer, onCommunityServiceInitialize)

addEvent("communityService:updateTrash", true)
addEventHandler("communityService:updateTrash", localPlayer, onCommunityServiceUpdateTrash)

addEvent("communityService:finish", true)
addEventHandler("communityService:finish", localPlayer, onCommunityServiceFinish)

addEvent("communityService:startCollection", true)
addEventHandler("communityService:startCollection", localPlayer, onStartCollection)

addEvent("communityService:finishCollection", true)
addEventHandler("communityService:finishCollection", localPlayer, onFinishCollection)

addEvent("communityService:cancelCollection", true)
addEventHandler("communityService:cancelCollection", localPlayer, onCancelCollection)

-- ===================================
-- REGISTRAR COMANDOS ESENCIALES
-- ===================================

addCommandHandler("togglehud", toggleCommunityServiceHUD)
addCommandHandler("comunitariahud", toggleCommunityServiceHUD)
