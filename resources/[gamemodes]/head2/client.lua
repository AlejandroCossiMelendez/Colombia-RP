local screenW, screenH = guiGetScreenSize()
local headshots = 0

function drawHeadshot(attacker, weapon, bodypart, loss)
	if not attacker then return end
		if bodypart == 9 then
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
				blood3 = guiCreateStaticImage(screenW, screenH, 450, 221, "blood_1.png", false)
				blood4 = guiCreateStaticImage(screenW, screenH, 196, 386, "blood_2.png", false)
				windowFadeAnim(blood3)
				windowFadeAnim(blood4)
				setTimer(
					function()
						blood3 = nil
						blood4 = nil
					end,6000,1)
			end
			-- make a headshot about twice as harmful (estimate, as it's influenced by specific gun's regular damage.. 'twice' goes for AK-47 damage, so as to say)
			local newHealth = math.floor(getElementHealth(source) - (30 - loss))
			if newHealth > 0 then
				setElementHealth(source, newHealth)
		end
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), drawHeadshot)

function restoreHead()
    setPedHeadless(source, false)
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
        if (theHealth - 40 <= 0) then
			-- kill the player and blow his head off serversided, for better sync
            triggerServerEvent("onGameOver", localPlayer)
        end
    end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), finalBlow)