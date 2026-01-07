-- Crear un nuevo marcador para fabricar cargadores de Colt-45
local marcadorCargador = createMarker(2476.6875, -830.7041015625, 80.4609375-1, "cylinder", 1.5, 0, 144, 255, 100) -- Ajusta las coordenadas según tu mapa
local interior = 0
local dimension = 0

setElementInterior(marcadorCargador, interior)
setElementDimension(marcadorCargador, dimension)

function getPolicias()
	n = 0
	for _, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
			n = n + 1
		end
	end
	return n
end

function fabricarCargador(playerSource)
    if getElementType(playerSource) == "player" then
        if getPolicias() < 0 then
            exports.a_infobox:addBox(playerSource, "Para fabricar un cargador deben haber al menos 2 policías en servicio", "error")
            return
        end

        local piezaColt, slotColt = exports.items:has(playerSource, 87) -- Pieza Cargador Colt
        local cantidadCautiles, slotsCautiles = exports.items:contarItems(playerSource, 86, 1) -- Contamos 1 cautil

        if piezaColt and cantidadCautiles >= 1 then
            local x, y, z = getElementPosition(playerSource)
            local x2, y2, z2 = getElementPosition(marcadorCargador)

            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
                -- Remover la pieza de cargador
                exports.items:take(playerSource, slotColt)

                -- Remover 1 cautil usando el método robusto
                local cautilesEliminados = 0
                local items = exports.items:get(playerSource)
                if items then
                    for key, v in ipairs(items) do
                        if v.item == 86 then -- ID del cautil
                            local resultado = exports.items:take(playerSource, key)
                            if resultado then
                                cautilesEliminados = cautilesEliminados + 1
                                break -- Solo necesitamos 1 cautil
                            end
                        end
                    end
                end

                local tiempoFabricacion = 30000 -- 1 minuto
                setElementFrozen(playerSource, true)
                toggleAllControls(playerSource, false, true, false)
                setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)

                -- Iniciar la barra de progreso en el cliente
                triggerClientEvent(playerSource, "progressBar", playerSource, tiempoFabricacion)
                exports.a_infobox:addBox(playerSource, "Fabricando un cargador de Colt-45, espera 1 minuto...", "info")

                setTimer(function()
                    setElementFrozen(playerSource, false)
                    toggleAllControls(playerSource, true)
                    setPedAnimation(playerSource, nil)
                    exports.items:give(playerSource, 43, "22", "Cargador Colt-45", 12)
                    exports.a_infobox:addBox(playerSource, "Has fabricado un cargador de Colt-45", "success")
                    exports.chat:me(playerSource, "ha fabricado un cargador de Colt-45.")

                    -- Crear blip para la policía
                    local blipX, blipY, blipZ = 2476.6875, -830.7041015625, 80.4609375 -- Ubicación fija
                    exports.factions:createFactionBlip2(blipX, blipY, blipZ, 1)

                    local name = getPlayerName(playerSource)
                    for _, v in ipairs(getElementsByType("player")) do
                        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
                            outputChatBox("#FFFFFF[#42B007Entorno#FFFFFF] (#42B007"..name.."#FFFFFF): Se escucharía un ruido sospechoso en la zona.", v, 255, 255, 255, true)
                        end
                    end

                    for k, v in ipairs(getElementsByType("player")) do
                        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
                            outputChatBox("(("..getPlayerName(playerSource)..")) Emergencia - Posible fabricación de cargadores de armas en curso.", v, 130, 255, 130)
                            triggerClientEvent(v, "gui:hint", v, "Policía: Emergencia", "Posible fabricación de cargadores de armas en curso.")
                        end
                    end
                    
                    outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
                end, tiempoFabricacion, 1)
            end
        else
            if not piezaColt then
                exports.a_infobox:addBox(playerSource, "No tienes la pieza de cargador Colt.", "error")
            elseif cantidadCautiles < 1 then
                exports.a_infobox:addBox(playerSource, "No tienes suficientes cautiles. Necesitas 1.", "error")
            end
        end
    end
end
addEvent("FabricarCargador", true)
addEventHandler("FabricarCargador", resourceRoot, fabricarCargador)

function activarPanelCargador(playerSource)
    if getElementType(playerSource) == "player" then
        triggerClientEvent(playerSource, "ToggleCargador", resourceRoot)
    end
end
addEventHandler("onMarkerHit", marcadorCargador, activarPanelCargador)
