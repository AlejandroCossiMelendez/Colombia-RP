--[[
    Sistema de Chat Unificado para Facciones
    Autor: Sistema Automatizado
    Descripción: Script que maneja todos los comandos de chat de facciones usando configuración externa
--]]

local factionConfig = {}

-- Función para cargar la configuración desde el archivo JSON
function loadFactionConfig()
    local file = fileOpen("config.json", true)
    if not file then
        outputDebugString("[CHAT-FACCIONES] Error: No se pudo cargar el archivo config.json", 1)
        return false
    end
    
    local content = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    local success, result = pcall(function()
        return fromJSON(content)
    end)
    
    if not success or not result then
        outputDebugString("[CHAT-FACCIONES] Error: No se pudo parsear el archivo config.json", 1)
        return false
    end
    
    factionConfig = result
    outputDebugString("[CHAT-FACCIONES] Configuración cargada exitosamente. " .. #factionConfig.factions .. " facciones configuradas.", 3)
    return true
end

-- Función principal para manejar comandos de chat
function handleFactionChat(source, commandName, ...)
    local message = table.concat({...}, " ")
    
    -- Buscar la configuración de la facción por comando
    local factionData = nil
    local isExtraCommand = false
    
    for _, faction in ipairs(factionConfig.factions) do
        if faction.command == commandName then
            factionData = faction
            break
        end
        
        -- Verificar comandos extra
        if faction.extra_commands then
            for _, extraCmd in ipairs(faction.extra_commands) do
                if extraCmd.command == commandName then
                    factionData = faction
                    isExtraCommand = extraCmd
                    break
                end
            end
        end
    end
    
    if not factionData then
        outputDebugString("[CHAT-FACCIONES] Comando no encontrado: " .. commandName, 2)
        return
    end
    
    -- Verificar si el jugador pertenece a la facción
    if not exports.factions:isPlayerInFaction(source, factionData.id) then
        outputChatBox(factionData.error_message, source, 255, 0, 0, false)
        return
    end
    
    -- Verificar que el mensaje no esté vacío
    if not message or message == "" or message == " " then
        outputChatBox("Tienes que ingresar un texto para el anuncio", source, 255, 0, 0, false)
        return
    end
    
    -- Determinar el formato del mensaje
    local messageFormat = factionData.message_format
    if isExtraCommand then
        messageFormat = isExtraCommand.message_format
    end
    
    -- Reemplazar placeholder del mensaje
    local finalMessage = messageFormat:gsub("{message}", message)
    
    -- Enviar el mensaje a todos los jugadores
    for _, player in ipairs(getElementsByType("player")) do
        outputChatBox(finalMessage, player, 255, 255, 255, true)
    end
    
    -- Log para debug
    local playerName = getPlayerName(source)
    outputDebugString("[CHAT-FACCIONES] " .. playerName .. " usó /" .. commandName .. ": " .. message, 3)
end

-- Función para registrar todos los comandos dinámicamente
function registerFactionCommands()
    if not factionConfig.factions then
        outputDebugString("[CHAT-FACCIONES] Error: No hay facciones configuradas", 1)
        return
    end
    
    local commandsRegistered = 0
    
    for _, faction in ipairs(factionConfig.factions) do
        -- Registrar comando principal
        addCommandHandler(faction.command, handleFactionChat)
        commandsRegistered = commandsRegistered + 1
        
        -- Registrar comandos extra si existen
        if faction.extra_commands then
            for _, extraCmd in ipairs(faction.extra_commands) do
                addCommandHandler(extraCmd.command, handleFactionChat)
                commandsRegistered = commandsRegistered + 1
            end
        end
    end
    
    outputDebugString("[CHAT-FACCIONES] " .. commandsRegistered .. " comandos registrados exitosamente.", 3)
end

-- Función para recargar la configuración (útil para administradores)
function reloadFactionConfig(player, cmd)
    -- Verificar permisos de administrador
    if not hasObjectPermissionTo(player, "general.adminpanel") then
        outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0, false)
        return
    end
    
    if loadFactionConfig() then
        -- No podemos re-registrar comandos fácilmente, así que mejor reiniciar el recurso
        outputChatBox("Configuración recargada. Se recomienda reiniciar el recurso para aplicar cambios en comandos.", player, 0, 255, 0, false)
        outputDebugString("[CHAT-FACCIONES] Configuración recargada por " .. getPlayerName(player), 3)
    else
        outputChatBox("Error al recargar la configuración. Revisa el archivo config.json", player, 255, 0, 0, false)
    end
end

-- Función para mostrar información de facciones (útil para debug)
function showFactionsInfo(player, cmd)
    if not hasObjectPermissionTo(player, "general.adminpanel") then
        outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0, false)
        return
    end
    
    outputChatBox("=== INFORMACIÓN DE FACCIONES ===", player, 255, 255, 0, false)
    for i, faction in ipairs(factionConfig.factions) do
        local info = string.format("%d. %s (ID: %d) - Comando: /%s", 
            i, faction.name, faction.id, faction.command)
        outputChatBox(info, player, 255, 255, 255, false)
        
        if faction.extra_commands then
            for _, extraCmd in ipairs(faction.extra_commands) do
                outputChatBox("   └── Comando extra: /" .. extraCmd.command, player, 200, 200, 200, false)
            end
        end
    end
end

-- Eventos al iniciar el recurso
addEventHandler("onResourceStart", resourceRoot, function()
    if loadFactionConfig() then
        registerFactionCommands()
        outputDebugString("[CHAT-FACCIONES] Sistema de chat unificado iniciado exitosamente.", 3)
    else
        outputDebugString("[CHAT-FACCIONES] Error al iniciar el sistema. Revisa el archivo config.json", 1)
    end
end)

-- Comandos administrativos
addCommandHandler("reloadfactions", reloadFactionConfig)
addCommandHandler("factionsinfo", showFactionsInfo)

-- Función utilitaria para obtener información de una facción por ID
function getFactionInfoById(factionId)
    for _, faction in ipairs(factionConfig.factions) do
        if faction.id == factionId then
            return faction
        end
    end
    return nil
end

-- Exportar funciones útiles para otros recursos
function getFactionConfig()
    return factionConfig
end

function getFactionCommands()
    local commands = {}
    for _, faction in ipairs(factionConfig.factions) do
        table.insert(commands, faction.command)
        if faction.extra_commands then
            for _, extraCmd in ipairs(faction.extra_commands) do
                table.insert(commands, extraCmd.command)
            end
        end
    end
    return commands
end
