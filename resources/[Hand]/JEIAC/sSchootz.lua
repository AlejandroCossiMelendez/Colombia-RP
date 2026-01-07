-- JEICORDERO AC - Servidor Limpio
-- Solo Anti-VPN, Anti-Spoofer y Anti-Executor

-- ============================================================================
-- JEICORDERO AC - SERVIDOR PRINCIPAL
-- Usa configuración centralizada de gSchootz.lua
-- ============================================================================

-- Verificar que existe la configuración
if not config then
    outputDebugString("❌ [JEICORDERO AC] Error: No se encontró configuración. Verificar gSchootz.lua", 1)
    return
end

-- Base de datos SQLite
local database = dbConnect('sqlite', config.database.name)
if not database then
    outputDebugString("❌ [JEICORDERO AC] Error: No se pudo conectar a la base de datos", 1)
    return
end

-- Crear tablas necesarias
dbExec(database, [[
    CREATE TABLE IF NOT EXISTS vpn_whitelist (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        ip TEXT UNIQUE, 
        added_by TEXT, 
        date_added INTEGER,
        reason TEXT DEFAULT 'Manual'
    )
]])

dbExec(database, [[
    CREATE TABLE IF NOT EXISTS player_serials (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        serial TEXT UNIQUE, 
        ip TEXT, 
        first_seen INTEGER,
        last_seen INTEGER DEFAULT 0
    )
]])

dbExec(database, [[
    CREATE TABLE IF NOT EXISTS detection_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT,
        serial TEXT,
        ip TEXT,
        detection_type TEXT,
        details TEXT,
        timestamp INTEGER
    )
]])

dbExec(database, [[
    CREATE TABLE IF NOT EXISTS serial_whitelist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serial TEXT UNIQUE,
        added_by TEXT,
        reason TEXT,
        date_added INTEGER
    )
]])

-- Estadísticas globales
local stats = {
    connections = 0,
    vpn_blocks = 0,
    spoofer_detections = 0,
    executor_detections = 0,
    total_bans = 0
}

-- ===== FUNCIONES DE UTILIDAD =====
function hasPermission(player)
    if not player or not isElement(player) then
        return false
    end
    
    -- Verificar ACL groups
    local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
        for _, group in ipairs(config.bypass.acl_groups) do
            local aclGroup = aclGetGroup(group)
            if aclGroup and isObjectInACLGroup("user." .. getAccountName(account), aclGroup) then
                return true
            end
        end
    end
    
    -- Verificar element data
    for _, element in ipairs(config.bypass.element_data) do
        if getElementData(player, element) then
            return true
        end
    end
    
    return false
end

function isSerialWhitelisted(serial)
    if not serial or serial == "" then
        return false
    end
    
    local result = dbPoll(dbQuery(database, "SELECT * FROM serial_whitelist WHERE serial = ?", serial), -1)
    if result and #result > 0 then
        outputDebugString("[JEICORDERO AC] Serial " .. serial .. " está en whitelist (añadido por: " .. (result[1].added_by or "Unknown") .. ")", 3)
        return true
    end
    
    return false
end

function logDetection(player, detectionType, details)
    if not config.logging.enabled then return end
    
    -- Validar que el player sea válido
    if not player or not isElement(player) or getElementType(player) ~= "player" then
        outputDebugString("[JEICORDERO AC] Error: logDetection llamado con jugador inválido", 1)
        return
    end
    
    local playerName = getPlayerName(player) or "Unknown"
    local serial = getPlayerSerial(player) or "Unknown"
    local ip = getPlayerIP(player) or "Unknown"
    
    -- Log a base de datos
    dbExec(database, "INSERT INTO detection_log (player_name, serial, ip, detection_type, details, timestamp) VALUES (?, ?, ?, ?, ?, ?)",
           playerName, serial, ip, detectionType, details, getRealTime().timestamp)
    
    -- Log a console si está habilitado
    if config.logging.console_output then
        outputDebugString(string.format("[JEICORDERO AC] %s detectado - %s (%s) - %s", 
                         detectionType, playerName, ip, details), 2)
    end
end

function sendWebhook(webhookType, title, description, fields, color)
    -- Debug logs
    outputDebugString("[JEICORDERO AC] 📡 Intentando enviar webhook tipo: " .. (webhookType or "unknown"), 3)
    outputDebugString("[JEICORDERO AC] 📝 Título: " .. (title or "nil"), 3)
    
    if not config.logging.webhook_logs then 
        outputDebugString("[JEICORDERO AC] ❌ Webhooks deshabilitados en configuración", 2)
        return 
    end
    
    -- Verificar que existe el export discord_webhooks
    if not exports.discord_webhooks then
        outputDebugString("[JEICORDERO AC] ❌ Resource 'discord_webhooks' no encontrado", 1)
        return
    end
    
    -- Usar webhook principal para todo
    local webhookUrl = config.webhooks.main
    if not webhookUrl then
        outputDebugString("[JEICORDERO AC] ❌ Webhook URL no configurada", 1)
        return
    end
    
    -- Crear mensaje con formato similar al ejemplo
    local discordMessage = {
        title = title or "JEICORDERO AC - Detección",
        description = description or "Detección del anticheat",
        color = color or 16711680, -- Rojo por defecto
        fields = fields or {},
        footer = {
            text = "By Jeicordero",
            icon_url = "https://imgur.com/n3378F1"
        },
        timestamp = "now"
    }
    
    -- Añadir campos adicionales si existen
    if fields and #fields > 0 then
        -- Los campos ya vienen en el formato correcto
    end
    
    outputDebugString("[JEICORDERO AC] 📦 Enviando via exports.discord_webhooks", 3)
    
    -- Usar el export como en tu ejemplo
    local success = exports.discord_webhooks:sendToURL(webhookUrl, discordMessage)
    
    if success then
        outputDebugString("[JEICORDERO AC] ✅ Webhook enviado exitosamente via exports", 3)
    else
        outputDebugString("[JEICORDERO AC] ❌ Error enviando webhook via exports", 1)
    end
end

function generateRandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    math.randomseed(getTickCount())
    
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        result = result .. chars:sub(randIndex, randIndex)
    end
    
    return result
end

-- ===== ANTI-VPN =====
function checkVPN(player, ip)
    -- Validar parámetros
    if not player or not isElement(player) then
        outputDebugString("[JEICORDERO AC] Error: checkVPN llamado con jugador inválido", 1)
        return
    end
    
    if not ip or ip == "" then
        outputDebugString("[JEICORDERO AC] Error: checkVPN llamado con IP inválida", 1)
        return
    end
    
    outputDebugString("[JEICORDERO AC] 🔍 Verificando VPN para " .. getPlayerName(player) .. " (" .. ip .. ")", 3)
    
    -- Verificar whitelist local primero
    local result = dbPoll(dbQuery(database, "SELECT * FROM vpn_whitelist WHERE ip = ?", ip), -1)
    if result and #result > 0 then
        outputDebugString("[JEICORDERO AC] IP " .. ip .. " está en whitelist", 3)
        return false -- No es VPN (está en whitelist)
    end
    
    -- Verificar con API externa
    if config.modules.antivpn.enabled and config.vpn_api.enabled and not config.vpn_api.key:find("TU_API_KEY") then
        local apiUrl = config.vpn_api.url .. ip .. "?key=" .. config.vpn_api.key
        outputDebugString("[JEICORDERO AC] 🌐 Consultando API: " .. apiUrl, 3)
        
        fetchRemote(apiUrl, {}, function(response, error)
            -- Verificar que el jugador sigue conectado
            if not player or not isElement(player) then
                outputDebugString("[JEICORDERO AC] Jugador desconectado antes de verificar VPN", 2)
                return
            end
            
            if response then
                local data = fromJSON(response)
                if data and data.security then
                    local isVPN = data.security.vpn or data.security.proxy or data.security.tor
                    
                    if isVPN then
                        stats.vpn_blocks = stats.vpn_blocks + 1
                        
                        local vpnType = data.security.vpn and "VPN" or data.security.proxy and "Proxy" or "Tor"
                        local playerName = "Unknown"
                        if player and isElement(player) then
                            playerName = getPlayerName(player) or "Unknown"
                        end
                        outputDebugString(string.format("[JEICORDERO AC] VPN detectada: %s (%s) usando %s", 
                                        playerName, ip or "Unknown", vpnType or "Unknown"), 2)
                        
                        local fields = {
                            {name = "🔒 Jugador", value = playerName, inline = true},
                            {name = "🌐 IP", value = ip, inline = true},
                            {name = "⚙️ Serial", value = (player and isElement(player)) and getPlayerSerial(player) or "Unknown", inline = false},
                            {name = "🚫 Tipo", value = vpnType, inline = true},
                            {name = "📊 Total Bloqueados", value = tostring(stats.vpn_blocks), inline = true}
                        }
                        
                        sendWebhook("antivpn", "🚫 VPN Detectada", "Se bloqueó una conexión VPN en " .. config.server_info.name, fields)
                        
                        addBan(ip, nil, (player and isElement(player)) and getPlayerSerial(player) or nil, "Jeicordero AC", config.modules.antivpn.ban_reason, config.modules.antivpn.ban_time)
                    else
                        -- IP verificada como no-VPN
                        local safePlayerName = "Unknown"
                        if player and isElement(player) then
                            safePlayerName = getPlayerName(player) or "Unknown"
                        end
                        outputDebugString(string.format("[JEICORDERO AC] IP verificada como legítima: %s (%s)", 
                                        safePlayerName, ip or "Unknown"), 3)
                        
                        if config.modules.antivpn.auto_whitelist_verified then
                            dbExec(database, "INSERT OR IGNORE INTO vpn_whitelist (ip, added_by, date_added, reason) VALUES (?, ?, ?, ?)", 
                                   ip, "sistema", getRealTime().timestamp, "Verificado como no-VPN")
                        end
                    end
                end
            else
                outputDebugString("[JEICORDERO AC] Error en API VPN para " .. ip .. ": " .. (error or "Sin respuesta"), 2)
            end
        end)
    end
end

addEventHandler("onPlayerConnect", root, function(nickname, ip, username, serial)
    stats.connections = stats.connections + 1
    
    -- Validar parámetros de conexión
    if not nickname or nickname == "" then nickname = "Unknown" end
    if not ip or ip == "" then 
        outputDebugString("[JEICORDERO AC] ⚠️ Conexión sin IP válida", 2)
        return 
    end
    if not serial or serial == "" then 
        outputDebugString("[JEICORDERO AC] ⚠️ Conexión sin serial válido", 2)
        return 
    end
    
    -- Log conexión si está habilitado
    if config.logging.log_successful_connections then
        outputDebugString(string.format("[JEICORDERO AC] Nueva conexión: %s (%s) - Serial: %s", nickname, ip, serial), 3)
    end
    
    -- Verificar VPN con delay configurado (usar timer para obtener el jugador cuando esté disponible)
    if config.modules.antivpn.enabled then
        setTimer(function()
            -- Buscar jugador por serial ya que nickname puede cambiar
            local targetPlayer = nil
            for _, player in ipairs(getElementsByType("player")) do
                local playerSerial = getPlayerSerial(player)
                local playerIP = getPlayerIP(player)
                
                if playerSerial == serial and playerIP == ip then
                    targetPlayer = player
                    break
                end
            end
            
            if targetPlayer then
                outputDebugString("[JEICORDERO AC] 🎯 Jugador encontrado para verificar VPN: " .. getPlayerName(targetPlayer), 3)
                checkVPN(targetPlayer, ip)
            else
                outputDebugString("[JEICORDERO AC] ⚠️ No se pudo encontrar jugador para verificar VPN: " .. (nickname or "Unknown"), 2)
                outputDebugString("[JEICORDERO AC] 📊 Jugadores online: " .. #getElementsByType("player"), 3)
            end
        end, config.modules.antivpn.check_delay, 1)
    end
    
    -- Guardar serial para anti-spoofer
    local currentTime = getRealTime().timestamp
    dbExec(database, "INSERT OR REPLACE INTO player_serials (serial, ip, first_seen, last_seen) VALUES (?, ?, COALESCE((SELECT first_seen FROM player_serials WHERE serial = ?), ?), ?)", 
           serial, ip, serial, currentTime, currentTime)
end)

-- ===== ANTI-SPOOFER =====
function detectSpoofer(oldSerial, newSerial)
    if not client then return end
    if not config.modules.antispoofer.enabled then return end
    
    if hasPermission(client) then
        outputDebugString("[JEICORDERO AC] Bypass Anti-Spoofer: " .. getPlayerName(client) .. " tiene permisos", 3)
        return -- Bypass para admins
    end
    
    -- Verificar whitelist de seriales
    if isSerialWhitelisted(newSerial) or isSerialWhitelisted(oldSerial) then
        outputDebugString("[JEICORDERO AC] Bypass Anti-Spoofer: Serial en whitelist - " .. getPlayerName(client), 3)
        return -- Bypass para seriales en whitelist
    end
    
    if oldSerial ~= newSerial then
        stats.spoofer_detections = stats.spoofer_detections + 1
        stats.total_bans = stats.total_bans + 1
        
        -- Log detección
        logDetection(client, "Anti-Spoofer", string.format("Serial anterior: %s, Serial actual: %s", oldSerial, newSerial))
        
        local fields = {
            {name = "🔒 Jugador", value = getPlayerName(client), inline = true},
            {name = "🌐 IP", value = getPlayerIP(client), inline = true},
            {name = "⚙️ Serial Anterior", value = oldSerial, inline = false},
            {name = "🆕 Serial Actual", value = newSerial, inline = false},
            {name = "📊 Total Detecciones", value = tostring(stats.spoofer_detections), inline = true}
        }
        
        sendWebhook("antispoofer", "🔍 Spoofer Detectado", "Se detectó cambio de serial en " .. config.server_info.name, fields)
        
        addBan(getPlayerIP(client), nil, newSerial, "Jeicordero AC", config.modules.antispoofer.ban_reason, config.modules.antispoofer.ban_time)
    end
end
addEvent("Pegasus.DetectSpoofer", true)
addEventHandler("Pegasus.DetectSpoofer", root, detectSpoofer)

-- ===== ANTI-EXECUTOR =====
function detectExecutor(data)
    if not client then return end
    if not config.modules.antiexecutor.enabled then return end
    
    if hasPermission(client) then
        return -- Bypass para admins
    end
    
    if data.type == "Anti-Executor" then
        stats.executor_detections = stats.executor_detections + 1
        stats.total_bans = stats.total_bans + 1
        
        -- Log detección
        logDetection(client, "Anti-Executor", string.format("Patrón: %s, Código: %s", data.pattern or "Desconocido", data.code or "N/A"))
        
        -- Subir código a hastebin para análisis
        local hastebinData = {
            headers = { ["Content-Type"] = "text/plain" },
            postData = data.code or "No code provided"
        }
        
        fetchRemote("https://hastebin.com/documents", hastebinData, function(response, error)
            local codeUrl = "No disponible"
            if response then
                local hastebinResponse = fromJSON(response)
                if hastebinResponse and hastebinResponse.key then
                    codeUrl = "https://hastebin.com/share/" .. hastebinResponse.key
                end
            end
            
            local fields = {
                {name = "🔒 Jugador", value = getPlayerName(client), inline = true},
                {name = "🌐 IP", value = getPlayerIP(client), inline = true},
                {name = "⚙️ Serial", value = getPlayerSerial(client), inline = false},
                {name = "📝 Código", value = codeUrl, inline = false},
                {name = "🎯 Patrón", value = data.pattern or "Desconocido", inline = true},
                {name = "📊 Detecciones", value = tostring(data.detections or 1), inline = true}
            }
            
            sendWebhook("antiexecutor", "💻 Executor Detectado", "Se detectó ejecución de código malicioso en " .. config.server_info.name, fields)
        end)
        
        addBan(getPlayerIP(client), nil, getPlayerSerial(client), "Jeicordero AC", config.modules.antiexecutor.ban_reason, config.modules.antiexecutor.ban_time)
        
    elseif data.type == "Anti-Block" then
        stats.total_bans = stats.total_bans + 1
        
        -- Log detección
        logDetection(client, "Anti-Block", data.reason or "Intento de bloqueo del anticheat")
        
        local fields = {
            {name = "🔒 Jugador", value = getPlayerName(client), inline = true},
            {name = "🌐 IP", value = getPlayerIP(client), inline = true},
            {name = "⚙️ Serial", value = getPlayerSerial(client), inline = false},
            {name = "🛡️ Motivo", value = data.reason or "Intento de bloqueo", inline = false}
        }
        
        sendWebhook("antiblock", "🛡️ Intento de Bypass", "Se detectó intento de bloquear el anticheat en " .. config.server_info.name, fields)
        
        addBan(getPlayerIP(client), nil, getPlayerSerial(client), "Jeicordero AC", "Intento de bypass del anticheat", 0)
    end
end
addEvent("Pegasus.detectCheaters", true)
addEventHandler("Pegasus.detectCheaters", root, detectExecutor)

-- ===== COMANDOS ADMINISTRATIVOS =====
function addVPNWhitelist(player, cmd, ip, reason)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not ip then
        outputChatBox("📝 Uso: /" .. cmd .. " [IP] [razón opcional]", player, 255, 255, 0)
        return
    end
    
    reason = reason or "Añadido manualmente por " .. getPlayerName(player)
    
    local result = dbExec(database, "INSERT OR IGNORE INTO vpn_whitelist (ip, added_by, date_added, reason) VALUES (?, ?, ?, ?)", 
                         ip, getPlayerName(player), getRealTime().timestamp, reason)
    
    if result then
        outputChatBox("✅ IP " .. ip .. " añadida a la whitelist VPN", player, 0, 255, 0)
        outputDebugString(string.format("[JEICORDERO AC] %s añadió IP %s a whitelist VPN: %s", getPlayerName(player), ip, reason), 3)
    else
        outputChatBox("❌ Error al añadir IP a la whitelist (posiblemente ya existe)", player, 255, 0, 0)
    end
end
addCommandHandler(config.commands.whitelist_vpn, addVPNWhitelist)

function removeVPNWhitelist(player, cmd, ip)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not ip then
        outputChatBox("📝 Uso: /" .. cmd .. " [IP]", player, 255, 255, 0)
        return
    end
    
    local result = dbExec(database, "DELETE FROM vpn_whitelist WHERE ip = ?", ip)
    
    if result then
        outputChatBox("✅ IP " .. ip .. " removida de la whitelist VPN", player, 0, 255, 0)
        outputDebugString(string.format("[JEICORDERO AC] %s removió IP %s de whitelist VPN", getPlayerName(player), ip), 3)
    else
        outputChatBox("❌ Error al remover IP de la whitelist", player, 255, 0, 0)
    end
end
addCommandHandler(config.commands.remove_whitelist, removeVPNWhitelist)

function showACStats(player, cmd)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    outputChatBox("📊 ═══ JEICORDERO AC ESTADÍSTICAS ═══", player, 0, 255, 255)
    outputChatBox("🔗 Conexiones totales: " .. stats.connections, player, 255, 255, 255)
    outputChatBox("🚫 VPNs bloqueadas: " .. stats.vpn_blocks, player, 255, 255, 255)
    outputChatBox("🔍 Spoofers detectados: " .. stats.spoofer_detections, player, 255, 255, 255)
    outputChatBox("💻 Executors detectados: " .. stats.executor_detections, player, 255, 255, 255)
    outputChatBox("🔨 Total bans aplicados: " .. stats.total_bans, player, 255, 255, 255)
    
    -- Estadísticas de base de datos
    local vpnWhitelist = dbPoll(dbQuery(database, "SELECT COUNT(*) as count FROM vpn_whitelist"), -1)
    local totalSerials = dbPoll(dbQuery(database, "SELECT COUNT(*) as count FROM player_serials"), -1)
    
    if vpnWhitelist and vpnWhitelist[1] then
        outputChatBox("📝 IPs en whitelist VPN: " .. vpnWhitelist[1].count, player, 255, 255, 255)
    end
    if totalSerials and totalSerials[1] then
        outputChatBox("👥 Serials registrados: " .. totalSerials[1].count, player, 255, 255, 255)
    end
end
addCommandHandler(config.commands.stats, showACStats)

-- Comando para probar webhooks
function testWebhook(player, cmd, tipo)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    tipo = tipo or "test"
    outputChatBox("🧪 Probando webhook " .. tipo .. "...", player, 255, 255, 0)
    
    local fields = {
        {name = "🧪 Prueba", value = "Este es un mensaje de prueba del anticheat", inline = false},
        {name = "👤 Enviado por", value = getPlayerName(player), inline = true},
        {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
        {name = "🌐 IP", value = getPlayerIP(player), inline = true},
        {name = "⚙️ Serial", value = getPlayerSerial(player), inline = false}
    }
    
    sendWebhook("test", "🧪 Prueba de Webhook - JEICORDERO AC", 
               "> [ + ] Servidor: **" .. config.server_info.name .. "**\n" ..
               "> [ + ] Enviado por: **" .. getPlayerName(player) .. "**\n" ..
               "> [ + ] Tipo: **Prueba de funcionamiento**\n" ..
               "> [ + ] Estado: **Todos los sistemas operativos**", 
               fields, 65280) -- Verde
    
    outputChatBox("✅ Webhook enviado via exports.discord_webhooks. Revisa Discord!", player, 0, 255, 0)
end
addCommandHandler("testwebhook", testWebhook)

-- Comando para remover ban de spoofer (para pruebas)
function unbanSpoofer(player, cmd, serial_o_ip)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not serial_o_ip then
        outputChatBox("📝 Uso: /" .. cmd .. " [serial o IP]", player, 255, 255, 0)
        return
    end
    
    -- Intentar unban por serial primero, luego por IP
    local result1 = removeBan(nil, nil, serial_o_ip)
    local result2 = removeBan(serial_o_ip, nil, nil)
    
    if result1 or result2 then
        outputChatBox("✅ Ban removido para: " .. serial_o_ip, player, 0, 255, 0)
        outputDebugString("[JEICORDERO AC] " .. getPlayerName(player) .. " removió ban de spoofer: " .. serial_o_ip, 3)
    else
        outputChatBox("❌ No se encontró ban para: " .. serial_o_ip, player, 255, 0, 0)
    end
end
addCommandHandler("unbanspoofer", unbanSpoofer)

-- Comando para resetear archivo de serial (para pruebas)
function resetSerial(player, cmd)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    outputChatBox("📝 Instrucciones para resetear serial:", player, 255, 255, 0)
    outputChatBox("1. Salir del servidor", player, 255, 255, 255)
    outputChatBox("2. Buscar archivo: @pegasus_serial.json", player, 255, 255, 255)
    outputChatBox("3. Eliminar el archivo", player, 255, 255, 255)
    outputChatBox("4. Reconectar (se creará nuevo archivo)", player, 255, 255, 255)
    outputChatBox("O usa: /verserial para ver contenido actual", player, 255, 255, 255)
end
addCommandHandler("resetserial", resetSerial)

-- Comando para añadir serial a whitelist
function addSerialWhitelist(player, cmd, serial, ...)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not serial then
        outputChatBox("📝 Uso: /" .. cmd .. " [serial] [razón opcional]", player, 255, 255, 0)
        outputChatBox("💡 Tip: Usa /verserial para ver tu serial actual", player, 255, 255, 0)
        return
    end
    
    local reason = table.concat({...}, " ")
    if reason == "" then
        reason = "Añadido por " .. getPlayerName(player) .. " para pruebas"
    end
    
    local result = dbExec(database, "INSERT OR IGNORE INTO serial_whitelist (serial, added_by, reason, date_added) VALUES (?, ?, ?, ?)", 
                         serial, getPlayerName(player), reason, getRealTime().timestamp)
    
    if result then
        outputChatBox("✅ Serial añadido a whitelist Anti-Spoofer: " .. serial, player, 0, 255, 0)
        outputDebugString("[JEICORDERO AC] " .. getPlayerName(player) .. " añadió serial a whitelist: " .. serial .. " - " .. reason, 3)
    else
        outputChatBox("❌ Error al añadir serial (posiblemente ya existe)", player, 255, 0, 0)
    end
end
addCommandHandler("addserialwhitelist", addSerialWhitelist)

-- Comando para remover serial de whitelist
function removeSerialWhitelist(player, cmd, serial)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    if not serial then
        outputChatBox("📝 Uso: /" .. cmd .. " [serial]", player, 255, 255, 0)
        return
    end
    
    local result = dbExec(database, "DELETE FROM serial_whitelist WHERE serial = ?", serial)
    
    if result then
        outputChatBox("✅ Serial removido de whitelist: " .. serial, player, 0, 255, 0)
        outputDebugString("[JEICORDERO AC] " .. getPlayerName(player) .. " removió serial de whitelist: " .. serial, 3)
    else
        outputChatBox("❌ Error al remover serial de whitelist", player, 255, 0, 0)
    end
end
addCommandHandler("removeserialwhitelist", removeSerialWhitelist)

-- Comando para ver whitelist de seriales
function listSerialWhitelist(player, cmd)
    if not hasPermission(player) then
        outputChatBox("❌ No tienes permisos para usar este comando", player, 255, 0, 0)
        return
    end
    
    local result = dbPoll(dbQuery(database, "SELECT * FROM serial_whitelist ORDER BY date_added DESC LIMIT 10"), -1)
    
    if result and #result > 0 then
        outputChatBox("📋 ═══ WHITELIST SERIALES ANTI-SPOOFER ═══", player, 0, 255, 255)
        for i, row in ipairs(result) do
            outputChatBox(string.format("%d. %s - %s (%s)", i, row.serial, row.reason or "Sin razón", row.added_by or "Unknown"), player, 255, 255, 255)
        end
    else
        outputChatBox("📋 Whitelist de seriales vacía", player, 255, 255, 0)
    end
end
addCommandHandler("listserialwhitelist", listSerialWhitelist)

-- ===== VERIFICACIONES DE INTEGRIDAD =====
addEventHandler("onPlayerLogin", root, function()
    setTimer(function(player)
        if not player or not isElement(player) then return end
        
        if not getElementData(player, "Pegasus.AntiCheat") then
            if not isGuestAccount(getPlayerAccount(player)) then
                logDetection(player, "Anti-Block", "Anticheat no inicializado correctamente")
                addBan(getPlayerIP(player), nil, getPlayerSerial(player), "Jeicordero AC", "Anticheat no inicializado correctamente", 60)
            end
        end
    end, 5000, 1, source)
end)

-- ===== INICIALIZACIÓN =====
setTimer(function()
    local modulesActive = {}
    if config.modules.antivpn.enabled then table.insert(modulesActive, "Anti-VPN") end
    if config.modules.antispoofer.enabled then table.insert(modulesActive, "Anti-Spoofer") end
    if config.modules.antiexecutor.enabled then table.insert(modulesActive, "Anti-Executor") end
    
    local modulesList = table.concat(modulesActive, ", ")
    outputDebugString(string.format("[JEICORDERO AC] Servidor iniciado correctamente - Módulos activos: %s", modulesList), 3)
    
    -- Verificar configuración
    local errors = validateConfig()
    if #errors > 0 then
        outputDebugString("⚠️ [JEICORDERO AC] Configuración incompleta, algunos módulos pueden no funcionar correctamente", 2)
    end
end, 1000, 1)
