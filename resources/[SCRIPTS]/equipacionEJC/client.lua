local sx, sy = guiGetScreenSize()
local scaleX, scaleY = sx / 1920, sy / 1080
local font = dxCreateFont('fonts/Orbitron-Regular.ttf', 21)
local isPanelVisible = false

function renderUI()
	dxDrawImage(sx/2 - 402 * scaleX, 212 * scaleY, 901 * scaleX, 685 * scaleY, 'data/backgroundEJC.png')
	dxDrawImage(sx/2 - 247 * scaleX, 295 * scaleY, 591 * scaleX, 591 * scaleY, 'data/logoEJC.png')
	dxDrawImage(sx/2 - 358 * scaleX, 452 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroUtiles.png')
	dxDrawImage(sx/2 - 358 * scaleX, 697 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroCargadotres.png')
	dxDrawImage(sx/2 + 85 * scaleX, 697 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroDuty.png')
	dxDrawImage(sx/2 + 85 * scaleX, 452 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroArmamento.png')
	dxDrawText('EQUIPACION MILITAR', sx/2 - 161 * scaleX, 242 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Utiles Militares', sx/2 - 330 * scaleX, 462 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Cargadores', sx/2 - 295 * scaleX, 708 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Duty EJC', sx/2 + 186 * scaleX, 707 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Armamento', sx/2 + 155 * scaleX, 461 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
end

function toggleUIS(visible)
    isPanelVisible = visible
    local eventCallback = visible and addEventHandler or removeEventHandler
    eventCallback('onClientRender', root, renderUI)
end

removeEventHandler('onClientRender', root, renderUI)

addEvent("showUIs", true)
addEventHandler("showUIs", root, function()
    toggleUIS(true)
    showCursor(true)
end)

addEvent("hideUIs", true)
addEventHandler("hideUIs", root, function()
    toggleUIS(false)
    showCursor(false)
end)

bindKey("space", "down", function()
    toggleUIS(false)
    showCursor(false)
end)

function handleButtonClick(button)
    if button == "duty" then
        triggerServerEvent("EJC_toggleDutySiri", localPlayer)
    elseif button == "weapons" then
        triggerServerEvent("EJC_givePDWeaponsSiri", localPlayer)
    elseif button == "ammo" then
        triggerServerEvent("EJC_givePDAmmoSiri", localPlayer)
    elseif button == "utils" then
        triggerServerEvent("EJC_givePDUtilsSiri", localPlayer)
    end
end

-- Detectar clics en los botones
addEventHandler("onClientClick", root, function(button, state)
    if state == "down" and isPanelVisible then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * sx, cursorY * sy

        -- Verificar si se hizo clic en un botón específico
        if cursorX >= (sx/2 - 358 * scaleX) and cursorX <= (sx/2 - 358 * scaleX + 344 * scaleX) then
            if cursorY >= (452 * scaleY) and cursorY <= (452 * scaleY + 65 * scaleY) then
                handleButtonClick("utils")
            elseif cursorY >= (697 * scaleY) and cursorY <= (697 * scaleY + 65 * scaleY) then
                handleButtonClick("ammo")
            end
        elseif cursorX >= (sx/2 + 85 * scaleX) and cursorX <= (sx/2 + 85 * scaleX + 344 * scaleX) then
            if cursorY >= (452 * scaleY) and cursorY <= (452 * scaleY + 65 * scaleY) then
                handleButtonClick("weapons")
            elseif cursorY >= (697 * scaleY) and cursorY <= (697 * scaleY + 65 * scaleY) then
                handleButtonClick("duty")
            end
        end
    end
end)
