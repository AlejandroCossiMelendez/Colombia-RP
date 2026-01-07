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
if getElementModel(v) == 503 then
	setVehicleHandling(v, "mass", 5000) -- Más peso para mayor estabilidad
	setVehicleHandling(v, "turnMass", 4000) -- Ajuste de giro más realista
	setVehicleHandling(v, "dragCoeff", 1.5) -- Menos resistencia al aire
	setVehicleHandling(v, "centerOfMass", { 0, 0, -0.4 }) -- Centro de gravedad más bajo
	setVehicleHandling(v, "percentSubmerged", 80)

	-- 🔥 TRACCIÓN MEJORADA PARA EVITAR DERRAPE 🔥
	setVehicleHandling(v, "tractionMultiplier", 1.7) -- MÁS AGARRE
	setVehicleHandling(v, "tractionLoss", 0.6) -- EVITA PÉRDIDA DE TRACCIÓN
	setVehicleHandling(v, "tractionBias", 0.52) -- DISTRIBUCIÓN DEL AGARRE

	-- ⚡ VELOCIDAD Y ACELERACIÓN ⚡
	setVehicleHandling(v, "numberOfGears", 5)
	setVehicleHandling(v, "maxVelocity", 210) -- Baja un poco para más control
	setVehicleHandling(v, "engineAcceleration", 40) -- Menos agresivo para evitar derrapes
	setVehicleHandling(v, "engineInertia", 15)

	-- 🚗 TRANSMISIÓN Y MOTOR 🚗
	setVehicleHandling(v, "driveType", "awd") -- TRACCIÓN EN LAS 4 RUEDAS
	setVehicleHandling(v, "engineType", "petrol")

	-- 🚦 FRENADO MÁS ESTABLE 🚦
	setVehicleHandling(v, "brakeDeceleration", 110) -- EVITA BLOQUEO DE RUEDAS
	setVehicleHandling(v, "ABS", true)

	-- 🔄 GIRO MÁS CONTROLADO 🔄
	setVehicleHandling(v, "steeringLock", 24) -- Reduce la agresividad al girar

	-- 🛠️ SUSPENSIÓN MEJORADA 🛠️
	setVehicleHandling(v, "suspensionForceLevel", 3.5) -- Más firmeza
	setVehicleHandling(v, "suspensionDamping", 1.2) -- Menos rebotes
	setVehicleHandling(v, "suspensionHighSpeedDamping", 0.5) -- Mejor control en alta velocidad
	setVehicleHandling(v, "suspensionUpperLimit", 0.12) -- Reduce altura para estabilidad
	setVehicleHandling(v, "suspensionLowerLimit", -0.12)
	setVehicleHandling(v, "suspensionFrontRearBias", 0.50) -- Equilibrio entre ejes
	setVehicleHandling(v, "suspensionAntiDiveMultiplier", 0.7) -- Reduce inclinación al frenar

	-- 🔧 OTROS AJUSTES 🔧
	setVehicleHandling(v, "seatOffsetDistance", 0.2)
	setVehicleHandling(v, "collisionDamageMultiplier", 0.50) -- Reduce daño por choques
	setVehicleHandling(v, "monetary", 25000)
	setVehicleHandling(v, "modelFlags", 0x40000001)
	setVehicleHandling(v, "handlingFlags", 0x10308803)
	setVehicleHandling(v, "headLight", 0)
	setVehicleHandling(v, "tailLight", 1)
	setVehicleHandling(v, "animGroup", 0)
end



	--==MOTO==-- 	
if getElementModel(v) == 00 then --ID do Veiculo que deseja setar a hand
	setVehicleHandling(v, "mass", 5999) --Massa do veículo no caso 5999
	setVehicleHandling(v, "turnMass", 5999)
	setVehicleHandling(v, "maxVelocity", 210) --Velocidade Máxima
	setVehicleHandling(v, "engineAcceleration", 30) -- Aceleração do Veículo
	setVehicleHandling(v, "engineInertia", 5.0)
	setVehicleHandling(v, "engineType", "petrol")
	setVehicleHandling(v, "brakeDeceleration", 30) --Força do freio
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