local ropa = {}
ropa.__index = ropa

--[[
if tostring(genero) == "hombre" then gen = 1 else gen = 2 end
if tostring(color) == "negro" then col = 0 else col = 1 end
]]

local categoria = {
	[0] = 'camisa',
	[2] = 'pantalon',
	[3] = 'zapato',
	[13] = 'cadena',
	--
	camisa = 0,
	pantalon = 2,
	zapato = 3,
	cadena = 13,
}

function ropa:init()

	self.x, self.y = GuiElement.getScreenSize()
	self.s = (1/1024) * self.x

	self.female = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 91, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}
	
	self.sex = 1
	self.raza = 0
	self.click = nil

	self.scroll = 1
	self.type = 0
	self.idUnico = nil
	self.clothes = {}

	self.f_render = bind(self.render, self)
	addEventHandler('onClientDoubleClick', root, bind(self.onDoubleClick, self))

	local w,h = self.x*.4, self.y*.58
	local x,y = self.x/2 - w/2, self.y/2 - h/2

	self.combox = GuiComboBox(self.x/2 - w/4, y+self.y*.0375, w/2, self.y*0.13, '', false)
	self.combox.visible = false
	for _, v in ipairs({0,2,3,13}) do
		self.combox:addItem(categoria[v])
	end
	self.combox:setSelected(0)
	addEventHandler('onClientGUIComboBoxAccepted', self.combox, bind(self.onComboxClick, self))
end

function ropa:load(sex,raza)
	self.visible = not self.visible
	if self.visible then

		self.sex = sex
		self.raza = raza
		self.currentSkin = localPlayer:getModel()
		--
		for _, v in ipairs({0,2,3,13}) do
			local text,model = localPlayer:getClothes(v)
			if text ~= false then
				self.clothes[v] = {text, model}
			end
		end
		--
		if sex == 1 then
			self.combox.visible = true
		end

		addEventHandler('onClientRender', root, self.f_render)
	else

		removeEventHandler('onClientRender', root, self.f_render)
		self.combox.visible = false
		self.sex = nil
		self.raza = nil
		self.currentSkin = nil
		self.idUnico = nil
		self.clothes = {}

		triggerEvent('offcursor', root)
	end
	--showCursor(self.visible)
end


function ropa:onComboxClick(b)
	if b == source then
		local item = source:getSelected()
        local text = tostring ( source:getItemText ( item ) )
        if ( text ~= "" ) then
        	self.scroll = 1
            self.type = categoria[text]
        end
	end
end

function ropa:onDoubleClick(b)
	if not self.visible then
		return
	end
	if guiComboBoxIsOpen(self.combox) then
		return
	end

	if (b == 'left')then		
		local w,h = self.x*.38, self.y*.58
		local x,y = self.x * 0.03, self.y/2 - h/2

		local cY = 0
		for i = self.scroll, 4+self.scroll do

			if isCursorOver(x+self.x*.02, y+self.y*.07+cY, w-self.x*0.04, self.y*0.08) then

				if self.idUnico then

					if self.sex == 1 then

						local precio = getPrecioRopa(self.idUnico)
						if precio <= getPlayerMoney( ) then
							
							triggerServerEvent('aplicarRopaServidor', localPlayer, self.idUnico)
							self.clothes[self.type] = nil

						else
							outputChatBox('No tienes dinero.', 255, 0, 0)
						end

					elseif self.sex == 2 then

						if 300 <= getPlayerMoney() then
							self.currentSkin = localPlayer.model
							triggerServerEvent('ropa:comprarSkin', localPlayer, self.idUnico)
						else
							outputChatBox('No tienes dinero.', 255, 0, 0)
						end

					end

					playSoundFrontEnd( 40 )
				end

				break
			end

			cY = cY + self.y*0.09
		end
	end
end

function ropa:render()

	local w,h = self.x*.38, self.y*.58
	local x,y = self.x * 0.03, self.y/2 - h/2

	if self.combox.visible then
		guiSetPosition(self.combox, x + w/4, y+self.y*.0375, false )
	end

	dxDrawRectangle(x,y,w,h,tocolor(0,0,0,170), false)
	dxText('Tienda de Ropa', x,y,w,h, nil, 0.6*self.s, self.s*0.7, 'bankgothic', 'center')

	local cY = 0
	for i = self.scroll, 4+self.scroll do

		if isCursorOver(x+self.x*.02, y+self.y*.07+cY, w-self.x*0.04, self.y*0.08) then

			if not guiComboBoxIsOpen(self.combox) then
				
				local ap = 50
				if (not self.click and getKeyState 'mouse1') then

					ap = 70
					self.idUnico = self.sex == 1 and clothes[self.type][i].idUnico or self.female[i]
					
					if self.sex == 1 then

						local t = clothes[self.type][i]
						local text = t.Texture
						local model = t.Model

						localPlayer:addClothes(text, model, self.type)

						if self.raza == 1 then
							triggerEvent("onSolicitarRopaBlanco", localPlayer)
						end

					elseif self.sex == 2 then

						localPlayer:setModel(self.idUnico)

					end

				end

				dxDrawRectangle(x+self.x*.02, y+self.y*.07+cY, w-self.x*0.04, self.y*0.08, tocolor(255,255,255,ap))

			end
		end

		local path = self.sex == 1 and 'icons/'..categoria[self.type]..'.png' or 'files/Skinid'..self.female[i]..'.jpg'
		local title, price, color = '', 0, tocolor(255,255,255)

		if self.sex == 1 then
			local t = clothes[self.type][i]
			title = t.Nombre
			price = t.price
			t.color = t.color or tocolor(math.random(255),math.random(255),math.random(255))
			color = t.color
		else
			title = getSkinNameFromID(self.female[i])
			price = 300
		end

		dxDrawImage(x+self.x*.02, y+self.y*.07+cY, self.x*0.05, self.y*0.08, path, 0,0,0, color)
		dxText(title..'\nPrecio: '..price..'$', x+self.x*.08, y+self.y*.07+cY, w, self.y*0.08, nil, 0.5*self.s, self.s*0.6, 'bankgothic', 'left', 'center')

		cY = cY + self.y*0.09
	end

	local ap = 115

	if isCursorOver(x + w/4, y+self.y*.075+cY, w/2, self.y*0.035) then
		if (not self.click and getKeyState 'mouse1') then
			ap = 150

			if self.sex == 2 and self.currentSkin ~= localPlayer.model then
				localPlayer:setModel(self.currentSkin)
			end
			--
			for k, v in pairs(self.clothes) do
				if v then
					localPlayer:addClothes(v[1],v[2], k)
				end
			end
			--
			if self.raza == 1 then
				triggerEvent("onSolicitarRopaBlanco", localPlayer)
			end

			self:load()
		end
	end
	dxDrawRectangle(x + w/4, y+self.y*.075+cY, w/2, self.y*0.035, tocolor(255,0,0, ap))
	dxText('Salir', x + w/4, y+self.y*.075+cY, w/2, self.y*0.035, nil, 0.5*self.s, self.s*0.6, 'bankgothic', 'center', 'center')

	self.click = getKeyState 'mouse1'
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		ropa:init()
	end
)

addEvent('showDemClothGui', true)
addEventHandler('showDemClothGui', root,
	function(sex,color)
		ropa:load(sex,color)
	end
)

function dxText(t, x,y,w,h, ...)
	return dxDrawText(t, x, y, w+x, h+y, ...)
end

bindKey( "mouse_wheel_up", "down", function( )
    local w,h = ropa.x*.38, ropa.y*.58
	local x,y = ropa.x * 0.03, ropa.y/2 - h/2
    if ropa.visible and isCursorOver(x,y,w,h) then
        if ropa.scroll > 1 then
            ropa.scroll = ropa.scroll - 1
        end
    end
end)

bindKey( "mouse_wheel_down", "down", function( )
    local w,h = ropa.x*.38, ropa.y*.58
	local x,y = ropa.x * 0.03, ropa.y/2 - h/2
    if ropa.visible and isCursorOver(x,y,w,h) then
        if ropa.scroll < (ropa.sex == 1 and #clothes[ropa.type] or #ropa.female)-4 then
            ropa.scroll = ropa.scroll+1
        end
    end
end)

bindKey( "pgup", "down", function( )
    local w,h = ropa.x*.38, ropa.y*.58
	local x,y = ropa.x * 0.03, ropa.y/2 - h/2
    if ropa.visible and isCursorOver(x,y,w,h) then
        if ropa.scroll > 1 then
            ropa.scroll = ropa.scroll - 1
        end
    end
end)

bindKey( "pgdn", "down", function( )
    local w,h = ropa.x*.38, ropa.y*.58
	local x,y = ropa.x * 0.03, ropa.y/2 - h/2
    if ropa.visible and isCursorOver(x,y,w,h) then
        if ropa.scroll < (ropa.sex == 1 and #clothes[ropa.type] or #ropa.female)-4 then
            ropa.scroll = ropa.scroll+1
        end
    end
end)

function isCursorOver(x,y,w,h)

	if isCursorShowing() then

		local sx,sy = guiGetScreenSize(  ) 
		local cx,cy = getCursorPosition(  )
		local px,py = sx*cx,sy*cy

		if (px >= x and px <= x+w) and (py >= y and py <= y+h) then

			return true

		end

	end
	return false
end

function bind(f, ...)
	local params = {...}
	return function(...)

		local args = {}
		for i = 1, select('#', unpack(params)) do
			args[i] = params[i]
		end

		local f_params = {...}
		for i = 1, select('#', ...) do
			args[#args + i] = f_params[i]
		end

		return f(unpack(args))
	end
end