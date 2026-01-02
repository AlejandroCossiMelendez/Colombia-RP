--[[
$$\   $$\  $$$$$$\  $$\   $$\ $$$$$$$\        $$\    $$\ $$$$$$$$\ $$\   $$\ $$$$$$\  $$$$$$\  $$\       $$$$$$$$\  $$$$$$\  
$$ |  $$ |$$  __$$\ $$$\  $$ |$$  __$$\       $$ |   $$ |$$  _____|$$ |  $$ |\_$$  _|$$  __$$\ $$ |      $$  _____|$$  __$$\ 
$$ |  $$ |$$ /  $$ |$$$$\ $$ |$$ |  $$ |      $$ |   $$ |$$ |      $$ |  $$ |  $$ |  $$ /  \__|$$ |      $$ |      $$ /  \__|
$$$$$$$$ |$$$$$$$$ |$$ $$\$$ |$$ |  $$ |      \$$\  $$  |$$$$$\    $$$$$$$$ |  $$ |  $$ |      $$ |      $$$$$\    \$$$$$$\  
$$  __$$ |$$  __$$ |$$ \$$$$ |$$ |  $$ |       \$$\$$  / $$  __|   $$  __$$ |  $$ |  $$ |      $$ |      $$  __|    \____$$\ 
$$ |  $$ |$$ |  $$ |$$ |\$$$ |$$ |  $$ |        \$$$  /  $$ |      $$ |  $$ |  $$ |  $$ |  $$\ $$ |      $$ |      $$\   $$ |
$$ |  $$ |$$ |  $$ |$$ | \$$ |$$$$$$$  |         \$  /   $$$$$$$$\ $$ |  $$ |$$$$$$\ \$$$$$$  |$$$$$$$$\ $$$$$$$$\ \$$$$$$  |
\__|  \__|\__|  \__|\__|  \__|\_______/           \_/    \________|\__|  \__|\______| \______/ \________|\________| \______/ 
]]

function loadHandling(v)

--QUATRO RODAS!!!
--==CARRO==-- 
if getElementModel(v) == 00 then --ID do Veiculo que deseja setar a hand
	setVehicleHandling(v, "mass", 1600) --Massa do veículo no caso 1600
	setVehicleHandling(v, "turnMass", 3000)
	setVehicleHandling(v, "dragCoeff", 1.8)
	setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
	setVehicleHandling(v, "percentSubmerged", 75)
	setVehicleHandling(v, "tractionMultiplier", 1.1)
	setVehicleHandling(v, "tractionLoss", 0.9)
	setVehicleHandling(v, "tractionBias", 0.497)
	setVehicleHandling(v, "numberOfGears", 5)
	setVehicleHandling(v, "maxVelocity", 170) --Velocidade Máxima
	setVehicleHandling(v, "engineAcceleration", 30) -- Aceleração do Veículo
	setVehicleHandling(v, "engineInertia", 15)
	setVehicleHandling(v, "driveType", "awd")
	setVehicleHandling(v, "engineType", "petrol")
	setVehicleHandling(v, "brakeDeceleration", 55) --Força do freio
	setVehicleHandling(v, "ABS", false) -- Freio ABS
	setVehicleHandling(v, "steeringLock", 35)
	setVehicleHandling(v, "suspensionForceLevel", 1.8)
	setVehicleHandling(v, "suspensionDamping", 0.5)
	setVehicleHandling(v, "suspensionHighSpeedDamping", 0.1)
	setVehicleHandling(v, "suspensionUpperLimit", 0.3) --Suspensão para cima
	setVehicleHandling(v, "suspensionLowerLimit", -0.10) -- Suspensão para baixo
	setVehicleHandling(v, "suspensionFrontRearBias", 0.55)
	setVehicleHandling(v, "suspensionAntiDiveMultiplier", 0.5)
	setVehicleHandling(v, "seatOffsetDistance", 0.2)
	setVehicleHandling(v, "collisionDamageMultiplier", 0.60) -- Multiplicador de dano EX: demonstra como seu carro ira fica após uma batida simples.
	setVehicleHandling(v, "monetary", 25000)
	setVehicleHandling(v, "modelFlags", 0x40000001)
	setVehicleHandling(v, "handlingFlags", 0x10308803)
	setVehicleHandling(v, "headLight", 0)
	setVehicleHandling(v, "tailLight", 1)
	setVehicleHandling(v, "animGroup", 0)
end

	--==MOTO==-- 	
if getElementModel(v) == 586 then --ID do Veiculo que deseja setar a hand
	setVehicleHandling(v, "mass", 5999) --Massa do veículo no caso 5999
	setVehicleHandling(v, "turnMass", 5999)
	setVehicleHandling(v, "maxVelocity", 200) --Velocidade Máxima
	setVehicleHandling(v, "engineAcceleration", 38) -- Aceleração do Veículo
	setVehicleHandling(v, "engineInertia", 5.0)
	setVehicleHandling(v, "engineType", "petrol")
	setVehicleHandling(v, "brakeDeceleration", 50) --Força do freio
	setVehicleHandling(v, "driveType", "fwd")
	setVehicleHandling(v, "steeringLock", 45.0)
	setVehicleHandling(v, "tractionMultiplier", 1.51)
	setVehicleHandling(v, "tractionLoss", 1.15)
	setVehicleHandling(v, "tractionBias", 0.5)
	setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
	setVehicleHandling(v, "dragCoeff",0.0)
 end
--!! NESTE CASO AO ENTRAR NO VEÍCULO DA ID DETERMINADO O VEHICLE MUDA DE COR !!--
 if getElementModel(v) == 504 or getElementModel(v) == 576 then
     setVehiclePaintjob (v, 2 )
	 setVehicleColor(v, 0, 213, 255)
 end 

end --Este END finaliza esta Function

--! PARTIÇÃO DAS FUNÇÕES EM SÍ !--
--⚠ RECOMENDO NÃO MEXER AQUI ⚠--
function loadHandlings()
	for k, v in ipairs(getElementsByType("vehicle")) do
		loadHandling(v)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadHandlings)

addEventHandler("onVehicleEnter", root, function(player)
    loadHandling(source)
end)

 function currentTime(sourcePlayer)
    local timehour, timeminute = getTime()
    outputChatBox( "The current game time (server) is "..timehour..":"..timeminute, sourcePlayer )
end
addCommandHandler("gettime", currentTime)