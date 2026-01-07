--[[
    =============================================
    SISTEMA DE CÁMARAS CCTV - SERVIDOR v2.0
    =============================================
    
    Sistema modular que utiliza archivo de configuración externo.
    No modifiques este archivo - usa config.lua para configurar el sistema.
    
    Autor: Sistema CCTV MTA
    Versión: 2.0
    Archivo de configuración: config.lua
]]

-- =============================================
-- CARGA DE CONFIGURACIÓN
-- =============================================

-- Cargar archivo de configuración
local Config = {}
local configFile = "config.lua"

-- Función para cargar la configuración
local function loadConfig()
    local configPath = ":" .. getResourceName(getThisResource()) .. "/" .. configFile
    local file = fileOpen(configPath)
    
    if not file then
        outputServerLog("[CCTV] ERROR: No se pudo encontrar " .. configFile)
        return false
    end
    
    local configData = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    -- Ejecutar el archivo de configuración
    local configFunc, err = loadstring(configData)
    if not configFunc then
        outputServerLog("[CCTV] ERROR: Error de sintaxis en " .. configFile .. ": " .. (err or "desconocido"))
        return false
    end
    
    local success, result = pcall(configFunc)
    if not success then
        outputServerLog("[CCTV] ERROR: Error al cargar " .. configFile .. ": " .. (result or "desconocido"))
        return false
    end
    
    Config = result or {}
    outputServerLog("[CCTV] Configuración cargada exitosamente desde " .. configFile)
    return true
end

-- Cargar configuración al inicio
if not loadConfig() then
    outputServerLog("[CCTV] FATAL: No se pudo cargar la configuración. El sistema no funcionará correctamente.")
    Config = {
        General = { debugMode = false, enableLogs = true },
        Access = { messages = {} },
        CameraLocations = {},
        Marker = { position = {x=0,y=0,z=0}, size=1, color={r=255,g=0,b=0,alpha=100}, interior=0, dimension=0, id="camaraMarker" }
    }
end

-- =============================================
-- VARIABLES GLOBALES DEL SISTEMA
-- =============================================

local systemStats = {
    totalLocations = 0,
    totalCameras = 0,
    invalidCameras = 0,
    activeUsers = 0
}

local activeUsers = {} -- Jugadores que están usando el sistema
local commandSpam = {} -- Control anti-spam de comandos

-- =============================================
-- FUNCIONES UTILITARIAS
-- =============================================

-- Función para logs del sistema
local function logSystem(message, level)
    if not Config.General or not Config.General.enableLogs then return end
    
    level = level or "INFO"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[CCTV %s] %s: %s", timestamp, level, message)
    
    outputServerLog(logMessage)
    
    if Config.General.enableDetailedLogs then
        outputDebugString(logMessage, level == "ERROR" and 1 or 3)
    end
end

-- Función para validar datos de cámara
local function validateCameraData(camera)
    if not camera then return false end
    
    local requiredFields = {"x", "y", "z", "lookX", "lookY", "lookZ", "interior", "dimension"}
    
    for _, field in ipairs(requiredFields) do
        if type(camera[field]) ~= "number" then
            return false
        end
    end
    
    return true
end

-- Función para calcular estadísticas del sistema
local function calculateSystemStats()
    systemStats.totalLocations = 0
    systemStats.totalCameras = 0
    systemStats.invalidCameras = 0
    
    if not Config.CameraLocations then
        return systemStats
    end
    
    for location, cameras in pairs(Config.CameraLocations) do
        systemStats.totalLocations = systemStats.totalLocations + 1
        
        if type(cameras) == "table" then
            for _, camera in pairs(cameras) do
                systemStats.totalCameras = systemStats.totalCameras + 1
                if not validateCameraData(camera) then
                    systemStats.invalidCameras = systemStats.invalidCameras + 1
                end
            end
        end
    end
    
    return systemStats
end

-- =============================================
-- SISTEMA DE VERIFICACIÓN DE ACCESO
-- =============================================

-- Función para verificar si el jugador es administrador
local function isPlayerAdmin(player)
    if not Config.Access or not Config.Access.adminAccess or not Config.Access.adminAccess.enabled then
        return false
    end
    
    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return false
    end
    
    local accountName = getAccountName(account)
    local aclGroup = Config.Access.adminAccess.aclGroup or "Admin"
    
    return isObjectInACLGroup("user." .. accountName, aclGetGroup(aclGroup))
end

-- Función para verificar acceso por facción
local function checkFactionAccess(player)
    if not Config.Access or not Config.Access.factionSystem or not Config.Access.factionSystem.enabled then
        return false
    end
    
    local resourceName = Config.Access.factionSystem.resourceName
    local allowedFactions = Config.Access.factionSystem.allowedFactions
    
    if not resourceName or not allowedFactions then
        return false
    end
    
    local factionResource = getResourceFromName(resourceName)
    if not factionResource or getResourceState(factionResource) ~= "running" then
        return false
    end
    
    -- Verificar cada facción permitida
    for _, factionID in ipairs(allowedFactions) do
        local hasAccess = exports[resourceName]:isPlayerInFaction(player, factionID)
        if hasAccess then
            return true
        end
    end
    
    return false
end

-- Función para verificar acceso por cuenta específica
local function checkAccountAccess(player)
    if not Config.Access or not Config.Access.accountAccess or not Config.Access.accountAccess.enabled then
        return false
    end
    
    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return false
    end
    
    local accountName = getAccountName(account)
    local allowedAccounts = Config.Access.accountAccess.allowedAccounts or {}
    
    for _, allowedAccount in ipairs(allowedAccounts) do
        if accountName == allowedAccount then
            return true
        end
    end
    
    return false
end

-- Función principal para verificar acceso al sistema
local function hasSystemAccess(player)
    if not player or not isElement(player) then
        return false, "Jugador inválido"
    end
    
    -- Modo debug - acceso para todos
    if Config.General and Config.General.debugMode then
        return true, "debug"
    end
    
    -- Verificar acceso de administrador
    if isPlayerAdmin(player) then
        return true, "admin"
    end
    
    -- Verificar acceso por facción
    if checkFactionAccess(player) then
        return true, "faction"
    end
    
    -- Verificar acceso por cuenta específica
    if checkAccountAccess(player) then
        return true, "account"
    end
    
    return false, "No tienes permisos para usar este sistema"
end

-- =============================================
-- GESTIÓN DE MENSAJES
-- =============================================

-- Función para obtener mensaje configurado
local function getMessage(category, key, default)
    if Config.Messages and Config.Messages[category] and Config.Messages[category][key] then
        return Config.Messages[category][key]
    end
    return default or "Mensaje no configurado"
end

-- Función para enviar mensaje de acceso
local function sendAccessMessage(player, accessType, granted)
    if not Config.Access or not Config.Access.messages then return end
    
    local messages = Config.Access.messages
    local message = ""
    
    if granted then
        if accessType == "admin" then
            message = messages.adminAccess or "Acceso de administrador concedido"
        elseif accessType == "faction" then
            message = messages.factionAccess or "Acceso por facción concedido"
        elseif accessType == "debug" then
            message = messages.debugAccess or "Acceso concedido por modo debug"
        else
            message = messages.accessGranted or "Acceso concedido"
        end
        outputChatBox(message, player, 0, 255, 0)
    else
        message = messages.accessDenied or "Acceso denegado"
        outputChatBox(message, player, 255, 0, 0)
    end
end

-- =============================================
-- EVENTOS PRINCIPALES
-- =============================================

-- Evento para verificar acceso al sistema
addEvent("checkPoliceAccess", true)
addEventHandler("checkPoliceAccess", root, function()
    local player = client
    
    if not player or not isElement(player) then
        logSystem("Intento de acceso con cliente inválido", "WARNING")
        return
    end
    
    local playerName = getPlayerName(player)
    logSystem("Jugador " .. playerName .. " solicita acceso al sistema")
    
    -- Verificar permisos
    local hasAccess, accessType = hasSystemAccess(player)
    
    if hasAccess then
        -- Calcular estadísticas actuales
        local stats = calculateSystemStats()
        
        -- Advertir sobre cámaras inválidas
        if stats.invalidCameras > 0 then
            logSystem("ADVERTENCIA: " .. stats.invalidCameras .. " cámaras con datos inválidos", "WARNING")
        end
        
        -- Registrar usuario activo
        activeUsers[player] = {
            loginTime = getRealTime().timestamp,
            accessType = accessType
        }
        systemStats.activeUsers = systemStats.activeUsers + 1
        
        -- Log de acceso exitoso
        logSystem("Acceso concedido a " .. playerName .. " (Tipo: " .. accessType .. ", Cámaras: " .. stats.totalCameras .. ")")
        
        -- Enviar datos al cliente
        triggerClientEvent(player, "allowCameraAccess", player, Config.CameraLocations)
        
        -- Mensajes de confirmación
        sendAccessMessage(player, accessType, true)
        outputChatBox(getMessage("info", "cameraActivated", "Sistema activado"), player, 0, 255, 0)
        outputChatBox(string.format(getMessage("info", "locationInfo", "Ubicaciones: %d | Cámaras: %d"), 
                      stats.totalLocations, stats.totalCameras), player, 0, 200, 255)
        
    else
        -- Log de acceso denegado
        logSystem("Acceso denegado a " .. playerName .. " - " .. (accessType or "Sin permisos"))
        
        -- Mensaje de error
        sendAccessMessage(player, nil, false)
    end
end)

-- =============================================
-- COMANDOS ADMINISTRATIVOS
-- =============================================

-- Control anti-spam para comandos
local function checkCommandSpam(player, commandName)
    if not Config.Advanced or not Config.Advanced.security or not Config.Advanced.security.enableAntiSpam then
        return true
    end
    
    local playerSerial = getPlayerSerial(player)
    local currentTime = getRealTime().timestamp
    local maxCommands = Config.Advanced.security.maxCommandsPerMinute or 10
    
    if not commandSpam[playerSerial] then
        commandSpam[playerSerial] = {}
    end
    
    -- Limpiar comandos antiguos (más de 1 minuto)
    local commands = commandSpam[playerSerial]
    for i = #commands, 1, -1 do
        if currentTime - commands[i] > 60 then
            table.remove(commands, i)
        end
    end
    
    -- Verificar límite
    if #commands >= maxCommands then
        outputChatBox("⚠️ Demasiados comandos, espera un momento.", player, 255, 150, 0)
        return false
    end
    
    -- Registrar comando
    table.insert(commands, currentTime)
    return true
end

-- Comando para modo debug
if Config.Commands and Config.Commands.commands and Config.Commands.commands.debug and Config.Commands.commands.debug.enabled then
    addCommandHandler(Config.Commands.commands.debug.command, function(player, command, state)
        if not checkCommandSpam(player, command) then return end
        
        if not isPlayerAdmin(player) then
            outputChatBox("❌ No tienes permisos para usar este comando.", player, 255, 0, 0)
            return
        end
        
        if state == "on" then
            Config.General.debugMode = true
            outputChatBox(getMessage("info", "debugEnabled", "Modo debug activado"), player, 0, 255, 0)
            logSystem("Modo debug activado por " .. getPlayerName(player))
        elseif state == "off" then
            Config.General.debugMode = false
            outputChatBox(getMessage("info", "debugDisabled", "Modo debug desactivado"), player, 255, 255, 0)
            logSystem("Modo debug desactivado por " .. getPlayerName(player))
        else
            local status = Config.General.debugMode and "activado" or "desactivado"
            outputChatBox("🐛 Modo debug: " .. status .. " | Uso: /" .. Config.Commands.commands.debug.command .. " [on/off]", player, 255, 255, 255)
        end
    end)
end

-- Comando para información del sistema
if Config.Commands and Config.Commands.commands and Config.Commands.commands.info and Config.Commands.commands.info.enabled then
    addCommandHandler(Config.Commands.commands.info.command, function(player)
        if not checkCommandSpam(player, "info") then return end
        
        local hasAccess = hasSystemAccess(player)
        if not hasAccess then
            outputChatBox("❌ No tienes permisos para ver esta información.", player, 255, 0, 0)
            return
        end
        
        local stats = calculateSystemStats()
        local version = Config.General and Config.General.version or "2.0"
        
        outputChatBox("=== Sistema de Cámaras CCTV v" .. version .. " ===", player, 0, 255, 255)
        outputChatBox("📍 Ubicaciones disponibles: " .. stats.totalLocations, player, 255, 255, 255)
        outputChatBox("📹 Total de cámaras: " .. stats.totalCameras, player, 255, 255, 255)
        outputChatBox("👥 Usuarios activos: " .. systemStats.activeUsers, player, 255, 255, 255)
        outputChatBox("🐛 Modo debug: " .. (Config.General.debugMode and "Activado" or "Desactivado"), player, 255, 255, 255)
        
        if stats.invalidCameras > 0 then
            outputChatBox(string.format(getMessage("errors", "invalidCamera", "⚠️ Cámaras con errores: %d"), stats.invalidCameras), player, 255, 150, 0)
        else
            outputChatBox(getMessage("info", "allCamerasValid", "✅ Todas las cámaras configuradas correctamente"), player, 0, 255, 0)
        end
    end)
end

-- Comando para listar ubicaciones
if Config.Commands and Config.Commands.commands and Config.Commands.commands.list and Config.Commands.commands.list.enabled then
    addCommandHandler(Config.Commands.commands.list.command, function(player)
        if not checkCommandSpam(player, "list") then return end
        
        local hasAccess = hasSystemAccess(player)
        if not hasAccess then
            outputChatBox("❌ No tienes permisos para ver esta información.", player, 255, 0, 0)
            return
        end
        
        outputChatBox("=== 📍 Ubicaciones de Cámaras ===", player, 0, 255, 255)
        
        local locationCount = 0
        for location, cameras in pairs(Config.CameraLocations or {}) do
            locationCount = locationCount + 1
            outputChatBox("📍 " .. location .. " (" .. #cameras .. " cámaras)", player, 255, 255, 255)
            
            for i, camera in pairs(cameras) do
                local name = camera.name or ("Cámara " .. i)
                local coords = string.format("%.1f, %.1f, %.1f", camera.x or 0, camera.y or 0, camera.z or 0)
                local status = validateCameraData(camera) and "✅" or "❌"
                outputChatBox("   " .. i .. ". " .. status .. " " .. name .. " (" .. coords .. ")", player, 200, 200, 200)
            end
        end
        
        if locationCount == 0 then
            outputChatBox("⚠️ No hay ubicaciones configuradas.", player, 255, 150, 0)
        end
    end)
end

-- Comando para recargar configuración
if Config.Commands and Config.Commands.commands and Config.Commands.commands.reload and Config.Commands.commands.reload.enabled then
    addCommandHandler(Config.Commands.commands.reload.command, function(player)
        if not checkCommandSpam(player, "reload") then return end
        
        if not isPlayerAdmin(player) then
            outputChatBox("❌ No tienes permisos para usar este comando.", player, 255, 0, 0)
            return
        end
        
        outputChatBox("🔄 Recargando configuración...", player, 255, 255, 0)
        
        if loadConfig() then
            calculateSystemStats()
            outputChatBox("✅ Configuración recargada exitosamente.", player, 0, 255, 0)
            logSystem("Configuración recargada por " .. getPlayerName(player))
        else
            outputChatBox("❌ Error al recargar la configuración. Revisa los logs.", player, 255, 0, 0)
        end
    end)
end

-- =============================================
-- GESTIÓN DEL MARCADOR DE ACCESO
-- =============================================

-- Crear marcador de acceso
local function createAccessMarker()
    if not Config.Marker then
        logSystem("No se pudo crear el marcador: configuración faltante", "ERROR")
        return nil
    end
    
    local pos = Config.Marker.position
    local color = Config.Marker.color
    
    local marker = createMarker(
        pos.x, pos.y, pos.z,
        "cylinder", 
        Config.Marker.size,
        color.r, color.g, color.b, color.alpha
    )
    
    if marker then
        setElementInterior(marker, Config.Marker.interior)
        setElementDimension(marker, Config.Marker.dimension)
        setElementID(marker, Config.Marker.id)
        
        logSystem("Marcador de acceso creado exitosamente")
        return marker
    else
        logSystem(getMessage("errors", "markerError", "ERROR: No se pudo crear el marcador"), "ERROR")
        return nil
    end
end

-- =============================================
-- EVENTOS DE GESTIÓN DE JUGADORES
-- =============================================

-- Limpiar datos cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    if activeUsers[source] then
        activeUsers[source] = nil
        systemStats.activeUsers = math.max(0, systemStats.activeUsers - 1)
        logSystem("Jugador " .. getPlayerName(source) .. " desconectado del sistema CCTV")
    end
    
    -- Limpiar spam de comandos
    local playerSerial = getPlayerSerial(source)
    if commandSpam[playerSerial] then
        commandSpam[playerSerial] = nil
    end
end)

-- =============================================
-- INICIALIZACIÓN Y MANTENIMIENTO
-- =============================================

-- Inicialización del sistema
addEventHandler("onResourceStart", resourceRoot, function()
    -- Calcular estadísticas iniciales
    local stats = calculateSystemStats()
    
    -- Crear marcador de acceso
    local marker = createAccessMarker()
    
    -- Log de inicio
    local version = Config.General and Config.General.version or "2.0"
    logSystem(string.format(getMessage("system", "started", "Sistema iniciado: %d ubicaciones, %d cámaras"), 
              stats.totalLocations, stats.totalCameras))
    
    outputDebugString(string.format(getMessage("system", "loaded", "Sistema de Cámaras CCTV v%s cargado exitosamente"), version), 3)
    
    -- Advertencias de configuración
    if stats.invalidCameras > 0 then
        logSystem(string.format(getMessage("errors", "invalidCamera", "ADVERTENCIA: %d cámaras tienen datos inválidos"), stats.invalidCameras), "WARNING")
    end
    
    if stats.totalCameras == 0 then
        logSystem(getMessage("errors", "noLocations", "ADVERTENCIA: No hay cámaras configuradas"), "WARNING")
    end
    
    -- Verificar dependencias
    if Config.Access and Config.Access.factionSystem and Config.Access.factionSystem.enabled then
        local resourceName = Config.Access.factionSystem.resourceName
        local factionResource = getResourceFromName(resourceName)
        if not factionResource or getResourceState(factionResource) ~= "running" then
            logSystem("ADVERTENCIA: Recurso de facciones '" .. resourceName .. "' no encontrado", "WARNING")
        end
    end
end)

-- Cleanup al detener el recurso
addEventHandler("onResourceStop", resourceRoot, function()
    logSystem(getMessage("system", "stopped", "Sistema de cámaras desactivado"))
    
    -- Limpiar datos de usuarios activos
    activeUsers = {}
    commandSpam = {}
    systemStats.activeUsers = 0
end)

-- Verificación periódica de integridad (si está habilitada)
if Config.General and Config.General.enableAutoCheck then
    local interval = Config.General.integrityCheckInterval or 300000
    setTimer(function()
        local stats = calculateSystemStats()
        if stats.invalidCameras > 0 then
            logSystem("MANTENIMIENTO: " .. stats.invalidCameras .. " cámaras necesitan revisión", "WARNING")
        end
    end, interval, 0)
end

-- =============================================
-- FUNCIONES EXPORTADAS
-- =============================================

-- Exportar funciones para uso de otros recursos
function getSystemStats()
    return systemStats
end

function isPlayerAuthorized(player)
    local hasAccess, accessType = hasSystemAccess(player)
    return hasAccess, accessType
end

function getCameraLocations()
    return Config.CameraLocations
end

function reloadSystemConfig()
    return loadConfig()
end