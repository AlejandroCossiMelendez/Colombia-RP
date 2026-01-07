local Request = {}
local Cooldown = {}
local function isOnCooldown(player, key, ms)
    local now = getTickCount()
    Cooldown[player] = Cooldown[player] or {}
    local t = Cooldown[player][key] or 0
    if now - t < ms then return true end
    Cooldown[player][key] = now
    return false
end

addEventHandler("onPlayerQuit", root, function()
    Request[source] = nil
    Cooldown[source] = nil
end)

addCommandHandler("cachear", function(player, _, target)
	if not exports["players"]:isLoggedIn(player) then
		return
	end
	if not target then
		exports["mrp_notify"]:AddNotify(player, "Cacheo", "Debes especificar un jugador.", "error")
		return
	end
	local other, name = exports["players"]:getFromName(player, target)
	if not isElement(other) then
		return
	end
	if player == other then
		exports["mrp_notify"]:AddNotify(player, "Cacheo", "No puedes cachearte a ti mismo.", "error")
		return
	end
	if Request[other] then
		exports["mrp_notify"]:AddNotify(
			player,
			"Cacheo",
			"El jugador ya tiene una solicitud de cacheo pendiente.",
			"error"
		)
		return
	end
	Request[other] = player
	exports["mrp_notify"]:AddNotify(player, "Cacheo", "Has enviado una solicitud de cacheo a " .. name .. ".", "info")
	exports["mrp_notify"]:AddNotify(
		other,
		"Cacheo",
		"Has recibido una solicitud de cacheo de " .. getPlayerName(player) .. ".",
		"info"
	)
	outputChatBox("Utiliza /aceptarcacheo o /rechazarcacheo para responder a la solicitud.", other, 255, 50, 50)
end)

addCommandHandler("aceptarcacheo", function(player)
	if not exports["players"]:isLoggedIn(player) then
		return
	end
	if not Request[player] then
		exports["mrp_notify"]:AddNotify(player, "Cacheo", "No tienes ninguna solicitud de cacheo pendiente.", "error")
		return
	end
	local other = Request[player]
	exports["mrp_notify"]:AddNotify(
		player,
		"Cacheo",
		"Has aceptado la solicitud de cacheo de " .. getPlayerName(other) .. ".",
		"info"
	)
	local items = exports["items"]:get(player)
	exports["mrp_notify"]:AddNotify(other, "Cacheo", "El jugador ha aceptado tu solicitud de cacheo.", "info")
	triggerClientEvent(other, "inventory->show_target_items", resourceRoot, player, items)
	Request[player] = nil
end)

addCommandHandler("rechazarcacheo", function(player)
	if not exports["players"]:isLoggedIn(player) then
		return
	end
	if not Request[player] then
		exports["mrp_notify"]:AddNotify(player, "Cacheo", "No tienes ninguna solicitud de cacheo pendiente.", "error")
		return
	end
	local other = Request[player]
	exports["mrp_notify"]:AddNotify(
		player,
		"Cacheo",
		"Has rechazado la solicitud de cacheo de " .. getPlayerName(other) .. ".",
		"info"
	)
	exports["mrp_notify"]:AddNotify(other, "Cacheo", "El jugador ha rechazado tu solicitud de cacheo.", "info")
	Request[player] = nil
end)

addEvent("inventory->send", true)
addEventHandler("inventory->send", resourceRoot, function(slot, target)
	if not isElement(client) or getElementType(client) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(client) then
		return
	end
    if isOnCooldown(client, "send", 600) then return end
	local item = exports["items"]:get(client)[slot]
	if not item then
		return
	end
	local other, name = exports["players"]:getFromName(client, target)
	if not isElement(other) then
		return
	end
	if client == other then
		exports["mrp_notify"]:AddNotify(client, "Inventario", "No puedes enviarte un objeto a ti mismo.", "error")
		return
	end
	local client_x, client_y, client_z = getElementPosition(client)
	local other_x, other_y, other_z = getElementPosition(other)
	local distance = getDistanceBetweenPoints3D(client_x, client_y, client_z, other_x, other_y, other_z)
	if distance > 2 then
		exports["mrp_notify"]:AddNotify(client, "Inventario", "Estás demasiado lejos del jugador.", "error")
		return
	end
	if not exports["items"]:give(other, item.item, item.value, item.name, item.value2) then
		exports["mrp_notify"]:AddNotify(client, "Inventario", "Ocurrió un error al enviar el objeto.", "error")
		return
	end
	exports["items"]:take(client, slot)
	exports["chat"]:me(client, "envía un objeto a " .. name .. ".")
	exports["chat"]:me(other, "recibe un objeto de " .. getPlayerName(client) .. ".")
	triggerClientEvent(client, "inventory->update_items", resourceRoot)
	triggerClientEvent(other, "inventory->update_items", resourceRoot)
end)

local ObjectsTimer = {}

addEvent("inventory->drop", true)
addEventHandler("inventory->drop", resourceRoot, function(slot)
	if not isElement(client) or getElementType(client) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(client) then
		return
	end
    if isOnCooldown(client, "drop", 700) then return end
	local item = exports["items"]:get(client)[slot]
	if not item then
		return
	end
	local x, y, z = getElementPosition(client)
	local object = createObject(1220, x + 0.5, y, z - 0.5)
	setElementFrozen(object, true)
	setElementDimension(object, getElementDimension(client))
	setElementInterior(object, getElementInterior(client))
	setElementData(object, "items", { item })
	exports["items"]:take(client, slot)
	exports["chat"]:me(client, "deja caer un objeto.")
	triggerClientEvent(client, "inventory->update_items", resourceRoot)
	ObjectsTimer[object] = setTimer(function()
		killTimer(ObjectsTimer[object])
		ObjectsTimer[object] = nil
		if isElement(object) then
			destroyElement(object)
		end
	end, 60000, 1)
end)

-- Soltar cantidad específica (para stacks)
addEvent("inventory->drop_quantity", true)
addEventHandler("inventory->drop_quantity", resourceRoot, function(slot, amount)
    if not isElement(client) or getElementType(client) ~= "player" then return end
    if not exports["players"]:isLoggedIn(client) then return end
    amount = tonumber(amount) or 1
    if amount < 1 then return end
    if isOnCooldown(client, "drop", 700) then return end
    local items = exports["items"]:get(client)
    local item = items[slot]
    if not item then return end

    local function normalizeValue(it)
        if it.item == 29 or it.item == 43 then return tonumber(it.value) end
        return it.value
    end

    local function matchesSignature(a, b)
        if not a or not b then return false end
        if a.item ~= b.item then return false end
        if normalizeValue(a) ~= normalizeValue(b) then return false end
        if (a.name or "") ~= (b.name or "") then return false end
        if (a.value2 or "") ~= (b.value2 or "") then return false end
        return true
    end
    local x, y, z = getElementPosition(client)
    local object = createObject(1220, x + 0.5, y, z - 0.5)
    setElementFrozen(object, true)
    setElementDimension(object, getElementDimension(client))
    setElementInterior(object, getElementInterior(client))
    local list = {}
    for i = 1, amount do
        local inv = exports["items"]:get(client) or {}
        local foundSlot, foundItem
        for s = #inv, 1, -1 do
            if matchesSignature(inv[s], item) then foundSlot = s; foundItem = inv[s]; break end
        end
        if not foundSlot then break end
        table.insert(list, foundItem)
        exports["items"]:take(client, foundSlot)
    end
    if #list == 0 then
        if isElement(object) then destroyElement(object) end
        return
    end
    setElementData(object, "items", list)
    exports["chat"]:me(client, "deja caer un objeto.")
    triggerClientEvent(client, "inventory->update_items", resourceRoot)
    ObjectsTimer[object] = setTimer(function()
        killTimer(ObjectsTimer[object])
        ObjectsTimer[object] = nil
        if isElement(object) then
            destroyElement(object)
        end
    end, 60000, 1)
end)

addEventHandler("onPlayerClick", root, function(button, state, element)
	if button ~= "left" then
		return
	end
	if not isElement(element) then
		return
	end
	if getElementModel(element) ~= 1220 then
		return
	end
	local x, y, z = getElementPosition(source)
	local object_x, object_y, object_z = getElementPosition(element)
	local distance = getDistanceBetweenPoints3D(x, y, z, object_x, object_y, object_z)
	if distance > 2 then
		exports["mrp_notify"]:AddNotify(source, "Inventario", "Estás demasiado lejos para recoger el objeto.", "error")
		return
	end
	local object_items = getElementData(element, "items")
	if not object_items or #object_items == 0 then
		exports["mrp_notify"]:AddNotify(source, "Inventario", "Esta caja no contiene ningún objeto.", "error")
		return
	end
	local player_items = exports["items"]:get(source)
	if #player_items >= 100 then
		exports["mrp_notify"]:AddNotify(source, "Inventario", "No puedes llevar más objetos.", "error")
		return
	end
	local item = object_items[1]
	if not exports["items"]:give(source, item.item, item.value, item.name, item.value2) then
		exports["mrp_notify"]:AddNotify(source, "Inventario", "Ocurrió un error al recoger el objeto.", "error")
		return
	end
	exports["chat"]:me(source, "recoge un objeto del suelo.")
	triggerClientEvent(source, "inventory->update_items", resourceRoot)
	table.remove(object_items, 1)
	setElementData(element, "items", object_items)
	if #object_items == 0 then
		if isTimer(ObjectsTimer[element]) then
			killTimer(ObjectsTimer[element])
			ObjectsTimer[element] = nil
		end
		destroyElement(element)
	end
end)

addEvent("inventory->exchange_from_player", true)
addEventHandler("inventory->exchange_from_player", resourceRoot, function(slot, target)
	if not isElement(client) or getElementType(client) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(client) then
		return
	end
	if not isElement(target) or getElementType(target) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(target) then
		return
	end
    if isOnCooldown(client, "give", 600) then return end
    local item = exports["items"]:get(client)[slot]
	if not item then
		return
	end
	if not exports["items"]:give(target, item.item, item.value, item.name, item.value2) then
		exports["mrp_notify"]:AddNotify(client, "Inventario", "Ocurrió un error al enviar el objeto.", "error")
		return
	end
	local items = exports["items"]:get(target)
	exports["items"]:take(client, slot)
	exports["chat"]:me(client, "le da un objeto a " .. getPlayerName(target) .. ".")
	exports["chat"]:me(target, "recibe un objeto de " .. getPlayerName(client) .. ".")
	triggerClientEvent(client, "inventory->update_items", resourceRoot)
	triggerClientEvent(client, "inventory->update_target_items", resourceRoot, items)
end)

addEvent("inventory->exchange_from_target", true)
addEventHandler("inventory->exchange_from_target", resourceRoot, function(slot, target)
	if not isElement(client) or getElementType(client) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(client) then
		return
	end
	if not isElement(target) or getElementType(target) ~= "player" then
		return
	end
	if not exports["players"]:isLoggedIn(target) then
		return
	end
    if isOnCooldown(client, "take", 600) then return end
    local item = exports["items"]:get(target)[slot]
	if not item then
		return
	end
	if not exports["items"]:give(client, item.item, item.value, item.name, item.value2) then
		exports["mrp_notify"]:AddNotify(client, "Inventario", "Ocurrió un error al enviar el objeto.", "error")
		return
	end
	local items = exports["items"]:get(target)
	exports["items"]:take(target, slot)
	exports["chat"]:me(client, "recibe un objeto de " .. getPlayerName(target) .. ".")
	exports["chat"]:me(target, "le da un objeto a " .. getPlayerName(client) .. ".")
	triggerClientEvent(client, "inventory->update_items", resourceRoot)
	triggerClientEvent(client, "inventory->update_target_items", resourceRoot, items)
end)