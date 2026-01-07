local zonasReparacion = {
    {2885.6235351562, -1942.8049316406, 11.207813262939- 1}, -- ELN
    {2505.9350585938, -1531.1497802734, 24.10781288147 - 1}, -- CDG
    {2194.2888183594, -1356.4346923828, 24.026182174683 - 1} --CDJ
}

local markers = {}

for _, pos in ipairs(zonasReparacion) do
    local marker = createMarker(pos[1], pos[2], pos[3], "cylinder", 4, 255, 0, 0, 150)
    table.insert(markers, marker)

    addEventHandler("onMarkerHit", marker, function(hitElement, matchingDimension)
        if isElement(hitElement) and getElementType(hitElement) == "player" and matchingDimension then
            local veh = getPedOccupiedVehicle(hitElement)
            if veh and isElement(veh) then
                if getElementHealth(veh) < 1000 then
                    if exports.players:getMoney(hitElement) < 1000000 then
                        outputChatBox("No tienes suficiente dinero para reparar el vehículo!", hitElement, 255, 0, 0)
                    else
                        setElementFrozen(veh, true)
                        triggerClientEvent(hitElement, "startRepairProgress", hitElement, veh)
                    end
                else
                    outputChatBox("El vehículo no necesita reparación!", hitElement, 255, 0, 0)
                end
            end
        end
    end)
end

addEvent("repairVehicle", true)
addEventHandler("repairVehicle", root, function(veh, player)
    if isElement(veh) and isElement(player) then
        exports.players:takeMoney(player, 2500000)
        setElementFrozen(veh, false)
        fixVehicle(veh)
        outputChatBox("Vehículo reparado! Se te descontaron $1.000.000 por la reparacion.", player, 0, 255, 0)
    end
end)
