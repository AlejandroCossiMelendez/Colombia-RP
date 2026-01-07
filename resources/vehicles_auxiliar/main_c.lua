------------------------------------
-- QUANTUMZ - QUANTUMZ - QUANTUMZ --
------------------------------------
--         2011 - Romania	  	  -- 	    
------------------------------------
-- You can modify this file but   --
-- don't change the credits.      --
------------------------------------
------------------------------------
--  VEHICLECONTROL v1.0 for MTA   --
------------------------------------

local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local zoom = math.min(1, 1920/sx)  -- Ajustamos el zoom para que sea más suave

-- Cache de fuentes para mejor rendimiento
local fonts = {
    default = dxCreateFont("fonts/LilitaOne-Regular.ttf", 13/zoom, false, "proof")
}

-- Variables para el estado de los elementos del vehículo
local estadoMotor = false
local estadoLuces = false
local estadoFrenoMano = false
local isInterfaceVisible = false

-- Variables para el estado de las puertas
local doorStates = {
    leftFrontDoor = false,  -- Puerta delantera izquierda
    rightFrontDoor = false, -- Puerta delantera derecha
    leftRearDoor = false,   -- Puerta trasera izquierda
    rightRearDoor = false,  -- Puerta trasera derecha
    hood = false,           -- Capó
    trunk = false          -- Maletero
}

-- Cache de texturas para mejor rendimiento
local textures = {}
local function loadTextures()
    textures = {
        bg = dxCreateTexture("interface/bg.png", "dxt5", true, "clamp"),
        logo = dxCreateTexture("interface/logo.png", "dxt5", true, "clamp"),
        vehicleimage = dxCreateTexture("interface/vehicleimage.png", "dxt5", true, "clamp"),
        -- ... resto de texturas
    }
end

function renderUI()
    if not isInterfaceVisible then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then return end
    
    -- Ajustamos la posición del bg para que esté centrado
    dxDrawImage(sx/2 - 410/zoom, sy/2 - 250/zoom, 820/zoom, 500/zoom, textures.bg)
    
    -- Dibujamos el logo del servidor centrado y más grande
    dxDrawImage(sx/2 - 200/zoom, sy/2 - 200/zoom, 400/zoom, 400/zoom, textures.logo, 0, 0, 0, tocolor(255, 255, 255, 255))
    
    -- Ajustamos la posición del vehículo más arriba y un poco a la derecha
    dxDrawImage(sx/2 + 85/zoom, sy/2 - 200/zoom, 190/zoom, 397/zoom, textures.vehicleimage)
    
    -- Elementos de la izquierda (información)
    dxDrawImage(sx/2 - 382/zoom, sy/2 - 199/zoom, 300/zoom, 60/zoom, textures.recuadromodeloveh)
    dxDrawImage(sx/2 - 382/zoom, sy/2 - 99/zoom, 300/zoom, 60/zoom, textures.recuadrovidavehiculo)
    dxDrawImage(sx/2 - 382/zoom, sy/2 + 1/zoom, 300/zoom, 60/zoom, textures.recuadrogasolina)
    
    -- Información del vehículo en los recuadros
    -- Modelo del vehículo
    dxDrawText(getVehicleName(vehicle), sx/2 - 382/zoom, sy/2 - 199/zoom, sx/2 - 82/zoom, sy/2 - 139/zoom, tocolor(255, 255, 255, 255), 1, fonts.default, "center", "center")
    
    -- Vida del vehículo
    local health = math.floor(getElementHealth(vehicle))
    local healthText = "Estado: " .. math.floor((health/1000)*100) .. "%"
    dxDrawText(healthText, sx/2 - 382/zoom, sy/2 - 99/zoom, sx/2 - 82/zoom, sy/2 - 39/zoom, tocolor(255, 255, 255, 255), 1, fonts.default, "center", "center")
    
    -- Gasolina
    local fuel = getElementData(vehicle, "fuel") or 0
    local fuelText = "Gasolina: " .. math.floor(fuel) .. "%"
    dxDrawText(fuelText, sx/2 - 382/zoom, sy/2 + 1/zoom, sx/2 - 82/zoom, sy/2 + 61/zoom, tocolor(255, 255, 255, 255), 1, fonts.default, "center", "center")
    
    -- Botones de control abajo a la izquierda con estados
    -- Motor
    local engineState = getVehicleEngineState(vehicle)
    dxDrawImage(sx/2 - 382/zoom, sy/2 + 126/zoom, 100/zoom, 100/zoom, textures.botoniconmotor, 0, 0, 0, engineState and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 100))
    
    -- Luces
    local lightState = getVehicleOverrideLights(vehicle) == 2
    dxDrawImage(sx/2 - 258/zoom, sy/2 + 126/zoom, 100/zoom, 100/zoom, textures.botoniconluces, 0, 0, 0, lightState and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 100))
    
    -- Freno de mano
    local handbrakeState = isElementFrozen(vehicle)
    dxDrawImage(sx/2 - 134/zoom, sy/2 + 126/zoom, 100/zoom, 100/zoom, textures.botoniconfrenomano, 0, 0, 0, handbrakeState and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 100))
    
    -- Iconos de estado
    dxDrawImage(sx/2 - 377/zoom, sy/2 + 131/zoom, 90/zoom, 90/zoom, textures.iconmotor)
    dxDrawImage(sx/2 - 253/zoom, sy/2 + 131/zoom, 90/zoom, 90/zoom, textures.iconluces)
    dxDrawImage(sx/2 - 127/zoom, sy/2 + 131/zoom, 90/zoom, 90/zoom, textures.iconfrenomano)
    
    -- Botones de puertas y capó
    dxDrawImage(sx/2 + 14/zoom, sy/2 + 40/zoom, 90/zoom, 40/zoom, textures.botonpuertaizquierdatrasera)
    dxDrawImage(sx/2 + 13/zoom, sy/2 - 54/zoom, 90/zoom, 40/zoom, textures.botonpuertaizquierdaprincipal)
    dxDrawImage(sx/2 + 252/zoom, sy/2 - 54/zoom, 90/zoom, 40/zoom, textures.botonpuertaderechaprincipal)
    dxDrawImage(sx/2 + 254/zoom, sy/2 + 40/zoom, 90/zoom, 40/zoom, textures.botonpuertaderechatrasera)
    dxDrawImage(sx/2 + 135/zoom, sy/2 - 219/zoom, 90/zoom, 40/zoom, textures.botoncapo)
    dxDrawImage(sx/2 + 139/zoom, sy/2 + 170/zoom, 90/zoom, 40/zoom, textures.botonmaletero)
    
    -- Textos con la fuente precargada
    dxDrawText('PUERTA', sx/2 + 59/zoom, sy/2 + 44/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
    dxDrawText('PUERTA', sx/2 + 59/zoom, sy/2 - 50/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
    dxDrawText('CAPO', sx/2 + 180/zoom, sy/2 - 215/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
    dxDrawText('MALETERO', sx/2 + 184/zoom, sy/2 + 174/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
    dxDrawText('PUERTA', sx/2 + 298/zoom, sy/2 - 50/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
    dxDrawText('PUERTA', sx/2 + 298/zoom, sy/2 + 44/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.default, 'center', 'top')
end

-- Función para manejar clicks
function handleClicks(button, state, absoluteX, absoluteY)
    if not isInterfaceVisible or button ~= "left" or state ~= "down" then return end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then return end
    
    local relativeX = absoluteX - sx/2
    local relativeY = absoluteY - sy/2
    
    -- Convertir coordenadas absolutas a relativas con zoom
    local x, y = relativeX * zoom, relativeY * zoom
    
    -- Verificar clicks en cada botón
    if isPointInBox(x, y, -382, 126, 100, 100) then -- Motor
        triggerServerEvent("vehicles:toggleEngine", localPlayer)
    elseif isPointInBox(x, y, -258, 126, 100, 100) then -- Luces
        triggerServerEvent("vehicles:toggleLights", localPlayer)
    elseif isPointInBox(x, y, -134, 126, 100, 100) then -- Freno de mano
        if isVehicleOnGround(vehicle) then
            local speed = getElementSpeed(vehicle, "km/h")
            if speed < 5 then
                triggerServerEvent("vehicles:toggleHandbrake", localPlayer)
            end
        end
    elseif isPointInBox(x, y, 14, 40, 90, 40) then -- Puerta izquierda trasera
        doorStates.leftRearDoor = not doorStates.leftRearDoor
        triggerServerEvent("moveThisShit", localPlayer, 4, doorStates.leftRearDoor and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "trasera izquierda", doorStates.leftRearDoor)
    elseif isPointInBox(x, y, 13, -54, 90, 40) then -- Puerta izquierda principal
        doorStates.leftFrontDoor = not doorStates.leftFrontDoor
        triggerServerEvent("moveThisShit", localPlayer, 2, doorStates.leftFrontDoor and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "delantera izquierda", doorStates.leftFrontDoor)
    elseif isPointInBox(x, y, 252, -54, 90, 40) then -- Puerta derecha principal
        doorStates.rightFrontDoor = not doorStates.rightFrontDoor
        triggerServerEvent("moveThisShit", localPlayer, 3, doorStates.rightFrontDoor and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "delantera derecha", doorStates.rightFrontDoor)
    elseif isPointInBox(x, y, 254, 40, 90, 40) then -- Puerta derecha trasera
        doorStates.rightRearDoor = not doorStates.rightRearDoor
        triggerServerEvent("moveThisShit", localPlayer, 5, doorStates.rightRearDoor and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "trasera derecha", doorStates.rightRearDoor)
    elseif isPointInBox(x, y, 135, -219, 90, 40) then -- Capó
        doorStates.hood = not doorStates.hood
        triggerServerEvent("moveThisShit", localPlayer, 0, doorStates.hood and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "capó", doorStates.hood)
    elseif isPointInBox(x, y, 139, 170, 90, 40) then -- Maletero
        doorStates.trunk = not doorStates.trunk
        triggerServerEvent("moveThisShit", localPlayer, 1, doorStates.trunk and 100 or 0)
        triggerServerEvent("vehicles:doorAction", localPlayer, "maletero", doorStates.trunk)
	end
end

function isPointInBox(x, y, boxX, boxY, width, height)
    return x >= boxX and x <= boxX + width and y >= boxY and y <= boxY + height
end

function toggleInterface()
    if not isPedInVehicle(localPlayer) then
        outputChatBox("Debes estar en un vehículo para usar este comando.", 255, 0, 0)
        return
    end
    
    isInterfaceVisible = not isInterfaceVisible
    showCursor(isInterfaceVisible)
    
    if isInterfaceVisible then
        -- Cargamos las texturas y la fuente cuando se abre la interfaz
        if not fonts.default then
            fonts.default = dxCreateFont("fonts/LilitaOne-Regular.ttf", 13/zoom, false, "proof")
        end
        
        -- Cargamos todas las texturas necesarias
        textures = {
            bg = dxCreateTexture("interface/bg.png", "dxt5", true, "clamp"),
            logo = dxCreateTexture("interface/logo.png", "dxt5", true, "clamp"),
            vehicleimage = dxCreateTexture("interface/vehicleimage.png", "dxt5", true, "clamp"),
            recuadromodeloveh = dxCreateTexture("interface/recuadromodeloveh.png", "dxt5", true, "clamp"),
            recuadrovidavehiculo = dxCreateTexture("interface/recuadrovidavehiculo.png", "dxt5", true, "clamp"),
            recuadrogasolina = dxCreateTexture("interface/recuadrogasolina.png", "dxt5", true, "clamp"),
            botoniconmotor = dxCreateTexture("interface/botoniconmotor.png", "dxt5", true, "clamp"),
            botoniconluces = dxCreateTexture("interface/botoniconluces.png", "dxt5", true, "clamp"),
            botoniconfrenomano = dxCreateTexture("interface/botoniconfrenomano.png", "dxt5", true, "clamp"),
            iconmotor = dxCreateTexture("interface/iconmotor.png", "dxt5", true, "clamp"),
            iconluces = dxCreateTexture("interface/iconluces.png", "dxt5", true, "clamp"),
            iconfrenomano = dxCreateTexture("interface/iconfrenomano.png", "dxt5", true, "clamp"),
            botonpuertaizquierdatrasera = dxCreateTexture("interface/botonpuertaizquierdatrasera.png", "dxt5", true, "clamp"),
            botonpuertaizquierdaprincipal = dxCreateTexture("interface/botonpuertaizquierdaprincipal.png", "dxt5", true, "clamp"),
            botonpuertaderechaprincipal = dxCreateTexture("interface/botonpuertaderechaprincipal.png", "dxt5", true, "clamp"),
            botonpuertaderechatrasera = dxCreateTexture("interface/botonpuertaderechatrasera.png", "dxt5", true, "clamp"),
            botoncapo = dxCreateTexture("interface/botoncapo.png", "dxt5", true, "clamp"),
            botonmaletero = dxCreateTexture("interface/botonmaletero.png", "dxt5", true, "clamp")
        }
        
        addEventHandler("onClientRender", root, renderUI)
        addEventHandler("onClientClick", root, handleClicks)
    else
        -- Limpiamos las texturas al cerrar la interfaz
        for _, texture in pairs(textures) do
            if isElement(texture) then
                destroyElement(texture)
            end
        end
        textures = {}
        
        removeEventHandler("onClientRender", root, renderUI)
        removeEventHandler("onClientClick", root, handleClicks)
    end
end

addCommandHandler("puertas", toggleInterface)

-- Inicialización
isInterfaceVisible = false
showCursor(false)

function cerrarVentanaGUIGVehs()
	triggerEvent("offCursor", getLocalPlayer())
	destroyElement(vGestVehiculo)
	setElementData(getLocalPlayer(), "GUIVehs", false)
end

function calcularPrecioVenta(modelo, fmotor, ffrenos)
	if modelo and fmotor and ffrenos then
		--[[ 40% del precio del vehículo + 50% del coste de las fases. El tunning no vale nada, porque no
		se sabe si el que lo compre lo quiere modificar o le gusta así.]]
		local precioVeh = 0
		local precioVehOriginal = tonumber(exports.vehicles_auxiliar:getPrecioFromModel(getVehicleNameFromModel(modelo)))*0.40
		local faseMotor = 6000
		local faseFrenos = 5000
		if fmotor > 0 then
			costeFasesMotor = (fmotor*faseMotor)+((fmotor-1)*faseMotor)
		else
			costeFasesMotor = 0
		end
		if ffrenos > 0 then
			costeFasesFrenos = (ffrenos*faseFrenos)+((ffrenos-1)*faseFrenos)
		else
			costeFasesFrenos = 0
		end
		local costeDosFases = costeFasesMotor+costeFasesFrenos
		local precioVeh = (costeDosFases*0.5)+precioVehOriginal
		return precioVeh
	end
end
            
--function mostrarGUIGVehs(data)
--	triggerEvent("onCursor", getLocalPlayer())
  --  vGestVehiculo = guiCreateWindow(390*x/1366, 140*y/768, 560*x/1366, 418*y/768, "Panel de Gestión de Vehículos - DownTown RolePlay", false)
--	--guiWindowSetSizable(vGestVehiculo, false)
 --   labelInfo = guiCreateLabel(13*x/1366, 31*y/768, 537*x/1366, 61*y/768, "Bienvenido al panel de gestión de vehículos de DownTown RolePlay.\n\nDesde aquí podrás ver los vehículos que tienes, ver su estado, y realizar trámites con ellos, como renovarlos o venderlos al sistema de concesionarios de 2º mano.", false, vGestVehiculo)
 --   guiLabelSetHorizontalAlign(labelInfo, "center", true)
   -- gridVehiculos2 = guiCreateGridList(31*x/1366, 104*y/768, 492*x/1366, 210*y/768, false, vGestVehiculo)
    --guiGridListAddColumn(gridVehiculos2, "ID vehículo", 0.18)
--    guiGridListAddColumn(gridVehiculos2, "Modelo", 0.28)
  --  --guiGridListAddColumn(gridVehiculos2, "Días restantes", 0.13)
    --guiGridListAddColumn(gridVehiculos2, "Coste renovación", 0.15)
--    guiGridListAddColumn(gridVehiculos2, "Precio venta", 0.20)
--	guiGridListAddColumn(gridVehiculos2, "¿Depósito?", 0.16)
--	row = 0 
--	for k, v in ipairs(data) do
--		guiGridListAddRow(gridVehiculos2)
--		guiGridListSetItemText(gridVehiculos2, row, 1, tostring(v.vehicleID), false, false)
--		guiGridListSetItemText(gridVehiculos2, row, 2, tostring(getVehicleNameFromModel(v.model)), false, false)
--		--guiGridListSetItemText(gridVehiculos2, row, 3, tostring(v.dias), false, false)
--		--guiGridListSetItemText(gridVehiculos2, row, 4, tostring(exports.vehicles_auxiliar:getCosteRenovacionFromModel(tostring(getVehicleNameFromModel(v.model)))), false, false)
--		guiGridListSetItemText(gridVehiculos2, row, 3, tostring(calcularPrecioVenta(v.model, tonumber(v.fasemotor), tonumber(v.fasefrenos))), false, false)
--		if tonumber(v.cepo) == 1 then
--			guiGridListSetItemText(gridVehiculos2, row, 4, "Sí", false, false)
	--	else
	--		guiGridListSetItemText(gridVehiculos2, row, 5, "No", false, false)
	--	end
--		row = row+1
--	end
  --  bCerrarVentana = guiCreateButton(30*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Cerrar ventana", false, vGestVehiculo)
 --   bLocalizarVeh = guiCreateButton(156*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Localizar vehículo", false, vGestVehiculo)
--bRenovarVeh = guiCreateButton(282*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Renovar vehículo", false, vGestVehiculo)
--    bVenderVeh = guiCreateButton(282*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Vender vehículo", false, vGestVehiculo)
	--bPasarOpcionA = guiCreateButton(408*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Pasar a Opción A", false, vGestVehiculo)
--	bCancelarPrestamo = guiCreateButton(156*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Cancelar préstamo", false, vGestVehiculo)
--	--bRetirarVeh = guiCreateButton(282*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Retirar del depósito", false, vGestVehiculo)
--	addEventHandler("onClientGUIClick", bCerrarVentana, regularGUIVehs)
--	addEventHandler("onClientGUIClick", bLocalizarVeh, regularGUIVehs)
--	--addEventHandler("onClientGUIClick", bRenovarVeh, regularGUIVehs)
--	addEventHandler("onClientGUIClick", bVenderVeh, regularGUIVehs)
--	--addEventHandler("onClientGUIClick", bPasarOpcionA, regularGUIVehs)
--	addEventHandler("onClientGUIClick", bCancelarPrestamo, regularGUIVehs)
--	addEventHandler("onClientGUIClick", bRetirarVeh, regularGUIVehs)
--end
--addEvent("onAbrirGUIGestVehs", true)
--addEventHandler("onAbrirGUIGestVehs", getRootElement(), mostrarGUIGVehs)
                    
function regularGUIVehs()
	local r, c = guiGridListGetSelectedItem(gridVehiculos2)
	if source == bCerrarVentana then
		cerrarVentanaGUIGVehs()
	elseif source == bLocalizarVeh then
		if tonumber(r) == -1 then
			outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		triggerServerEvent("onSolicitarLocVehViaAsistencia", getLocalPlayer(), vehicleID)
		cerrarVentanaGUIGVehs()
	-- elseif source == bRenovarVeh then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		-- local modelo = guiGridListGetItemText(gridVehiculos2, r, 2)
		-- local dias = guiGridListGetItemText(gridVehiculos2, r, 3)
		-- triggerServerEvent("onRenovarVehiculo", getLocalPlayer(), vehicleID, modelo)
	-- elseif source == bVenderVeh then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		-- TODO
	-- elseif source == bPasarOpcionA then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end	
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
	elseif source == bCancelarPrestamo then
		cerrarVentanaGUIGVehs()
		outputChatBox("Para cancelar el préstamo de tu vehículo, pulsa F1.", 0, 255, 0)
		outputChatBox("Se hará efectivo inmediatamente. ¡Sin hay esperas!", 0, 255, 0)
	elseif source == bRetirarVeh then
		if tonumber(r) == -1 then
			outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		triggerServerEvent("onRetirarDepo", getLocalPlayer(), getLocalPlayer(), "cmd", vehicleID)
	end
end

function getElementSpeed(element, unit)
    if not isElement(element) then return 0 end
    local x, y, z = getElementVelocity(element)
    local speed = math.sqrt(x^2 + y^2 + z^2)
    if unit == "km/h" then
        return math.floor(speed * 180)
    end
    return speed
end

-- Manejadores de eventos para actualizar la interfaz cuando cambian los estados
addEventHandler("onClientVehicleEnginStateChange", root, function(state)
    if source == getPedOccupiedVehicle(localPlayer) then
        estadoMotor = state
    end
end)

addEventHandler("onClientElementDataChange", root, function(dataName)
    if source == getPedOccupiedVehicle(localPlayer) then
        if dataName == "fuel" then
            -- Actualizar el estado de gasolina en la interfaz
            local fuel = getElementData(source, "fuel") or 0
            -- La interfaz se actualizará en el siguiente frame
        end
    end
end)

-- Limpieza de recursos al detener
addEventHandler("onClientResourceStop", resourceRoot, function()
    if fonts.default and isElement(fonts.default) then
        destroyElement(fonts.default)
    end
    for _, texture in pairs(textures) do
        if isElement(texture) then
            destroyElement(texture)
        end
    end
end)

-- Agregar eventos para sincronizar con el servidor
addEvent("vehicles:toggleEngine", true)
addEvent("vehicles:toggleLights", true)
addEvent("vehicles:toggleHandbrake", true)

-- Funciones locales para manejar los cambios
function toggleEngine()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
    end
end

function toggleLights()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        setVehicleOverrideLights(vehicle, getVehicleOverrideLights(vehicle) == 2 and 1 or 2)
    end
end

function toggleHandbrake()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        setElementFrozen(vehicle, not isElementFrozen(vehicle))
    end
end

-- Agregar los event handlers
addEventHandler("vehicles:toggleEngine", root, toggleEngine)
addEventHandler("vehicles:toggleLights", root, toggleLights)
addEventHandler("vehicles:toggleHandbrake", root, toggleHandbrake)

-- Función para actualizar el estado de las puertas cuando se entra al vehículo
function updateDoorStates()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        doorStates.leftFrontDoor = getVehicleDoorOpenRatio(vehicle, 2) > 0
        doorStates.rightFrontDoor = getVehicleDoorOpenRatio(vehicle, 3) > 0
        doorStates.leftRearDoor = getVehicleDoorOpenRatio(vehicle, 4) > 0
        doorStates.rightRearDoor = getVehicleDoorOpenRatio(vehicle, 5) > 0
        doorStates.hood = getVehicleDoorOpenRatio(vehicle, 0) > 0
        doorStates.trunk = getVehicleDoorOpenRatio(vehicle, 1) > 0
    end
end

-- Actualizar estados cuando se entra al vehículo
addEventHandler("onClientVehicleEnter", root, function(thePlayer, seat)
    if thePlayer == localPlayer then
        updateDoorStates()
    end
end)

-- Actualizar estados cuando se abre la interfaz
addEventHandler("onClientResourceStart", resourceRoot, function()
    updateDoorStates()
end)