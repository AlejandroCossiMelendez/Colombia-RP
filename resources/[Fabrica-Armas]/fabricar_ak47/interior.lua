----------------------------------------------------------------------------------------------------------------------------------------
--local enter = createMarker(2357.240234375, -646.9091796875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local exit = createMarker(2357.240234375, -646.9091796875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local obj = createObject(2533.502, -1666.769, 15.164, 0, 0, 270)
local marker = createMarker(1314.041015625, -750.6630859375, 79.335899353027 -1, "cylinder", 1.50, 30, 144, 255, 100)
local int = 0
local dim = 0
setElementInterior(marker, int)
setElementDimension(marker, dim)


function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
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
        exports.a_infobox:addBox(playerSource, "Para fabricar un arma debe haber al menos 1 policía en servicio", "error")
        return
    end

    exports.items:load(playerSource) -- Recarga segura del inventario

    local materiales = {
        {id = 38, nombre = "Culata de Ak-47"},
        {id = 39, nombre = "Cuerpo de Ak-47"},
        {id = 40, nombre = "Cargador de AK-47"},
        {id = 41, nombre = "Cañón de AK"}
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

    -- 🔹 SEGUNDA VERIFICACIÓN IMPORTANTE:
    -- Confirmar que todos los slots obtenidos siguen siendo válidos justo antes de eliminar
    exports.items:load(playerSource) -- Segunda recarga para máxima seguridad

    for _, slot in ipairs(slotsAEliminar) do
        if not exports.items:slotValido(playerSource, slot) then
            exports.a_infobox:addBox(playerSource, "Inventario modificado, fabricación cancelada.", "error")
            return
        end
    end

    -- 🔹 Ahora eliminar materiales empezando por slot más alto (evita errores por desplazamiento)
    table.sort(slotsAEliminar, function(a,b) return a > b end)

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
        exports.items:load(playerSource) -- Recargar inventario inmediatamente ante error
        return
    end

    -- 🔹 Fabricación segura:
    local tiempoFabricacion = 120000
    setElementFrozen(playerSource, true)
    toggleAllControls(playerSource, false, true, false)
    setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
    triggerClientEvent(playerSource, "progressBar", playerSource, tiempoFabricacion)
    exports.a_infobox:addBox(playerSource, "Fabricando AK-47, espera 2 minutos...", "info")

    setTimer(function()
        setElementFrozen(playerSource, false)
        toggleAllControls(playerSource, true)
        setPedAnimation(playerSource, nil)

        exports.items:load(playerSource) -- Recarga antes de dar el arma
        local armaDada = exports.items:give(playerSource, 29, "30", "Ak-47", 1)
        if armaDada then
            exports.a_infobox:addBox(playerSource, "Has fabricado una AK-47", "success")
            exports.chat:me(playerSource, "ha fabricado una AK-47.")
        else
            exports.a_infobox:addBox(playerSource, "Error al entregar AK-47, contacta admin.", "error")
        end

        for _, v in ipairs(getElementsByType("player")) do
            if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
                outputChatBox("(("..getPlayerName(playerSource)..")) Emergencia - Alarma Fabrica armas Las Venturas activada.", v, 130, 255, 130)
                triggerClientEvent(v, "gui:hint", v, "Policía: Emergencia", "Alarma Fabrica armas Las Venturas activada.")
            end
        end
        outputChatBox("Aviso enviado a la policía.", playerSource, 255, 0, 0)

    end, tiempoFabricacion, 1)
end






addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)

----------------------------------------------------------------------------------------------------------------------------------------


















