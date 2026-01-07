addEvent("startRepairProgress", true)
addEventHandler("startRepairProgress", root, function(veh)
    if not isElement(veh) then return end

    local screenW, screenH = guiGetScreenSize()
    local progress = 0
    local duration = 15000 
    local startTime = getTickCount()

    for i = 0, 5 do
        setVehicleDoorOpenRatio(veh, i, 1, 1000)
    end

    local function renderProgress()
        local now = getTickCount()
        local elapsedTime = now - startTime
        local progress = math.min(elapsedTime / duration, 1) 

        local barWidth, barHeight = 350, 50
        local barX, barY = (screenW - barWidth) / 2, screenH - 120  
        local textY = barY - 25  

        local r = 255 * (1 - progress) 
        local g = 255 * progress 
        local b = 0 

        dxDrawText("Reparando el vehículo...", barX, textY, barX + barWidth, textY + 20, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center")

        dxDrawRectangle(barX - 2, barY - 2, barWidth + 4, barHeight + 2, tocolor(0, 0, 0, 200)) -- Borde
        dxDrawRectangle(barX, barY, barWidth, barHeight, tocolor(50, 30, 30, 180)) -- Fondo

        local progressWidth = barWidth * progress
        dxDrawRectangle(barX, barY, progressWidth, barHeight, tocolor(r, g, b, 255))

        dxDrawRectangle(barX, barY, progressWidth, barHeight * 0.4, tocolor(255, 255, 255, 50))

        if progress >= 1 then
            removeEventHandler("onClientRender", root, renderProgress)
            triggerServerEvent("repairVehicle", localPlayer, veh, localPlayer)

            for i = 0, 5 do
                setVehicleDoorOpenRatio(veh, i, 0, 1000)
            end
        end
    end

    addEventHandler("onClientRender", root, renderProgress)
end)
