function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) or exports.factions:isPlayerInFaction(v, 10) then
			n = n + 1
		end
	end
	return n
end


---===================================== Processar ======================================---

local processarM = createMarker(346.5862121582, -715.97149658203, 11.873379707336 -1, "cylinder", 1.5, 0, 0, 255, 155)

function processarf(source)

if getPolicias() > 2 then
	if isElementWithinMarker(source, processarM) then
			if getElementData (source,"ProcessandoT") == "Sim" then
				exports.a_infobox:addBox(source, "Ya estas fabricando un 'Chaleco Antibalas'", "error")
			return
			end
		local tem, quant, data = exports.items:has(source, 55)
		local tem2, quant2, data2 = exports.items:has(source, 56)
		if tem and tem2 then
			setElementData(source,"ProcessandoT", "Sim")
			setElementFrozen( source, true )
			setElementRotation(source,0,0,0)
			setPedAnimation(source, "GANGS", "prtial_hndshk_biz_01",-1, true)
			triggerClientEvent(source, "progressServiceM", source, 60, "Fabricando")
			exports.items:take(source, quant)
			local tem3, quant3, data3 = exports.items:has(source, 56)
			exports.items:take(source, quant3)
			setTimer( function(source)
				if isElementWithinMarker(source, processarM) then
					setElementFrozen( source, false )
					setPedAnimation (source)
					exports.items:give(source, 46, 100)	
					exports.a_infobox:addBox(source, "Has fabricado un 'Chaleco Antibalas'", "success")
					setElementData(source,"ProcessandoT","Não")
				else
					exports.a_infobox:addBox(source, "No estas en la zona para fabricar el 'Chaleco Antibalas'", "error")
				end
			end, 60000, 1,source )
		else
			exports.a_infobox:addBox(source, "Necesitas 'Tela' y 'Kevlar' para fabricar el 'Chaleco Antibalas'", "error")
		end
	end
else
	exports.a_infobox:addBox(source, "Para fabricar el chaleco deben haber 2 policias en servicio", "error")
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

