----------------------------------------------------------------------------------------------------------------------------------------
local marker = createMarker(1319.8271484375, -750.5546875, 79.335899353027 -1, "cylinder", 1.50, 0, 255, 0, 100)
local int = 0
local dim = 0
setElementInterior(marker, int)
setElementDimension(marker, dim)

function getPolicias()
	local n = 0
	for _, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
			n = n + 1
		end
	end
	return n
end

----------------------------------------------------------------------------------------------------------------------------------------
function showPanel(playerSource)
	if getElementType(playerSource) == "player" then
		triggerClientEvent(playerSource, "Toggle", resourceRoot)
	end
end
addEventHandler("onMarkerHit", marker, showPanel)
----------------------------------------------------------------------------------------------------------------------------------------

function start(playerSource, qntd)
	if getElementType(playerSource) ~= "player" then return end

	if getPolicias() < 0 then
		exports.a_infobox:addBox(playerSource, "Para fabricar una Tec-9 deben haber al menos 2 policías en servicio", "error")
		return
	end

	exports.items:load(playerSource) -- Recarga segura del inventario

	local materiales = {
		{id = 61, nombre = "Cañon de Tec-9"},
		{id = 62, nombre = "Cargador de Tec-9"},
		{id = 63, nombre = "Cuerpo de Tec-9"}
	}

	local slotsAEliminar = {}

	-- 🔹 Verificación segura ANTES de eliminar algo:
	for _, material in ipairs(materiales) do
		local cantidad, slots = exports.items:contarItemsExactos(playerSource, material.id, 1)
		if cantidad < 1 or #slots < 1 then
			exports.a_infobox:addBox(playerSource, "Falta el material: "..material.nombre, "error")
			return
		end
		table.insert(slotsAEliminar, slots[1])
	end

	-- 🔹 Segunda recarga para máxima seguridad
	exports.items:load(playerSource)

	-- 🔹 Validar slots justo antes de eliminar
	for _, slot in ipairs(slotsAEliminar) do
		if not exports.items:slotValido(playerSource, slot) then
			exports.a_infobox:addBox(playerSource, "Inventario modificado, fabricación cancelada.", "error")
			return
		end
	end

	-- 🔹 Ahora eliminar materiales desde el slot más alto hacia abajo
	table.sort(slotsAEliminar, function(a, b) return a > b end)

	local eliminacionCorrecta = true
	for _, slot in ipairs(slotsAEliminar) do
		if not exports.items:take(playerSource, slot) then
			eliminacionCorrecta = false
			break
		end
	end

	if not eliminacionCorrecta then
		exports.a_infobox:addBox(playerSource, "Error crítico al eliminar materiales. Fabricación cancelada.", "error")
		outputDebugString("❌ Error al eliminar slots, fabricación cancelada para "..getPlayerName(playerSource))
		exports.items:load(playerSource)
		return
	end

	-- 🔹 Fabricación segura
	local tiempoFabricacion = 60000 -- 2 minutos
	setElementFrozen(playerSource, true)
	toggleAllControls(playerSource, false, true, false)
	setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
	triggerClientEvent(playerSource, "progressBar", playerSource, tiempoFabricacion)
	exports.a_infobox:addBox(playerSource, "Fabricando Tec-9, espera 1 minuto...", "info")

	setTimer(function()
		setElementFrozen(playerSource, false)
		toggleAllControls(playerSource, true)
		setPedAnimation(playerSource, nil)

		exports.items:load(playerSource) -- Recarga antes de dar el arma
		local armaDada = exports.items:give(playerSource, 29, "32", "Tec-9", 1)
		if armaDada then
			exports.a_infobox:addBox(playerSource, "Has fabricado una Tec-9", "success")
			exports.chat:me(playerSource, "ha fabricado una Tec-9.")
		else
			exports.a_infobox:addBox(playerSource, "Error al entregar Tec-9, contacta admin.", "error")
		end

		-- Avisar a policías
		local name = getPlayerName(playerSource)
		for _, v in ipairs(getElementsByType("player")) do
			if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
				outputChatBox("#FFFFFF[#42B007Entorno#FFFFFF] (#42B007"..name.."#FFFFFF): Se escucharía sonar la alarma de la Fabrica de Armas en Las Venturas", v, 255, 255, 255, true)
				outputChatBox("(("..name..")) Emergencia - Alarma Fabrica de Armas Mansion Madd Dog activada.", v, 130, 255, 130)
				triggerClientEvent(v, "gui:hint", v, "Policía: Emergencia", "Alarma Fabrica de Armas Mansion Madd Dog activada.")
			end
		end
		outputChatBox("Aviso enviado a la policía.", playerSource, 255, 0, 0)

	end, tiempoFabricacion, 1)
end

addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)

----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------


















