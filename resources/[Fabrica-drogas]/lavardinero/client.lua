local screenW, screenH = guiGetScreenSize()
local progressActive = false

addEventHandler("onClientRender", root,
function()
    if getDistanceBetweenPoints3D(-563.3232421875, -176.927734375, 78.40625, getElementPosition(getLocalPlayer())) < 5 then
        local coords = {getScreenFromWorldPosition(-563.3232421875, -176.927734375, 78.40625)}
        if coords[1] and coords[2] then
            dxDrawText("Usa [/lavar cantidad] para convertir dinero sucio en limpio", coords[1], coords[2], coords[1], coords[2], tocolor(250, 250, 250), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        end
    end
end)

addEvent("startProgressBar", true)
addEventHandler("startProgressBar", root,
function(time, action)
    if progressActive then return end -- Evita que se duplique la barra de progreso
    progressActive = true
    local startTime = getTickCount()
    local endTime = startTime + time

    local function renderProgressBar()
        local now = getTickCount()
        local elapsedTime = now - startTime
        local progress = elapsedTime / (endTime - startTime)

        dxDrawRectangle(0.4 * screenW, 0.85 * screenH, 0.2 * screenW, 0.04 * screenH, tocolor(0, 0, 0, 200))
        dxDrawRectangle(0.4 * screenW, 0.85 * screenH, (0.2 * screenW) * progress, 0.04 * screenH, tocolor(0, 255, 0, 200))
        dxDrawText(action .. " - " .. math.floor(progress * 100) .. "%", 0.5 * screenW, 0.87 * screenH, 0.5 * screenW, 0.87 * screenH, tocolor(255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)

        if now >= endTime then
            removeEventHandler("onClientRender", root, renderProgressBar)
            progressActive = false -- Restablecer estado para permitir una nueva barra de progreso
        end
    end

    addEventHandler("onClientRender", root, renderProgressBar)
end)
