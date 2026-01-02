-- HUD del juego
local hudVisible = false
local hunger = 100
local thirst = 100
local health = 100
local money = 0
local screenWidth, screenHeight = guiGetScreenSize()

function showHUD()
    hudVisible = true
end

function hideHUD()
    hudVisible = false
end

addEvent("showHUD", true)
addEventHandler("showHUD", resourceRoot, function()
    showHUD()
end)

addEvent("updateNeeds", true)
addEventHandler("updateNeeds", resourceRoot, function(newHunger, newThirst, newHealth)
    hunger = newHunger or hunger
    thirst = newThirst or thirst
    health = newHealth or health
end)

-- Actualizar dinero
setTimer(function()
    if hudVisible then
        local charMoney = getElementData(localPlayer, "character:money")
        if charMoney then
            money = charMoney
        end
    end
end, 1000, 0)

-- Renderizar HUD
addEventHandler("onClientRender", root, function()
    if not hudVisible then
        return
    end
    
    -- Actualizar salud en tiempo real desde el elemento del jugador
    if isElement(localPlayer) then
        local currentHealth = getElementHealth(localPlayer)
        if currentHealth then
            health = currentHealth
        end
    end
    
    -- Actualizar hambre y sed desde elementData (se actualizan desde el servidor)
    local charHunger = getElementData(localPlayer, "character:hunger")
    local charThirst = getElementData(localPlayer, "character:thirst")
    if charHunger then
        hunger = charHunger
    end
    if charThirst then
        thirst = charThirst
    end
    
    -- Fondo del HUD
    local hudX = 20
    local hudY = screenHeight - 150
    
    -- Dinero
    dxDrawText("$" .. money, hudX, hudY, screenWidth, screenHeight, tocolor(255, 255, 0, 255), 1.5, "default-bold", "left", "top", false, false, false, false, false)
    
    -- Barra de hambre
    local hungerWidth = 200
    local hungerHeight = 20
    local hungerBarWidth = (hunger / 100) * hungerWidth
    
    dxDrawRectangle(hudX, hudY + 30, hungerWidth, hungerHeight, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(hudX, hudY + 30, hungerBarWidth, hungerHeight, tocolor(255, 165, 0, 255), false)
    dxDrawText("Hambre: " .. math.floor(hunger) .. "%", hudX + 5, hudY + 32, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false, false, false, false, false)
    
    -- Barra de sed
    local thirstBarWidth = (thirst / 100) * hungerWidth
    
    dxDrawRectangle(hudX, hudY + 55, hungerWidth, hungerHeight, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(hudX, hudY + 55, thirstBarWidth, hungerHeight, tocolor(0, 100, 255, 255), false)
    dxDrawText("Sed: " .. math.floor(thirst) .. "%", hudX + 5, hudY + 57, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false, false, false, false, false)
    
    -- Barra de salud (actualizada en tiempo real)
    local healthBarWidth = (health / 100) * hungerWidth
    
    dxDrawRectangle(hudX, hudY + 80, hungerWidth, hungerHeight, tocolor(0, 0, 0, 150), false)
    dxDrawRectangle(hudX, hudY + 80, healthBarWidth, hungerHeight, tocolor(255, 0, 0, 255), false)
    dxDrawText("Salud: " .. math.floor(health) .. "%", hudX + 5, hudY + 82, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false, false, false, false, false)
end)
