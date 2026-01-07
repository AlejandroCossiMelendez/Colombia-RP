local sx, sy = guiGetScreenSize()
local scaleX, scaleY = sx / 1920, sy / 1080
local font = dxCreateFont('fonts/Orbitron-Regular.ttf', 21)
local isPanelVisible = false

function renderUI()
	dxDrawImage(sx/2 - 402 * scaleX, 212 * scaleY, 901 * scaleX, 685 * scaleY, 'data/background.png')
	dxDrawImage(sx/2 - 247 * scaleX, 295 * scaleY, 591 * scaleX, 591 * scaleY, 'data/logoPolicia.png')
	dxDrawImage(sx/2 - 358 * scaleX, 452 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroUtiles.png')
	dxDrawImage(sx/2 - 358 * scaleX, 697 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroCargadotres.png')
	dxDrawImage(sx/2 + 85 * scaleX, 697 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroDuty.png')
	dxDrawImage(sx/2 + 85 * scaleX, 452 * scaleY, 344 * scaleX, 65 * scaleY, 'data/cuadroArmamento.png')
	dxDrawText('EQUIPACION POLICIAL', sx/2 - 161 * scaleX, 242 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Utiles Policiales', sx/2 - 330 * scaleX, 462 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Cargadores', sx/2 - 295 * scaleX, 708 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Duty Pd', sx/2 + 186 * scaleX, 707 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
	dxDrawText('Armamento ', sx/2 + 155 * scaleX, 461 * scaleY, nil, nil, tocolor(255, 255, 255, 255), 1, font, 'left', 'top')
end

function toggleUI(visible)
    if visible and not isPanelVisible then
        addEventHandler('onClientRender', root, renderUI)
    elseif not visible and isPanelVisible then
        removeEventHandler('onClientRender', root, renderUI)
    end
    isPanelVisible = visible
end

removeEventHandler('onClientRender', root, renderUI)

addEvent("showUI", true)
addEventHandler("showUI", root, function()
    toggleUI(true)
    showCursor(true)
end)

addEvent("hideUI", true)
addEventHandler("hideUI", root, function()
    toggleUI(false)
    showCursor(false)
end)

bindKey("space", "down", function()
    toggleUI(false)
    showCursor(false)
end)

function handleButtonClick(button)
    if button == "duty" then
        triggerServerEvent("toggleDutySirilo", localPlayer)
    elseif button == "weapons" then
        triggerServerEvent("givePDWeaponsSirilo", localPlayer)
    elseif button == "ammo" then
        triggerServerEvent("givePDAmmoSirilo", localPlayer)
    elseif button == "utils" then
        triggerServerEvent("givePDUtilsSirilo", localPlayer)
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
