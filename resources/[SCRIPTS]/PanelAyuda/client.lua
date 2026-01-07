-- Panel de Ayuda Futurista (DX) para "La Capital Roleplay"
-- Editado para una UI moderna con pestañas, overlay y animación
-- luacheck: globals outputChatBox addEventHandler removeEventHandler root resourceRoot guiGetScreenSize xmlUnloadFile dxDrawRectangle dxDrawText showCursor bindKey xmlLoadFile xmlNodeGetValue tocolor fileExists dxDrawImage getCursorPosition playSound isElement isCursorShowing isChatVisible showChat getEventHandlers dxCreateFont addCommandHandler cancelEvent unbindKey outputDebugString dxGetTextWidth dxGetFontHeight
---@diagnostic disable: undefined-global

outputChatBox("Presiona F1 para abrir el Panel de Ayuda.", 0, 255, 0, true)

local screenW, screenH = guiGetScreenSize()
local sx, sy = screenW, screenH
local isPanelVisible = false
local panelAlpha = 0
local selectedTabIndex = 1
local originalChatVisible = true
local scrollOffset = 0
local contentMaxScroll = 0
local contentRT = nil
local contentRTW, contentRTH = 0, 0

local tabs = { "Bienvenida", "Conceptos", "Reglas", "Informacion" }
local contents = { "", "", "", "" }

-- Escala basada en diseño 1920x1080
local UI_REF_W, UI_REF_H = 1920, 1080
local FONT_SCALE_FIX = 1.18 -- ajuste fino para que el tamaño se parezca al de Figma
local SCALE_K = math.min(sx / UI_REF_W, sy / UI_REF_H)
local ORIGIN_X = math.floor((sx - UI_REF_W * SCALE_K) / 2)
local ORIGIN_Y = math.floor((sy - UI_REF_H * SCALE_K) / 2)
local function s(px)
	return math.floor(px * SCALE_K)
end
local function ux(px)
	return ORIGIN_X + s(px)
end
local function uy(py)
	return ORIGIN_Y + s(py)
end
local function fontSize(px)
	return math.max(10, math.floor(px * SCALE_K * FONT_SCALE_FIX))
end

local PANEL_W = math.floor(math.min(920, screenW * 0.82))
local PANEL_H = math.floor(math.min(620, screenH * 0.86))
local HEADER_H = 72
local TABS_H = 44
local PADDING = 22

local function centerPanel()
	return math.floor((screenW - PANEL_W) / 2), math.floor((screenH - PANEL_H) / 2)
end

local function loadXmlText(path)
	local xml = xmlLoadFile(path)
	if not xml then return "" end
	local txt = xmlNodeGetValue(xml) or ""
	xmlUnloadFile(xml)
	return (txt:gsub("\r\n", "\n"))
end

local function drawRoundedRect(x, y, w, h, color)
	-- Borde sutil superior/inferior para sensación de profundidad
	dxDrawRectangle(x, y, w, h, color)
	dxDrawRectangle(x, y, w, 1, tocolor(255, 255, 255, 12 * panelAlpha))
	dxDrawRectangle(x, y + h - 1, w, 1, tocolor(0, 0, 0, 35 * panelAlpha))
end

-- Carga de fuentes locales (reemplazo de exports figma)
local fontCache = {}
local function getLocalFont(fontName, size)
	local key = tostring(fontName)..":"..tostring(size)
	if fontCache[key] and isElement(fontCache[key]) then
		return fontCache[key]
	end
	-- Mapear variantes figma a archivos locales conocidos
	local normalized = tostring(fontName)
	if normalized == 'Poppins-Regular' then
		normalized = 'Poppins-SemiBold'
	end
	local candidates = {
		("NuevaInterfaz/fonts/%s.ttf"):format(normalized),
		("NuevaInterfaz/fonts/%s.otf"):format(normalized),
		("NuevaInterfaz/fonts/%s.ttf"):format((normalized or ""):gsub("%s+", "")),
		("NuevaInterfaz/fonts/%s.otf"):format((normalized or ""):gsub("%s+", "")),
	}
	for _, path in ipairs(candidates) do
		if fileExists(path) then
			local f = dxCreateFont(path, math.floor(tonumber(size) or 14))
			if f then
				fontCache[key] = f
				return f
			end
		end
	end
	return "default-bold"
end

local function drawImageIfExists(x, y, w, h, path, alpha)
	if fileExists(path) then
		dxDrawImage(x, y, w, h, path, 0, 0, 0, tocolor(255, 255, 255, math.floor(alpha)))
	end
end

-- Calcular alto del texto con word-wrap para un ancho dado
local function getWrappedTextHeight(text, font, width)
	local lineHeight = dxGetFontHeight(1, font)
	local spacing = math.floor(lineHeight * 0.25)
	local totalLines = 0
	text = tostring(text or "")
	text = text:gsub("\r", "")
	for rawLine in (text .. "\n"):gmatch("([^\n]*)\n") do
		local line = ""
		local hasWord = false
		for word, space in rawLine:gmatch("(%S+)(%s*)") do
			local candidate = (line == "" and word) or (line .. " " .. word)
			if dxGetTextWidth(candidate, 1, font) > width and hasWord then
				totalLines = totalLines + 1
				line = word
			else
				line = candidate
				hasWord = true
			end
		end
		-- contar la última línea (o línea vacía)
		totalLines = totalLines + 1
	end
	if totalLines < 1 then totalLines = 1 end
	return totalLines * lineHeight + (totalLines - 1) * spacing
end

local function isCursorOnRect(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * screenW, cy * screenH
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function renderPanel()
	if panelAlpha <= 0 then return end

	-- Overlay
	dxDrawRectangle(0, 0, sx, sy, tocolor(10, 12, 16, math.floor(180 * panelAlpha)))

	-- Base (posiciones exactas de Figma sobre 1920x1080)
	local baseX, baseY, baseW, baseH = ux(560), uy(290), s(800), s(500)
	local a = math.floor(255 * panelAlpha)
	drawImageIfExists(baseX, baseY, baseW, baseH, 'NuevaInterfaz/data/BGEXTERIOR.png', a)
	local innerX, innerY, innerW, innerH = ux(588), uy(412), s(750), s(350)
	drawImageIfExists(innerX, innerY, innerW, innerH, 'NuevaInterfaz/data/BGINTERIOR.png', a)
	drawImageIfExists(ux(560), uy(290), s(800), s(70), 'NuevaInterfaz/data/Header.png', a)

	-- Título
	dxDrawText('La Capital Roleplay — Panel Ayuda', ux(716), uy(304), ux(716) + s(487), uy(304) + s(42),
		tocolor(255, 255, 255, a), 1, getLocalFont('Poppins-SemiBold', fontSize(28)), 'center', 'center')

	-- Botón cerrar (ícono)
	drawImageIfExists(ux(560 + 745), uy(290 + 12), s(46), s(46), 'NuevaInterfaz/data/IconoCerrar.png', a)

	-- Barra de pestañas y botones
	drawImageIfExists(ux(560), uy(356), s(800), s(40), 'NuevaInterfaz/data/barraPestanas.png', a)
	drawImageIfExists(ux(573), uy(361), s(180), s(30), 'NuevaInterfaz/data/BotonBienvenida.png', a)
	drawImageIfExists(ux(768), uy(361), s(180), s(30), 'NuevaInterfaz/data/BotonConceptos.png', a)
	drawImageIfExists(ux(963), uy(360), s(180), s(30), 'NuevaInterfaz/data/BotonReglas.png', a)
	drawImageIfExists(ux(1158), uy(360), s(180), s(30), 'NuevaInterfaz/data/BotonInformacion.png', a)
	drawImageIfExists(ux(560), uy(400), s(800), s(2), 'NuevaInterfaz/data/LineaInferiorBarraPestanas.png', a)

	-- Etiquetas de pestañas
	dxDrawText('Bienvenida',  ux(594),  uy(357), ux(594)  + s(138), uy(357) + s(36), tocolor(255,255,255,a), 1, getLocalFont('Poppins-SemiBold', fontSize(24)), 'center', 'center')
	dxDrawText('Conceptos',  ux(791),  uy(358), ux(791)  + s(133), uy(358) + s(36), tocolor(255,255,255,a), 1, getLocalFont('Poppins-SemiBold', fontSize(24)), 'center', 'center')
	dxDrawText('Reglas',     ux(1011), uy(357), ux(1011) + s(83),  uy(357) + s(36), tocolor(255,255,255,a), 1, getLocalFont('Poppins-SemiBold', fontSize(24)), 'center', 'center')
	dxDrawText('Informacion',ux(1178), uy(357), ux(1178) + s(150), uy(357) + s(36), tocolor(255,255,255,a), 1, getLocalFont('Poppins-SemiBold', fontSize(24)), 'center', 'center')

	-- Área de contenido dentro del panel interior (con scroll y clipping por RT)
	local contentX = innerX + s(20)
	local contentY = innerY + s(20)
	local contentW = innerW - s(40)
	local contentH = innerH - s(40)
	local bodyFont = getLocalFont('Poppins-Regular', fontSize(14))
	local fullText = contents[selectedTabIndex] or ""
	local estimatedH = getWrappedTextHeight(fullText, bodyFont, contentW - s(8))
	contentMaxScroll = math.max(0, estimatedH - contentH)
	if scrollOffset > contentMaxScroll then scrollOffset = contentMaxScroll end

	-- Crear / actualizar render target para clipping
	if (not contentRT) or contentRTW ~= contentW or contentRTH ~= contentH then
		if contentRT and isElement(contentRT) then destroyElement(contentRT) end
		contentRT = dxCreateRenderTarget(math.max(1, contentW), math.max(1, contentH), true)
		contentRTW, contentRTH = contentW, contentH
	end
	if contentRT then
		dxSetRenderTarget(contentRT, true)
		-- Dibuja el texto dentro del RT con offset vertical
		dxDrawText(fullText, 0, -scrollOffset, contentW, estimatedH,
			tocolor(230, 235, 245, 255), 1, bodyFont, 'left', 'top', true, true)
		dxSetRenderTarget()
		-- Pegar el RT en pantalla, respetando alpha general
		dxDrawImage(contentX, contentY, contentW, contentH, contentRT, 0, 0, 0, tocolor(255,255,255,a))
	end

	-- Scrollbar
	if contentMaxScroll > 0 then
		local trackX = contentX + contentW - s(6)
		local trackY = contentY
		local trackW = s(4)
		local trackH = contentH
		dxDrawRectangle(trackX, trackY, trackW, trackH, tocolor(255,255,255, math.floor(35 * panelAlpha)))
		local ratio = contentH / (estimatedH)
		local barH = math.max(s(20), math.floor(trackH * ratio))
		local barY = trackY + math.floor((trackH - barH) * (scrollOffset / contentMaxScroll))
		dxDrawRectangle(trackX, barY, trackW, barH, tocolor(255,255,255, math.floor(155 * panelAlpha)))
	end
end

local function showPanel(state)
	isPanelVisible = state
	showCursor(state)
	if state then
		if isChatVisible then originalChatVisible = isChatVisible() else originalChatVisible = true end
		if showChat then showChat(false) end
		if not isEventHandlerAdded("onClientRender", root, renderPanel) then
			addEventHandler("onClientRender", root, renderPanel)
		end
		panelAlpha = 0
		playSound("open.wav")
	else
		if showChat then showChat(originalChatVisible ~= false) end
		-- Destruir RT al cerrar y resetear scroll
		if contentRT and isElement(contentRT) then
			destroyElement(contentRT)
			contentRT = nil
			contentRTW, contentRTH = 0, 0
		end
		scrollOffset = 0
		-- Mantener render hasta desvanecer
		-- Se quitará automáticamente cuando alpha llegue a 0
	end
end

addEventHandler("onClientRender", root, function()
	if isPanelVisible and panelAlpha < 1 then
		panelAlpha = math.min(1, panelAlpha + 0.15)
	elseif (not isPanelVisible) and panelAlpha > 0 then
		panelAlpha = math.max(0, panelAlpha - 0.15)
		if panelAlpha == 0 and isEventHandlerAdded("onClientRender", root, renderPanel) then
			removeEventHandler("onClientRender", root, renderPanel)
		end
	end
end)

addEventHandler("onClientClick", root, function(button, state)
	if button ~= "left" or state ~= "down" then return end
	if panelAlpha <= 0 then return end
	-- Áreas clicables con posiciones de la nueva interfaz
	-- Cerrar (icono 46x46)
	local closeX, closeY, closeW, closeH = ux(560 + 745), uy(290 + 12), s(46), s(46)
	if isCursorOnRect(closeX, closeY, closeW, closeH) then
		showPanel(false)
		return
	end
	-- Pestañas
	local tabsClickable = {
		{ux(573),  uy(361), s(180), s(30)}, -- Bienvenida
		{ux(768),  uy(361), s(180), s(30)}, -- Conceptos
		{ux(963),  uy(360), s(180), s(30)}, -- Reglas
		{ux(1158), uy(360), s(180), s(30)}, -- Informacion
	}
	for i, r in ipairs(tabsClickable) do
		if isCursorOnRect(r[1], r[2], r[3], r[4]) then
			selectedTabIndex = i
			break
		end
	end
end)

-- Scroll con rueda del ratón
addEventHandler("onClientKey", root, function(key, press)
	if panelAlpha <= 0 then return end
	if not press then return end
	if key == "mouse_wheel_up" then
		scrollOffset = math.max(0, scrollOffset - s(30))
	elseif key == "mouse_wheel_down" then
		scrollOffset = math.min(contentMaxScroll, scrollOffset + s(30))
	end
end)

function toggleHelpPanel()
	showPanel(not isPanelVisible)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	contents[1] = loadXmlText("cmd.xml")
	contents[2] = loadXmlText("member.xml")
	contents[3] = loadXmlText("other.xml")
	contents[4] = loadXmlText("server.xml")
	if unbindKey then unbindKey("F1", "down") end
	bindKey("F1", "down", toggleHelpPanel)
	addCommandHandler("ayuda", function() toggleHelpPanel() end)
	addCommandHandler("help", function() toggleHelpPanel() end)
	addCommandHandler("panel", function() toggleHelpPanel() end)
	addEventHandler("onClientKey", root, function(button, press)
		if button == "f1" and press then
			toggleHelpPanel()
			if cancelEvent then cancelEvent() end
		end
	end)
	if outputDebugString then outputDebugString("Help panel preparado: usa F1 o /ayuda") end
end)

-- Utilidad: verificar si el handler ya está agregado
function isEventHandlerAdded(theEventName, attachedTo, theFunction)
	if type(theEventName) == "string" and isElement(attachedTo) and type(theFunction) == "function" then
		local attachedFunctions = getEventHandlers(theEventName, attachedTo)
		if type(attachedFunctions) == "table" and #attachedFunctions > 0 then
			for _, fn in ipairs(attachedFunctions) do
				if fn == theFunction then
					return true
				end
			end
		end
	end
	return false
end