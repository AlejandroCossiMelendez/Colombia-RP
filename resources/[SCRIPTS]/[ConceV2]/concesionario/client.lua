addEvent("panelVehicleConce", true)
addEvent("comprano", true)
addEvent("compra", true)
addEvent("comprao", true)

local conceDx = false
local max = 11
local lineActual = 0
local sTick, aDuration, eTick = nil, 1000, nil

local x, y = guiGetScreenSize( )
local sx, sy = ( x / 1366 ), ( y / 768 )

local font = dxCreateFont("utils/font.ttf", sx*12)
local font3 = dxCreateFont ("utils/medium.ttf", sx*16)

addEventHandler("onClientRender", root,
    function()
		if conceDx then
			local cTick = getTickCount()

			local dxAlpha = interpolateBetween( 0, 0, 0, 255, 0, 0, ( cTick - sTick ) / aDuration, "InOutQuad" )

			dxDraw:RoundedRectangle(21, 66, 303, 550,tocolor(9, 10, 18, dxAlpha), 6)
			dxDraw:Text("Premium deluxe\nMotor Sports (IMPORTADOS)", 36, 76, 310, 131, tocolor(255, 194, 50, dxAlpha), 1, font3, "left", "top", false, false, false, false, false)
			dxDraw:RoundedRectangle(297, 75, 15, 16, tocolor(99, 27, 24, dxAlpha), 4)
			dxDraw:Text("x", 298, 71, 312, 87, tocolor(0, 0, 0, dxAlpha), 1, font, "center", "top", false, false, true, false, false)
			local y = 146
			for i = lineActual + 1, math.min(max + lineActual, #vehiclesTable) do
				local vehicleData = vehiclesTable[i]
				dxDraw:RoundedRectangle(42, y, 257, 50,tocolor(23, 23,30, dxAlpha), 4)
				if functions:isMouseInPosition(42, y, 257, 50) then
					dxDraw:RoundedRectangle(42, y, 257, 50,tocolor(10, 15,36, 255), 4)
					if click and getKeyState("mouse1") then
						vehicleCreatePreview(vehicleData.model, 153.88671875, -253.87890625, 1.5723714828491)
						print(vehicleData.model)
						model = vehicleData.model or 0
						price = vehicleData.cost or 0
						name = vehicleData.name or "invalido"
						vip = vehicleData.vip
					end
				end
				dxDraw:Text(vehicleData.name, 46, y, 156, y + 45, tocolor(255, 255, 255, dxAlpha), 1, font, "left", "center", false, false, false, false, false)	
				dxDraw:Text("$" .. NumerosComas(vehicleData.cost), 184, y, 294, y + 45, tocolor(55, 105, 69, dxAlpha), 1, font, "right", "center", false, false, false, false, false)
				y = y + 40
			end
			
		elseif infoDx then
			dxDraw:RoundedRectangle(571, 282, 259, 150, tocolor(9, 10, 18, 255), 5)
			dxDraw:Text("Estas a punto de comprar un " .. name .. " por: $" .. NumerosComas(price) .. " ¿estas seguro?", 579, 288, 820, 341, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, true, true, false, false)
			dxDraw:RoundedRectangle(579, 377, 97, 47, tocolor(10, 15,36, 255), 6)
			dxDraw:RoundedRectangle(724, 377, 97, 47, tocolor(10, 15,36, 255), 6)
			dxDraw:Text("Aceptar", 583, 383, 666, 414, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, true, false, false)
			if functions:isMouseInPosition(579, 377, 97, 47) then
				dxDraw:RoundedRectangle(579, 377, 97, 47, tocolor(30, 35,56, 255), 6)
			end
			dxDraw:Text("Cerrar", 728, 383, 811, 414, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, true, false, false)
			if functions:isMouseInPosition(724, 377, 97, 47) then
				dxDraw:RoundedRectangle(724, 377, 97, 47, tocolor(30, 35,56, 255), 6)
			end
		elseif metodo then
			dxDraw:RoundedRectangle(571, 282, 259, 150, tocolor(9, 10, 18, 255), 5)
			dxDraw:Text("¿Que metodo de pago eliges?", 579, 288, 820, 341, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, true, true, false, false)
			dxDraw:RoundedRectangle(579, 377, 97, 47, tocolor(10, 15,36, 255), 6)
			if functions:isMouseInPosition(579, 377, 97, 47) then
				dxDraw:RoundedRectangle(579, 377, 97, 47, tocolor(30, 35,56, 255), 6)
			end
			dxDraw:RoundedRectangle(724, 377, 97, 47, tocolor(10, 15,36, 255), 6)
			if functions:isMouseInPosition(724, 377, 97, 47) then
				dxDraw:RoundedRectangle(724, 377, 97, 47, tocolor(30, 35,56, 255), 6)
			end
			dxDraw:Text("Efectivo", 583, 383, 666, 414, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, true, false, false)
			dxDraw:Text("Banco", 728, 383, 811, 414, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, true, false, false)

		elseif mose then
			dxDraw:RoundedRectangle(1290, 311, 20, 18, tocolor(60, 32, 75, 255), 4)
			dxDraw:RoundedRectangle(1036, 220, 330, 282, tocolor(9, 10, 19, 255), 5)
			dxDraw:RoundedRectangle(1062, 427, 109, 58, tocolor(23, 23, 30, 255), 5)
			dxDraw:RoundedRectangle(1242, 427, 109, 58, tocolor(23, 23, 30, 255), 6)
			dxDraw:Text("Comprar", 1066, 429, 1165, 480, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, false, false, false)
			dxDraw:Text("Comprar", 1247, 429, 1346, 480, tocolor(255, 255, 255, 255), 1.20, "arial", "center", "center", false, false, false, false, false)
			dxDraw:Text("Infernus", 1046, 230, 1161, 263, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, false, false, false, false)
			dxDraw:Text("Infernus", 1284, 230, 1399, 263, tocolor(255, 255, 255, 255), 1.00, font, "left", "top", false, false, false, false, false)
			dxDraw:Text("Colores", 1099, 263, 1274, 298, tocolor(255, 255, 255, 255), 1.00, font, "center", "top", false, false, false, false, false)
			dxDraw:RoundedRectangle(1052, 311, 20, 18, tocolor(0, 0, 52, 255), 6)
			dxDraw:RoundedRectangle(1105, 311, 20, 18, tocolor(254, 240, 23, 255), 6)
			dxDraw:RoundedRectangle(1079, 311, 20, 18, tocolor(61, 31, 247, 255), 6)
			dxDraw:RoundedRectangle(1131, 311, 20, 18, tocolor(254, 22, 22, 255), 6)
			dxDraw:RoundedRectangle(1157, 311, 20, 18, tocolor(254, 255, 255, 255), 6)
			dxDraw:RoundedRectangle(1183, 311, 20, 18, tocolor(0, 0, 0, 255), 6)
			dxDraw:RoundedRectangle(1209, 311, 20, 18, tocolor(230, 123, 18, 255), 6)
			dxDraw:RoundedRectangle(1235, 311, 20, 18, tocolor(20, 238, 9, 255), 6)
			dxDraw:RoundedRectangle(1260, 311, 20, 18, tocolor(60, 32, 75, 255), 6)
			dxDraw:RoundedRectangle(1285, 311, 20, 18, tocolor(221, 75, 231, 255),6)
			dxDraw:RoundedRectangle(1310, 311, 20, 18, tocolor(67, 216, 238, 255), 6)
		end
		click = getKeyState("mouse1")
    end
)

addEventHandler('onClientClick', root, function(b, s)
    if (b == 'left') and (s == 'down') then
		if conceDx then
			if functions:isMouseInPosition(297, 75, 15, 16) then
				conceDx = false
				showChat(true)
				setCameraTarget(localPlayer)
				deleteVehicle()
				triggerServerEvent("cerrar", localPlayer, localPlayer)
			end
		elseif infoDx then
			if functions:isMouseInPosition(724, 377, 97, 47) then
				conceDx = true
				infoDx = false
				metodo = false
				nox = false

			elseif functions:isMouseInPosition(579, 377, 97, 47) then
				conceDx = false
				infoDx = false
				metodo = true
				nox = false

			end
		elseif metodo then
			if functions:isMouseInPosition(579, 377, 97, 47) then
				triggerServerEvent("RealizarCompra", localPlayer, tonumber(model), tonumber(price), vip)
				exports.notificaiones:dxDrawNotifications("Informacion", "Realizando compra espere.", 4)
				conceDx = false
				infoDx = false
				metodo = false	
				nox = false
				showChat(true)
				setCameraTarget(localPlayer)
				deleteVehicle()
				triggerServerEvent("cerrar", localPlayer, localPlayer)
			elseif functions:isMouseInPosition(724, 377, 97, 47) then
				triggerServerEvent("RealizarCompraBank", localPlayer, tonumber(model), tonumber(price), vip)
				exports.notificaiones:dxDrawNotifications("Informacion", "Realizando compra espere.", 4)
				conceDx = false
				infoDx = false
				metodo = false
				nox = false
				showChat(true)
				deleteVehicle()
				triggerServerEvent("cerrar", localPlayer, localPlayer)
			end
		end
    end
end)




addEventHandler("panelVehicleConce", root, function()
	local posCamera = {	posx = 140.529296875, posy = -253.6552734375, posz = 3.9956886768341, posx2 = 157.591796875, posy2 = -253.994140625, posz2 = 1.5723714828491}
	showChat(false)
	setCameraMatrix(posCamera.posx, posCamera.posy, posCamera.posz, posCamera.posx2, posCamera.posy2, posCamera.posz2)
	conceDx = true
	sTick = getTickCount()
	eTick = sTick + aDuration
	exports.notificaiones:dxDrawNotifications("Informacion", "Motor Sports ", 4)

end)


addEventHandler("onClientKey", root, function(key, press)
	if key == 'mouse_wheel_up' and press then
        if conceDx then
            if lineActual > 0 then
                lineActual = lineActual - 1
            end
        end
    elseif key == 'mouse_wheel_down' and press then
        if conceDx then
            if max + lineActual < #vehiclesTable then
                lineActual = lineActual + 1
            end
        end
	elseif key == "enter" and press then
		if conceDx then
			if tonumber(model) > 0 then
				infoDx = true
				conceDx = false
			end
		end
	elseif key == "backspace" and press then
		if conceDx or infoDx or metodo or nox then
			conceDx = false
			infoDx = false
			metodo = false
			nox = false
			setCameraTarget(localPlayer)
			deleteVehicle()
			showChat(true)
			triggerServerEvent("cerrar", localPlayer, localPlayer)
		end
	end
end)


addEventHandler("comprao", root, function()
	time = setTimer(function()
		exports.notificaiones:dxDrawNotifications("Error", "No eres usuario VIP.", 4)
		killTimer(time)
	end, 500, 0)
end)

addEventHandler("compra", root, function()
	time = setTimer(function()
		exports.notificaiones:dxDrawNotifications("Exito", "Compra realizada disfrutelo.", 4)
		killTimer(time)
	end, 500, 0)
end)

addEventHandler("comprano", root, function()
	time = setTimer(function()
		exports.notificaiones:dxDrawNotifications("Error", "Dinero insuficiente.", 4)
		killTimer(time)
	end, 500, 0)
end)