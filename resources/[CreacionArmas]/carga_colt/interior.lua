local marker = createMarker(4305.2900390625, 219.794921875, 8.8060350418091 -1, "cylinder", 1.10, 0, 255, 25, 100)
local int = 4
local dim = 427
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
if getPolicias() > 1 then
local material, slot, v = exports.items:has(playerSource, 91)
local material2, slot2, v2 = exports.items:has(playerSource, 92)
if material and material2 then
	if qntd == 1 then
	local x, y, z = getElementPosition(playerSource)
	local x2, y2, z2 = getElementPosition(marker)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
			local material, slot, v = exports.items:has(playerSource, 91)
			exports.items:take(playerSource, slot)
			local material2, slot2, v2 = exports.items:has(playerSource, 92)
			exports.items:take(playerSource, slot2)
			local time = 30000
			setElementFrozen(playerSource, true)
			toggleAllControls(playerSource, false, true, false)
			setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
			triggerClientEvent(playerSource, "progressBar", playerSource, time)
			exports.infobox:addNotification(playerSource, "Fabricando Cargas...", "info")
			setTimer(function()
				setElementFrozen(playerSource, false)
				toggleAllControls(playerSource, true)
				setPedAnimation(playerSource, nil)
			    exports.items:give(playerSource, 43, 22)
			    exports.items:give(playerSource, 43, 22)
				exports.infobox:addNotification(playerSource, "Has fabricado cargadores de Colt-45", "success")
				exports.chat:me(playerSource, "Emsambla un conjunto de piezas")
				local name = getPlayerName(playerSource); 
				for _,v in ipairs(getElementsByType("player")) do 
					if exports.factions:isPlayerInFaction(v, 1) then
						outputChatBox("#FFFFFF[#42B007Entorno#FFFFFF] (#42B007"..name.."#FFFFFF): Se veria un sujeto soldar acero en un racho de 'Cartagena'.", v, 255, 255, 255, true)
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
						outputChatBox( "(("..getPlayerName(playerSource)..")) Emergencia - Situacion: Se escucharia sonar la alarma anti-intrusos de el rancho de CARTAGENA.", v, 130, 255, 130 )
						triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: Se escucharia sonar la alarma anti-intrusos de el rancho de CARTAGENA." )
					end
				end
				outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
			end, time, 1)
		end
    end
else
	exports.infobox:addNotification(playerSource, "No tienes los materiales necesarios para fabricar cargadores de Colt-45", "error")
end
else
exports.infobox:addNotification(playerSource, "Para fabricar deben haber 2 policias en servicio", "error")
end
end
addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)
----------------------------------------------------------------------------------------------------------------------------------------


















