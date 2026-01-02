function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) then
			n = n + 1
		end
	end
	return n
end




addEvent( "fabCargador", true ) 
addEventHandler( "fabCargador", root,
function (cargador, polvora, chatarra)
	
	if getPolicias() > 1 then
		if cargador then

			if tonumber(cargador) == 1 then
				local mat1, slot1, v1 = exports.items:has(source, 67)
				local mat2, slot2, v2 = exports.items:has(source, 66)


				if not mat1 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if not mat2 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

				if v1.value < tonumber(polvora) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if v2.value < tonumber(chatarra) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

					setElementFrozen(source, true)
					setPedAnimation(source, "GANGS", "prtial_hndshk_biz_01",-1, true)

					local mat1, slot1, v1 = exports.items:has(source, 67)
					exports.items:take(source, slot1)
					local mat2, slot2, v2 = exports.items:has(source, 66)
					exports.items:take(source, slot2)

					local material1 = v1.value - tonumber(polvora)
					local material2 = v2.value - tonumber(chatarra)
					if material1 ~= 0 then
						exports.items:give(source, 67, material1)
					end
					if material2 ~= 0 then
						exports.items:give(source, 66, material2)
					end

					triggerClientEvent(source, "progressBar", source, 20000, "Fabricando" )
					setTimer( function(source, cargador, polvora, chatarra)

						exports.infobox:addNotification(source, "Has fabricado un 'Cargador de Colt-45'", "success")
						exports.items:give(source, 43, 22)
						setElementFrozen( source, false )
						setPedAnimation( source, nil )

					end, 20000, 1, source, cargador, polvora, chatarra)

			elseif tonumber(cargador) == 2 then

				local mat1, slot1, v1 = exports.items:has(source, 67)
				local mat2, slot2, v2 = exports.items:has(source, 66)


				if not mat1 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if not mat2 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

				if v1.value < tonumber(polvora) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if v2.value < tonumber(chatarra) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

					setElementFrozen(source, true)
					setPedAnimation(source, "GANGS", "prtial_hndshk_biz_01",-1, true)

					local mat1, slot1, v1 = exports.items:has(source, 67)
					exports.items:take(source, slot1)
					local mat2, slot2, v2 = exports.items:has(source, 66)
					exports.items:take(source, slot2)

					local material1 = v1.value - tonumber(polvora)
					local material2 = v2.value - tonumber(chatarra)
					if material1 ~= 0 then
						exports.items:give(source, 67, material1)
					end
					if material2 ~= 0 then
						exports.items:give(source, 66, material2)
					end

					triggerClientEvent(source, "progressBar", source, 20000, "Fabricando" )
					setTimer( function(source, cargador, polvora, chatarra)

						exports.infobox:addNotification(source, "Has fabricado un 'Cargador de Tec-9'", "success")
						exports.items:give(source, 43, 32)
						setElementFrozen( source, false )
						setPedAnimation( source, nil )

					end, 20000, 1, source, cargador, polvora, chatarra)

			elseif tonumber(cargador) == 3 then
			
				local mat1, slot1, v1 = exports.items:has(source, 67)
				local mat2, slot2, v2 = exports.items:has(source, 66)


				if not mat1 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if not mat2 then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

				if v1.value < tonumber(polvora) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end
				if v2.value < tonumber(chatarra) then exports.infobox:addNotification(source, "No tienes suficientes materiales", "error") return end

					setElementFrozen(source, true)
					setPedAnimation(source, "GANGS", "prtial_hndshk_biz_01",-1, true)

					local mat1, slot1, v1 = exports.items:has(source, 67)
					exports.items:take(source, slot1)
					local mat2, slot2, v2 = exports.items:has(source, 66)
					exports.items:take(source, slot2)

					local material1 = v1.value - tonumber(polvora)
					local material2 = v2.value - tonumber(chatarra)
					if material1 ~= 0 then
						exports.items:give(source, 67, material1)
					end
					if material2 ~= 0 then
						exports.items:give(source, 66, material2)
					end

					triggerClientEvent(source, "progressBar", source, 20000, "Fabricando" )
					setTimer( function(source, cargador, polvora, chatarra)

						exports.infobox:addNotification(source, "Has fabricado un 'Cargador de AK-47'", "success")
						exports.items:give(source, 43, 30)
						setElementFrozen( source, false )
						setPedAnimation( source, nil )

					end, 20000, 1, source, cargador, polvora, chatarra)

			end

		end
	else
		exports.infobox:addNotification(source, "Para fabricar cargadores deben haber 2 policias en servicio", "error")
	end

end)
