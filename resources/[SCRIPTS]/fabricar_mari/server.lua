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

local processarM = createMarker( 1939.6455078125, 144.74609375, 37.260635375977 -1, "cylinder", 1.5, 0, 145, 255, 150)

function processarf(source)

if getPolicias() > 1 then
	if isElementWithinMarker(source, processarM) then
			if getElementData (source,"ProcessandoT") == "Sim" then
				exports.infobox:addNotification(source, "Ya Estás Sembrando 'Marihuana'", "error")
			return
			end
		local tem, quant, data = exports.items:has(source, 65)
		local tem2, quant2, data2 = exports.items:has(source, 74)
		if tem and tem2 then
			setElementData(source,"ProcessandoT", "Sim")
			setElementFrozen( source, true )
			setElementRotation(source,0,0,0)
			setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true)
			triggerClientEvent(source, "progressBar", source, 23000, "Fabricando")
			exports.items:take(source, quant)
			local tem3, quant3, data3 = exports.items:has(source, 74)
			exports.items:take(source, quant3)
			setTimer( function(source)
				if isElementWithinMarker(source, processarM) then
					setElementFrozen( source, false )
					setPedAnimation (source)
					exports.items:give(source, 18, 1)	
					exports.infobox:addNotification(source, "Has fabricado un 'Porro de marihuana'", "success")
					setElementData(source,"ProcessandoT","Não")
				else
					exports.infobox:addNotification(source, "No estas en la zona para sembrar la 'marihuana'", "error")
				end
			end, 23000, 1,source )
		else
			exports.infobox:addNotification(source, "Necesitas 'Bandeja' y 'Semillas' para fabricar un 'porro de marihuana'", "error")
		end
	end
else
	exports.infobox:addNotification(source, "Para fabricar el porro deben haber 2 policias en servicio", "error")
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

