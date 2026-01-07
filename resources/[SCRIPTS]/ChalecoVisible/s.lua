local armor = {}

addEvent("setArmorCustomAlpha", true)
addEventHandler("setArmorCustomAlpha", resourceRoot, function(alpha)
	if armor[client] then
		setElementAlpha(armor[client],alpha)
	end
end)

addEvent("createArmorCustom", true)
addEventHandler("createArmorCustom", resourceRoot, function(status)
	if status then
		local x, y, z = getElementPosition(client)
		armor[client] = createObject(1242, x, y, z)
        setElementCollisionsEnabled(armor[client], false)
		setObjectScale(armor[client], 1.0) -- Reducida de 1.05 a 1.0 para mejor alineación

        setElementData(client, "customArmor", armor[client])
		-- Parámetros ajustados: (objeto, jugador, hueso, x, y, z, rx, ry, rz)
		-- Hueso 2 = spine (columna), Y reducido para pegarlo más al cuerpo
		exports.pAttach:attach(armor[client], client, 2, 0, 0.03, 0, 0, 0, 0)
	else
        if armor[client] then
            removeElementData(client, "customArmor")
			if isElement(armor[client]) then 
				destroyElement(armor[client]) 
			end
            armor[client] = nil
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
    if not armor[source] then return end
    if isElement(armor[source]) then
        destroyElement(armor[source]) 
    end
    armor[source] = nil
end)

--[[addEventHandler("onPlayerWasted",getRootElement(),function(ammo, attacker, weapon, bodypart)
    if armor[source] then
        if isElement(armor[source]) then 
            destroyElement(armor[source]) 
        end
        armor[source] = nil
        local data = getElementData(source,"objetos:player")
        if data and data["armor"] then
            data["armor"] = nil
            setElementData(source,"objetos:player",data)
        end
    end
end)]]