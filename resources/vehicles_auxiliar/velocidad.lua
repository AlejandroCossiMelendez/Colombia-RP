local mVelocidad =
{
	[ 445 ] = 25,
     [ 429 ] = 13.6,
	[ 506 ] = 17.39999961853,
	[ 565 ] = 12.2,
	[ 558 ] = 10.6,
	[ 439 ] = 15.199999809265,
	[ 550 ] = 10.4,
	[ 566 ] = 10,
	[ 560 ] = 15,
     [ 426 ] = 23.4,
	[ 451 ] = 15.8,
	[ 555 ] = 14.5, -- otro reducido de velocidad de 15 a 14.5
	[ 402 ] = 16.5,
	[ 603 ] = 14,
	[ 492 ] = 11.5,
	[ 587 ] = 12.4,
	[ 414 ] = 15,
	[ 510 ] = 30,
	[ 525 ] = 45,
	[ 527 ] = 17,
	[ 554 ] = 25,
	[ 459 ] = 25,
	[ 462 ] = 35,
	[ 505 ] = 20,
	[ 495 ] = 14.199999809265,
	[ 545 ] = 14,
	[ 400 ] = 10.5,
	[ 404 ] = 10.6,
	[ 441 ] = 450,
	[ 479 ] = 60.9,
	[ 475 ] = 10.9,
	[ 405 ] = 10.3,
	[ 458 ] = 8.7,
	[ 567 ] = 8.6000003814697,
	[ 559 ] = 17,
	[ 419 ] = 10,
	[ 466 ] = 15.800000190735,
	[ 536 ] = 10,
	[ 529 ] = 10,
	[ 546 ] = 14.1999998092651,
	[ 467 ] = 9.7,
	[ 533 ] = 12.2,
	[ 576 ] = 15.1,
	[ 517 ] = 10.2,
	[ 540 ] = 8.9,
	[ 412 ] = 9.6,
	[ 551 ] = 9.8000001907349,
	[ 421 ] = 9.6,
	[ 580 ] = 11.2,
	[ 561 ] = 11.8,
	[ 401 ] = 6.7,
	[ 507 ] = 9,
	[ 470 ] = 25,
	[ 562 ] = 12.3,
	[ 496 ] = 10.3,
	[ 474 ] = 7.7999998092651,
	[ 489 ] = 10.5,
	[ 500 ] = 11.10000038147,
	[ 422 ] = 50,
	[ 518 ] = 9.7,
	[ 543 ] = 9,
	[ 600 ] = 9.9,
	[ 413 ] = 9,
	[ 502 ] = 20,
	[ 483 ] = 8.4000000953674,
	[ 508 ] = 7.8999999046326,
	[ 482 ] = 10.2,
	[ 440 ] = 8.1999998092651,
	[ 424 ] = 30,
	[ 471 ] = 35,
	[ 468 ] = 33.1999,
	[ 581 ] = 30,
	[ 461 ] = 24,
	[ 522 ] = 50,
	[ 521 ] = 30,
	[ 579 ] = 17.5,
	[ 541 ] = 11.2, -- Posible averia, si antes tenia 11.5...
	[ 411 ] = 12.9,
}

function getVehicleHandlingProperty( vehiculo, property )
    if isElement ( vehiculo ) and getElementType ( vehiculo ) == "vehicle" and type ( property ) == "string" then
		model = getElementModel(vehiculo)
        local handlingTable = getOriginalHandling ( model )
        local value = handlingTable[property]
        if value then
            return value
        end
    end
    return false
end

--[[function getVehicleHandlingProperty2( vehiculo, property )
    if isElement ( vehiculo ) and getElementType ( vehiculo ) == "vehicle" and type ( property ) == "string" then
		model = getElementModel(vehiculo)
		if mVelocidad[model] and property == "engineAcceleration" then
			return mVelocidad[model]
		else
			local handlingTable = getOriginalHandling ( model )
			local value = handlingTable[property]
			if value then
				return value
			end
		end
    end
    return false
end]]

function solicitarMejora (veh, tipo, fase)
	if veh and tipo then
		if not fase then fase = 0 end
		local pmejora = fase*1.6
		if tipo == 1 then -- Mejora de motor
			-- Parche para vehículos que se vuelven locos si tienen nitro (#1013)
			nitroC = nil
			local nitro = getVehicleUpgradeOnSlot(veh, 8)
			if nitro then
				nitroC = nitro
				removeVehicleUpgrade(veh, nitro)
			end
			-- Fin Parche
			local model = getElementModel(veh)
			if mVelocidad[model] then
				local mejora = mVelocidad[model]
				setVehicleHandling(veh, "engineAcceleration", tonumber(mejora+pmejora))
			else
				if model == 596 then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 20)
					setVehicleHandling(veh, "maxVelocity", 220)
				elseif model == 597 then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 25)
					setVehicleHandling(veh, "maxVelocity", 210.4)
				elseif model == 602 then
					setVehicleHandling(veh, "maxVelocity", 280)
				elseif model == 509 or model == 481 then
					setVehicleHandling(veh, "maxVelocity", 40)
				elseif model == 510 then
					setVehicleHandling(veh, "maxVelocity", 100)
				elseif model == 523 then
					setVehicleHandling(veh, "engineAcceleration", 50)
                                elseif model == 490 then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 25)
					setVehicleHandling(veh, "maxVelocity", 250)

                                elseif model == 462  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 45)
					setVehicleHandling(veh, "maxVelocity", 210)

                                elseif model == 401  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 14)
					setVehicleHandling(veh, "maxVelocity", 180)
                                elseif model == 604  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 14)
					setVehicleHandling(veh, "maxVelocity", 180)
                                elseif model == 439  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 120)
					setVehicleHandling(veh, "maxVelocity", 250)
				elseif model == 401 then
                                        setVehicleHandling(veh, "engineAcceleration", 200)
				elseif model == 401 then
                                        setVehicleHandling(veh, "engineAcceleration", 200)										
                                elseif model == 550  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 150)
					setVehicleHandling(veh, "maxVelocity", 200)
                                elseif model == 542  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 150)
					setVehicleHandling(veh, "maxVelocity", 200)
				elseif model == 401 then
                                        setVehicleHandling(veh, "engineAcceleration", 150)
           elseif model == 598  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 20)
					setVehicleHandling(veh, "maxVelocity", 250)
				elseif model == 598 then
                                        setVehicleHandling(veh, "engineAcceleration", 250)
           elseif model == 599  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 30)
					setVehicleHandling(veh, "maxVelocity", 250)
				elseif model == 599 then
                                        setVehicleHandling(veh, "engineAcceleration", 250)
           elseif model == 418  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 20)
					setVehicleHandling(veh, "maxVelocity", 200)
           elseif model == 445  then
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "engineAcceleration", 25)
					setVehicleHandling(veh, "maxVelocity", 220)
				elseif model == 445 then
                                        setVehicleHandling(veh, "engineAcceleration", 220)






				else
					local mejora = getVehicleHandlingProperty(veh, "engineAcceleration")
					setVehicleHandling(veh, "engineAcceleration", tonumber(mejora+pmejora))
				end
			end
			-- Parche para vehículos que se vuelven locos si tienen nitro (#1013)
			if nitroC then
				addVehicleUpgrade(veh, nitroC)
			end
			-- Fin Parche
			return true
		elseif tipo == 2 then -- Mejora de frenos
			local mejora = getVehicleHandlingProperty(veh, "brakeDeceleration")
			setVehicleHandling(veh, "brakeDeceleration", tonumber(mejora+pmejora))
			return true
		end
	else 
		return false
	end
end

function resolicitarMejora (vehicle)
	solicitarMejora(vehicle, 1, getElementData(vehicle, "fasemotor"))
	solicitarMejora(vehicle, 2, getElementData(vehicle, "fasefrenos"))
end

function resolicitarMejoraUser (player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("Debes de estar en un vehículo.", player, 255, 0, 0) return end
	solicitarMejora(vehicle, 1, getElementData(vehicle, "fasemotor"))
	solicitarMejora(vehicle, 2, getElementData(vehicle, "fasefrenos"))
	outputChatBox("Su vehiculo ha sido refaseado.", player, 0, 255, 0)
end
--addCommandHandler("refaseo", resolicitarMejoraUser)

function aplicarVelocidades ()
	for k, v in ipairs(getElementsByType("vehicle")) do
		resolicitarMejora(v, true)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), aplicarVelocidades)


function limitadorDeVelocidad (player, cmd, kms)
	if not getPedOccupiedVehicle(player) then return end
	if not getVehicleController(getPedOccupiedVehicle(player)) then return end
	local vehicle = getPedOccupiedVehicle(player)
	local conductor = getVehicleController(vehicle)
	if not kms or not tonumber(kms) then outputChatBox("Sintaxis: /limitador [velocidad máxima, mínimo 40]", player, 255, 255, 255) return end
	if vehicle and conductor and player == conductor then
		if getVehicleType(vehicle) == "BMX" then outputChatBox("No puedes usar /limitador en una bicicleta.", player, 255, 0, 0) return end
		-- Parche para vehículos que se vuelven locos si tienen nitro (#1013)
		nitroC = nil
		local nitro = getVehicleUpgradeOnSlot(vehicle, 8)
		if nitro then
			nitroC = nitro
			removeVehicleUpgrade(vehicle, nitro)
		end
		-- Fin Parche
		if tonumber(kms) < 40 and tonumber(kms) ~= 0 then outputChatBox("El mínimo permitido es de 40 KM/H.", player, 255, 0, 0) return end
		if tonumber(kms) > 125 then outputChatBox("El límite máximo para el limitador es de 125.", player, 255, 0, 0) return end
		if tonumber(kms) == 0 then 
			setVehicleHandling(vehicle, "maxVelocity", getVehicleHandlingProperty(vehicle, "maxVelocity")) 
			outputChatBox("Has desactivado el limitador.", player, 255, 255, 255) 
			return
		end
		local m = ((tonumber(kms+9))*199)/227
		if getVehicleHandlingProperty(vehicle, "maxVelocity") >= m and kms and tonumber(kms) >= 0 then
			setVehicleHandling(vehicle, "maxVelocity", m)
			outputChatBox("Su velocidad ha sido #FF0000limitada #FFFFFF a #00FF00 "..tostring(kms)..".", player, 255, 255, 255, true)
		else
			outputChatBox("¡Tu vehículo no tiene tanta velocidad máxima!", player, 255, 0, 0)
		end
		-- Parche para vehículos que se vuelven locos si tienen nitro (#1013)
		if nitroC then
			addVehicleUpgrade(vehicle, nitroC)
		end
		-- Fin Parche
	end
end
addCommandHandler("limitador", limitadorDeVelocidad)