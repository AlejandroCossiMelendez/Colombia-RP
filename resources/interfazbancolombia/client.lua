-- Variables globales
local sx, sy = guiGetScreenSize()
local currentPanel = "principal" -- "principal", "depositar", "retirar"
local font = {}
local saldoBanco = 0
local saldoEfectivo = 0
local montoInput = ""

-- Función para cargar las fuentes
function loadFonts()
	font[20] = dxCreateFont("fonts/RussoOne-Regular.ttf", 20, false, "proof")
	font[16] = dxCreateFont("fonts/RussoOne-Regular.ttf", 16.666666666666668, false, "proof")
	font[13] = dxCreateFont("fonts/RussoOne-Regular.ttf", 13.333333333333334, false, "proof")
end

-- Función para liberar recursos de las fuentes
function unloadFonts()
	for size, fontElement in pairs(font) do
		if isElement(fontElement) then
			destroyElement(fontElement)
		end
	end
	font = {}
end

-- Función para renderizar el panel principal
function renderPrincipal()
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 750, 'data/bgprincipal.png')
	dxDrawImage(sx/2 - 212, sy/2 + 174, 210, 90, 'data/botondepositar.png')
	dxDrawImage(sx/2 + 25, sy/2 + 174, 210, 90, 'data/botonretirar.png')
	dxDrawImage(sx/2 - 216, sy/2 + 178, 76, 76, 'data/icondepositar.png')
	dxDrawImage(sx/2 + 31, sy/2 + 188, 76, 76, 'data/iconretirar.png')
	dxDrawImage(sx/2 - 93, sy/2 + 278, 200, 50, 'data/botoncerrarpanel.png')
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 200, 'data/header.png')
	dxDrawImage(sx/2 - 225, sy/2 - 298, 470, 123, 'data/imagenicon.png')
	dxDrawImage(sx/2 - 212, sy/2 - 358, 72, 72, 'data/iconlogobancolombia.png')
	dxDrawImage(sx/2 + 153, sy/2 - 355, 72, 72, 'data/iconlogobancolombia2.png')
	
	-- Textos
	dxDrawText('BANCOLOMBIA', sx/2 + 7, sy/2 - 321.5, nil, nil, tocolor(255, 255, 255, 255), 1, font[20], 'center', 'center')
	dxDrawText('Banco: $'..formatNumber(saldoBanco), sx/2 - 60, sy/2 - 87.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('Efectivo: $'..formatNumber(saldoEfectivo), sx/2 - 60, sy/2 - 129.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('DEPOSITAR', sx/2 - 78, sy/2 + 220.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[13], 'center', 'center')
	dxDrawText('RETIRAR', sx/2 + 168, sy/2 + 220.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[13], 'center', 'center')
	dxDrawText('Cerrar Sesion', sx/2 + 14, sy/2 + 299.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
	
	-- Tarjeta de crédito
	dxDrawImage(sx/2 - 148, sy/2 - 61, 316, 200, 'data/imagentarjetacredito.png')
end

-- Función para renderizar el panel de depositar
function renderDepositar()
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 750, 'data/bgprincipal.png')
	dxDrawImage(sx/2 - 95, sy/2 + 115, 210, 90, 'data/botondepositar.png')
	dxDrawImage(sx/2 - 190, sy/2 + 6, 400, 80, 'data/cuadrotextodepositar.png')
	dxDrawImage(sx/2 - 95 + 105 - 38, sy/2 + 120, 76, 76, 'data/icondepositar.png')
	dxDrawImage(sx/2 - 85, sy/2 + 225, 200, 50, 'data/botoncerrarpanel.png')
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 200, 'data/header.png')
	dxDrawImage(sx/2 - 225, sy/2 - 298, 470, 123, 'data/imagenicon.png')
	dxDrawImage(sx/2 - 212, sy/2 - 358, 72, 72, 'data/iconlogobancolombia.png')
	dxDrawImage(sx/2 + 153, sy/2 - 355, 72, 72, 'data/iconlogobancolombia2.png')
	
	-- Textos
	dxDrawText('BANCOLOMBIA', sx/2 + 7, sy/2 - 321.5, nil, nil, tocolor(255, 255, 255, 255), 1, font[20], 'center', 'center')
	dxDrawText('Banco: $'..formatNumber(saldoBanco), sx/2 - 60, sy/2 - 87.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('Efectivo: $'..formatNumber(saldoEfectivo), sx/2 - 60, sy/2 - 129.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('Monto a depositar:', sx/2 + 10, sy/2 - 47.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
	dxDrawText('$'..montoInput, sx/2 + 10, sy/2 + 46, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
	dxDrawText('Cerrar Sesion', sx/2 + 14, sy/2 + 250.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
end

-- Función para renderizar el panel de retirar
function renderRetirar()
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 750, 'data/bgprincipal.png')
	dxDrawImage(sx/2 - 95, sy/2 + 115, 210, 90, 'data/botondepositar.png')
	dxDrawImage(sx/2 - 190, sy/2 + 6, 400, 80, 'data/cuadrotextodepositar.png')
	dxDrawImage(sx/2 - 85, sy/2 + 225, 200, 50, 'data/botoncerrarpanel.png')
	dxDrawImage(sx/2 - 225, sy/2 - 375, 470, 200, 'data/header.png')
	dxDrawImage(sx/2 - 225, sy/2 - 298, 470, 123, 'data/imagenicon.png')
	dxDrawImage(sx/2 - 212, sy/2 - 358, 72, 72, 'data/iconlogobancolombia.png')
	dxDrawImage(sx/2 + 153, sy/2 - 355, 72, 72, 'data/iconlogobancolombia2.png')
	dxDrawImage(sx/2 - 95 + 105 - 38, sy/2 + 120, 76, 76, 'data/iconretirar.png')
	
	-- Textos
	dxDrawText('BANCOLOMBIA', sx/2 + 7, sy/2 - 321.5, nil, nil, tocolor(255, 255, 255, 255), 1, font[20], 'center', 'center')
	dxDrawText('Banco: $'..formatNumber(saldoBanco), sx/2 - 60, sy/2 - 87.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('Efectivo: $'..formatNumber(saldoEfectivo), sx/2 - 60, sy/2 - 129.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'left', 'center')
	dxDrawText('Monto a Retirar:', sx/2 + 10, sy/2 - 47.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
	dxDrawText('$'..montoInput, sx/2 + 10, sy/2 + 46, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
	dxDrawText('Cerrar Sesion', sx/2 + 14, sy/2 + 250.5, nil, nil, tocolor(61, 61, 63, 255), 1, font[16], 'center', 'center')
end

-- Función principal de renderizado
function renderUI()
	if currentPanel == "principal" then
		renderPrincipal()
	elseif currentPanel == "depositar" then
		renderDepositar()
	elseif currentPanel == "retirar" then
		renderRetirar()
	end
end

-- Evento separado para detectar clics en cajeros
addEventHandler("onClientClick", root, 
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if button == "left" and state == "down" then
			if clickedElement then
				local elementType = getElementType(clickedElement)
				if elementType == "object" then
					local modelID = getElementModel(clickedElement)
					if modelID == 2942 then
						-- Si no está abierta la interfaz, abrirla
						if not isEventHandlerAdded("onClientRender", root, renderUI) then
							outputChatBox("Abriendo panel bancario...", 0, 255, 0)
							toggleBancoUI(true)
						end
					end
				end
			end
		end
	end
)

-- Control de clics para interacción con los botones
function handleClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
		if currentPanel == "principal" then
			-- Botón depositar
			if isMouseInPosition(sx/2 - 212, sy/2 + 174, 210, 90) then
				currentPanel = "depositar"
				montoInput = ""
				playSoundFrontEnd(6)
			-- Botón retirar
			elseif isMouseInPosition(sx/2 + 25, sy/2 + 174, 210, 90) then
				currentPanel = "retirar"
				montoInput = ""
				playSoundFrontEnd(6)
			-- Botón cerrar (ajustar posición)
			elseif isMouseInPosition(sx/2 - 93, sy/2 + 278, 200, 50) then
				toggleBancoUI(false)
				playSoundFrontEnd(4)
			end
		elseif currentPanel == "depositar" then
			-- Botón depositar
			if isMouseInPosition(sx/2 - 95, sy/2 + 115, 210, 90) then
				local monto = tonumber(montoInput)
				if monto and monto > 0 then
					triggerServerEvent("onPlayerAddBalance", localPlayer, localPlayer, monto)
					montoInput = ""
				else
					outputChatBox("Ingresa un monto válido para depositar.", 255, 0, 0)
				end
			-- Botón cerrar (ajustar posición)
			elseif isMouseInPosition(sx/2 - 85, sy/2 + 225, 200, 50) then
				currentPanel = "principal"
				montoInput = ""
				playSoundFrontEnd(4)
			end
		elseif currentPanel == "retirar" then
			-- Botón retirar
			if isMouseInPosition(sx/2 - 95, sy/2 + 115, 210, 90) then
				local monto = tonumber(montoInput)
				if monto and monto > 0 then
					triggerServerEvent("onPlayerRemoveBalance", localPlayer, localPlayer, monto)
					montoInput = ""
				else
					outputChatBox("Ingresa un monto válido para retirar.", 255, 0, 0)
				end
			-- Botón cerrar (ajustar posición)
			elseif isMouseInPosition(sx/2 - 85, sy/2 + 225, 200, 50) then
				currentPanel = "principal"
				montoInput = ""
				playSoundFrontEnd(4)
			end
		end
	end
end

-- Función para verificar si el ratón está en una posición específica
function isMouseInPosition(x, y, width, height)
	local screenX, screenY = getCursorPosition()
	if not screenX then return false end
	
	screenX, screenY = screenX * sx, screenY * sy
	return (screenX >= x and screenX <= x + width) and (screenY >= y and screenY <= y + height)
end

-- Función para manejar la entrada de texto
function handleTextInput(character)
	if (currentPanel == "depositar" or currentPanel == "retirar") and string.len(montoInput) < 10 then
		if string.find(character, "[0-9]") then
			montoInput = montoInput .. character
			playSoundFrontEnd(7) -- Sonido al escribir
		end
	end
end

-- Función para manejar teclas
function handleKey(button, press)
	if press then
		if (currentPanel == "depositar" or currentPanel == "retirar") then
			if button == "backspace" and string.len(montoInput) > 0 then
				montoInput = string.sub(montoInput, 1, -2)
				playSoundFrontEnd(8) -- Sonido al borrar
			end
		end
	end
end

-- Función para formatear números con separadores de miles
function formatNumber(number)
	local formatted = tostring(number)
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	return formatted
end

-- Función para activar/desactivar la interfaz
function toggleBancoUI(visible)
	if visible then
		currentPanel = "principal"
		loadFonts()
		addEventHandler("onClientRender", root, renderUI)
		addEventHandler("onClientClick", root, handleClick)
		addEventHandler("onClientCharacter", root, handleTextInput)
		addEventHandler("onClientKey", root, handleKey)
		
		-- Solicitar saldos al servidor
		triggerServerEvent("onRequestBalance", localPlayer, localPlayer)
		saldoEfectivo = getPlayerMoney()
		
		showCursor(true)
	else
		removeEventHandler("onClientRender", root, renderUI)
		removeEventHandler("onClientClick", root, handleClick)
		removeEventHandler("onClientCharacter", root, handleTextInput)
		removeEventHandler("onClientKey", root, handleKey)
		unloadFonts()
		showCursor(false)
	end
end

-- Se mantiene el comando para abrir/cerrar la interfaz (alternativa)
addCommandHandler("banco", function()
	if isEventHandlerAdded("onClientRender", root, renderUI) then
		toggleBancoUI(false)
	else
		toggleBancoUI(true)
	end
end)

-- Función auxiliar para verificar si un event handler está asociado
function isEventHandlerAdded(eventName, attachedTo, func)
	if type(eventName) == "string" and isElement(attachedTo) and type(func) == "function" then
		local attachedFunctions = getEventHandlers(eventName, attachedTo)
		if type(attachedFunctions) == "table" and #attachedFunctions > 0 then
			for i, v in ipairs(attachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end

-- Eventos para actualizar saldos
addEvent("onClientUpdateBalance", true)
addEventHandler("onClientUpdateBalance", root, function(balance)
	saldoBanco = balance
	saldoEfectivo = getPlayerMoney() -- Actualizar también el efectivo
end)