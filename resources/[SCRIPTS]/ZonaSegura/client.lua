local Fonts = {
    ["1"] = dxCreateFont("font.ttf", 19),
}

zonas_seguras = {
--   PosX,      PosY,           PosZ, Width, Depth, Height
    {76.93688, -174.08754, 0.0, 50, 30, 20},
    {193.17252, -183.78207, 0.0, 30, 32, 20},
    {-330.71795654297, 994.55822753906, 0.0, 50, 79, 50},
    {909.86737060547, 594.52575683594, 0.0, 50, 79, 50},
    {607.32501, -613.88062, 0.0, 64.5, 79, 50}
}

function crearZonasSeguras()
    for i, _ in ipairs(zonas_seguras) do
        local zona_verde = createColCuboid(zonas_seguras[i][1], zonas_seguras[i][2], zonas_seguras[i][3], zonas_seguras[i][4], zonas_seguras[i][5], zonas_seguras[i][6])
        local radar_verde = createRadarArea(zonas_seguras[i][1], zonas_seguras[i][2], zonas_seguras[i][4], zonas_seguras[i][5], 0, 255, 0, 100)
        
        addEventHandler("onClientColShapeHit", zona_verde, function(hitPlayer)
            if hitPlayer == localPlayer then
                setPedWeaponSlot(hitPlayer, 0)
                setToggleControlsPlayer(false)
                addEventHandler("onClientRender", getRootElement(), viewTextSafeZone)
                addEventHandler("onClientPlayerDamage", getLocalPlayer(), quitarDano)
            end
        end)
        
        addEventHandler("onClientColShapeLeave", zona_verde, function(hitPlayer)
            if hitPlayer == localPlayer then
                setToggleControlsPlayer(true)
                removeEventHandler("onClientRender", getRootElement(), viewTextSafeZone)
                removeEventHandler("onClientPlayerDamage", getLocalPlayer(), quitarDano)
            end
        end)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, crearZonasSeguras)

function quitarDano(attacker, weapon, bodypart, loss)
    if isElement(attacker) and getElementType(attacker) == "player" then
        local attackerX, attackerY, attackerZ = getElementPosition(attacker)
        local playerX, playerY, playerZ = getElementPosition(localPlayer)
        
        if isLineOfSightClear(attackerX, attackerY, attackerZ, playerX, playerY, playerZ, true, false, false, true, false, false, false, localPlayer) then
            cancelEvent()
        end
    end
end

function setToggleControlsPlayer(status)
    toggleControl("fire", status)
    toggleControl("next_weapon", status)
    toggleControl("previous_weapon", status)
    toggleControl("aim_weapon", status)
    toggleControl("vehicle_fire", status)
    toggleControl("vehicle_secondary_fire", status)
end

function viewTextSafeZone()
    dxDrawImage(001, 550, 300, 80, "fondo.png")
    dxDrawText("Zona Segura", 020, 567, 194, 41, tocolor(255, 255, 255, 255), 1, Fonts["1"], "center", "center")
end