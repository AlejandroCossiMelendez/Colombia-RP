----------------------------------------------------------------------------------------------------------------------------------------
--local enter = createMarker(2357.2353515625, -649.8935546875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local exit = createMarker(2357.2353515625, -649.8935546875, 128.0546875 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local obj = createObject(2533.502, -1666.769, 15.164, 0, 0, 270)
local marker = createMarker(2552.8740234375, -1303.439453125, 1044.125 -1, "cylinder", 1.50, 0, 255, 0, 100)
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
local material, slot, v = exports.items:has(playerSource, 61)
local material2, slot2, v2 = exports.items:has(playerSource, 62)
local material3, slot3, v3 = exports.items:has(playerSource, 63)
if material and material2 and material3 then
	if qntd == 1 then
	local x, y, z = getElementPosition(playerSource)
	local x2, y2, z2 = getElementPosition(marker)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
			local material, slot, v = exports.items:has(playerSource, 61)
			exports.items:take(playerSource, slot)
			local material2, slot2, v2 = exports.items:has(playerSource, 62)
			exports.items:take(playerSource, slot2)
			local material3, slot3, v3 = exports.items:has(playerSource, 63)
			exports.items:take(playerSource, slot3)
			local time = 27000
			setElementFrozen(playerSource, true)
			toggleAllControls(playerSource, false, true, false)
			setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
			triggerClientEvent(playerSource, "progressBar", playerSource, time)
			exports.infobox:addNotification(playerSource, "fabricando arma...", "info")
			setTimer(function()
				setElementFrozen(playerSource, false)
				toggleAllControls(playerSource, true)
				setPedAnimation(playerSource, nil)
                giveWeapon(playerSource, 32)
				exports.infobox:addNotification(playerSource, "Has fabricado una Tec-9", "success")
				exports.chat:me(playerSource, "ha fabricado un Tec-9.")
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
	exports.infobox:addNotification(playerSource, "No tienes los materiales necesario para fabricar una Tec-9", "error")
end
else
exports.infobox:addNotification(playerSource, "Para fabricar el arma deben haber 3 policias en servicio", "error")
end
end
addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)
----------------------------------------------------------------------------------------------------------------------------------------


















