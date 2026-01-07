local parpadeos = {}

function toggleLights(player, cmd, mode)
    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then
        outputChatBox("Debes estar en un vehículo para usar este comando.", player, 255, 0, 0)
        return
    end

    local mode = tonumber(mode)
    if not mode or mode < 0 or mode > 3 then
        outputChatBox("Uso: /luces [0-3]", player, 255, 255, 0)
        return
    end

    local vehicleID = getElementData(vehicle, "ID") or vehicle -- Identificador único

    -- Si ya hay parpadeo, detenerlo
    if parpadeos[vehicleID] then
        for _, timer in ipairs(parpadeos[vehicleID]) do
            if isTimer(timer) then
                killTimer(timer)
            end
        end
        parpadeos[vehicleID] = nil
    end

    -- Desactivar luces si el modo es 0
    if mode == 0 then
        outputChatBox("Parpadeo de luces desactivado.", player, 0, 255, 0)
        setVehicleOverrideLights(vehicle, 0)
        return
    end

    local speeds = { [1] = {1000, 1200}, [2] = {500, 700}, [3] = {250, 400} } -- Diferentes tiempos
    local speed1, speed2 = unpack(speeds[mode])
    local state1, state2 = false, false

    parpadeos[vehicleID] = {
        setTimer(function()
            if isElement(vehicle) then
                state1 = not state1
                setVehicleLightState(vehicle, 0, state1 and 0 or 1) -- Faro izquierdo
            end
        end, speed1, 0),

        setTimer(function()
            if isElement(vehicle) then
                state2 = not state2
                setVehicleLightState(vehicle, 1, state2 and 0 or 1) -- Faro derecho
            end
        end, speed2, 0)
    }

    outputChatBox("Parpadeo alternado activado: Modo " .. mode, player, 0, 255, 0)
end
addCommandHandler("luces", toggleLights)
