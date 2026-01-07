-- Crear un nuevo marcador para fabricar la Tec-9
local marcadorTec9 = createMarker(2479.6611328125, -831.1962890625, 80.4609375 -1, "cylinder", 1.5, 255, 144, 0, 100)
local interior = 0
local dimension = 0

setElementInterior(marcadorTec9, interior)
setElementDimension(marcadorTec9, dimension)

function getPolicias()
    local n = 0
    for _, v in ipairs(getElementsByType("player")) do
        if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
            n = n + 1
        end
    end
    return n
end

function fabricarTec9(playerSource)
    if getElementType(playerSource) == "player" then
        -- Verifica si hay suficientes policías en servicio
        if getPolicias() < 0 then
            exports.a_infobox:addBox(playerSource, "Para fabricar una Tec-9 deben haber al menos 2 policías en servicio", "error")
            return
        end

        local tienePieza, slotPieza = exports.items:has(playerSource, 88) -- Verifica la pieza de cargador Tec-9
        local cantidadCautiles, slotsCautiles = exports.items:contarItems(playerSource, 86, 2) -- Contamos los cautiles

        -- Verificar si realmente tiene los materiales antes de continuar
        if not tienePieza then
            exports.a_infobox:addBox(playerSource, "No tienes la pieza de cargador Tec-9.", "error")
            return
        end

        if cantidadCautiles < 2 then
            exports.a_infobox:addBox(playerSource, "No tienes suficientes cautiles. Necesitas 2.", "error")
            return
        end

        local x, y, z = getElementPosition(playerSource)
        local x2, y2, z2 = getElementPosition(marcadorTec9)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
            -- 🔹 Eliminar la pieza de cargador
            exports.items:take(playerSource, slotPieza)

            -- 🔹 Eliminar los 2 cautiles encontrados (usando método robusto)
            local cautilesEliminados = 0
            
            -- Método robusto: eliminar por ID de item en lugar de por slots precalculados
            for i = 1, 2 do
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
            exports.a_infobox:addBox(playerSource, "Fabricando un Cargador de Tec-9, espera 1 minuto...", "info")

            setTimer(function()
                setElementFrozen(playerSource, false)
                toggleAllControls(playerSource, true)
                setPedAnimation(playerSource, nil)
                exports.items:give(playerSource, 43, "32", "Tec-9", 35)
                exports.a_infobox:addBox(playerSource, "Has fabricado un Cargador de Tec-9", "success")
                exports.chat:me(playerSource, "ha fabricado un Cargador de Tec-9.")

                -- 🔹 Enviar aviso a la policía
                for _, v in ipairs(getElementsByType("player")) do
                    if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 4) then
                        outputChatBox("(("..getPlayerName(playerSource)..")) Emergencia - Posible fabricación de cargadores de armas en curso.", v, 130, 255, 130)
                        triggerClientEvent(v, "gui:hint", v, "Policía: Emergencia", "Posible fabricación de cargadores de armas en curso.")
                    end
                end
                outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
            end, tiempoFabricacion, 1)
        end
    end
end

-- 🔹 Vincular la función a un evento para ejecutarla desde el cliente
addEvent("FabricarTec9", true)
addEventHandler("FabricarTec9", resourceRoot, fabricarTec9)

function activarPanelTec9(playerSource)
    if getElementType(playerSource) == "player" then
        triggerClientEvent(playerSource, "ToggleTec9", resourceRoot)
    end
end
addEventHandler("onMarkerHit", marcadorTec9, activarPanelTec9)
