--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local gui = {}

function gui:Structure()
	self.fontSettings = {
		quality = 'cleartype_natural',
		bold = false,
		fonts = {},
	}

	self.textures = {
		window = dxCreateTexture('images/window.png', 'dxt5', false, 'clamp'),
		line = dxCreateTexture('images/line.png', 'dxt5', false, 'clamp'),
		line2 = dxCreateTexture('images/line2.png', 'dxt5', false, 'clamp'),

		button_normal = dxCreateTexture('images/button_normal.png', 'dxt5', false, 'clamp'),
		button_hover = dxCreateTexture('images/button_hover.png', 'dxt5', false, 'clamp'),
	}

	self.screen = {guiGetScreenSize()}
	self.button_click = false

	for i = 0,30 do
		self.fontSettings.fonts[i] = dxCreateFont('fonts/font.ttf', (i + 9), self.fontSettings.bold, self.fontSettings.quality)
	end
end

function gui:IsMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local mouse = {getCursorPosition()}
	local myX, myY = (mouse[1] * self.screen[1]), (mouse[2] * self.screen[2])
	if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
		return true
	end

	return false
end

function gui:StricteRectangle(x, y, w, h, color, a)
	local c = (getKeyState('mouse1') and self:IsMouseIn(x, y, w, h)) and {18,18,18} or {15,15,15}
	dxDrawRectangle(x, y, w, h, tocolor(c[1], c[2], c[3], a), false) -- button

	--out lined
	if color then
		dxDrawRectangle(x, y, 1, h, tocolor(45, 45, 45, a), false)
		dxDrawRectangle(x, y, w, 1, tocolor(45, 45, 45, a), false)
		dxDrawRectangle(x + w, y, 1, h + 1, tocolor(45, 45, 45, a), false)
		dxDrawRectangle(x, y + h, w, 1, tocolor(45, 45, 45, a), false)
	else
		dxDrawImage(x, y, 1, h, self.textures.line2, 0, 0, 0, tocolor(255, 255, 255, a), false)
		dxDrawImage(x, y, w, 1, self.textures.line2, 0, 0, 0, tocolor(255, 255, 255, a), false)
		dxDrawImage(x + w, y, 1, h + 1, self.textures.line2, 0, 0, 0, tocolor(255, 255, 255, a), false)
		dxDrawImage(x, y + h, w, 1, self.textures.line2, 0, 0, 0, tocolor(255, 255, 255, a), false)
	end
end

function gui:CreateWindow(x, y, w, h, a, postGUI)
	a = a or 255

	--main window
	dxDrawImage(x, y, w, h, self.textures.window, 0, 0, 0, tocolor(15, 15, 15, a > 245 and 245 or a), postGUI)
	dxDrawImage(x, y + h - 2, w, 2, self.textures.line, 0, 0, 0, tocolor(255, 255, 255, a), postGUI)
end

function gui:CreateButton(t, x, y, w, h, size, a)
	size = size or 3
	a = (not a or a and not tonumber(a)) and 255 or a

	if not self:IsMouseIn(x, y, w, h) then
		self:StricteRectangle(x, y, w, h, tocolor(0, 255, 75, 255), a)
	else
	    if getKeyState('mouse1') and not self.button_click then
	    	playSoundFrontEnd(20)
	        self.button_click = true
	    elseif not getKeyState('mouse1') and self.button_click then
	        self.button_click = false
	    end

		self:StricteRectangle(x, y, w, h, false, a)
	end

	self:CreateText(t, x, y, w + x, h + y, tocolor(175, 175, 175, a), size, 'default', 'center', 'center', false)
end

function gui:CreateText(text, x, y, w, h, color, size, _, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	size = size or 1
    font = self.fontSettings.fonts[size] or self.fontSettings.fonts[0]
    alignX = alignX or 'left'
    alignY = alignY or 'top'

    dxDrawText(text, x, y, w, h, color, 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
end

function gui:CreateShadowText(text, x, y, w, h, color, size, _, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	size = size or 1
	font = self.fontSettings.fonts[size] or self.fontSettings.fonts[0]
	alignX = alignX or 'left'
	alignY = alignY or 'top'
	color = color or tocolor(255, 255, 255, 255)

	local a = bitExtract(color, 24, 8)

	dxDrawText(text, x + 1, y + 1, w + 1, h + 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)

	dxDrawText(text, x, y, w, h, color, 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
end

function gui:CreateShadowMaxText(text, x, y, w, h, color, size, _, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	size = size or 1
	font = self.fontSettings.fonts[size] or self.fontSettings.fonts[0]
	alignX = alignX or 'left'
	alignY = alignY or 'top'
	color = color or tocolor(255, 255, 255, 255)

	local a = bitExtract(color, 24, 8)
	a = a > 50 and 50 or a

	dxDrawText(text, x - 1, y - 1, w - 1, h - 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x + 1, y - 1, w + 1, h - 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x - 1, y + 1, w - 1, h + 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x + 1, y + 1, w + 1, h + 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x - 1, y, w - 1, h, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x + 1, y, w + 1, h, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x, y - 1, w, h - 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	dxDrawText(text, x, y + 1, w, h + 1, tocolor(0, 0, 0, a), 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)

	dxDrawText(text, x, y, w, h, color, 1, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
end

function dxLibary_shadowText(...)
	gui:CreateShadowMaxText(...)
end

function dxLibary_shadowText2(...)
	gui:CreateShadowText(...)
end

function dxLibary_text(...)
  	gui:CreateText(...)
end

function dxLibary_createButton(...)
	gui:CreateButton(...)
end

function dxLibary_createButtonAlpha(...)
	gui:CreateButton(...)
end

function dxLibary_createWindow(...)
   	gui:CreateWindow(...)
end

function dxLibary_createWindowAlpha(...)
	gui:CreateWindow(...)
end

function dxLibary_formatTextPosition(x, y, w, h)
  return x, y, w + x, h + y
end

function dxLibary_getFont(size)
  return gui.fontSettings.fonts[size] or gui.fontSettings.fonts[1]
end

function createTexture(filePath, textureFormat, mipmaps, textureEdge)
	return dxCreateTexture(filePath, textureFormat or 'dxt5', mipmaps, textureEdge or 'clamp')
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	gui:Structure()
end)