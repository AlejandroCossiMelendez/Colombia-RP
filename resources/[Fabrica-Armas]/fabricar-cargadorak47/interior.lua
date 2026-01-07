-- Crear un nuevo marcador para fabricar la Tec-9
local marcadorAK47 = createMarker(2475.9521484375, -834.4111328125, 80.4609375 -1, "cylinder", 1.5, 255, 144, 0, 100) -- Ajusta la posición si es necesario
local interior = 0
local dimension = 0

setElementInterior(marcadorAK47, interior)
setElementDimension(marcadorAK47, dimension)

function getPolicias()
    local n = 0
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
            n = n + 1
        end
    end
    return n
end
function fabricarAk47(playerSource)
    if getElementType(playerSource) == "player" then
        -- Verifica si hay suficientes policías en servicio
        if getPolicias() < 0 then
            exports.a_infobox:addBox(playerSource, "Para fabricar una Ak-47 deben haber al menos 2 policías en servicio", "error")
            return
        end

        local tienePieza, slotPieza = exports.items:has(playerSource, 89) -- Verifica la pieza de cargador
        local cantidadCautiles, slotsCautiles = exports.items:contarItems(playerSource, 86, 3) -- Contamos los cautiles



        -- Verificar si realmente tiene los materiales antes de continuar
        if not tienePieza then
            exports.a_infobox:addBox(playerSource, "No tienes la pieza de cargador AK-47.", "error")
            return
        end

        if cantidadCautiles < 3 then
            exports.a_infobox:addBox(playerSource, "No tienes suficientes cautiles. Necesitas 3.", "error")
            return
        end

        local x, y, z = getElementPosition(playerSource)
        local x2, y2, z2 = getElementPosition(marcadorAK47)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
            -- 🔹 Eliminar la pieza de cargador
            exports.items:take(playerSource, slotPieza)

            -- 🔹 Eliminar los 3 cautiles encontrados (usando la lógica del sistema de items)
            local cautilesEliminados = 0
            
            -- Método usando la estructura real del sistema de items
            for i = 1, 3 do
                local encontrado = false
                local items = exports.items:get(playerSource)
                if items then
                    for key, v in ipairs(items) do
                        if v.item == 86 then -- ID del cautil
                            local resultado = exports.items:take(playerSource, key)
                            if resultado then
                                cautilesEliminados = cautilesEliminados + 1
                                encontrado = true
                                break
                            end
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
            exports.a_infobox:addBox(playerSource, "Fabricando un Cargador de AK-47, espera 1 minuto...", "info")

            setTimer(function()
                setElementFrozen(playerSource, false)
                toggleAllControls(playerSource, true)
                setPedAnimation(playerSource, nil)
                exports.items:give(playerSource, 43, "30", "Ak-47", 30)
                exports.a_infobox:addBox(playerSource, "Has fabricado un Cargador de AK-47", "success")
                exports.chat:me(playerSource, "ha fabricado un Cargador de AK-47.")

                -- 🔹 Enviar aviso a la policía
                for _, v in ipairs(getElementsByType("player")) do
                    if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then -- Si el jugador es policía
                        outputChatBox("(("..getPlayerName(playerSource)..")) Emergencia - Posible fabricación de cargas de armas en curso.", v, 130, 255, 130)
                        triggerClientEvent(v, "gui:hint", v, "Policía: Emergencia", "Posible fabricación de cargas de armas en curso.")
                    end
                end
                outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
            end, tiempoFabricacion, 1)
        end
    end
end



addEvent("fabricarAk47", true)
addEventHandler("fabricarAk47", resourceRoot, fabricarAk47)

function activarPanelak47(playerSource)
    if getElementType(playerSource) == "player" then
        triggerClientEvent(playerSource, "ToggleAk47", resourceRoot)
    end
end
addEventHandler("onMarkerHit", marcadorAK47, activarPanelak47)
