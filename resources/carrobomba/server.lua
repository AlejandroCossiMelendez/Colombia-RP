local IED_ITEM_ID = 113
local WEBHOOK_URL = "https://discord.com/api/webhooks/1418986619922288850/AJG9JJ_wTwg2sUSET_4fLXFS1G8Y45UY9VZQIivgV3YsEA0HRY023f-8TAL5Cdmo8jJ_"

local activeBombs = {}
local playerCooldowns = {}
local pendingGround = {}

local function getVehicleId(vehicle)
	return getElementData(vehicle, "idveh") or 0
end

local function getCharacterID(player)
	if exports.players and exports.players.getCharacterID then
		return exports.players:getCharacterID(player)
	end
	return getElementData(player, "characterID")
end

local function isPolice(player)
	return (exports.factions and (exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 4))) == true
end

local function isCriminal(player)
	-- 3: crimen organizado, 5: mafias (ajustable a tu esquema)
	return (exports.factions and (exports.factions:isPlayerInFactionType(player, 3) or exports.factions:isPlayerInFactionType(player, 5))) == true
end

local function sendDiscordLog(title, description, color)
	local msg = {
		title = title,
		description = description,
		color = color or 15158332,
		footer = { text = "LOGS-CARROBOMBA" },
		timestamp = "now"
	}
	if exports.discord_webhooks then
		exports.discord_webhooks:sendToURL(WEBHOOK_URL, msg)
	end
end

local function sql(fmt)
	if not exports.sql then return end
	exports.sql:query_free(fmt)
end

local function sqlf(fmt, ...)
	if not exports.sql then return end
	exports.sql:query_free(string.format(fmt, ...))
end

local function sqlInsert(fmt, ...)
	if not exports.sql then return nil end
	return exports.sql:query_insertid(string.format(fmt, ...))
end

local function ensureTables()
	if not exports.sql then return end
	sql([[CREATE TABLE IF NOT EXISTS vehicle_bombs (
		bombID INT AUTO_INCREMENT PRIMARY KEY,
		vehicleID INT NOT NULL,
		placerCID INT NOT NULL,
		seconds INT NOT NULL,
		status ENUM('armed','countdown','defused','exploded','cancelled') NOT NULL DEFAULT 'armed',
		correctWire VARCHAR(16) DEFAULT NULL,
		createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]])
	sql([[CREATE TABLE IF NOT EXISTS vehicle_bombs_log (
		logID INT AUTO_INCREMENT PRIMARY KEY,
		bombID INT NOT NULL,
		event VARCHAR(64) NOT NULL,
		detail TEXT,
		createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]])
end
-- Utilidad: buscar vehículo propio cerca o ocupado
local function getOwnedVehicleNearOrCurrent(player, maxDist)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle and getElementData(vehicle, "idowner") == exports.players:getCharacterID(player) then
        return vehicle
    end
    local px, py, pz = getElementPosition(player)
    local nearest, dmin = nil, maxDist or 3.0
    for _, v in ipairs(getElementsByType("vehicle")) do
        local x, y, z = getElementPosition(v)
        local d = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
        if d < dmin and getElementData(v, "idowner") == exports.players:getCharacterID(player) then
            nearest = v
            dmin = d
        end
    end
    return nearest
end


addEventHandler("onResourceStart", resourceRoot, function()
	ensureTables()
end)

local function logEvent(bombId, event, detail)
	if not exports.sql then return end
	exports.sql:query_free(string.format(
		"INSERT INTO vehicle_bombs_log (bombID, event, detail) VALUES (%d, '%s', '%s')",
		tostring(bombId or 0), exports.sql:escape_string(event or ""), exports.sql:escape_string(detail or "")
	))
end

local function broadcastPolice(vehicle, seconds)
	local x, y, z = getElementPosition(vehicle)
	if exports.factions and exports.factions.createFactionBlip2 then
		exports.factions:createFactionBlip2(x, y, z, 1)
	end
	local vehId = getVehicleId(vehicle)
	local msg = string.format("\239\184\157\239\184\157 Se ha detectado un posible carro bomba | Veh ID %s | Pos: %.2f, %.2f, %.2f | Tiempo: %ss", tostring(vehId), x, y, z, tostring(seconds or "?"))
	if exports.factions and exports.factions.sendMessageToFaction then
		exports.factions:sendMessageToFaction(1, msg, 255, 0, 0, true)
		exports.factions:sendMessageToFaction(4, msg, 255, 0, 0, true)
	end
	sendDiscordLog("Alerta Carro Bomba", string.format(
		"> Vehículo ID: **%s**\n> Ubicación: **%.2f, %.2f, %.2f**\n> Tiempo: **%s s**",
		tostring(vehId), x, y, z, tostring(seconds or "?")), 16711680)
end

local function stopCountdown(vehicle)
	local bomb = activeBombs[vehicle]
	if not bomb then return end
	if isTimer(bomb.explosionTimer) then killTimer(bomb.explosionTimer) end
	bomb.countdownActive = false
	setElementData(vehicle, "carbomb:countdown", false)
	for i=0, getVehicleMaxPassengers(vehicle) do
		local p = getVehicleOccupant(vehicle, i)
		if p then
			triggerClientEvent(p, "carbomb:stopCountdown", p)
			toggleControl(p, "enter_exit", true)
		end
	end
	return bomb
end

local function injurePlayerAsDeadRole(player)
    if not isElement(player) or getElementType(player) ~= "player" then return end
    if getElementData(player, "carbomb:injured") then return end
    setElementData(player, "carbomb:injured", true)
    setTimer(function(p)
        if isElement(p) then setElementData(p, "carbomb:injured", false) end
    end, 3000, 1, player)

    if isPedInVehicle(player) then
        removePedFromVehicle(player)
    end
    if isPedDead(player) then
        local x, y, z = getElementPosition(player)
        spawnPlayer(player, x, y, z, 0, getElementModel(player), 0, 0)
        fadeCamera(player, true)
        setCameraTarget(player, player)
    end

    -- Marcar estado de muerte (sin spam si ya estaba)
    if not getElementData(player, "muerto") then
        outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", player, 255, 0, 0)
        outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", player, 255, 0, 0)
    end
    setElementHealth(player, 1)
    setElementData(player, "muerto", true)
    setElementData(player, "accidente", true)

    -- Secuencia de caída y posición final tumbado
    setPedAnimation(player, "CRACK", "crckdeth2", 1000, false, false, false)
    setTimer(function(p)
        if isElement(p) then
            setPedAnimation(p, "wuzi", "cs_dead_guy", -1, true, false, false)
        end
    end, 800, 1, player)

    -- Los controles y HUD de muerte son manejados por players/players_auxiliar/medico

    -- Notificar a otros sistemas
    triggerEvent("onSufrirDamageCapitalRP", player, nil, nil, 3, true)
end

local LATERAL_DIST = 3.0 -- distancia segura al costado/atrás del vehículo

local function explodeVehicle(vehicle, bomb, cause)
    if not isElement(vehicle) then return end
    local x, y, z = getElementPosition(vehicle)
    if bomb and bomb.bombID then
        if bomb.exploded then return end
        bomb.exploded = true
        sqlf("UPDATE vehicle_bombs SET status='exploded' WHERE bombID=%d", bomb.bombID)
        logEvent(bomb.bombID, "exploded", cause or "")
    end
    if bomb and bomb.explosionTimer and isTimer(bomb.explosionTimer) then
        killTimer(bomb.explosionTimer)
        bomb.explosionTimer = nil
    end

    -- Proteger vehículos cercanos para que queden solo averiados (no explotados)
    local protected = {}
    local R = 20
    for _, v in ipairs(getElementsByType("vehicle")) do
        if v ~= vehicle then
            local vx, vy, vz = getElementPosition(v)
            if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= R then
                protected[#protected+1] = v
                setVehicleDamageProof(v, true)
                if setVehicleOnFire then setVehicleOnFire(v, false) end
            end
        end
    end

    -- Simular explosión notoria sin destruir por completo el vehículo
    setVehicleDamageProof(vehicle, true)
    -- Explosión principal y secundarias para mayor efecto visual/sonoro
    createExplosion(x, y, z, 7)
    createExplosion(x + 1.5, y, z, 2)
    createExplosion(x - 1.0, y + 1.0, z, 10)
    createExplosion(x, y - 1.2, z, 7)
    -- Marcar a jugadores para que 'explosiones' no cancele la explosión visual localmente
    for _, p in ipairs(getElementsByType("player")) do
        local px, py, pz = getElementPosition(p)
        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 50 then
            setElementData(p, "_carbomb:lastExplodeTick", getTickCount())
        end
    end

    setTimer(function(v, list)
        if isElement(v) then
            setVehicleDamageProof(v, false)
        end
        for _, pv in ipairs(list or {}) do
            if isElement(pv) then
                -- dejar averiado pero no destruido
                setVehicleEngineState(pv, false)
                if isVehicleBlown and isVehicleBlown(pv) then
                    fixVehicle(pv)
                end
                local hp = getElementHealth(pv) or 1000
                local newHp = math.max(305, math.min(hp, 320))
                setElementHealth(pv, newHp)
                if setVehicleOnFire then setVehicleOnFire(pv, false) end
                setVehicleDamageProof(pv, false)
            end
        end
    end, 1200, 1, vehicle, protected)

    -- Romper motor y dejar el vehículo dañado pero reparable por mecánicos
    setVehicleEngineState(vehicle, false)
    -- No marcamos "averiado" para no bloquear los flujos de reparación estándar
    if getElementHealth(vehicle) > 305 then
        setElementHealth(vehicle, 305)
    end

    -- Herir a ocupantes con el sistema de muerte del servidor y cerrar HUDs (posicionar fuera del vehículo)
    for seat = 0, getVehicleMaxPassengers(vehicle) do
        local occ = getVehicleOccupant(vehicle, seat)
        if occ then
            triggerClientEvent(occ, "carbomb:stopCountdown", occ)
            triggerClientEvent(occ, "carbomb:closeDefuseUI", occ)
            -- Empujar al lado del vehículo evitando superponer
            local vx, vy, vz = getElementPosition(vehicle)
            local _, _, rotZ = getElementRotation(vehicle)
            local sideX = vx + math.cos(math.rad(rotZ + 90)) * LATERAL_DIST
            local sideY = vy + math.sin(math.rad(rotZ + 90)) * LATERAL_DIST
            local sideZ = vz + 0.2
            if isPedInVehicle(occ) then removePedFromVehicle(occ) end
            setElementInterior(occ, getElementInterior(vehicle))
            setElementDimension(occ, getElementDimension(vehicle))
            setElementFrozen(occ, true)
            setElementPosition(occ, sideX, sideY, sideZ)
            pendingGround[occ] = true
            triggerClientEvent(occ, "carbomb:queryGround", occ, sideX, sideY, sideZ)
            injurePlayerAsDeadRole(occ)
            setTimer(function(p)
                if isElement(p) then setElementFrozen(p, false) end
            end, 800, 1, occ)
        end
    end

    -- Herir a jugadores cercanos (radio 6m) y cerrar HUDs
    for _, pl in ipairs(getElementsByType("player")) do
        local px, py, pz = getElementPosition(pl)
        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 6 then
            triggerClientEvent(pl, "carbomb:stopCountdown", pl)
            triggerClientEvent(pl, "carbomb:closeDefuseUI", pl)
            -- Colocar a un lado del vehículo si estaba dentro
            if isPedInVehicle(pl) then
                local vx, vy, vz = getElementPosition(vehicle)
                local _, _, rotZ = getElementRotation(vehicle)
                local sideX = vx + math.cos(math.rad(rotZ - 90)) * LATERAL_DIST
                local sideY = vy + math.sin(math.rad(rotZ - 90)) * LATERAL_DIST
                local sideZ = vz + 0.2
                removePedFromVehicle(pl)
                setElementInterior(pl, getElementInterior(vehicle))
                setElementDimension(pl, getElementDimension(vehicle))
                setElementFrozen(pl, true)
                setElementPosition(pl, sideX, sideY, sideZ)
                pendingGround[pl] = true
                triggerClientEvent(pl, "carbomb:queryGround", pl, sideX, sideY, sideZ)
                setTimer(function(p)
                    if isElement(p) then setElementFrozen(p, false) end
                end, 800, 1, pl)
            end
            injurePlayerAsDeadRole(pl)
        end
    end

    setElementData(vehicle, "carbomb:armed", false)
    setElementData(vehicle, "carbomb:countdown", false)
    activeBombs[vehicle] = nil
    broadcastPolice(vehicle, 0)
end

-- Recibir Z de suelo desde el cliente y ajustar posición final
addEvent("carbomb:setGroundZ", true)
addEventHandler("carbomb:setGroundZ", root, function(x, y, gz)
    local p = source
    if not isElement(p) or getElementType(p) ~= "player" then return end
    if not pendingGround[p] then return end
    pendingGround[p] = nil
    local int = getElementInterior(p)
    local dim = getElementDimension(p)
    setElementInterior(p, int)
    setElementDimension(p, dim)
    setElementPosition(p, x, y, (tonumber(gz) or select(3, getElementPosition(p))) + 0.05)
    -- Reforzar animación tumbado tras ajuste fino
    setPedAnimation(p, "wuzi", "cs_dead_guy", -1, true, false, false)
end)

local WIRES = { "rojo", "azul", "verde", "amarillo" }
local function pickWire()
	return WIRES[math.random(1, #WIRES)]
end

local function startCountdown(vehicle)
	local bomb = activeBombs[vehicle]
	if not bomb or bomb.countdownActive then return end
	bomb.countdownActive = true
	bomb.status = "countdown"
	sqlf("UPDATE vehicle_bombs SET status='countdown' WHERE bombID=%d", bomb.bombID)
	local seconds = bomb.seconds
	local endTick = getTickCount() + seconds*1000
	setElementData(vehicle, "carbomb:countdown", { endTick = endTick, seconds = seconds })
	for i=0, getVehicleMaxPassengers(vehicle) do
		local p = getVehicleOccupant(vehicle, i)
		if p then
			triggerClientEvent(p, "carbomb:startCountdown", p, seconds, endTick)
			toggleControl(p, "enter_exit", false)
		end
	end
	bomb.explosionTimer = setTimer(function()
		explodeVehicle(vehicle, bomb, "timeout")
	end, seconds*1000, 1)
	broadcastPolice(vehicle, seconds)
end

addEventHandler("onVehicleEnter", root, function(player, seat)
	if seat ~= 0 then return end
	local vehicle = source
	local bomb = activeBombs[vehicle]
	if not bomb then return end
    if bomb.status == "armed" and bomb.manualOnly ~= true then
		startCountdown(vehicle)
	end
end)

addEventHandler("onVehicleStartExit", root, function(player, seat)
	local vehicle = source
	local bomb = activeBombs[vehicle]
	if bomb and bomb.countdownActive and seat == 0 and player == getVehicleOccupant(vehicle, 0) then
		cancelEvent()
		outputChatBox("No puedes salir del vehículo.", player, 255, 0, 0)
	end
end)

function useIED(player, seconds)
	if not isElement(player) or getElementType(player) ~= "player" then return false end
	if not exports.players or not exports.players:isLoggedIn(player) then return false end
	if not isCriminal(player) then
		outputChatBox("No tienes conocimientos para armar esta bomba.", player, 255, 0, 0)
		return false
	end
	local now = getTickCount()
	local cd = playerCooldowns[player] or 0
	if now < cd then
		outputChatBox("Espera antes de volver a colocar una bomba.", player, 255, 0, 0)
		return false
	end
	playerCooldowns[player] = now + 15000
	local px, py, pz = getElementPosition(player)
	local nearest, nd = nil, 4.5
	for _, v in ipairs(getElementsByType("vehicle")) do
		if getElementDimension(v) == getElementDimension(player) and getElementInterior(v) == getElementInterior(player) then
			local x, y, z = getElementPosition(v)
			local d = getDistanceBetweenPoints3D(px,py,pz,x,y,z)
			if d < nd then
				nearest = v
				nd = d
			end
		end
	end
	if not nearest then
		outputChatBox("No hay un vehículo lo suficientemente cerca.", player, 255, 0, 0)
		return false
	end
	local vehId = getVehicleId(nearest)
	if not vehId or vehId <= 0 then
		outputChatBox("Este vehículo no tiene un ID válido.", player, 255, 0, 0)
		return false
	end
	if activeBombs[nearest] then
		outputChatBox("Este vehículo ya tiene una bomba.", player, 255, 0, 0)
		return false
	end
    seconds = tonumber(seconds) or 240
    seconds = math.max(240, math.min(600, seconds))
	local cid = getCharacterID(player)
	local correct = pickWire()
	local bombId = sqlInsert("INSERT INTO vehicle_bombs (vehicleID, placerCID, seconds, status, correctWire) VALUES (%d, %d, %d, 'armed', '%s')",
		vehId, cid or 0, seconds, exports.sql and exports.sql:escape_string(correct) or correct)
    activeBombs[nearest] = {
		bombID = bombId,
		vehicleID = vehId,
		placerCID = cid,
		seconds = seconds,
		status = "armed",
		correctWire = correct,
        countdownActive = false,
        manualOnly = false
	}
	setElementData(nearest, "carbomb:armed", true)
	exports.chat:me(player, "coloca discretamente un artefacto bajo el chasis.")
    outputChatBox("IED armada: modo AUTO (al subir). Usa /detonador para cambiar a remoto o /detonar [seg] para activar por entorno.", player, 255, 255, 0)
	sendDiscordLog("Bomba colocada",
		string.format("> Colocada por CID **%s** en veh **%s** | Temporizador **%ds** | Cable correcto **%s**", tostring(cid or "?"), tostring(vehId), seconds, correct), 15105570)
	logEvent(bombId, "armed", string.format("placerCID=%s vehicleID=%s seconds=%d", tostring(cid or "?"), tostring(vehId), seconds))
	return true
end
addEvent("carbomb:useIED", true)
addEventHandler("carbomb:useIED", root, function(seconds)
	if client then
		useIED(client, seconds)
	end
end)

function isVehicleBombArmed(vehicle)
	return isElement(vehicle) and activeBombs[vehicle] ~= nil
end

function attemptEngineStart(player, vehicle)
	if not isElement(vehicle) then return true end
	local bomb = activeBombs[vehicle]
	if not bomb then return true end
	if bomb.countdownActive then
        stopCountdown(vehicle)
        explodeVehicle(vehicle, bomb, "engine_start")
		return false
	end
	return true
end

addCommandHandler("desarmarbomba", function(player)
	if not isPolice(player) then
		outputChatBox("Solo policía puede intentar desarmar.", player, 255, 0, 0)
		return
	end
	local px, py, pz = getElementPosition(player)
	local nearest, nd = nil, 4.5
	for _, v in ipairs(getElementsByType("vehicle")) do
		local x, y, z = getElementPosition(v)
		local d = getDistanceBetweenPoints3D(px,py,pz,x,y,z)
		if d < nd and activeBombs[v] then
			nearest = v
			nd = d
		end
	end
	if not nearest then
		outputChatBox("No hay ningún vehículo con bomba cerca.", player, 255, 0, 0)
		return
	end
	local bomb = activeBombs[nearest]
	local left = bomb.countdownActive and math.max(0, math.floor(((getElementData(nearest, "carbomb:countdown") or {}).endTick or getTickCount()) - getTickCount())/1000) or bomb.seconds
	triggerClientEvent(player, "carbomb:openDefuseUI", player, { options = WIRES, timeLeft = left })
	setElementData(player, "carbomb:defusing", nearest)
end)

-- Activación remota por entorno (para atentado planificado)
-- /activarcarrobomba [segundos]
local function remoteActivate(player, cmd, segundos)
    if not exports.players or not exports.players:isLoggedIn(player) then return end
    local vehicle = getOwnedVehicleNearOrCurrent(player, 3.0)
    if not vehicle then outputChatBox("Acércate a tu vehículo (≤3m).", player, 255, 0, 0) return end
    -- Validar propietario
    local owner = getElementData(vehicle, "idowner")
    if owner and owner ~= exports.players:getCharacterID(player) then
        outputChatBox("Este no es tu vehículo.", player, 255, 0, 0)
        return
    end
    local bomb = activeBombs[vehicle]
    if not bomb then
        outputChatBox("Este vehículo no tiene una bomba activa.", player, 255, 0, 0)
        return
    end
    local secs = tonumber(segundos)
    if bomb.countdownActive then
        if secs and secs > 0 then
            -- Reiniciar countdown con nuevo tiempo
            stopCountdown(vehicle)
            bomb.seconds = math.max(10, math.min(600, secs))
            bomb.manualOnly = true
            startCountdown(vehicle)
            outputChatBox("Cuenta regresiva reiniciada: "..tostring(bomb.seconds).."s", player, 0, 255, 153)
        else
            outputChatBox("La bomba ya está en cuenta regresiva.", player, 255, 255, 0)
        end
        return
    end
    bomb.seconds = math.max(10, math.min(600, secs or bomb.seconds or 240))
    bomb.manualOnly = true
    startCountdown(vehicle)
    exports.chat:me(player, "envía un entorno y activa remotamente el detonador de su vehículo.")
    outputChatBox("Cuenta regresiva iniciada: "..tostring(bomb.seconds).."s", player, 0, 255, 153)
end

addCommandHandler("activarcarrobomba", remoteActivate)
addCommandHandler("detonar", remoteActivate)

-- Cambiar modo de activación: auto (al entrar) o entorno (manual)
-- /carrobomba_modo auto|entorno (requiere ser dueño y estar en/near el vehículo con bomba)
addCommandHandler("detonador", function(player, cmd, modo)
    if not exports.players or not exports.players:isLoggedIn(player) then return end
    modo = tostring(modo or ""):lower()
    if modo ~= "auto" and modo ~= "entorno" then
        outputChatBox("Uso: /detonador auto|entorno", player, 255, 255, 0)
        return
    end
    local vehicle = getOwnedVehicleNearOrCurrent(player, 3.0)
    if not vehicle then outputChatBox("Acércate a tu vehículo (≤3m).", player, 255, 0, 0) return end
    if getElementData(vehicle, "idowner") ~= exports.players:getCharacterID(player) then
        outputChatBox("Este no es tu vehículo.", player, 255, 0, 0)
        return
    end
    local bomb = activeBombs[vehicle]
    if not bomb or bomb.status ~= "armed" then
        outputChatBox("No hay una bomba armada o ya está en cuenta regresiva.", player, 255, 0, 0)
        return
    end
    local toEntorno = (modo == "entorno")
    if toEntorno and bomb.countdownActive then
        stopCountdown(vehicle)
    end
    bomb.manualOnly = toEntorno
    outputChatBox("Detonador: " .. (bomb.manualOnly and "ENTORNO (manual)" or "AUTO (al subir)"), player, 0, 255, 153)
end)

addEvent("carbomb:defuseChoice", true)
addEventHandler("carbomb:defuseChoice", root, function(choice)
	local player = client
	if not isElement(player) then return end
	if not isPolice(player) then return end
	local vehicle = getElementData(player, "carbomb:defusing")
	if not isElement(vehicle) then return end
	local bomb = activeBombs[vehicle]
	if not bomb then return end
	removeElementData(player, "carbomb:defusing")
	if choice == bomb.correctWire then
		stopCountdown(vehicle)
		sqlf("UPDATE vehicle_bombs SET status='defused' WHERE bombID=%d", bomb.bombID)
		logEvent(bomb.bombID, "defused", string.format("by=%s", tostring(getCharacterID(player) or "?")))
		activeBombs[vehicle] = nil
		setElementData(vehicle, "carbomb:armed", false)
		-- Asegurar que el vehículo pueda arrancar tras desactivar la bomba
		setElementData(vehicle, "averiado", false)
		if getElementHealth(vehicle) < 450 then
			setElementHealth(vehicle, 450)
		end
		for i=0, getVehicleMaxPassengers(vehicle) do
			local p = getVehicleOccupant(vehicle, i)
			if p then
				outputChatBox("La bomba ha sido desactivada.", p, 0, 255, 0)
			end
		end
		outputChatBox("Has desactivado la bomba correctamente.", player, 0, 255, 0)
		sendDiscordLog("Bomba desactivada", string.format("> Vehículo **%s** desactivada por **%s**", tostring(getVehicleId(vehicle)), getPlayerName(player):gsub("_"," ")), 3066993)
	else
		explodeVehicle(vehicle, bomb, "wrong_wire:" .. tostring(choice))
		-- Aplicar la misma lógica de muerte roleada al policía que falló
		if isElement(player) then
			local vx, vy, vz = getElementPosition(vehicle)
			local _, _, rotZ = getElementRotation(vehicle)
			local px = vx + math.cos(math.rad(rotZ + 180)) * 2.5
			local py = vy + math.sin(math.rad(rotZ + 180)) * 2.5
			local pz = vz + 0.2
			if isPedInVehicle(player) then removePedFromVehicle(player) end
			setElementInterior(player, getElementInterior(vehicle))
			setElementDimension(player, getElementDimension(vehicle))
			setElementFrozen(player, true)
			setElementPosition(player, px, py, pz)
			pendingGround[player] = true
			triggerClientEvent(player, "carbomb:queryGround", player, px, py, pz)
			injurePlayerAsDeadRole(player)
			setTimer(function(p)
				if isElement(p) then setElementFrozen(p, false) end
			end, 800, 1, player)
		end
		sendDiscordLog("Desarme fallido", string.format("> Vehículo **%s** | Cable escogido **%s** (correcto **%s**)", tostring(getVehicleId(vehicle)), tostring(choice), tostring(bomb.correctWire)), 15158332)
	end
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, p in ipairs(getElementsByType("player")) do
		toggleControl(p, "enter_exit", true)
	end
end)

