----------------------------------------------------------------------------------------------------------------------------------------
--local enter = createMarker(2357.240234375, -646.9091796875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local exit = createMarker(2357.240234375, -646.9091796875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local obj = createObject(2533.502, -1666.769, 15.164, 0, 0, 270)
local marker = createMarker(2546.8662109375, -1292.3642578125, 1044.125 -1, "cylinder", 1.50, 30, 144, 255, 100)
local int = 2
local dim = 1980
setElementInterior(marker, int)
setElementDimension(marker, dim)


function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) then
			n = n + 1
		end
	end
	return n
end


----------------------------------------------------------------------------------------------------------------------------------------
function showPanel(playerSource)
	if getElementType(playerSource) == "player" then
			triggerClientEvent(playerSource, "Toggle", resourceRoot)
	end
end
addEventHandler("onMarkerHit", marker, showPanel)
----------------------------------------------------------------------------------------------------------------------------------------

function start(playerSource, qntd)
if getPolicias() > 2 then
local material, slot, v = exports.items:has(playerSource, 38)
local material2, slot2, v2 = exports.items:has(playerSource, 39)
local material3, slot3, v3 = exports.items:has(playerSource, 40)
local material4, slot4, v4 = exports.items:has(playerSource, 41)
if material and material2 and material3 and material4 then
	if qntd == 1 then
	local x, y, z = getElementPosition(playerSource)
	local x2, y2, z2 = getElementPosition(marker)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
			local material, slot, v = exports.items:has(playerSource, 38)
			exports.items:take(playerSource, slot)
			local material2, slot2, v2 = exports.items:has(playerSource, 39)
			exports.items:take(playerSource, slot2)
			local material3, slot3, v3 = exports.items:has(playerSource, 40)
			exports.items:take(playerSource, slot3)
			local material4, slot4, v4 = exports.items:has(playerSource, 41)
			exports.items:take(playerSource, slot4)
			local time = 30000
			setElementFrozen(playerSource, true)
			toggleAllControls(playerSource, false, true, false)
			setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
			triggerClientEvent(playerSource, "progressBar", playerSource, time)
			exports.infobox:addNotification(playerSource, "Fabricando arma...", "info")
			setTimer(function()
				setElementFrozen(playerSource, false)
				toggleAllControls(playerSource, true)
				setPedAnimation(playerSource, nil)
                giveWeapon(playerSource, 30)
				exports.infobox:addNotification(playerSource, "Has fabricado una AK-47", "success")
				exports.chat:me(playerSource, "ha fabricado un AK-47.")
				local name = getPlayerName(playerSource); 
				for _,v in ipairs(getElementsByType("player")) do 
					if exports.factions:isPlayerInFaction(v, 1) then
						outputChatBox("#FFFFFF[#42B007Entorno#FFFFFF] (#42B007"..name.."#FFFFFF): Se escucharia sonar la alarma de la fabrica abandonada de los santos.", v, 255, 255, 255, true) --efeito no chat
					end
				end
				if getElementDimension(playerSource) == 0 then
					local x, y, z = getElementPosition(playerSource)
					exports.factions:createFactionBlip2(x, y, z, 1)
				else
					local x, y, z = exports.interiors:getPos(getElementDimension(playerSource))
					exports.factions:createFactionBlip2(x, y, z, 1)
				end
				for k, v in ipairs(getElementsByType("player")) do
					if exports.factions:isPlayerInFaction(v, 1) then
						outputChatBox( "(("..getPlayerName(playerSource)..")) Emergencia - Situacion: Se escucharia sonar la alarma de la fabrica abandonada de los santos.", v, 130, 255, 130 )
						triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: Se escucharia sonar la alarma de la fabrica abandonada de los santos." )
					end
				end
				outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
			end, time, 1)
		end
    end
else
	exports.infobox:addNotification(playerSource, "No tienes los materiales necesario para fabricar una AK-47", "error")
end
else
exports.infobox:addNotification(playerSource, "Para fabricar el arma deben haber 3 policias en servicio", "error")
end
end
addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)
----------------------------------------------------------------------------------------------------------------------------------------


















