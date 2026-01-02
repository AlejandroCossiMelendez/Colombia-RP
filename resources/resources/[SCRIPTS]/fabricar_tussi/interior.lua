----------------------------------------------------------------------------------------------------------------------------------------
--local enter = createMarker(-229.4580078125, 2729.5771484375, 62.731258392334 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local exit = createMarker(2352.9350585938,-1180.9763183594,1027.9765625 + 0.75, "arrow", 1.25, 255, 255, 255, 100)
--local obj = createObject(2533.502, -1666.769, 15.164, 0, 0, 270)
local marker = createMarker(1932.0908203125, 159.9541015625, 37.28125 -1, "cylinder", 1.20, 30, 145, 255, 100)
local int = 0
local dim = 0
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

function getRepublicana()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 22) then
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
if getPolicias() > 0 or getRepublicana() > 0 then
local drog, slot, v = exports.items:has(playerSource, 74)
local drog2, slot2, v = exports.items:has(playerSource, 84)
if drog and drog2 then
	if qntd == 1 then
	local x, y, z = getElementPosition(playerSource)
	local x2, y2, z2 = getElementPosition(marker)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3 then
			local drog, slot, v = exports.items:has(playerSource, 74)
		    exports.items:take(playerSource, slot)
			local drog2, slot2, v = exports.items:has(playerSource, 84)
			exports.items:take(playerSource, slot2)
			local time = 21000
			setElementFrozen(playerSource, true)
			toggleAllControls(playerSource, false, true, false)
			setPedAnimation(playerSource, "CASINO", "dealone", -1, true, false, false, false, _, true)
			triggerClientEvent(playerSource, "progressBar", playerSource, time)
			exports.infobox:addNotification(playerSource, "Fabricando Droga...", "info")
			setTimer(function()
				setElementFrozen(playerSource, false)
				toggleAllControls(playerSource, true)
				setPedAnimation(playerSource, nil)
				exports.items:give(playerSource, 20, 1002)
				exports.items:give(playerSource, 20, 1002)
				exports.infobox:addNotification(playerSource, "Has fabricado tusssi", "success")
				local name = getPlayerName(playerSource); 
				for _,v in ipairs(getElementsByType("player")) do 
					if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 1) then
						outputChatBox("#FFFFFF[#42B007Entorno#FFFFFF] (#42B007"..name.."#FFFFFF): Se sentiria un fuerte olor salir de un laboratorio en bogota.", v, 255, 255, 255, true) --efeito no chat
					end
				end
				if getElementDimension(playerSource) == 0 then
					local x, y, z = getElementPosition(playerSource)
					exports.factions:createFactionBlip2(x, y, z, 1)
					exports.factions:createFactionBlip2(x, y, z, 1)
				else
					local x, y, z = exports.interiors:getPos(getElementDimension(playerSource))
					exports.factions:createFactionBlip2(x, y, z, 1)
					exports.factions:createFactionBlip2(x, y, z, 1)
				end
				for k, v in ipairs(getElementsByType("player")) do
					if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 1) then
						outputChatBox( "(("..getPlayerName(playerSource)..")) Emergencia - Situacion: Se sentiria un fuerte olor salir del viejo hotel abandonado.", v, 130, 255, 130 )
						triggerClientEvent( v, "gui:hint", v, "Policía: Emergencia", "Situacion: Se sentiria un fuerte olor salir del viejo hotel abandonado." )
					end
				end
				outputChatBox("Se ha dado el aviso por entorno correctamente a la policía.", playerSource, 255, 0, 0)
			end, time, 1)
		end
	end
else
	exports.infobox:addNotification(playerSource, "No tienes los materiales necesarios", "error")
end
else
exports.infobox:addNotification(playerSource, "Para fabricar tussi deben haber 2 policias en servicio", "error")
end
end

addEvent("Start", true)
addEventHandler("Start", resourceRoot, start)
----------------------------------------------------------------------------------------------------------------------------------------
