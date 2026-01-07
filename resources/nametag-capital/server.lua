--[[
    Sistema /yo para La Capital Roleplay
    Servidor - Manejo de comandos y datos
]]

-- Configuración del servidor
local CONFIG = {
    MAX_YO_LENGTH = 100,
    MIN_YO_LENGTH = 5,
    COOLDOWN_TIME = 3000, -- 3 segundos en milisegundos
    PALABRAS_PROHIBIDAS = {
        "admin", "staff", "moderador", "helper", "gm", "gamemaster",
        "hack", "cheat", "bug", "exploit", "script", "mod"
    }
}

-- Cache de cooldowns
local cooldowns = {}

-- Función para limpiar texto
function limpiarTexto(texto)
    -- Remover caracteres especiales peligrosos
    texto = texto:gsub("[<>\"'&]", "")
    -- Remover espacios extra
    texto = texto:gsub("%s+", " ")
    -- Trim
    texto = texto:match("^%s*(.-)%s*$")
    return texto
end

-- Función para validar contenido
function validarContenido(texto)
    local textoLower = texto:lower()
    
    -- Verificar palabras prohibidas
    for _, palabra in ipairs(CONFIG.PALABRAS_PROHIBIDAS) do
        if textoLower:find(palabra) then
            return false, "El texto contiene palabras no permitidas."
        end
    end
    
    -- Verificar longitud
    if #texto < CONFIG.MIN_YO_LENGTH then
        return false, "La descripción debe tener al menos " .. CONFIG.MIN_YO_LENGTH .. " caracteres."
    end
    
    if #texto > CONFIG.MAX_YO_LENGTH then
        return false, "La descripción no puede exceder " .. CONFIG.MAX_YO_LENGTH .. " caracteres."
    end
    
    return true, "Válido"
end

-- Función para verificar cooldown
function verificarCooldown(player)
    local accountName = getAccountName(getPlayerAccount(player))
    if not accountName then return false end
    
    local ultimoUso = cooldowns[accountName]
    if ultimoUso then
        local tiempoTranscurrido = getTickCount() - ultimoUso
        if tiempoTranscurrido < CONFIG.COOLDOWN_TIME then
            local tiempoRestante = math.ceil((CONFIG.COOLDOWN_TIME - tiempoTranscurrido) / 1000)
            return false, tiempoRestante
        end
    end
    
    return true
end

-- Comando /yo
addCommandHandler("yo", function(player, cmd, ...)
    -- Verificar si el jugador está logueado
    if not getElementData(player, "playerid") then
        outputChatBox("§[Error] §Debes estar logueado para usar este comando.", player, 255, 100, 100)
        return
    end
    
    -- Verificar argumentos
    if not ... then
        local yoActual = getElementData(player, "yo") or "Ninguna"
        outputChatBox("§[/yo] §Uso: /yo [descripción] - Actual: " .. yoActual, player, 100, 200, 255)
        outputChatBox("§[Info] §Describe las características físicas visibles de tu personaje.", player, 150, 150, 150)
        return
    end
    
    -- Verificar cooldown
    local puedeUsar, tiempoRestante = verificarCooldown(player)
    if not puedeUsar then
        outputChatBox("§[Cooldown] §Debes esperar " .. tiempoRestante .. " segundos antes de usar /yo nuevamente.", player, 255, 165, 0)
        return
    end
    
    -- Procesar texto
    local texto = table.concat({...}, " ")
    texto = limpiarTexto(texto)
    
    -- Validar contenido
    local esValido, mensaje = validarContenido(texto)
    if not esValido then
        outputChatBox("§[Error] §" .. mensaje, player, 255, 100, 100)
        return
    end
    
    -- Guardar cooldown
    local accountName = getAccountName(getPlayerAccount(player))
    if accountName then
        cooldowns[accountName] = getTickCount()
    end
    
    -- Establecer el /yo
    setElementData(player, "yo", texto)
    
    -- Confirmar al jugador
    outputChatBox("§[/yo] §Características físicas establecidas: " .. texto, player, 100, 255, 100)
    
    -- Log para administradores
    local playerName = getPlayerName(player)
    local playerID = getElementData(player, "playerid") or "?"
    outputServerLog("[YO] " .. playerName .. " [ID:" .. playerID .. "] estableció: " .. texto)
    
    -- Notificar a staff en servicio (opcional)
    for _, staff in ipairs(getElementsByType("player")) do
        if getElementData(staff, "account:gmduty") then
            outputChatBox("§[Staff-Log] §" .. playerName .. " [" .. playerID .. "] /yo: " .. texto, staff, 200, 200, 200)
        end
    end
end)

-- Comando /limpiaryo - Para limpiar la descripción
addCommandHandler("limpiaryo", function(player)
    if not getElementData(player, "playerid") then
        outputChatBox("§[Error] §Debes estar logueado para usar este comando.", player, 255, 100, 100)
        return
    end
    
    -- Verificar cooldown
    local puedeUsar, tiempoRestante = verificarCooldown(player)
    if not puedeUsar then
        outputChatBox("§[Cooldown] §Debes esperar " .. tiempoRestante .. " segundos.", player, 255, 165, 0)
        return
    end
    
    -- Guardar cooldown
    local accountName = getAccountName(getPlayerAccount(player))
    if accountName then
        cooldowns[accountName] = getTickCount()
    end
    
    -- Limpiar /yo
    setElementData(player, "yo", "")
    outputChatBox("§[/yo] §Características físicas eliminadas.", player, 100, 255, 100)
    
    -- Log
    local playerName = getPlayerName(player)
    local playerID = getElementData(player, "playerid") or "?"
    outputServerLog("[YO] " .. playerName .. " [ID:" .. playerID .. "] limpió su descripción")
end)

-- Comando /veryo - Para ver la descripción de otro jugador (Staff)
addCommandHandler("veryo", function(player, cmd, targetID)
    -- Solo staff puede usar este comando
    if not getElementData(player, "account:gmduty") then
        outputChatBox("§[Error] §No tienes permisos para usar este comando.", player, 255, 100, 100)
        return
    end
    
    if not targetID then
        outputChatBox("§[/veryo] §Uso: /veryo [ID]", player, 100, 200, 255)
        return
    end
    
    -- Buscar jugador por ID
    local targetPlayer = nil
    for _, p in ipairs(getElementsByType("player")) do
        if tostring(getElementData(p, "playerid")) == targetID then
            targetPlayer = p
            break
        end
    end
    
    if not targetPlayer then
        outputChatBox("§[Error] §Jugador con ID " .. targetID .. " no encontrado.", player, 255, 100, 100)
        return
    end
    
    local targetName = getPlayerName(targetPlayer)
    local yo = getElementData(targetPlayer, "yo") or "Ninguna descripción establecida"
    
    outputChatBox("§[Staff] §/yo de " .. targetName .. " [" .. targetID .. "]: " .. yo, player, 255, 165, 0)
end)

-- Limpiar cooldowns al desconectarse
addEventHandler("onPlayerQuit", root, function()
    local accountName = getAccountName(getPlayerAccount(source))
    if accountName and cooldowns[accountName] then
        cooldowns[accountName] = nil
    end
end)

-- Limpiar /yo al desconectarse (opcional, depende de si quieres que persista)
addEventHandler("onPlayerQuit", root, function()
    setElementData(source, "yo", "")
end)

-- Función para cargar /yo desde base de datos (si tienes sistema de guardado)
function cargarYoDesdeDB(player)
    -- Esta función se puede implementar si tienes un sistema de base de datos
    -- Por ahora, el /yo se resetea al reconectarse
    setElementData(player, "yo", "")
end

-- Cargar /yo al spawnear
addEventHandler("onPlayerSpawn", root, function()
    cargarYoDesdeDB(source)
end)

-- Comando de información del sistema
addCommandHandler("infoyo", function(player)
    outputChatBox("§═══════════════════════════════════════", player, 100, 200, 255)
    outputChatBox("§[La Capital Roleplay] §Sistema de Características Físicas", player, 100, 200, 255)
    outputChatBox("§", player)
    outputChatBox("§/yo [descripción] - Establecer características físicas", player, 255, 255, 255)
    outputChatBox("§/limpiaryo - Eliminar descripción actual", player, 255, 255, 255)
    outputChatBox("§/infoyo - Mostrar esta información", player, 255, 255, 255)
    outputChatBox("§", player)
    outputChatBox("§Límites: " .. CONFIG.MIN_YO_LENGTH .. "-" .. CONFIG.MAX_YO_LENGTH .. " caracteres", player, 200, 200, 200)
    outputChatBox("§Cooldown: " .. (CONFIG.COOLDOWN_TIME/1000) .. " segundos", player, 200, 200, 200)
    outputChatBox("§═══════════════════════════════════════", player, 100, 200, 255)
end)

-- Funciones exportables para otros recursos
function obtenerYoJugador(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    return getElementData(player, "yo") or ""
end

function establecerYoJugador(player, descripcion)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    if not descripcion or type(descripcion) ~= "string" then
        return false
    end
    
    descripcion = limpiarTexto(descripcion)
    local esValido, mensaje = validarContenido(descripcion)
    
    if not esValido then
        return false, mensaje
    end
    
    setElementData(player, "yo", descripcion)
    return true
end

-- Mensaje de bienvenida del sistema
addEventHandler("onResourceStart", resourceRoot, function()
    outputServerLog("[La Capital Roleplay] Sistema de nametags y /yo iniciado correctamente")
    
    -- Notificar a todos los jugadores conectados
    for _, player in ipairs(getElementsByType("player")) do
        outputChatBox("§[Sistema] §Nametags de La Capital Roleplay cargados. Usa /infoyo para más información.", player, 100, 255, 100)
    end
end)
