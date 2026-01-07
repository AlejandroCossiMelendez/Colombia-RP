--[[
============================================
SISTEMA DE TERRITORIOS - LA CAPITAL RP
============================================
Sistema completo optimizado y organizado
Ganancias: $12M/hora por territorio
Solo facciones ilegales
============================================
]]

-- ==========================================
-- CONFIGURACIÓN PRINCIPAL (fácil modificar)
-- ==========================================

local CONFIG = {
    -- Facciones que pueden participar (agregar más aquí)
    FACCIONES_PERMITIDAS = {5, 10, 11, 12, 13, 14, 15, 16}, -- CDM, RUSA, CDC, TRECE, MECAIL, ELN, CDJ, CDG
    
    -- Configuración de batalla
    JUGADORES_MIN_ONLINE = 1,     -- Mínimo jugadores online para atacar
    MAX_FACCIONES_BATALLA = 4,    -- Máximo facciones por territorio
    TIEMPO_BATALLA_MULTIPLE = 900, -- 15 minutos para batallas múltiples
    COOLDOWN_ATAQUE = 1800,       -- 30 minutos entre ataques
    
    -- Configuración económica
    SOLO_CON_JUGADORES_ONLINE = true, -- Solo generar dinero si hay jugadores online
    INTERVALO_GANANCIAS = 3600000,    -- 1 hora en milisegundos
    
    -- Sistema
    VERIFICACION_FRECUENCIA = 10000,  -- Verificar batallas cada 10 segundos
    SPAM_REDUCIDO = true,             -- Menos mensajes en chat
}

-- ==========================================
-- VARIABLES DEL SISTEMA
-- ==========================================

local territorios = {}
local batallas = {}
local negocios = {}
local jugadoresEnZona = {}
local jugadoresEnBatalla = {}
local colisiones = {}
local cooldowns = {}

-- ==========================================
-- FUNCIONES BÁSICAS
-- ==========================================

function cargarTerritorios()
    -- Cargar territorios desde base de datos
    local result = exports.sql:query_assoc([[
        SELECT t.*, f.factionTag, g.groupName as factionName 
        FROM territorios t 
        LEFT JOIN factions f ON t.factionID = f.factionID 
        LEFT JOIN wcf1_group g ON f.groupID = g.groupID 
        WHERE t.activo = 1
    ]])
    
    if result then
        territorios = {}
        
        -- Limpiar colisiones anteriores
        for id, col in pairs(colisiones) do
            if isElement(col) then destroyElement(col) end
        end
        colisiones = {}
        
        -- Crear territorios y colisiones
        for _, t in ipairs(result) do
            territorios[t.territorioID] = {
                id = t.territorioID,
                nombre = t.nombre,
                x1 = t.x1, y1 = t.y1, x2 = t.x2, y2 = t.y2,
                centerX = t.centerX, centerY = t.centerY, centerZ = t.centerZ or 3,
                factionID = t.factionID,
                factionName = t.factionName,
                ganancia = t.gananciaPorHora,
                tiempo = t.tiempoConquista,
                enAtaque = t.enAtaque == 1,
                atacante = t.factionAtacante
            }
            
            -- Crear colisión para detectar entrada/salida
            local col = createColCuboid(t.x1, t.y1, -50, t.x2 - t.x1, t.y2 - t.y1, 200)
            if col then
                colisiones[t.territorioID] = col
                
                addEventHandler("onColShapeHit", col, function(player)
                    if getElementType(player) == "player" and exports.players:isLoggedIn(player) then
                        entrarZona(player, t.territorioID)
                    end
                end)
                
                addEventHandler("onColShapeLeave", col, function(player)
                    if getElementType(player) == "player" and exports.players:isLoggedIn(player) then
                        salirZona(player, t.territorioID)
                    end
                end)
            end
        end
        
        -- Enviar a clientes
        triggerClientEvent(getElementsByType("player"), "territorios:sync", resourceRoot, territorios)
    end
    
    -- Cargar negocios
    local negResult = exports.sql:query_assoc("SELECT * FROM territorios_negocios WHERE activo = 1")
    if negResult then
        negocios = {}
        for _, n in ipairs(negResult) do
            negocios[n.negocioID] = {
                territorio = n.territorioID,
                ganancia = n.gananciaPorHora
            }
        end
    end
    
    outputDebugString("[TERRITORIOS] Sistema cargado: " .. (result and #result or 0) .. " territorios")
end

function esFaccionPermitida(factionID)
    for _, permitida in ipairs(CONFIG.FACCIONES_PERMITIDAS) do
        if factionID == permitida then return true end
    end
    return false
end

function obtenerFaccionJugador(player)
    local factions = exports.factions:getPlayerFactions(player)
    if not factions then return nil end
    
    for _, faction in ipairs(factions) do
        if esFaccionPermitida(faction) then
            return faction
        end
    end
    return nil
end

function obtenerTerritorioJugador(player)
    for territID, jugadores in pairs(jugadoresEnZona) do
        if jugadores[player] then
            return territID, territorios[territID]
        end
    end
    return false
end

function contarJugadoresOnline(factionID)
    local count = 0
    for _, player in ipairs(getElementsByType("player")) do
        if exports.players:isLoggedIn(player) then
            local factions = exports.factions:getPlayerFactions(player)
            if factions then
                for _, f in ipairs(factions) do
                    if f == factionID then
                        count = count + 1
                        break
                    end
                end
            end
        end
    end
    return count
end

function contarVivosEnZona(factionID, territID)
    local count = 0
    if jugadoresEnZona[territID] then
        for player, datos in pairs(jugadoresEnZona[territID]) do
            if isElement(player) and exports.players:isLoggedIn(player) and 
               not getElementData(player, "muerto") and not isPedDead(player) and
               datos.faction == factionID then
                count = count + 1
            end
        end
    end
    return count
end

function calcularGananciaTotal(territID)
    local total = territorios[territID].ganancia
    for _, negocio in pairs(negocios) do
        if negocio.territorio == territID then
            total = total + negocio.ganancia
        end
    end
    return total
end

function formatearDinero(amount)
    if amount >= 1000000 then
        return string.format("%.1fM", amount / 1000000)
    elseif amount >= 1000 then
        return string.format("%.0fK", amount / 1000)
    else
        return tostring(amount)
    end
end

-- ==========================================
-- SISTEMA DE ZONA (ENTRADA/SALIDA)
-- ==========================================

function entrarZona(player, territID)
    if not jugadoresEnZona[territID] then
        jugadoresEnZona[territID] = {}
    end
    
    jugadoresEnZona[territID][player] = {
        faction = obtenerFaccionJugador(player),
        tiempo = getTickCount()
    }
    
    -- Si hay batalla, agregar a batalla
    if batallas[territID] then
        agregarABatalla(player, territID)
    end
end

function salirZona(player, territID)
    if jugadoresEnZona[territID] then
        jugadoresEnZona[territID][player] = nil
    end
    
    if jugadoresEnBatalla[player] and jugadoresEnBatalla[player].territorio == territID then
        jugadoresEnBatalla[player] = nil
        setTimer(verificarBatalla, 2000, 1, territID)
    end
end

-- ==========================================
-- SISTEMA DE BATALLA
-- ==========================================

function iniciarBatalla(player, territID)
    local territorio = territorios[territID]
    local faction = obtenerFaccionJugador(player)
    
    -- Validaciones
    if not faction then
        return false, "Solo facciones ilegales pueden participar"
    end
    
    if territorio.factionID == faction then
        return false, "Tu faccion ya controla este territorio"
    end
    
    if not jugadoresEnZona[territID] or not jugadoresEnZona[territID][player] then
        return false, "Debes estar en el territorio"
    end
    
    -- Verificar cooldown
    local coolKey = faction .. "_" .. territID
    if cooldowns[coolKey] and getTickCount() - cooldowns[coolKey] < CONFIG.COOLDOWN_ATAQUE * 1000 then
        local minutos = math.ceil((CONFIG.COOLDOWN_ATAQUE * 1000 - (getTickCount() - cooldowns[coolKey])) / 60000)
        return false, "Cooldown: " .. minutos .. " minutos"
    end
    
    -- Verificar jugadores online
    if contarJugadoresOnline(faction) < CONFIG.JUGADORES_MIN_ONLINE then
        return false, "Necesitas " .. CONFIG.JUGADORES_MIN_ONLINE .. " jugador online"
    end
    
    -- Iniciar o unirse a batalla
    if not territorio.enAtaque then
        return crearBatalla(player, territID, faction)
    else
        return unirseABatalla(player, territID, faction)
    end
end

function crearBatalla(player, territID, faction)
    local territorio = territorios[territID]
    
    territorio.enAtaque = true
    territorio.atacante = faction
    
    batallas[territID] = {
        facciones = {[faction] = {player}},
        duenoOriginal = territorio.factionID,
        inicio = getTickCount(),
        tiempoLimite = territorio.tiempo * 1000,
        tipo = "individual"
    }
    
    jugadoresEnBatalla[player] = {territorio = territID, faction = faction}
    cooldowns[faction .. "_" .. territID] = getTickCount()
    
    exports.sql:query_free("UPDATE territorios SET enAtaque = 1, factionAtacante = %d WHERE territorioID = %d", faction, territID)
    
    -- Mensaje
    local factionName = exports.factions:getFactionName(faction)
    outputChatBox("[ATAQUE] " .. factionName .. " atacando " .. territorio.nombre .. " (" .. (territorio.tiempo/60) .. "m)", root, 255, 200, 0)
    
    triggerClientEvent(getElementsByType("player"), "territorios:rojo", resourceRoot, territID)
    
    setTimer(verificarBatalla, CONFIG.VERIFICACION_FRECUENCIA, 0, territID)
    setTimer(finalizarBatalla, territorio.tiempo * 1000, 1, territID)
    
    return true, "Ataque iniciado"
end

function unirseABatalla(player, territID, faction)
    local batalla = batallas[territID]
    
    if batalla.facciones[faction] then
        return false, "Tu faccion ya participa"
    end
    
    if #batalla.facciones >= CONFIG.MAX_FACCIONES_BATALLA then
        return false, "Batalla llena"
    end
    
    -- Unirse
    batalla.facciones[faction] = {player}
    batalla.tipo = "multiple"
    jugadoresEnBatalla[player] = {territorio = territID, faction = faction}
    cooldowns[faction .. "_" .. territID] = getTickCount()
    
    -- Si es la segunda facción, cambiar a tiempo múltiple
    if #batalla.facciones == 2 then
        batalla.tiempoLimite = CONFIG.TIEMPO_BATALLA_MULTIPLE * 1000
        setTimer(finalizarBatalla, CONFIG.TIEMPO_BATALLA_MULTIPLE * 1000, 1, territID)
    end
    
    local factionName = exports.factions:getFactionName(faction)
    outputChatBox("[BATALLA MULTIPLE] " .. factionName .. " se une (" .. #batalla.facciones .. " facciones)", root, 255, 255, 0)
    
    triggerClientEvent(getElementsByType("player"), "territorios:amarillo", resourceRoot, territID)
    
    return true, "Te uniste a la batalla"
end

function verificarBatalla(territID)
    local batalla = batallas[territID]
    if not batalla then return end
    
    -- Contar facciones con jugadores vivos
    local faccionesVivas = {}
    for faction, jugadores in pairs(batalla.facciones) do
        local vivos = contarVivosEnZona(faction, territID)
        if vivos > 0 then
            faccionesVivas[faction] = vivos
        end
    end
    
    local numFacciones = 0
    local ultimaFaccion = nil
    for faction, vivos in pairs(faccionesVivas) do
        numFacciones = numFacciones + 1
        ultimaFaccion = faction
    end
    
    -- Si no hay jugadores vivos
    if numFacciones == 0 then
        restaurarTerritorio(territID)
        return
    end
    
    -- Si solo queda una facción
    if numFacciones == 1 and batalla.tipo == "multiple" then
        batalla.tipo = "individual"
        territorios[territID].atacante = ultimaFaccion
        triggerClientEvent(getElementsByType("player"), "territorios:rojo", resourceRoot, territID)
    end
    
    -- Limpiar facciones sin jugadores
    for faction, jugadores in pairs(batalla.facciones) do
        if not faccionesVivas[faction] then
            batalla.facciones[faction] = nil
        end
    end
end

function finalizarBatalla(territID)
    local batalla = batallas[territID]
    if not batalla then return end
    
    -- Contar supervivientes
    local resultados = {}
    for faction, jugadores in pairs(batalla.facciones) do
        local vivos = contarVivosEnZona(faction, territID)
        if vivos > 0 then
            table.insert(resultados, {faction = faction, vivos = vivos})
        end
    end
    
    -- Ordenar por supervivientes
    table.sort(resultados, function(a, b) return a.vivos > b.vivos end)
    
    if #resultados == 0 then
        restaurarTerritorio(territID)
    elseif #resultados == 1 or resultados[1].vivos > resultados[2].vivos then
        conquistarTerritorio(territID, resultados[1].faction)
    else
        restaurarTerritorio(territID)
    end
end

function conquistarTerritorio(territID, faction)
    local territorio = territorios[territID]
    
    territorio.factionID = faction
    territorio.factionName = exports.factions:getFactionName(faction)
    territorio.enAtaque = false
    territorio.atacante = nil
    
    exports.sql:query_free("UPDATE territorios SET factionID = %d, fechaConquista = NOW(), enAtaque = 0, factionAtacante = NULL WHERE territorioID = %d", faction, territID)
    
    outputChatBox("[CONQUISTA] " .. territorio.factionName .. " controla " .. territorio.nombre, root, 0, 255, 0)
    
    limpiarBatalla(territID)
    triggerClientEvent(getElementsByType("player"), "territorios:conquistado", resourceRoot, territID, faction)
end

function restaurarTerritorio(territID)
    local territorio = territorios[territID]
    local batalla = batallas[territID]
    
    if batalla and batalla.duenoOriginal then
        territorio.factionID = batalla.duenoOriginal
        territorio.factionName = exports.factions:getFactionName(batalla.duenoOriginal)
        exports.sql:query_free("UPDATE territorios SET factionID = %d, enAtaque = 0, factionAtacante = NULL WHERE territorioID = %d", batalla.duenoOriginal, territID)
        triggerClientEvent(getElementsByType("player"), "territorios:restaurado", resourceRoot, territID, batalla.duenoOriginal)
    else
        territorio.factionID = nil
        territorio.factionName = nil
        exports.sql:query_free("UPDATE territorios SET factionID = NULL, enAtaque = 0, factionAtacante = NULL WHERE territorioID = %d", territID)
        triggerClientEvent(getElementsByType("player"), "territorios:neutral", resourceRoot, territID)
    end
    
    territorio.enAtaque = false
    territorio.atacante = nil
    limpiarBatalla(territID)
end

function limpiarBatalla(territID)
    batallas[territID] = nil
    for player, datos in pairs(jugadoresEnBatalla) do
        if datos.territorio == territID then
            jugadoresEnBatalla[player] = nil
        end
    end
end

function agregarABatalla(player, territID)
    local faction = obtenerFaccionJugador(player)
    if not faction or not batallas[territID] then return end
    
    if batallas[territID].facciones[faction] then
        table.insert(batallas[territID].facciones[faction], player)
        jugadoresEnBatalla[player] = {territorio = territID, faction = faction}
    end
end

-- ==========================================
-- SISTEMA DE GANANCIAS
-- ==========================================

function generarGanancias()
    for territID, territorio in pairs(territorios) do
        if territorio.factionID and not territorio.enAtaque then
            -- Solo generar si hay jugadores online
            local puedeGenerar = true
            if CONFIG.SOLO_CON_JUGADORES_ONLINE then
                local jugadoresOnline = contarJugadoresOnline(territorio.factionID)
                if jugadoresOnline == 0 then
                    puedeGenerar = false
                end
            end
            
            if puedeGenerar then
                local gananciaTotal = calcularGananciaTotal(territID)
                exports.factions:giveFactionPresupuesto(territorio.factionID, gananciaTotal)
                
                -- Notificar solo a líderes
                if not CONFIG.SPAM_REDUCIDO then
                    local lideres = exports.factions:getFactionOwners(territorio.factionID)
                    if lideres then
                        for _, lider in ipairs(lideres) do
                            local player = exports.players:getPlayerFromCharacterID(lider.characterID)
                            if player then
                                outputChatBox("[TERRITORIO] " .. territorio.nombre .. " → $" .. formatearDinero(gananciaTotal), player, 255, 255, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ==========================================
-- EVENTOS DE MUERTE
-- ==========================================

addEvent("onSufrirDamageCapitalRP", true)
addEventHandler("onSufrirDamageCapitalRP", root, function(atacante, arma, parte, muerto)
    if muerto and getElementData(source, "muerto") == true then
        if jugadoresEnBatalla[source] then
            local datos = jugadoresEnBatalla[source]
            jugadoresEnBatalla[source] = nil
            setTimer(verificarBatalla, 1500, 1, datos.territorio)
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    jugadoresEnBatalla[source] = nil
    for territID, jugadores in pairs(jugadoresEnZona) do
        if jugadores[source] then
            jugadores[source] = nil
            if batallas[territID] then
                setTimer(verificarBatalla, 1000, 1, territID)
            end
        end
    end
end)

-- ==========================================
-- COMANDOS
-- ==========================================

function comandoTerritorios(player)
    if not exports.players:isLoggedIn(player) then return end
    
    outputChatBox("=== TERRITORIOS LOS SANTOS ===", player, 255, 255, 0)
    
    for territID, territorio in pairs(territorios) do
        local estado = territorio.factionName or "Neutral"
        if territorio.enAtaque then
            estado = estado .. " [BATALLA]"
        end
        
        local ganancia = formatearDinero(calcularGananciaTotal(territID))
        outputChatBox("[" .. territID .. "] " .. territorio.nombre .. " - " .. estado .. " ($" .. ganancia .. "/h)", player, 
                     territorio.enAtaque and 255 or (territorio.factionID and 100 or 200),
                     territorio.enAtaque and 100 or 255,
                     territorio.enAtaque and 100 or (territorio.factionID and 100 or 200))
    end
end
addCommandHandler("territorios", comandoTerritorios)

function comandoAtacar(player)
    if not exports.players:isLoggedIn(player) then return end
    
    local territID, territorio = obtenerTerritorioJugador(player)
    if not territID then
        outputChatBox("No estas en ningun territorio", player, 255, 100, 100)
        return
    end
    
    local exito, mensaje = iniciarBatalla(player, territID)
    outputChatBox(exito and "[OK] " .. mensaje or "[X] " .. mensaje, player, 
                  exito and 100 or 255, exito and 255 or 100, 100)
end
addCommandHandler("atacar", comandoAtacar)
addCommandHandler("reclamar", comandoAtacar)

function comandoTerritorio(player)
    if not exports.players:isLoggedIn(player) then return end
    
    local territID, territorio = obtenerTerritorioJugador(player)
    if not territID then
        outputChatBox("No estas en ningun territorio", player, 255, 100, 100)
        return
    end
    
    local info = "=== " .. territorio.nombre .. " ==="
    info = info .. "\n" .. (territorio.factionName and ("Controlado: " .. territorio.factionName) or "Estado: Neutral")
    info = info .. "\nGanancia: $" .. formatearDinero(calcularGananciaTotal(territID)) .. "/hora"
    
    if territorio.enAtaque then
        local batalla = batallas[territID]
        if batalla then
            local tiempo = (batalla.tiempoLimite - (getTickCount() - batalla.inicio)) / 60000
            info = info .. "\nBajo ataque (" .. math.ceil(tiempo) .. "m restante)"
        end
    end
    
    outputChatBox(info, player, 255, 255, 255)
end
addCommandHandler("territorio", comandoTerritorio)

function comandoBatalla(player)
    if not exports.players:isLoggedIn(player) then return end
    
    local territID, territorio = obtenerTerritorioJugador(player)
    if not territID or not batallas[territID] then
        outputChatBox("No hay batalla aqui", player, 255, 100, 100)
        return
    end
    
    local batalla = batallas[territID]
    local tiempo = (batalla.tiempoLimite - (getTickCount() - batalla.inicio)) / 60000
    
    outputChatBox("=== BATALLA: " .. territorio.nombre .. " ===", player, 255, 255, 0)
    outputChatBox("Tiempo: " .. math.ceil(tiempo) .. "m", player, 255, 255, 255)
    
    for faction, jugadores in pairs(batalla.facciones) do
        local vivos = contarVivosEnZona(faction, territID)
        local nombre = exports.factions:getFactionName(faction)
        outputChatBox("- " .. nombre .. ": " .. vivos .. " vivos", player, 255, 200, 100)
    end
end
addCommandHandler("batalla", comandoBatalla)

-- ==========================================
-- COMANDOS ADMIN
-- ==========================================

function comandoAdmin(player, cmd, accion, arg1)
    if not exports.players:isLoggedIn(player) then return end
    
    -- Verificar admin
    local characterID = exports.players:getCharacterID(player)
    local isAdmin = exports.sql:query_assoc_single("SELECT ug.groupID FROM wcf1_user_to_groups ug JOIN characters c ON c.userID = ug.userID WHERE c.characterID = %d AND ug.groupID IN (1, 2, 3)", characterID)
    
    if not isAdmin then
        outputChatBox("Sin permisos", player, 255, 100, 100)
        return
    end
    
    if accion == "reload" then
        for id, _ in pairs(batallas) do limpiarBatalla(id) end
        cargarTerritorios()
        outputChatBox("Sistema recargado", player, 100, 255, 100)
        
    elseif accion == "reset" and arg1 then
        local id = tonumber(arg1)
        if territorios[id] then
            limpiarBatalla(id)
            exports.sql:query_free("UPDATE territorios SET factionID = NULL, enAtaque = 0, factionAtacante = NULL WHERE territorioID = %d", id)
            territorios[id].factionID = nil
            territorios[id].factionName = nil
            territorios[id].enAtaque = false
            triggerClientEvent(getElementsByType("player"), "territorios:neutral", resourceRoot, id)
            outputChatBox("Territorio " .. id .. " liberado", player, 100, 255, 100)
        end
        
    else
        outputChatBox("Admin: /aterr [reload/reset <id>]", player, 255, 255, 255)
    end
end
addCommandHandler("aterr", comandoAdmin)

-- ==========================================
-- INICIALIZACIÓN
-- ==========================================

addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(function()
        cargarTerritorios()
        setTimer(generarGanancias, CONFIG.INTERVALO_GANANCIAS, 0)
        outputDebugString("[TERRITORIOS] Sistema iniciado")
    end, 2000, 1)
end)

addEventHandler("onPlayerLogin", root, function()
    setTimer(function(player)
        if isElement(player) then
            triggerClientEvent(player, "territorios:sync", resourceRoot, territorios)
        end
    end, 2000, 1, source)
end)

-- ==========================================
-- FUNCIONES EXPORTADAS
-- ==========================================

function estaJugadorEnTerritorio(player, territID)
    return jugadoresEnZona[territID] and jugadoresEnZona[territID][player] ~= nil
end
