toys = {}
toys.__index = toys




function loadPanelRot()
	GUIEditor.window[1].visible = not GUIEditor.window[1].visible
end

function toys:init()

	self.x, self.y = GuiElement.getScreenSize()
	self.s = (1/1024) * self.x

	self.click = nil
	self.obj = nil
	self.selected = {}
	self.price = 400
	self.scroll = 1
	self.type = 'mascaras'
	self.rcolors = {}
	self.offsets = {0,0,0,0,0,0,1}

	self.f_render = bind(self.render, self)
	addEventHandler('onClientDoubleClick', root, bind(self.onDoubleClick, self))

	local w,h = self.x*.4, self.y*.58
	local x,y = self.x/2 - w/2, self.y/2 - h/2

	self.combox = GuiComboBox(self.x/2 - w/4, y+self.y*.0375, w/2, self.y*0.13, '', false)
	self.combox.visible = false
	for v in pairs(Accesorios) do
		self.combox:addItem(v)
	end
	self.combox:setSelected(0)
	addEventHandler('onClientGUIComboBoxAccepted', self.combox, bind(self.onComboxClick, self))
end

function toys:load(sex,raza)
	self.visible = not self.visible
	if self.visible then
		
		self.combox.visible = true
		

		addEventHandler('onClientRender', root, self.f_render)
		loadPanelRot()
	else

		removeEventHandler('onClientRender', root, self.f_render)
		self.combox.visible = false

		triggerEvent('offcursor', root)
		loadPanelRot()
	end
	--showCursor(self.visible)
end


function toys:onComboxClick(b)
	if b == source then
		local item = source:getSelected()
        local text = tostring ( source:getItemText ( item ) )
        if ( text ~= "" ) then
        	self.scroll = 1
            self.type = text
            if isElement(self.obj) then
            	self.obj:destroy()
            end
        end
	end
end

function toys:onDoubleClick(b)
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

				if #self.selected > 0 then
					if getPlayerMoney() >= self.price then
						triggerServerEvent('Buy:Toys', localPlayer, self.obj:getModel(), self.type, self.offsets, self.selected[2], self.price)
						playSoundFrontEnd( 40 )
						self.selected = {}
						self.offsets = {0,0,0,0,0,0,1}
					else
						outputChatBox('No tienes dinero.', 255, 0, 0)
					end
				end

				break
			end

			cY = cY + self.y*0.09
		end
	end
end

function toys:render()

	local w,h = self.x*.38, self.y*.58
	local x,y = self.x * 0.03, self.y/2 - h/2

	if self.combox.visible then
		guiSetPosition(self.combox, x + w/4, y+self.y*.0375, false )
	end

	dxDrawRectangle(x,y,w,h,tocolor(0,0,0,170), false)
	dxText('Tienda de Accesorios', x,y,w,h, nil, 0.6*self.s, self.s*0.7, 'bankgothic', 'center')

	local cY = 0
	for i = self.scroll, ((#Accesorios[self.type] < 4 and #Accesorios[self.type]) or 4+self.scroll) do

		local path = 'files/'..self.type..'.png'
		local title, price = self.type:sub(1,#self.type-1)..' '..i, self.price

		if isCursorOver(x+self.x*.02, y+self.y*.07+cY, w-self.x*0.04, self.y*0.08) then

			if not guiComboBoxIsOpen(self.combox) then
				
				local ap = 50
				if (not self.click and getKeyState 'mouse1') then

					ap = 70

					local ID = Accesorios[self.type][i]
					if not isElement(self.obj) then
		            	self.obj = Object(ID, localPlayer.position)
		            	self.obj.interior = localPlayer.interior
		            	self.obj.dimension = localPlayer.dimension

		            	exports.bone_attach:attachElementToBone(self.obj, localPlayer, 1, 0,0,0,0,0,0)
		            else
		            	self.obj.model = ID
		            end

		            self.selected = {ID, title}
		            --(id, _type, offsets, name, price)
				end

				dxDrawRectangle(x+self.x*.02, y+self.y*.07+cY, w-self.x*0.04, self.y*0.08, tocolor(255,255,255,ap))

			end
		end

		self.rcolors[i] = self.rcolors[i] or tocolor(math.random(255),math.random(255),math.random(255))

		dxDrawImage(x+self.x*.02, y+self.y*.07+cY, self.x*0.05, self.y*0.08, path, 0,0,0, self.rcolors[i])
		dxText(title..'\nPrecio: '..price..'$', x+self.x*.08, y+self.y*.07+cY, w, self.y*0.08, nil, 0.5*self.s, self.s*0.6, 'bankgothic', 'left', 'center')

		cY = cY + self.y*0.09
	end

	local ap = 115

	if isCursorOver(x + w/4, y+self.y*.075+cY, w/2, self.y*0.035) then
		if (not self.click and getKeyState 'mouse1') then
			ap = 150

			if isElement(self.obj) then
            	self.obj:destroy()
            end
            self.selected = {}
			self.offsets = {0,0,0,0,0,0,1}

			self:load()
		end
	end
	dxDrawRectangle(x + w/4, y+self.y*.075+cY, w/2, self.y*0.035, tocolor(255,0,0, ap))
	dxText('Salir', x + w/4, y+self.y*.075+cY, w/2, self.y*0.035, nil, 0.5*self.s, self.s*0.6, 'bankgothic', 'center', 'center')

	self.click = getKeyState 'mouse1'
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		toys:init()
		if localPlayer.name == 'Thomp' then
		--	toys:load()
		end
	end
)

addEvent('showShopToys', true)
addEventHandler('showShopToys', root,
	function()
		toys:load()
	end
)

function dxText(t, x,y,w,h, ...)
	return dxDrawText(t, x, y, w+x, h+y, ...)
end

bindKey( "mouse_wheel_up", "down", function( )
    local w,h = toys.x*.38, toys.y*.58
	local x,y = toys.x * 0.03, toys.y/2 - h/2
    if toys.visible and isCursorOver(x,y,w,h) then
        if toys.scroll > 1 then
            toys.scroll = toys.scroll - 1
        end
    end
end)

bindKey( "mouse_wheel_down", "down", function( )
    local w,h = toys.x*.38, toys.y*.58
	local x,y = toys.x * 0.03, toys.y/2 - h/2
    if toys.visible and isCursorOver(x,y,w,h) then
        if toys.scroll < #Accesorios[toys.type]-4 then
            toys.scroll = toys.scroll+1
        end
    end
end)

bindKey( "pgup", "down", function( )
    local w,h = toys.x*.38, toys.y*.58
	local x,y = toys.x * 0.03, toys.y/2 - h/2
    if toys.visible and isCursorOver(x,y,w,h) then
        if toys.scroll > 1 then
            toys.scroll = toys.scroll - 1
        end
    end
end)

bindKey( "pgdn", "down", function( )
    local w,h = toys.x*.38, toys.y*.58
	local x,y = toys.x * 0.03, toys.y/2 - h/2
    if toys.visible and isCursorOver(x,y,w,h) then
        if toys.scroll < #Accesorios[toys.type]-4 then
            toys.scroll = toys.scroll+1
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