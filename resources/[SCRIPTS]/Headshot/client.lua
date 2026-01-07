local screenW, screenH = guiGetScreenSize()
local headshots = 0
local isMuerto = false

function drawHeadshot(attacker, weapon, bodypart, loss)
	if not attacker then return end
	if bodypart == 9 then
		-- Hacer que el jugador quede sin cabeza al recibir disparo
		setPedHeadless(source, true)
		
		if headshots == 0 and not (blood1 and blood2) then
			headshots = 1
			blood1 = guiCreateStaticImage(10, (screenW - 386) / 5, 196, 386, "blood_2.png", false)
			blood2 = guiCreateStaticImage(screenW - 631 - 10, (screenH - 425) / 2, 631, 425, "blood_1.png", false)
			windowFadeAnim(blood1)
			windowFadeAnim(blood2)
			setTimer(
				function()
					blood1 = nil
					blood2 = nil
				end,
				6000,1)
		elseif headshots == 1 and not (blood3 and blood4) then
			headshots = 0
			blood3 = guiCreateStaticImage(screenW/2 - 300, screenH/2 - 212, 631, 425, "blood_1.png", false)
			blood4 = guiCreateStaticImage(screenW/2 - 100, screenH/2 - 193, 196, 386, "blood_2.png", false)
			windowFadeAnim(blood3)
			windowFadeAnim(blood4)
			setTimer(
				function()
					blood3 = nil
					blood4 = nil
				end,6000,1)
		end
		
		local newHealth = math.floor(getElementHealth(source) - (99 - loss))
		if newHealth > 1 then
			setElementHealth(source, newHealth)
		end
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), drawHeadshot)

function restoreHead()
    setPedHeadless(source, false)
	if source == getLocalPlayer() and isMuerto then
		isMuerto = false
		toggleAllControls(true)
		setPedAnimation(source, false)
	end
end
addEventHandler("onClientPlayerSpawn", getRootElement(), restoreHead)

function windowFadeAnim(window)
    guiSetAlpha(window, 0)
    setTimer(fadeWindowIn, 50, 15, window)
    setTimer(fadeWindowOutStart, 5000, 1, window)
    setTimer(destroyBlood, 6000, 1, window)
end

function fadeWindowIn(window)
    if isElement(window) then
        local alpha = guiGetAlpha(window)
        local newalpha = alpha + 0.035
        guiSetAlpha(window, newalpha)
        guiMoveToBack(window)
    end
end

function fadeWindowOutStart(window)
    setTimer(fadeWindowOut, 50, 15, window)
end

function fadeWindowOut(window)
    if isElement(window) then
        local alpha = guiGetAlpha(window)
        local newalpha = alpha - 0.035
        guiSetAlpha(window, newalpha)
    end
end

function destroyBlood(window)
    destroyElement(window)
end

function finalBlow(attacker, weapon, bodypart, loss)
    if attacker and bodypart == 9 then
        local theHealth = getElementHealth(source)
        if (theHealth - 100 <= 0) then
            -- Crear un charco de sangre bajo la cabeza
            local x, y, z = getPedBonePosition(source, 6)
            createBloodPool(x, y, z)
            
            triggerServerEvent("onGameOver", localPlayer)
        end
    end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), finalBlow)

-- Manejar el evento de muerte
function handleMuerto()
    isMuerto = true
    -- Deshabilitar controles
    toggleAllControls(false)
    -- Animación de muerto
    setPedAnimation(getLocalPlayer(), "wuzi", "cs_dead_guy", -1, true, true, true)
    -- Mostrar mensaje
    outputChatBox("Has recibido un disparo en la cabeza y estás gravemente herido.", 255, 0, 0)
end
addEvent("onClientMuerto", true)
addEventHandler("onClientMuerto", getRootElement(), handleMuerto)

-- Función para crear un charco de sangre
function createBloodPool(x, y, z)
    -- Crear un marcador para el charco de sangre
    local bloodPool = createMarker(x, y, z-0.9, "corona", 1.2, 255, 0, 0, 150)
    
    -- Eliminar el charco después de un tiempo
    setTimer(function()
        if isElement(bloodPool) then
            destroyElement(bloodPool)
        end
    end, 30000, 1)
end