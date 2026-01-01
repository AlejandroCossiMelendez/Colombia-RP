local sx, sy = GuiElement.getScreenSize()
local genero = 'hombre'
local raza = 'negro'
local R,G,B, Noti = 174, 0, 180,''
local count = {
	blanco = 0,
	negro = 0,
}

local count2 = {
	blanco = false,
	negro = false,
}

local clot = {
	cami = {{Texture = "vestblack", Model = "vest"}, {Texture = "tshirtbobomonk", Model = "tshirt"}, index=0},
	pant = {{Texture = "chinosblack", Model = "chinosb"}, {Texture = "shortsgrey", Model = "shorts"}, index=2},
	zap =  {{Texture = "convproblk", Model = "conv"}, {Texture = "sneakerbincblk", Model = "sneaker"}, index=3},

	c=1,
	p=1,
	z=1,
}



local skinsF = {69,55}

function show()
	if not isElement(ped) then
		ped = Ped(0, 2104.3837890625, -103.1298828125, 2.1924433708191, 303.09817504883)
		ped:setHeadless(true)
	end

	if not isEventHandlerAdded( "onClientRender", getRootElement(), createRender) then
		addEventHandler( "onClientRender", getRootElement(), createRender)
	end
	if not nameE then
		nameE = dxEdit(sx*0.14, sy*0.377, sx*0.16, sy*0.028, '', 'default-bold', tocolor(255,255,255,200), tocolor(0,0,0,255), true, false, 2.2, nil, tocolor(174, 0, 180))
	end
	if not edadE then
		edadE = dxEdit(sx*0.14, sy*0.44, sx*0.16, sy*0.028, '', 'default-bold', tocolor(255,255,255,200), tocolor(0,0,0,255), true, false, 2.2, nil, tocolor(174, 0, 180))
	end

	dxEditVisible(nameE, true)
	dxEditVisible(edadE, true)
	
	exports.gui:hide( )
	guiSetInputEnabled( true )
	showCursor(true)
	setCameraMatrix(2107.29833984375, -101.2528991699219, 3.272200107574463, 2106.465576171875, -101.7892532348633, 3.135133028030396, 0, 70 )
end
addEvent('showCrearPersonaje', true)
addEventHandler('showCrearPersonaje', root, show)

function hide()
	showCursor(not true)
	if isElement(ped) then
		ped:destroy()
	end

	if isEventHandlerAdded( "onClientRender", getRootElement(), createRender) then
		removeEventHandler( "onClientRender", getRootElement(), createRender)
	end

	dxEditVisible(nameE, false)
	dxEditVisible(edadE, false)
	guiSetInputEnabled( false )

	removeCabeza()
end

function createRender()

	if #Noti > 0 then 
		dxDrawRectangle(0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' ), tocolor(0,0,0,150), false)
		dxDrawText(Noti, 0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' )+(sy/2 + (0.33*sy)/1.5), tocolor(R,G,B,255), 1, 'default-bold', "center", "center", false, false,false)
	end

	dxDrawRoundedRectangle(sx*0.07, sy*0.3, sx*0.30, sy*0.4, tocolor(0,0,0,180), 8)
	dxDrawText2('Creación de Personaje', sx*0.07, sy*0.3, sx*0.30, sy*0.02, tocolor(174, 0, 180), 0.6, 0.7, 'bankgothic', 'center')


	dxDrawText2('Nombre Apellido', sx*0.07, sy*0.35, sx*0.30, sy*0.02, tocolor(255,255,255), 0.4, 0.5, 'bankgothic', 'center')
	dxDrawText2('Edad', sx*0.07, sy*0.415, sx*0.30, sy*0.02, tocolor(255,255,255), 0.4, 0.5, 'bankgothic', 'center')

	dxDrawText2('Genero', sx*0.07, sy*0.475, sx*0.30, sy*0.02, tocolor(255,255,255), 0.4, 0.5, 'bankgothic', 'center')

	dxDrawImage(sx*0.175, sy*0.5, sx*0.035, sy*0.035, 'img/hombre.png')
	dxDrawImage(sx*0.225, sy*0.5, sx*0.035, sy*0.035, 'img/mujer.png')

	dxDrawText2('Raza', sx*0.07, sy*0.55, sx*0.30, sy*0.02, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center')
	dxDrawImage(sx*0.175, sy*0.58, sx*0.035, sy*0.035, 'img/blanco.png')
	dxDrawImage(sx*0.225, sy*0.58, sx*0.035, sy*0.035, 'img/negro.png')

	dxDrawRoundedRectangle(sx*0.14, sy*0.65, sx*0.16, sy*0.03, tocolor(174, 0, 180,180), 8)
	dxDrawText2('Crear Personaje', sx*0.14, sy*0.65, sx*0.16, sy*0.03, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center', 'center')

	dxDrawRoundedRectangle(sx*0.33, sy*0.65, sx*0.03, sy*0.03, tocolor(174, 0, 180,180), 8)
	dxDrawText2('X', sx*0.33, sy*0.65, sx*0.03, sy*0.03, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center', 'center')

	if genero == 'hombre' then

		dxDrawRoundedRectangle(sx*0.7, sy*0.3, sx*0.23, sy*0.4, tocolor(0,0,0,180), 8)
		dxDrawText2('Personalizar Personaje', sx*0.7, sy*0.3, sx*0.23, sy*0.02, tocolor(174, 0, 180), 0.5, 0.6, 'bankgothic', 'center')

		dxDrawText2('Cabeza', sx*0.7, sy*0.35, sx*0.23, sy*0.02, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center')

		dxDrawRectangle(sx*0.76, sy*0.38, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('<', sx*0.76, sy*0.38, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')
		
		dxDrawRectangle(sx*0.82, sy*0.38, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('>', sx*0.82, sy*0.38, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')

		dxDrawText2('Camiseta', sx*0.7, sy*0.42, sx*0.23, sy*0.02, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center')

		dxDrawRectangle(sx*0.76, sy*0.45, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('<', sx*0.76, sy*0.45, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')
		
		dxDrawRectangle(sx*0.82, sy*0.45, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('>', sx*0.82, sy*0.45, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')

		dxDrawText2('Pantalon', sx*0.7, sy*0.49, sx*0.23, sy*0.02, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center')

		dxDrawRectangle(sx*0.76, sy*0.52, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('<', sx*0.76, sy*0.52, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')
		
		dxDrawRectangle(sx*0.82, sy*0.52, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('>', sx*0.82, sy*0.52, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')

		dxDrawText2('Zapatos', sx*0.7, sy*0.56, sx*0.23, sy*0.02, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center')

		dxDrawRectangle(sx*0.76, sy*0.59, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('<', sx*0.76, sy*0.59, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')
		
		dxDrawRectangle(sx*0.82, sy*0.59, sx*0.05, sy*0.025, tocolor(174, 0, 180,180))
		dxDrawText2('>', sx*0.82, sy*0.59, sx*0.05, sy*0.025, tocolor(255,255,255), 0.45, 0.55, 'bankgothic', 'center','center')

	end
	if not click and getKeyState( 'mouse1' ) then

		if isCursorOver(sx*0.33, sy*0.65, sx*0.03, sy*0.03) then
			hide()
			exports.gui:show( 'characters', false, false, true )
		elseif isCursorOver(sx*0.14, sy*0.65, sx*0.16, sy*0.03) then

			local name = dxEditGetText(nameE)
			local error = exports.gui:verifyCharacterName(name)
			if not error then
				local edad = tonumber(dxEditGetText(edadE)) or 0
				if edad >= 10 and edad <= 100 then
					if genero == 'mujer' or count2[raza] then
						local strClothes = ''
						local t = 0
						for i = 0, 16 do
							local textura = getPedClothes(ped, i)
							if textura then
								local idUnico = exports.ropas:getIdUnico(tostring(textura))
								if idUnico then
									if t == 0 then
										t = 1
										strClothes = tostring(idUnico)
									else
										strClothes = strClothes..","..tostring(idUnico)
									end
								end
							end
						end
						--print(name, edad, (genero == 'hombre' and 1 or 2), (raza == 'blanco' and 1 or 0), strClothes)			
						triggerServerEvent('gui:createCharacter', localPlayer, name, edad, (genero == 'hombre' and 1 or 2), (raza == 'blanco' and 1 or 0), strClothes, (genero == 'hombre' and _cabezas[raza][count2[raza]][1] or false))
					else
						setNoti(2, 'Selecciona una cabeza.', 1700)
					end
				else
					setNoti(2, 'La edad debe de estar entre 10 y 100.', 2500)
				end
			else
				setNoti(2, error, 2500)
			end

		elseif isCursorOver(sx*0.175, sy*0.5, sx*0.035, sy*0.035) then

			genero = 'hombre'
			ped:setModel(0)
			ped:setHeadless(true)

		elseif isCursorOver(sx*0.225, sy*0.5, sx*0.035, sy*0.035) then

			genero = 'mujer'
			ped:setHeadless(false)
			ped:setModel(raza=='negro' and 69 or 55)
			removeCabeza()

		elseif isCursorOver(sx*0.175, sy*0.58, sx*0.035, sy*0.035) then
			if genero == 'hombre' then
				triggerEvent('onSolicitarRopaBlanco', ped)
				removeCabeza()
				count2.negro = false
			else
				ped:setModel(55)
			end
			raza = 'blanco'
		elseif isCursorOver(sx*0.225, sy*0.58, sx*0.035, sy*0.035) then
			if genero == 'hombre' then
				triggerEvent('onResetRopaBlanco', ped)
				removeCabeza()
				count2.blanco = false
			else
				ped:setModel(69)
			end
			raza = 'negro'
		end


		if genero == 'hombre' then

			local update = false
			if isCursorOver(sx*0.76, sy*0.38, sx*0.05, sy*0.025) then
				if not count2[raza] or count2[raza] > 1 then
					testCabeza(ped, raza, -1)
				end
			elseif isCursorOver(sx*0.82, sy*0.38, sx*0.05, sy*0.025) then
				if not count2[raza] or count2[raza] < #_cabezas[raza] then
					testCabeza(ped, raza, 1)
				end
			elseif isCursorOver(sx*0.76, sy*0.45, sx*0.05, sy*0.025) then
				clot.c = clot.c == 1 and 2 or 1
				update = true
				local textC,modC, ic = clot.cami[clot.c].Texture, clot.cami[clot.c].Model, clot.cami.index
				addPedClothes(ped, textC,modC, ic )
			elseif isCursorOver(sx*0.82, sy*0.45, sx*0.05, sy*0.025) then
				clot.c = clot.c == 1 and 2 or 1
				update = true
				local textC,modC, ic = clot.cami[clot.c].Texture, clot.cami[clot.c].Model, clot.cami.index
				addPedClothes(ped, textC,modC, ic )
			elseif isCursorOver(sx*0.76, sy*0.52, sx*0.05, sy*0.025) then
				clot.p = clot.p == 1 and 2 or 1
				update = true
				local textP,modP, ip = clot.pant[clot.p].Texture, clot.pant[clot.p].Model, clot.pant.index
				addPedClothes(ped, textP,modP, ip )
			elseif isCursorOver(sx*0.82, sy*0.52, sx*0.05, sy*0.025) then
				clot.p = clot.p == 1 and 2 or 1
				update = true
				local textP,modP, ip = clot.pant[clot.p].Texture, clot.pant[clot.p].Model, clot.pant.index
				addPedClothes(ped, textP,modP, ip )
			elseif isCursorOver(sx*0.76, sy*0.59, sx*0.05, sy*0.025) then
				clot.z = clot.z == 1 and 2 or 1
				update = true
				local textZ,modZ, iz = clot.zap[clot.z].Texture, clot.zap[clot.z].Model, clot.zap.index		
				addPedClothes(ped, textZ,modZ, iz )
			elseif isCursorOver(sx*0.82, sy*0.59, sx*0.05, sy*0.025) then
				clot.z = clot.z == 1 and 2 or 1
				update = true
				local textZ,modZ, iz = clot.zap[clot.z].Texture, clot.zap[clot.z].Model, clot.zap.index		
				addPedClothes(ped, textZ,modZ, iz )
			end
				
			
			--triggerEvent('onResetRopaBlanco', ped)
			if raza ~= 'negro' then triggerEvent('onSolicitarRopaBlanco', ped) end

		end
	end

	click = getKeyState( 'mouse1' )
end


addEventHandler( "onClientResourceStart", resourceRoot,
	function()
	end
)


addEvent("players:characterCreationResult", true)
addEventHandler("players:characterCreationResult", root,
	function(tipo)
		if tipo == 1 then
			setNoti(1, 'El nombre ya existe.', 2000)
		else
			setNoti(1, 'Personaje creado...', 2000)
			hide()
		end
	end
)


function dxDrawText2(t,x,y,w,h,...)
	return dxDrawText(t,x,y,w+x,h+y,...)
end

function setNoti(t, text, time)
	Noti = text
	if t == 1 then
		R,G,B = 174, 0, 180
	else
		R,G,B = 255,0,0
	end
	if isTimer(timenoti) then
		resetTimer( timenoti )
	else
		timenoti =setTimer(function() Noti = '' end,time,1)
	end
end

function removeCabeza()
	if isElement(obH) then
		obH:destroy()
	end
end

function testCabeza(ped, raza, i)
	removeCabeza()

	count2[raza] = math.max((count2[raza] or 0) + i,1)
	local id, x,y,z,rx,ry,rz = unpack(_cabezas[raza][count2[raza]])

	obH = Object(id, ped.position)
	obH:setCollisionsEnabled(false)

	Timer(function(ped,x,y,z,rx,ry,rz)
		exports.bone_attach:attachElementToBone(obH, ped, 1, x,y,z,rx,ry,rz)--52
	end, 150, 1, ped,x,y,z,rx,ry,rz)
end


function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end




function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

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

function getRandDiff(rango, diff)
	local diff = diff or 0
	local rand = math.random(rango)
	while diff == rand do
		rand = math.random(rango)
	end
	return rand
end



--etClipboard(toJSON({getCameraMatrix()}))

--[ [  ] ]