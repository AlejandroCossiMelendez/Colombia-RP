--[[
==============================================
SISTEMA DE TRABAJO COMUNITARIO - SERVIDOR OPTIMIZADO
==============================================
Copyright (c) 2025 Community Service System
Versión de producción optimizada y segura

Comandos esenciales:
- /comunitaria <jugador> <basuras> <razón> (asignar)
- /vercomunitaria [jugador] (verificar estado)
- /restaurarcomunitaria <jugador> (anti-evasión)
- /listarcomunitarias (detectar evasiones)
==============================================
]]

-- ===================================
-- CONFIGURACIÓN OPTIMIZADA
-- ===================================

local WORK_ZONE = {
    x = 1477.8916015625,
    y = -1659.0888671875, 
    z = 13.53955078125,
    radius = 70.0,
    name = "Zona de Trabajo Comunitario"
}

local TRASH_POSITIONS = {
    {1467.8310546875, -1615.58984375, 13.53955078125},
    {1452.7470703125, -1632.0791015625, 13.53955078125},
    {1489.173828125, -1632.2451171875, 13.53955078125},
    {1508.1015625, -1631.7490234375, 13.53955078125},
    {1508.435546875, -1686.1845703125, 13.53955078125},
    {1489.23828125, -1686.4423828125, 13.53955078125},
    {1452.34765625, -1686.408203125, 13.53955078125},
    {1489.5, -1703.6005859375, 13.53955078125},
    {1469.5341796875, -1711.2470703125, 13.35205078125},
    {1475.5, -1659.458984375, 13.53955078125},
    {1453.1103515625, -1620.26171875, 13.35205078125},
    {1499.9345703125, -1619.5791015625, 13.35205078125}
}

local CONFIG = {
    MIN_TRASH_COUNT = 1,
    MAX_TRASH_COUNT = 100,
    ESCAPE_PENALTY = 2,
    MAX_TRASH_OBJECTS = 12,
    COMPLETION_GRACE_MS = 30000
}

-- Variables globales optimizadas
local trashObjects = {}
local playersInService = {}
local workZoneShape = nil
local usedTrashPositions = {}
local playersCollecting = {}
local recentlyCompletedByUserId = {}

local function isInGraceWindow(player)
    if not exports.players then return false end
    local userID = exports.players:getUserID(player)
    if not userID then return false end
    local expiry = recentlyCompletedByUserId[userID]
    return expiry and expiry > getTickCount()
end

-- ===================================
-- FUNCIONES DE BASE DE DATOS
-- ===================================

local function checkCommunityServiceStatus(player)
    if not exports.players or not exports.sql then return false end
    
    local userID = exports.players:getUserID(player)
    if not userID then return false end
    
    local query = "SELECT * FROM community_service WHERE userID = %d AND activo = 1"
    local result, error = exports.sql:query_assoc_single(query, userID)
    
    return result or false
end

local function createCommunityService(targetPlayer, trashCount, reason, staffPlayer)
    local userID = exports.players:getUserID(targetPlayer)
    local account = getAccountName(getPlayerAccount(targetPlayer))
    local serial = getPlayerSerial(targetPlayer)
    local staffID = exports.players:getUserID(staffPlayer)
    local staffName = getPlayerName(staffPlayer)
    
    if not userID then 
        return false, "No se pudo obtener el ID del jugador"
    end
    
    local existing = checkCommunityServiceStatus(targetPlayer)
    
    if existing then
        local newTotal = existing.basuras_pendientes + trashCount
        local query = "UPDATE community_service SET basuras_pendientes = %d, basuras_totales = basuras_totales + %d, razon = CONCAT(razon, ' | %s') WHERE id = %d"
        local success = exports.sql:query_free(query, newTotal, trashCount, reason, existing.id)
        
        if success then
            return true, "Sanción actualizada. Total de basuras: " .. newTotal
        else
            return false, "Error al actualizar la sanción existente"
        end
    else
        local query = "INSERT INTO community_service (account, serial, userID, basuras_pendientes, basuras_totales, razon, activo, staff_id, staff_nombre) VALUES ('%s', '%s', %d, %d, %d, '%s', 1, %d, '%s')"
        local insertID = exports.sql:query_insertid(query, account, serial, userID, trashCount, trashCount, reason, staffID or -1, staffName or "Sistema")
        
        if insertID then
            return true, "Nueva sanción comunitaria creada. ID: " .. insertID
        else
            return false, "Error al crear la sanción en la base de datos"
        end
    end
end

local function updateTrashCount(player, newCount)
    local userID = exports.players:getUserID(player)
    if not userID then return false end
    
    local safeCount = newCount
    if safeCount < 0 then safeCount = 0 end
    local query = "UPDATE community_service SET basuras_pendientes = %d WHERE userID = %d AND activo = 1"
    return exports.sql:query_free(query, safeCount, userID)
end

local function completeCommunityServiceDB(player)
    local userID = exports.players:getUserID(player)
    if not userID then return false end
    
    local x, y, z = getElementPosition(player)
    local query = "UPDATE community_service SET activo = 0, fecha_completado = NOW(), posicion_x = %f, posicion_y = %f, posicion_z = %f WHERE userID = %d AND activo = 1"
    return exports.sql:query_free(query, x, y, z, userID)
end

-- ===================================
-- FUNCIONES DE GESTIÓN DE JUGADORES
-- ===================================

local function initializeCommunityService(player)
    if playersInService[player] then return end
    
    local serviceData = checkCommunityServiceStatus(player)
    if not serviceData then return end
    if tonumber(serviceData.basuras_pendientes) and serviceData.basuras_pendientes <= 0 then
        completeCommunityServiceDB(player)
        return
    end
    
    playersInService[player] = {
        trashPending = serviceData.basuras_pendientes,
        trashTotal = serviceData.basuras_totales,
        reason = serviceData.razon,
        startTime = getRealTime().timestamp
    }
    
    setElementData(player, "community_service", true)
    setElementData(player, "trash_pending", serviceData.basuras_pendientes)
    setElementData(player, "trash_total", serviceData.basuras_totales)
    
    setElementPosition(player, WORK_ZONE.x, WORK_ZONE.y, WORK_ZONE.z)
    setElementRotation(player, 0, 0, 0)
    
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    outputChatBox("[TRABAJO COMUNITARIO ACTIVO]", player, 255, 100, 100)
    outputChatBox("Basuras pendientes: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
    outputChatBox("Razon: " .. (serviceData.razon or "No especificada"), player, 255, 255, 255)
    outputChatBox("Zona: " .. WORK_ZONE.name, player, 255, 255, 255)
    outputChatBox("ATENCION: NO salgas de la zona marcada o se anadiran mas basuras", player, 255, 200, 0)
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    
    triggerClientEvent(player, "communityService:initialize", player, WORK_ZONE, serviceData.basuras_pendientes, serviceData.basuras_totales)
end

local function removeCommunityService(player)
    if playersInService[player] then
        playersInService[player] = nil
    end
    
    setElementData(player, "community_service", false)
    setElementData(player, "trash_pending", 0)
    
    triggerClientEvent(player, "communityService:finish", player)

    if exports.players then
        local userID = exports.players:getUserID(player)
        if userID then
            recentlyCompletedByUserId[userID] = getTickCount() + CONFIG.COMPLETION_GRACE_MS
        end
    end
end

-- ===================================
-- FUNCIONES DE ZONA DE TRABAJO
-- ===================================

local function createWorkZone()
    if workZoneShape then
        destroyElement(workZoneShape)
    end
    
    workZoneShape = createColSphere(WORK_ZONE.x, WORK_ZONE.y, WORK_ZONE.z, WORK_ZONE.radius)
    
    if workZoneShape then
        addEventHandler("onColShapeLeave", workZoneShape, function(element, matchingDimension)
            if not matchingDimension or not isElement(element) then return end
            if getElementType(element) ~= "player" then return end
            if not playersInService[element] then return end
            local player = element
            
            local currentTrash = playersInService[player].trashPending
            local newTrash = currentTrash + CONFIG.ESCAPE_PENALTY
            
            updateTrashCount(player, newTrash)
            playersInService[player].trashPending = newTrash
            setElementData(player, "trash_pending", newTrash)
            
            setElementPosition(player, WORK_ZONE.x, WORK_ZONE.y, WORK_ZONE.z)
            
            outputChatBox("ATENCION: Has salido de la zona de trabajo!", player, 255, 100, 100)
            outputChatBox("PENALIZACION: +" .. CONFIG.ESCAPE_PENALTY .. " basuras adicionales", player, 255, 50, 50)
            outputChatBox("Basuras pendientes: " .. newTrash, player, 255, 255, 0)
            outputChatBox("Has sido devuelto a la zona de trabajo.", player, 255, 255, 0)
            
            triggerClientEvent(player, "communityService:updateTrash", player, newTrash)
            
            if playersCollecting[player] then
                local data = playersCollecting[player]
                if data and data.trashData then
                    data.trashData.reservedBy = nil
                end
                playersCollecting[player] = nil
                setPedAnimation(player, false)
                triggerClientEvent(player, "communityService:cancelCollection", player)
            end
        end)
    end
end

-- ===================================
-- FUNCIONES DE OBJETOS DE BASURA
-- ===================================

local function createTrashObject()
    if #trashObjects >= CONFIG.MAX_TRASH_OBJECTS then return end
    
    local availablePositions = {}
    for i = 1, #TRASH_POSITIONS do
        if not usedTrashPositions[i] then
            table.insert(availablePositions, i)
        end
    end
    
    if #availablePositions == 0 then return end
    
    local selectedIndex = availablePositions[math.random(#availablePositions)]
    local position = TRASH_POSITIONS[selectedIndex]
    local x, y, z = position[1], position[2], position[3]
    
    local object = createObject(1265, x, y, z)
    
    if object then
        setElementRotation(object, 0, 0, math.random(0, 360))
        usedTrashPositions[selectedIndex] = true
        
        table.insert(trashObjects, {
            object = object,
            x = x, y = y, z = z,
            positionIndex = selectedIndex
        })
    end
end

local function completeTrashCollection(player)
    if not playersCollecting[player] or not playersInService[player] then return end
    
    local collectionData = playersCollecting[player]
    local trashData = collectionData.trashData
    
    setPedAnimation(player, false)
    
    local currentTrash = playersInService[player].trashPending
    local newTrash = currentTrash - 1
    
    updateTrashCount(player, newTrash)
    playersInService[player].trashPending = newTrash
    setElementData(player, "trash_pending", newTrash)
    
    if isElement(trashData.object) then
        destroyElement(trashData.object)
    end
    
    if trashData.positionIndex then
        usedTrashPositions[trashData.positionIndex] = nil
    end
    if trashData then
        trashData.reservedBy = nil
    end
    
    for i = #trashObjects, 1, -1 do
        if trashObjects[i].object == trashData.object then
            table.remove(trashObjects, i)
            break
        end
    end
    
    playersCollecting[player] = nil
    
    outputChatBox("[OK] Basura recogida! Pendientes: " .. newTrash .. "/" .. playersInService[player].trashTotal, player, 100, 255, 100)
    
    triggerClientEvent(player, "communityService:finishCollection", player)
    
    if newTrash <= 0 then
        completeCommunityServiceDB(player)
        removeCommunityService(player)
        
        outputChatBox("═══════════════════════════════════════", player, 0, 255, 0)
        outputChatBox("[TRABAJO COMUNITARIO COMPLETADO]", player, 100, 255, 100)
        outputChatBox("Has terminado tu sancion comunitaria exitosamente.", player, 255, 255, 255)
        outputChatBox("Puedes continuar con tu roleplay normal en esta ubicacion.", player, 255, 255, 255)
        outputChatBox("Tu personaje se mantiene igual y en la misma posicion.", player, 255, 255, 255)
        outputChatBox("═══════════════════════════════════════", player, 0, 255, 0)
        
        setPedAnimation(player, false)
        outputServerLog("[COMMUNITY SERVICE] " .. getPlayerName(player) .. " completó su trabajo comunitario exitosamente")
    else
        triggerClientEvent(player, "communityService:updateTrash", player, newTrash)
        
        setTimer(function()
            if #trashObjects < CONFIG.MAX_TRASH_OBJECTS then
                createTrashObject()
            end
        end, math.random(10000, 15000), 1)
    end
end

local function onPlayerTryPickupTrash(player)
    if not player or not isElement(player) or getElementType(player) ~= "player" then return end
    if not playersInService[player] or playersCollecting[player] then return end
    
    local px, py, pz = getElementPosition(player)
    local closestTrash = nil
    local closestDistance = 999999
    local closestIndex = nil
    
    for i, trash in ipairs(trashObjects) do
        local distance = getDistanceBetweenPoints3D(px, py, pz, trash.x, trash.y, trash.z)
        local isAvailable = not trash.reservedBy or trash.reservedBy == player
        if isAvailable and distance <= 3.0 and distance < closestDistance then
            closestTrash = trash
            closestDistance = distance
            closestIndex = i
        end
    end
    
    if not closestTrash then
        outputChatBox("No hay ninguna bolsa de basura cerca. Acercate a una bolsa para recogerla.", player, 255, 200, 0)
        return
    end
    
    outputChatBox("Recogiendo basura... (5 segundos)", player, 100, 255, 100)
    
    -- reservar bolsa para evitar duplicidad
    closestTrash.reservedBy = player
    
    playersCollecting[player] = {
        startTime = getTickCount(),
        trashData = closestTrash,
        trashIndex = closestIndex,
        totalTime = 5000
    }
    
    triggerClientEvent(player, "communityService:startCollection", player, 5000)
    setPedAnimation(player, "MISC", "pickup_box", -1, true, false, false, false)
    
    setTimer(function()
        if playersCollecting[player] then
            completeTrashCollection(player)
        end
    end, 5000, 1)
end

-- ===================================
-- COMANDOS ESENCIALES
-- ===================================

local function commandAssignCommunityService(player, command, target, amount, ...)
    if not hasObjectPermissionTo(player, "command.modchat", false) then
        outputChatBox("ERROR: No tienes permisos para usar este comando.", player, 255, 100, 100)
        return
    end
    
    if not target or not amount then
        outputChatBox("Uso: /comunitaria <id/nombre> <cantidad_basuras> <razón>", player, 255, 255, 0)
        outputChatBox("Ejemplo: /comunitaria JuanPerez 15 Ensuciar via publica", player, 255, 255, 0)
        return
    end
    
    local reason = "No especificada"
    if ... then
        reason = table.concat({...}, " ")
    end
    
    local targetPlayer = nil
    
    if tonumber(target) then
        targetPlayer = getPlayerFromID(tonumber(target))
    else
        local players = getElementsByType("player")
        for i, p in ipairs(players) do
            if string.find(string.lower(getPlayerName(p)), string.lower(target), 1, true) then
                targetPlayer = p
                break
            end
        end
    end
    
    if not targetPlayer then
        outputChatBox("ERROR: Jugador no encontrado: " .. target, player, 255, 100, 100)
        return
    end
    
    local trashCount = tonumber(amount)
    if not trashCount or trashCount < CONFIG.MIN_TRASH_COUNT or trashCount > CONFIG.MAX_TRASH_COUNT then
        outputChatBox("ERROR: La cantidad debe estar entre " .. CONFIG.MIN_TRASH_COUNT .. " y " .. CONFIG.MAX_TRASH_COUNT .. " basuras.", player, 255, 100, 100)
        return
    end
    
    local success, message = createCommunityService(targetPlayer, trashCount, reason, player)
    
    if success then
        outputChatBox("[OK] " .. message, player, 100, 255, 100)
        outputChatBox("Jugador: " .. getPlayerName(targetPlayer) .. " [ID: " .. getElementData(targetPlayer, "playerid") .. "]", player, 255, 255, 255)
        outputChatBox("Razon: " .. reason, player, 255, 255, 255)
        
        initializeCommunityService(targetPlayer)
        outputServerLog("[COMMUNITY SERVICE] " .. getPlayerName(player) .. " asignó trabajo comunitario a " .. getPlayerName(targetPlayer) .. " - Basuras: " .. trashCount .. " - Razón: " .. reason)
    else
        outputChatBox("ERROR: " .. message, player, 255, 100, 100)
    end
end

local function commandCheckCommunityService(player, command, target)
    if not hasObjectPermissionTo(player, "command.modchat", false) then
        outputChatBox("ERROR: No tienes permisos para usar este comando.", player, 255, 100, 100)
        return
    end
    
    local targetPlayer = player
    
    if target then
        if tonumber(target) then
            targetPlayer = getPlayerFromID(tonumber(target))
        else
            local players = getElementsByType("player")
            for i, p in ipairs(players) do
                if string.find(string.lower(getPlayerName(p)), string.lower(target), 1, true) then
                    targetPlayer = p
                    break
                end
            end
        end
        
        if not targetPlayer then
            outputChatBox("ERROR: Jugador no encontrado: " .. target, player, 255, 100, 100)
            return
        end
    end
    
    local serviceData = checkCommunityServiceStatus(targetPlayer)
    
    if serviceData then
        outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
        outputChatBox("[ESTADO DE TRABAJO COMUNITARIO]", player, 255, 255, 0)
        outputChatBox("Jugador: " .. getPlayerName(targetPlayer), player, 255, 255, 255)
        outputChatBox("Basuras: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
        outputChatBox("Razon: " .. (serviceData.razon or "No especificada"), player, 255, 255, 255)
        outputChatBox("Asignado: " .. serviceData.fecha_asignacion, player, 255, 255, 255)
        outputChatBox("Staff: " .. (serviceData.staff_nombre or "Sistema"), player, 255, 255, 255)
        outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    else
        outputChatBox("INFO: El jugador " .. getPlayerName(targetPlayer) .. " no tiene trabajo comunitario activo.", player, 255, 255, 0)
    end
end

local function commandRestoreCommunityService(player, command, target)
    if not hasObjectPermissionTo(player, "command.modchat", false) then
        outputChatBox("ERROR: No tienes permisos para usar este comando.", player, 255, 100, 100)
        return
    end
    
    if not target then
        outputChatBox("Uso: /restaurarcomunitaria <id/nombre>", player, 255, 255, 0)
        return
    end
    
    local targetPlayer = nil
    
    if tonumber(target) then
        targetPlayer = getPlayerFromID(tonumber(target))
    else
        local players = getElementsByType("player")
        for i, p in ipairs(players) do
            if string.find(string.lower(getPlayerName(p)), string.lower(target), 1, true) then
                targetPlayer = p
                break
            end
        end
    end
    
    if not targetPlayer then
        outputChatBox("ERROR: Jugador no encontrado: " .. target, player, 255, 100, 100)
        return
    end
    
    local serviceData = checkCommunityServiceStatus(targetPlayer)
    
    if serviceData then
        initializeCommunityService(targetPlayer)
        
        outputChatBox("[OK] Trabajo comunitario restaurado para " .. getPlayerName(targetPlayer), player, 100, 255, 100)
        outputChatBox("Basuras: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
        
        outputChatBox("═══════════════════════════════════════", targetPlayer, 255, 255, 0)
        outputChatBox("[TRABAJO COMUNITARIO RESTAURADO POR STAFF]", targetPlayer, 255, 100, 100)
        outputChatBox("Un administrador ha restaurado tu trabajo comunitario.", targetPlayer, 255, 255, 255)
        outputChatBox("═══════════════════════════════════════", targetPlayer, 255, 255, 0)
        
        outputServerLog("[COMMUNITY SERVICE] " .. getPlayerName(player) .. " restauró trabajo comunitario de " .. getPlayerName(targetPlayer))
    else
        outputChatBox("INFO: El jugador " .. getPlayerName(targetPlayer) .. " no tiene trabajo comunitario pendiente en la base de datos.", player, 255, 255, 0)
    end
end

local function commandListActiveCommunityServices(player)
    if not hasObjectPermissionTo(player, "command.modchat", false) then
        outputChatBox("ERROR: No tienes permisos para usar este comando.", player, 255, 100, 100)
        return
    end
    
    local query = "SELECT * FROM community_service WHERE activo = 1 ORDER BY fecha_asignacion DESC"
    local results, error = exports.sql:query_assoc(query)
    
    if error or not results or #results == 0 then
        outputChatBox("INFO: No hay trabajos comunitarios activos en la base de datos.", player, 255, 255, 0)
        return
    end
    
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    outputChatBox("[TRABAJOS COMUNITARIOS ACTIVOS EN BD]", player, 255, 255, 0)
    outputChatBox("Total activos: " .. #results, player, 255, 255, 255)
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
    
    for i, service in ipairs(results) do
        if i <= 10 then
            local isConnected = "DESCONECTADO"
            local connectedPlayer = nil
            
            local allPlayers = getElementsByType("player")
            for j, p in ipairs(allPlayers) do
                local pUserID = exports.players:getUserID(p)
                if pUserID and pUserID == service.userID then
                    connectedPlayer = p
                    isConnected = "CONECTADO"
                    break
                end
            end
            
            local inService = connectedPlayer and playersInService[connectedPlayer] and "EN SERVICIO" or "NO INICIALIZADO"
            
            outputChatBox(i .. ". " .. service.account .. " (UserID:" .. service.userID .. ") - " .. isConnected, player, 255, 255, 255)
            outputChatBox("   Basuras: " .. service.basuras_pendientes .. "/" .. service.basuras_totales .. " | Estado: " .. inService, player, 200, 200, 200)
            outputChatBox("   Razon: " .. (service.razon or "No especificada"), player, 200, 200, 200)
        end
    end
    
    if #results > 10 then
        outputChatBox("... y " .. (#results - 10) .. " mas. Usar web panel para ver todos.", player, 255, 200, 0)
    end
    
    outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
end

-- ===================================
-- EVENTOS DEL SISTEMA
-- ===================================

addEventHandler("onResourceStart", resourceRoot, function()
    trashObjects = {}
    usedTrashPositions = {}
    createWorkZone()
    
    for i = 1, CONFIG.MAX_TRASH_OBJECTS do
        createTrashObject()
    end
    
    if exports.sql and exports.players then
        local players = getElementsByType("player")
        for i, player in ipairs(players) do
            local serviceData = checkCommunityServiceStatus(player)
            if serviceData then
                initializeCommunityService(player)
            end
        end
    else
        -- Reintento diferido para cuando las dependencias esten listas
        setTimer(function()
            if exports.sql and exports.players then
                local players = getElementsByType("player")
                for i, player in ipairs(players) do
                    local serviceData = checkCommunityServiceStatus(player)
                    if serviceData then
                        initializeCommunityService(player)
                    end
                end
            end
        end, 5000, 6)
    end
end)

addEventHandler("onCharacterLogin", root, function()
    local player = source
    
    setTimer(function()
        if not isElement(player) or playersInService[player] then return end
        
        if not exports.players or not exports.sql then
            setTimer(function()
                if isElement(player) and not playersInService[player] then
                    local serviceData = checkCommunityServiceStatus(player)
                    if serviceData then
                        initializeCommunityService(player)
                        
                        outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
                        outputChatBox("[TRABAJO COMUNITARIO RESTAURADO]", player, 255, 100, 100)
                        outputChatBox("Tu trabajo comunitario ha sido restaurado automaticamente.", player, 255, 255, 255)
                        outputChatBox("Basuras pendientes: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
                        outputChatBox("Razon: " .. (serviceData.razon or "No especificada"), player, 255, 255, 255)
                        outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
                    end
                end
            end, 5000, 1)
            return
        end
        
        local serviceData = checkCommunityServiceStatus(player)
        if serviceData then
            initializeCommunityService(player)
            
            outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
            outputChatBox("[TRABAJO COMUNITARIO RESTAURADO]", player, 255, 100, 100)
            outputChatBox("Tu trabajo comunitario ha sido restaurado automaticamente.", player, 255, 255, 255)
            outputChatBox("Basuras pendientes: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
            outputChatBox("Razon: " .. (serviceData.razon or "No especificada"), player, 255, 255, 255)
            outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
        end
    end, 3000, 1)
end)

addEventHandler("onCharacterLogout", root, function()
    if playersInService[source] then
        playersInService[source] = nil
    end
    if playersCollecting[source] then
        playersCollecting[source] = nil
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if playersInService[source] then
        playersInService[source] = nil
    end
    if playersCollecting[source] then
        playersCollecting[source] = nil
    end
end)

-- ===================================
-- EVENTOS DE CLIENTE
-- ===================================

addEvent("communityService:pickupTrash", true)
addEventHandler("communityService:pickupTrash", root, function(playerElement)
    if playerElement and isElement(playerElement) then
        onPlayerTryPickupTrash(playerElement)
    else
        onPlayerTryPickupTrash(source)
    end
end)

-- ===================================
-- REGISTRAR COMANDOS
-- ===================================

addCommandHandler("comunitaria", commandAssignCommunityService)
addCommandHandler("vercomunitaria", commandCheckCommunityService)
addCommandHandler("restaurarcomunitaria", commandRestoreCommunityService)
addCommandHandler("listarcomunitarias", commandListActiveCommunityServices)

-- ===================================
-- TIMERS OPTIMIZADOS
-- ===================================

-- Verificación de zona cada 5 segundos (optimizado)
setTimer(function()
    for player, data in pairs(playersInService) do
        if isElement(player) then
            local px, py, pz = getElementPosition(player)
            local distance = getDistanceBetweenPoints3D(px, py, pz, WORK_ZONE.x, WORK_ZONE.y, WORK_ZONE.z)
            
            if distance > WORK_ZONE.radius then
                local currentTrash = playersInService[player].trashPending
                local newTrash = currentTrash + CONFIG.ESCAPE_PENALTY
                
                updateTrashCount(player, newTrash)
                playersInService[player].trashPending = newTrash
                setElementData(player, "trash_pending", newTrash)
                
                setElementPosition(player, WORK_ZONE.x, WORK_ZONE.y, WORK_ZONE.z)
                
                outputChatBox("ATENCION: Has salido de la zona de trabajo!", player, 255, 100, 100)
                outputChatBox("PENALIZACION: +" .. CONFIG.ESCAPE_PENALTY .. " basuras adicionales", player, 255, 50, 50)
                outputChatBox("Basuras pendientes: " .. newTrash, player, 255, 255, 0)
                
                triggerClientEvent(player, "communityService:updateTrash", player, newTrash)
            end
        end
    end
end, 5000, 0)

-- Verificación de recolección cada 1 segundo (optimizado)
setTimer(function()
    for player, data in pairs(playersCollecting) do
        if isElement(player) then
            local px, py, pz = getElementPosition(player)
            local distance = getDistanceBetweenPoints3D(px, py, pz, data.trashData.x, data.trashData.y, data.trashData.z)
            
            if distance > 5.0 then
                setPedAnimation(player, false)
                if data and data.trashData then
                    data.trashData.reservedBy = nil
                end
                playersCollecting[player] = nil
                outputChatBox("Recoleccion cancelada - te alejaste de la basura.", player, 255, 200, 0)
                triggerClientEvent(player, "communityService:cancelCollection", player)
            end
        else
            playersCollecting[player] = nil
        end
    end
end, 1000, 0)

-- Sistema anti-evasión cada 60 segundos (optimizado)
setTimer(function()
    local allPlayers = getElementsByType("player")
    for i, player in ipairs(allPlayers) do
        if exports.players and exports.players:isLoggedIn(player) and not playersInService[player] then
            if isInGraceWindow(player) then
                -- dentro de ventana de gracia, no restaurar ni mover
            else
                local serviceData = checkCommunityServiceStatus(player)
                if serviceData and tonumber(serviceData.basuras_pendientes) and serviceData.basuras_pendientes > 0 then
                initializeCommunityService(player)
                
                outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
                outputChatBox("[EVASION DETECTADA - TRABAJO RESTAURADO]", player, 255, 50, 50)
                outputChatBox("Se detectó que intentaste evadir tu trabajo comunitario.", player, 255, 255, 255)
                outputChatBox("El sistema de backup ha restaurado tu sanción.", player, 255, 255, 255)
                outputChatBox("Basuras pendientes: " .. serviceData.basuras_pendientes .. "/" .. serviceData.basuras_totales, player, 255, 255, 255)
                outputChatBox("═══════════════════════════════════════", player, 255, 255, 0)
                
                outputServerLog("[COMMUNITY SERVICE - ANTI EVASION] Sistema de backup restauró trabajo comunitario para " .. getPlayerName(player))
                end
            end
        end
    end
end, 60000, 0)

-- ===================================
-- EXPORTS PARA OTROS RECURSOS
-- ===================================

function assignCommunityService(targetPlayer, trashCount, reason, staffPlayer)
    if not isElement(targetPlayer) then return false, "Jugador inválido" end
    if not trashCount or trashCount < CONFIG.MIN_TRASH_COUNT or trashCount > CONFIG.MAX_TRASH_COUNT then
        return false, "Cantidad inválida"
    end
    
    local success, message = createCommunityService(targetPlayer, trashCount, reason or "Asignado por sistema", staffPlayer)
    
    if success then
        initializeCommunityService(targetPlayer)
    end
    
    return success, message
end

function getCommunityServiceStatus(targetPlayer)
    if not isElement(targetPlayer) then return false end
    return checkCommunityServiceStatus(targetPlayer)
end

function isPlayerInCommunityService(targetPlayer)
    if not isElement(targetPlayer) then return false end
    return playersInService[targetPlayer] ~= nil
end

function addTrashToPlayer(targetPlayer, amount)
    if not isElement(targetPlayer) or not playersInService[targetPlayer] then return false end
    
    local currentTrash = playersInService[targetPlayer].trashPending
    local newTrash = currentTrash + (amount or 1)
    
    updateTrashCount(targetPlayer, newTrash)
    playersInService[targetPlayer].trashPending = newTrash
    setElementData(targetPlayer, "trash_pending", newTrash)
    
    triggerClientEvent(targetPlayer, "communityService:updateTrash", targetPlayer, newTrash)
    
    return true
end

function completeCommunityService(targetPlayer)
    if not isElement(targetPlayer) or not playersInService[targetPlayer] then return false end
    
    updateTrashCount(targetPlayer, 0)
    completeCommunityServiceDB(targetPlayer)
    removeCommunityService(targetPlayer)
    
    outputChatBox("Tu trabajo comunitario ha sido completado por un administrador.", targetPlayer, 100, 255, 100)
    
    return true
end

-- ===================================
-- FUNCIONES AUXILIARES
-- ===================================

function getPlayerFromID(id)
    local players = getElementsByType("player")
    for i, player in ipairs(players) do
        if getElementData(player, "playerid") == id then
            return player
        end
    end
    return nil
end
