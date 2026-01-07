local screenW, screenH = guiGetScreenSize()
local isPanelVisible = false

function onStart()
    font1 = dxCreateFont("Roboto.ttf", 10)
    font2 = dxCreateFont("RobotoBold.ttf", 10)
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIÓN PARA DIBUJAR EL PANEL DE FABRICACIÓN
----------------------------------------------------------------------------------------------------------------------------------------
function renderTec9()
	dxDrawRectangle(screenW * 0.3946, screenH * 0.3164, screenW * 0.2116, screenH * 0.3672, tocolor(25, 25, 25, 254), false) -- Fondo del panel
	dxDrawRectangle(screenW * 0.5717, screenH * 0.3164, screenW * 0.0344, screenH * 0.0456, tocolor(190, 0, 0, 255), false) -- Botón de cerrar
	dxDrawRectangle(screenW * 0.4510, screenH * 0.3737, screenW * 0.0988, screenH * 0.1497, tocolor(45, 45, 45, 255), false) -- Área de selección
	dxDrawRectangle(screenW * 0.4580, screenH * 0.6270, screenW * 0.0871, screenH * 0.0391, tocolor(45, 45, 45, 255), false) -- Botón de fabricar

	dxDrawText("X", screenW * 0.5717, screenH * 0.3164, screenW * 0.6061, screenH * 0.3620, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)
	dxDrawText("1 -   2 Cautiles\n2 -   1 Pieza Cargador Tec-9", screenW * 0.4050, screenH * 0.4900, screenW * 0.5988, screenH * 0.6706, tocolor(255, 255, 255, 255), 0.80, font2, "left", "center", false, false, false, false, false)
	dxDrawText("FABRICAR", screenW * 0.4050, screenH * 0.6270, screenW * 0.5988, screenH * 0.6706, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)
	dxDrawText("    FABRICAR TEC-9", screenW * 0.3946, screenH * 0.3164, screenW * 0.5717, screenH * 0.3620, tocolor(255, 255, 255, 255), 1.00, font2, "left", "center", false, false, false, false, false)

	-- Imagen de la Tec-9 (Asegúrate de tener "tec9.png" en la carpeta y agregada en `meta.xml`)
	dxDrawImage(screenW * 0.4729, screenH * 0.3919, screenW * 0.0549, screenH * 0.0977, "tec9.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIÓN PARA ACTIVAR/DESACTIVAR EL PANEL
----------------------------------------------------------------------------------------------------------------------------------------
function toggleTec9()
	if not isPanelVisible then
		isPanelVisible = true
		showCursor(true)
		addEventHandler("onClientRender", root, renderTec9)
	else
		isPanelVisible = false
		showCursor(false)
		removeEventHandler("onClientRender", root, renderTec9)
	end
end
addEvent("ToggleTec9", true)
addEventHandler("ToggleTec9", resourceRoot, toggleTec9)

----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIÓN PARA DETECTAR CLICS EN EL PANEL
----------------------------------------------------------------------------------------------------------------------------------------
function onTec9Click(button, state)
	if button == "left" and state == "down" then
		if isPanelVisible then
			-- Cerrar el panel
			if isCursorOnElement(screenW * 0.5717, screenH * 0.3164, screenW * 0.0344, screenH * 0.0456) then
				toggleTec9()
			-- Botón de fabricar
			elseif isCursorOnElement(screenW * 0.4580, screenH * 0.6270, screenW * 0.0871, screenH * 0.0391) then
				triggerServerEvent("FabricarTec9", resourceRoot, localPlayer)
				toggleTec9()
			end
		end
	end
end
addEventHandler("onClientClick", root, onTec9Click)

----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIÓN PARA COMPROBAR SI EL CURSOR ESTÁ SOBRE UN BOTÓN
----------------------------------------------------------------------------------------------------------------------------------------
function isCursorOnElement(x, y, w, h)
	if isCursorShowing() then
		local mx, my = getCursorPosition()
		local fullx, fully = guiGetScreenSize()
		local cursorx, cursory = mx * fullx, my * fully
		return (cursorx > x and cursorx < x + w and cursory > y and cursory < y + h)
	end
	return false
end
