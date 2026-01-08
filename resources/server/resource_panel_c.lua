-- Panel para mostrar resultados de comandos start/stop/restart
local panelWindow = nil
local closeButton = nil
local panelVisible = false

-- Función para mostrar el panel con los resultados
function showResourcePanel(commandType, successList, skippedList, failedList)
	-- Cerrar panel anterior si existe
	if panelWindow and isElement(panelWindow) then
		destroyElement(panelWindow)
	end
	
	panelVisible = true
	showCursor(true)
	
	local screenW, screenH = guiGetScreenSize()
	local windowWidth = 600
	local windowHeight = 500
	local windowX = (screenW - windowWidth) / 2
	local windowY = (screenH - windowHeight) / 2
	
	-- Título según el tipo de comando
	local titleText = ""
	if commandType == "start" then
		titleText = "Resultados: Iniciar Recursos"
	elseif commandType == "stop" then
		titleText = "Resultados: Detener Recursos"
	elseif commandType == "restart" then
		titleText = "Resultados: Reiniciar Recursos"
	elseif commandType == "status" then
		titleText = "Estado de Recursos Importantes"
	end
	
	panelWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, titleText, false)
	guiWindowSetSizable(panelWindow, false)
	guiWindowSetMovable(panelWindow, true)
	
	-- Título de sección: Exitosos
	local yPos = 30
	local memoHeight = 100
	
	if #successList > 0 then
		local successLabel = guiCreateLabel(20, yPos, windowWidth - 40, 20, "✓ Exitosos (" .. #successList .. "):", false, panelWindow)
		guiLabelSetColor(successLabel, 0, 255, 0)
		guiSetFont(successLabel, "default-bold-small")
		yPos = yPos + 25
		
		local successText = table.concat(successList, ", ")
		local successMemo = guiCreateMemo(20, yPos, windowWidth - 40, memoHeight, successText, false, panelWindow)
		guiMemoSetReadOnly(successMemo, true)
		yPos = yPos + memoHeight + 10
	end
	
	-- Título de sección: Omitidos (ya estaban en ese estado)
	if #skippedList > 0 then
		local skippedLabel = guiCreateLabel(20, yPos, windowWidth - 40, 20, "⚠ Omitidos - Ya estaban en ese estado (" .. #skippedList .. "):", false, panelWindow)
		guiLabelSetColor(skippedLabel, 255, 255, 0)
		guiSetFont(skippedLabel, "default-bold-small")
		yPos = yPos + 25
		
		local skippedText = table.concat(skippedList, ", ")
		local skippedMemo = guiCreateMemo(20, yPos, windowWidth - 40, memoHeight, skippedText, false, panelWindow)
		guiMemoSetReadOnly(skippedMemo, true)
		yPos = yPos + memoHeight + 10
	end
	
	-- Título de sección: Fallidos
	if #failedList > 0 then
		local failedLabel = guiCreateLabel(20, yPos, windowWidth - 40, 20, "✗ Fallidos / No encontrados (" .. #failedList .. "):", false, panelWindow)
		guiLabelSetColor(failedLabel, 255, 0, 0)
		guiSetFont(failedLabel, "default-bold-small")
		yPos = yPos + 25
		
		local failedText = table.concat(failedList, ", ")
		local failedMemo = guiCreateMemo(20, yPos, windowWidth - 40, memoHeight, failedText, false, panelWindow)
		guiMemoSetReadOnly(failedMemo, true)
		yPos = yPos + memoHeight + 10
	end
	
	-- Si no hay resultados, mostrar mensaje
	if #successList == 0 and #skippedList == 0 and #failedList == 0 then
		local noResultsLabel = guiCreateLabel(20, yPos, windowWidth - 40, 20, "No se especificaron recursos válidos.", false, panelWindow)
		guiLabelSetColor(noResultsLabel, 255, 255, 0)
		guiSetFont(noResultsLabel, "default-bold")
		yPos = yPos + 30
	end
	
	-- Calcular altura mínima necesaria
	local minHeight = yPos + 60
	if minHeight < 200 then
		minHeight = 200
	end
	if minHeight > screenH - 40 then
		minHeight = screenH - 40
	end
	
	-- Ajustar altura de la ventana
	windowHeight = minHeight
	guiSetSize(panelWindow, windowWidth, windowHeight, false)
	guiSetPosition(panelWindow, (screenW - windowWidth) / 2, (screenH - windowHeight) / 2, false)
	
	-- Botón cerrar
	closeButton = guiCreateButton((windowWidth - 120) / 2, windowHeight - 50, 120, 35, "Cerrar", false, panelWindow)
end

-- Función para cerrar el panel
function closeResourcePanel()
	if panelWindow and isElement(panelWindow) then
		destroyElement(panelWindow)
		panelWindow = nil
		closeButton = nil
	end
	panelVisible = false
	showCursor(false)
end

-- Evento para recibir los resultados del servidor
addEvent("resource:showPanel", true)
addEventHandler("resource:showPanel", root, function(commandType, successList, skippedList, failedList)
	showResourcePanel(commandType, successList, skippedList, failedList)
end)

-- Manejar clic en el botón cerrar
addEventHandler("onClientGUIClick", root, function()
	if source == closeButton then
		closeResourcePanel()
	end
end)

-- Cerrar con ESC
addEventHandler("onClientKey", root, function(key, press)
	if press and key == "escape" and panelVisible then
		closeResourcePanel()
	end
end)
