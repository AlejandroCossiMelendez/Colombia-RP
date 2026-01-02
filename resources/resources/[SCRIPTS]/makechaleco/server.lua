function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) then
			n = n + 1
		end
	end
	return n
end


---===================================== Processar ======================================---

local processarM = createMarker( 1408.9597167969, -249.2451171875, 12.653544425964 -1, "cylinder", 1.5, 0, 145, 255, 150)

function processarf(source)

if getPolicias() > 1 then
	if isElementWithinMarker(source, processarM) then
			if getElementData (source,"ProcessandoT") == "Sim" then
				exports.infobox:addNotification(source, "Ya estas fabricando un 'Chaleco Antibalas'", "error")
			return
			end
		local tem, quant, data = exports.items:has(source, 55)
		local tem2, quant2, data2 = exports.items:has(source, 70)
		if tem and tem2 then
			setElementData(source,"ProcessandoT", "Sim")
			setElementFrozen( source, true )
			setElementRotation(source,0,0,0)
			setPedAnimation(source, "BD_FIRE", "wash_up", -1, true)
			triggerClientEvent(source, "progressBar", source, 27000, "Fabricando")
			exports.items:take(source, quant)
			local tem3, quant3, data3 = exports.items:has(source, 70)
			exports.items:take(source, quant3)
			setTimer( function(source)
				if isElementWithinMarker(source, processarM) then
					setElementFrozen( source, false )
					setPedAnimation (source)
					exports.items:give(source, 46, 100)	
					exports.infobox:addNotification(source, "Has fabricado un 'Chaleco Antibalas'", "success")
					setElementData(source,"ProcessandoT","Não")
				else
					exports.infobox:addNotification(source, "No estas en la zona para fabricar el 'Chaleco Antibalas'", "error")
				end
			end, 27000, 1,source )
		else
			exports.infobox:addNotification(source, "Necesitas 'Tela' y 'Tijeras' para fabricar el 'Chaleco Antibalas'", "error")
		end
	end
else
	exports.infobox:addNotification(source, "Para fabricar el chaleco deben haber 2 policias en servicio", "error")
end
end
---===============================================================================================================================
------------------------------------------------

function Jmarker(marker,md)
	if (md) then
		if marker == processarM then
			bindKey(source,"h", "down", processarf)
		end
	end
end
addEventHandler("onPlayerMarkerHit",getRootElement(),Jmarker)

function lmarker(marker,md)
	if (md) then
		if marker == processarM then
			unbindKey(source,"h", "down", processarf)
		end
	end
end
addEventHandler("onPlayerMarkerLeave",getRootElement(),lmarker)

