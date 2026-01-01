--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local sw,sh = guiGetScreenSize()
local tick = getTickCount()
local type = 'join'

local options = {
	sw,sh = guiGetScreenSize(),
	shader = dxCreateShader('shaders/shader.fx'),
	background = exports['dxLibary']:createTexture(':shader/images/background.png'),
	shader_screen = dxCreateScreenSource(sw, sh),
	showed = false,
}

function render()
	if type == 'join' then
		a1 = interpolateBetween(0, 0, 0, 240, 0, 0, (getTickCount()-tick)/300, 'Linear')
	else
		a1 = interpolateBetween(240, 0, 0, 0, 0, 0, (getTickCount()-tick)/300, 'Linear')

		if a1 == 0 then
			showed = false
			removeEventHandler('onClientHUDRender', root, render)
		end
	end

	if getElementData(localPlayer, 'grey_shader') == 2 then
		dxDrawRectangle(0, 0, sw, sh, tocolor(30, 30, 33, a1), true)
	else
		dxDrawRectangle(0, 0, sw, sh, tocolor(30, 30, 33, a1), false)
	end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	if options['shader'] and options['shader_screen'] then
		dxSetShaderValue(options['shader'], 'screenSource', options['shader_screen'])
	end

	if getElementData(localPlayer, 'grey_shader') and getElementData(localPlayer, 'grey_shader') >= 1 and not showed then
		showed = true
		type = 'join'
		addEventHandler('onClientHUDRender', root, render)
		tick = getTickCount()
	end
end)

addEventHandler('onClientElementDataChange', root, function(data)
	if source ~= localPlayer then return end
	if data == 'grey_shader' then
		if getElementData(localPlayer, 'grey_shader') and getElementData(localPlayer, 'grey_shader') >= 1 and not showed then
			showed = true
			type = 'join'
			addEventHandler('onClientHUDRender', root, render)
			tick = getTickCount()
		else
			tick = getTickCount()
			type = 'quit'
		end
	end
end)
