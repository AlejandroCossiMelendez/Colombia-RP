
barreraP1PCMG = createObject ( 968, 292.20001220703, -388.60000610352, 8.6000003814697, 180, 90, 76 )
markerP1PCMGO = createMarker (287.70001220703, -382.5, 8.8000001907349, "cylinder", 4.5, 255, 0, 0, 0 )
markerP1PCMGC = createMarker (301.20001220703, -385.20001220703, 8.8999996185303, "cylinder", 4.5, 255, 0, 0, 0 )
esBarP1PCMG = 0

function openbarreraP1PCMG(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		--player = element
		return
	end
	if getElementData(player, "peajePagado1") then
		setTimer(closebarreraP1PCMG, 5000, 1, player)
	else
		if exports.players:takeMoney(player, 35) then
			setElementData(player, "peajePagado1", true)
			if esBarP1PCMG == 0 then
				local rx, ry, rz = getElementRotation(barreraP1PCMG)
				setElementRotation(barreraP1PCMG, rx, 90, rz)
				exports.chat:me( player, "paga el peaje y le abren la barrera." )
				moveObject ( barreraP1PCMG, 1200, 292.20001220703, -388.60000610352, 8.6000003814697, 0, 90, 0)
				esBarP1PCMG = 4
				setTimer( function ()
				esBarP1PCMG = 1 end, 1200, 1 )
			elseif esBarP1PCMG == 2 then
				-- Estará cerrando, por lo que la rotación estará yendo a 90.
				local rx, ry, rz = getElementRotation(barreraP1PCMG)
				local diff = -ry
				exports.chat:me( player, "paga el peaje y le abren la barrera." )
				moveObject ( barreraP1PCMG, 1200, 292.20001220703, -388.60000610352, 8.6000003814697, 0, diff, 0)
				esBarP1PCMG = 3
				setTimer( function ()
				esBarP1PCMG = 1 end, 1200, 1 )
			end
		else
			outputChatBox("¡No tienes los 100 dólares que cuesta el peaje!", player, 255, 0, 0)
		end
	end
end
addEventHandler("onMarkerHit", markerP1PCMGO, openbarreraP1PCMG)
addEventHandler("onMarkerLeave", markerP1PCMGO, openbarreraP1PCMG)

function closebarreraP1PCMG(player)
	--if not getElementData(player, "peajePagado1") then return end
	if esBarP1PCMG == 1 or esBarP1PCMG == 4 then
		local hayAlguien = false
		for k, v in ipairs(getElementsByType("player")) do
			if isElementWithinMarker(v, markerP1PCMGC) then
				hayAlguien = true
			end
		end
		if hayAlguien == false then
			if esBarP1PCMG == 1 then
				moveObject ( barreraP1PCMG, 1200, 292.20001220703, -388.60000610352, 8.6000003814697, 0, -90, 0)
				esBarP1PCMG = 2
				setTimer( function ()
				esBarP1PCMG = 0 end, 1200, 1, player )
			elseif esBarP1PCMG == 4 then
				-- Está abriendo y solicitamos cierre antes de que llegue arriba.
				local rx, ry, rz = getElementRotation(barreraP1PCMG)
				local diff = 90-ry
				moveObject ( barreraP1PCMG, 1200, 292.20001220703, -388.60000610352, 8.6000003814697, 0, diff, 0)
				esBarP1PCMG = 2
				setTimer( function ()
				esBarP1PCMG = 0 end, 1200, 1, player )
			end
		else
			setTimer(closebarreraP1PCMG, 500, 1, player)
		end
		removeElementData(player, "peajePagado1")
	end
end

barreraP2PCMG = createObject ( 968, 253.89999389648, -364.70001220703, 8.8000001907349, 0, 270, 76.75 )
markerP2PCMGO = createMarker ( 257.79998779297, -370.39999389648, 8.8000001907349, "cylinder", 4.5, 255, 0, 0, 0 )
markerP2PCMGC = createMarker ( 249, -368, 8.8000001907349, "cylinder", 4.5, 255, 0, 0, 0 )
esBarP2PCMG = 0

function openbarreraP2PCMG(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		--player = element
		return
	end
	if getElementData(player, "peajePagado2") then
		setTimer(closebarreraP2PCMG, 5000, 1, player)
	else
		if exports.players:takeMoney(player, 20) then
			setElementData(player, "peajePagado2", true)
			if esBarP2PCMG == 0 then
				local rx, ry, rz = getElementRotation(barreraP2PCMG)
				setElementRotation(barreraP2PCMG, rx, 270, rz)
				exports.chat:me( player, "paga el peaje y le abren la barrera." )
				moveObject ( barreraP2PCMG, 1200, 253.89999389648, -364.70001220703, 8.8000001907349, 0, 90, 0)
				esBarP2PCMG = 4
				setTimer( function ()
				esBarP2PCMG = 1 end, 1200, 1 )
			elseif esBarP2PCMG == 2 then
				-- Estará cerrando, por lo que la rotación estará yendo a 270.
				local rx, ry, rz = getElementRotation(barreraP2PCMG)
				local diff = 360-ry
				exports.chat:me( player, "paga el peaje y le abren la barrera." )
				moveObject ( barreraP2PCMG, 1200, 2253.89999389648, -364.70001220703, 8.8000001907349, 0, diff, 0)
				esBarP2PCMG = 3
				setTimer( function ()
				esBarP2PCMG = 1 end, 1200, 1 )
			end
		else
			outputChatBox("¡No tienes los 100 dólares que cuesta el peaje!", player, 255, 0, 0)
		end
	end
end
addEventHandler("onMarkerHit", markerP2PCMGO, openbarreraP2PCMG)
addEventHandler("onMarkerLeave", markerP2PCMGO, openbarreraP2PCMG)

function closebarreraP2PCMG(player)
	--if not getElementData(player, "peajePagado2") then return end
	if esBarP2PCMG == 1 or esBarP2PCMG == 4 then
		local hayAlguien = false
		for k, v in ipairs(getElementsByType("player")) do
			if isElementWithinMarker(v, markerP2PCMGC) then
				hayAlguien = true
			end
		end
		if hayAlguien == false then
			if esBarP2PCMG == 1 then
				moveObject ( barreraP2PCMG, 1200, 253.89999389648, -364.70001220703, 8.8000001907349, 0, -90, 0)
				esBarP2PCMG = 2
				setTimer( function ()
				esBarP2PCMG = 0 end, 1200, 1, player )
			elseif esBarP2PCMG == 4 then
				-- Está abriendo y solicitamos cierre antes de que llegue arriba.
				local rx, ry, rz = getElementRotation(barreraP2PCMG)
				local diff = -(ry-270)
				moveObject ( barreraP2PCMG, 1200, 253.89999389648, -364.70001220703, 8.8000001907349, 0, diff, 0)
				esBarP2PCMG = 2
				setTimer( function ()
				esBarP2PCMG = 0 end, 1200, 1, player )
			end
		else
			setTimer(closebarreraP2PCMG, 500, 1, player)
		end
		removeElementData(player, "peajePagado2")
	end
end