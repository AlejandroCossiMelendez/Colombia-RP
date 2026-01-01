--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local dxLibary = exports.dxLibary

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1 
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

function center(x, y)
    return (sw / 2) - (x / 2), (sh / 2) - (y / 2)
end

local loading = {}

function loading:Load()
    self['txd_loading-image'] = dxLibary:createTexture(':ladowanie/images/circle.png', 'dxt5', false, 'clamp')
    self['txd_server-logo'] = dxLibary:createTexture(':ladowanie/images/logo.png', 'dxt5', false, 'clamp')

    for i = 1,7 do
        self['txd_background-'..i] = 'backgrounds/bgd_'..i..'.jpg'
    end

    self['loading_text'] = 'Espere porfavor.'

    self['render_fnc'] = function() loading:Render() end

    self['alpha_images'] = 1
    self['alpha_background'] = 1
    self['tick_images'] = getTickCount()
    self['rotation_images'] = 0
    self['ticked'] = getTickCount()
    self['dots'] = ''
    self['state'] = 'join'
    self['time'] = 1500
    self['tick'] = getTickCount()
    self.tick_ = getTickCount()

    self['texts'] = {
        '#f9f9f9¿Sabes que tenemos foro?.\nNuestro foro es: #00ff00 https://exoticrp.com/foro',
        '#f9f9f9¡Recuerda puedes usar /duda!\nPara poder aclarar cualquier duda que tengas.\nTambién puedes usar el botón#00ff00 F7#f9f9f9 para encontrar algo relacionado con el servidor.',
    }

    self.last_bgd = 0
    self.new_bgd = math.random(1,7)

    self['selected_text'] = self.texts[1]
    self['alpha_off'] = false
    self['alpha'] = 1

    self['tck'] = getTickCount()
    self.img_tick = getTickCount()
end

function loading:Render()
    self['rotation_images'] = self['rotation_images'] + 2

	if self['state'] == 'join' and not self['alpha_off'] then
		self['alpha_images'], self['alpha_background'], self['alpha'] = interpolateBetween(1, 1, 1, 255, 235, 150, (getTickCount() - self['tick_images']) / 500, 'Linear')
    elseif self['state'] == 'quit' then
    	self['alpha_images'], self['alpha_background'], self['alpha'] = interpolateBetween(255, 235, 150, 0, 0, 0, (getTickCount() - self['tick_images']) / 500, 'Linear')
    end

    dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0, self.alpha_images), false)

    if self.time and (getTickCount() - self['tick_images']) > self['time'] and self['state'] ~= 'quit' then
        self['state'] = 'quit'
        self['tick_images'] = getTickCount()
    end

    if (getTickCount() - self['ticked']) > 250 then
        self['dots'] = '..'
    end

    if (getTickCount() - self['ticked']) > 500 then
        self['dots'] = '...'
    end

    if (getTickCount() - self['ticked']) > 1000 then
        self['dots'] = '.'
        self['ticked'] = getTickCount()
    end

    if self['alpha_images'] == 0 then
        removeEventHandler('onClientRender', root, self['render_fnc'])
    end

    if (getTickCount() - self.tick) > 2500 then
        self.selected_text = self.texts[math.random(1,#self.texts)]
        self.tick = getTickCount()
    end

    if (getTickCount() - self.tick_) > 7500 then
        self.last_bgd = self.new_bgd
        self.new_bgd = math.random(1,7)
        self.tick_ = getTickCount()
        self.img_tick = getTickCount()
    end

    local postGUI = self.time and true or false

    dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0, self['alpha']), postGUI)

    if self.last_bgd ~= 0 and self.alpha_images == 255 then
        local a2 = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount() - self.img_tick) / 2500, 'Linear')
        dxDrawImage(0, 0, sw, sh, self['txd_background-'..self['last_bgd']], 0, 0, 0, tocolor(255, 255, 255, a2), postGUI)
    end

    local a1 = self['alpha_images'] == 255 and self.img_tick and interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - self.img_tick) / 2500, 'Linear') or self['alpha_images']
    dxDrawImage(0, 0, sw, sh, self['txd_background-'..self['new_bgd']], 0, 0, 0, tocolor(255, 255, 255, a1), postGUI)

    dxDrawImage((sw/2) - ((500/2)/scale), (sh/2) - ((500/2)/scale), 500/scale, 500/scale, self['txd_server-logo'], 0, 0, 0, tocolor(255, 255, 255, self['alpha_images']), postGUI)

    local x,y = center(0, -450/scale)
    dxLibary:dxLibary_text(string.gsub(self['selected_text'], '#%x%x%x%x%x%x', ''), 1, y + 1, sw + 1, y + 1, tocolor(0, 0, 0, self['alpha_images']), 5, 'default', 'center', 'center', false, false, postGUI, true, false)
    dxLibary:dxLibary_text(self['selected_text'], 0, y, sw, y, tocolor(255, 255, 255, self['alpha_images']), 5, 'default', 'center', 'center', false, false, postGUI, true, false)

    local len = string.len(self['loading_text']) * (2 * scale)
    dxLibary:dxLibary_text(self['loading_text']..self['dots'], sw-(230/scale) + 1 - len, sh-(65/scale) + 1, sw-(70/scale) + 1, sh-(10/scale) + 1, tocolor(0, 0, 0, self['alpha_images']), 5, 'default', 'left', 'center', false, false, postGUI, true, false)
    dxLibary:dxLibary_text(self['loading_text']..self['dots'], sw-(230/scale) - len, sh-(65/scale), sw-(70/scale), sh-(10/scale), tocolor(255, 255, 255, self['alpha_images']), 5, 'default', 'left', 'center', false, false, postGUI, true, false)
    
    local r,g,b = interpolateBetween(0, 75, 0, 0, 255, 0, (getTickCount()-self['tck'])/2400, 'SineCurve')
    dxDrawImage(1855/scale + 1, sh-(55/scale) + 1, 32/scale + 1, 32/scale + 1, self['txd_loading-image'], self['rotation_images'], 0, 0, tocolor(0, 0, 0, self['alpha_images']), postGUI)
    dxDrawImage(1855/scale, sh-(55/scale), 32/scale, 32/scale, self['txd_loading-image'], self['rotation_images'], 0, 0, tocolor(r, g, b, self['alpha_images']), postGUI)
end

function loading:CreateLoadingScreen(text, time, alpha)
    self['loading_text'] = text or 'Espere porfavor.'
    self['state'] = 'join'
    self['ticked'] = getTickCount()
    self['time'] = time
    self['selected_text'] = self['texts'][math.random(1, #self['texts'])]
    self['tick_images'] = getTickCount()

    self['alpha_images'] = (alpha == true and 255 or 1)
    self['alpha_background'] = (alpha == true and 150 or 1)
    self['alpha_off'] = alpha or false
    self['alpha'] = (alpha == true and 150 or 1)

    self.new_bgd = math.random(1,7)
    self.img_tick = false
    self.last_bgd = 0

    self.tick = getTickCount()
    self.tick_ = getTickCount()

    addEventHandler('onClientRender', root, self['render_fnc'])
end

function loading:DestroyLoadingScreen()
    removeEventHandler('onClientRender', root, self['render_fnc'])
end

function createLoadingScreen(...)
    loading:CreateLoadingScreen(...)
end

function destroyLoadingScreen()
    loading:DestroyLoadingScreen()
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    loading:Load()
end)