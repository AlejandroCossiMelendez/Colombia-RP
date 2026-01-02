marker = createMarker(2410.0146484375, 99.486328124, 27.96773147583-2.5,"cylinder", 2, 0, 0, 0, 0 )
marker2 = createMarker(2422.27734375, 83.775390625, 26.469835281372-1,"cylinder", 2, 0, 0, 0, 0 )
marker3 = createMarker(2419.609375, 83.5859375, 26.471096038818-1,"cylinder", 2, 0, 0, 0, 0 )
marker4 = createMarker(2419.69140625, 97.9677734375, 26.4765625-1,"cylinder", 2.5, 0, 0, 0, 0 )
marker5 = createMarker(2407.015625, 83.916801452637, 26.473546981812-1,"cylinder", 2.5, 0, 0, 0, 0 )



addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
createObject(941, 2422.0205078125, 82.1171875, 26.469976425171-0.5)
createObject(941, 2419.3740234375, 82.853515625-0.7, 26.470592498779-0.5)
createObject(18609, 2421.15625, 94.697265625, 26.4765625)
createObject(18609, 2421.845703125, 95.142578125, 26.4765625)
end)


local silla = {}
local caja = {}

addCommandHandler("trabajar", function(player)
    local cuenta = getPlayerAccount(player)
    if isElementWithinMarker(player, marker) then
        if cuenta then
            getC = getAccountData(cuenta, "Ocupacion")
            if getC == "Carpintero" then 
                outputChatBox('Ya tienes este trabajo', player, 255, 0, 0, true)
            else
                setAccountData(cuenta, "Ocupacion", "Carpintero")
	            exports.infobox:addNotification(player, "Bienvenido, Trabaja como carpintero", "success")
            end
        end
    else
        outputChatBox('', player, 255, 0, 0, true)
    end

end)

addCommandHandler("renunciar", function(player)
    local cuenta = getPlayerAccount(player)
        if isElementWithinMarker(player, marker) then
            getCa = getAccountData(cuenta, "Ocupacion")
                if getCa == "Carpintero" then 
                    outputChatBox('Acabas de renunciar a carpintero', player, 0, 255, 0, true)
                    setAccountData(cuenta, "Ocupacion", "Civil")
                else
                    outputChatBox('No tienes este trabajo', player, 255, 0, 0, true)
                end
        else
            outputChatBox('Tienes que estar en el icono', player, 255, 0, 0, true)
        end

end)

function recoger(player)
    local px, py, pz = getElementPosition(player)
    local cuenta = getPlayerAccount(player)
	if isElementWithinMarker(player, marker4) then
		getCa = getAccountData(cuenta, "Ocupacion")
		getEle = getElementData(player, "conMadera", true)
			if getCa == "Carpintero" then
					unbindKey(player, "mouse2", "down", recoger)
					outputChatBox('Recogiste materiales, ponte a trabajar', player, 0, 255, 0, true)
					setPedAnimation(player,"CARRY","crry_prtial",0,true,false,true,true)
					setElementData(player, "conMadera", true)
					caja[player] = createObject( 2969, px, py, pz)
					setElementCollisionsEnabled( caja[player], false)
					attachElements(caja[player], player, 0,0.5,0.35,0,0,0)
	                exports.infobox:addNotification(player, "Ve a las mesas de trabajo", "info")
                    toggleControl(player, "sprint", false)
                    toggleControl ( player, "jump", false ) 
			else
				outputChatBox('No tienes este trabajo', player, 255, 0, 0, true)
			end

	else
		outputChatBox('', player, 255, 0, 0, true)
	end
end

addEventHandler("onPlayerMarkerHit", getRootElement(), function(markerHit, matchingDimension)
	if matchingDimension then
		if markerHit == marker4 then
			bindKey(source, "mouse2", "down", recoger)
		end
	end
end)

function someoneLeftMarker(markerLeft, matchingDimension)
	if matchingDimension then
		if markerHit == marker4 then		
			unbindKey(source, "mouse2", "down", recoger)
		end
	end
end
addEventHandler("onPlayerMarkerLeave", getRootElement(), someoneLeftMarker)


function procesar(player)
    local px, py, pz = getElementPosition(player)
    local cuenta = getPlayerAccount(player)
    if isElementWithinMarker(player, marker2) then
        getCa = getAccountData(cuenta, "Ocupacion")
        getEle = getElementData(player, "conMadera", true)
        if getCa == "Carpintero" then 
            if getEle == true then 
				unbindKey(player, "mouse2", "down", procesar)
	            exports.infobox:addNotification(player, "Trabajando Madera", "success")
                setElementData(player, "conMadera", false)
                setPedAnimation(player)
				destroyElement(caja[player] )
				setElementFrozen(player, true)
                setPedAnimation( player, "BASEBALL", "Bat_M", -1, true, false, false, false )
                triggerClientEvent(player, "sonido", player)
                getElem = getElementData(player, "silla", true)
                setTimer(function()
					setElementFrozen(player, false)
                    setPedAnimation(player)
                    setPedAnimation(player,"CARRY","crry_prtial",0,true,false,true,true)
                    silla[player] = createObject( 2120, px, py, pz)
                    setElementCollisionsEnabled( silla[player], false)
                    attachElements(silla[player], player, 0,0.5,0.35,0,0,0)
                    setElementData(player, "silla", true)

                end, 10000, 1)
            else
                outputChatBox('No tienes materiales', player, 255, 0, 0, true)
            end
        else
            outputChatBox('No trabajas aqui', player, 255, 0, 0, true)
        end
    elseif isElementWithinMarker(player, marker3) then
        getCa = getAccountData(cuenta, "Ocupacion")
        getEle = getElementData(player, "conMadera", true)
        if getCa == "Carpintero" then 
            if getEle == true then 
				unbindKey(player, "mouse2", "down", procesar)
	            exports.infobox:addNotification(player, "Trabajando Madera", "success")
                setElementData(player, "conMadera", false)
                setPedAnimation(player)
				destroyElement(caja[player] )
				setElementFrozen(player, true)
                setPedAnimation( player, "BASEBALL", "Bat_M", -1, true, false, false, false )
                triggerClientEvent(player, "sonido2", player)
                setTimer(function()
					setElementFrozen(player, false)
                    setPedAnimation(player)
                    setPedAnimation(player,"CARRY","crry_prtial",0,true,false,true,true)
                    silla[player] = createObject( 2120, px, py, pz)
                    setElementCollisionsEnabled( silla[player], false)
                    attachElements(silla[player], player, 0,0.4,0.43,0,0,0)
                    setElementData(player, "silla", true)
                end, 10000, 1)
            else
                outputChatBox('No tienes materiales', player, 255, 0, 0, true)
            end
        else
            outputChatBox('No trabajas aqui', player, 255, 0, 0, true)
        end

    end

end

addEventHandler("onPlayerMarkerHit", getRootElement(), function(markerHit, matchingDimension)
	if matchingDimension then
		if markerHit == marker2 or markerHit == marker3 then
			bindKey(source, "mouse2", "down", procesar)
		end
	end
end)

function someoneLeftMarker(markerLeft, matchingDimension)
	if markerHit == marker2 or markerHit == marker3 then
		unbindKey(source, "mouse2", "down", procesar)
	end
end
addEventHandler("onPlayerMarkerLeave", getRootElement(), someoneLeftMarker)

addCommandHandler("vendersilla", function(player)
    local px, py, pz = getElementPosition(player)
    local cuenta = getPlayerAccount(player)
    if isElementWithinMarker(player, marker5) then
        getCa = getAccountData(cuenta, "Ocupacion")
        getElem = getElementData(player, "silla", true)
		if getCa == "Carpintero" then 
			if getElem == true then 
	        exports.infobox:addNotification(player, "Vendiste la silla, ve por más", "success")
			destroyElement(silla[player])
			setPedAnimation(player)
			setElementData(player, "silla", false)
			money = math.random(85000, 110000)
            exports.players:giveMoney( player, money )
            outputChatBox('Vendiste la silla en '..money.. '$ Pesos.' , player, 0, 255, 0, true)
            toggleControl(player, "sprint", true)
            toggleControl ( player, "jump", true ) 
			else
				setElementData(player, "silla", false)
	            exports.infobox:addNotification(player, "No tienes sillas para vender", "error")
			end
		else
			outputChatBox('No trabajas aqui', player, 255, 0, 0, true)
		end
    end

end)

addEventHandler("onPlayerQuit", root, function()
    if isElement(silla[player]) then 
    destroyElement(silla[player])
    end
        if isElement(caja[player]) then 
            destroyElement(caja[player])
        end
end)