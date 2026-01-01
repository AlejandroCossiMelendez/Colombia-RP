local total = #preguntas
local minimas = 10
local correctas = 0
local current = 1

local font2 = 'default-bold'
local font1 = 'default-bold'


local selected = false
local click = false

local p1 = 0
local NotiRol = ''

local sx,sy = guiGetScreenSize(  )

function onTestRol()

	if removerTestRoll then
		return
	end

	if #NotiRol > 0 then 
		dxDrawRectangle(0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' ), tocolor(0,0,0,150), false)
		dxDrawText(NotiRol, 0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' )+(sy/2 + (0.33*sy)/1.5), tocolor(R,G,B,255), 1, 'default-bold', "center", "center", false, false,false)
	end

	if current > total then return end
	local mx = 0.001 * sx

	local quest = preguntas[current]
	dxDrawRoundedRectangle( sx/2 - 0.175*sx, sy/2 - 0.15*sy, 0.35*sx,  0.35*sy,tocolor(0,0,0,180), 15)
	--dxDrawRoundedRectangle( sx/2 - 0.175*sx, sy/2 - 0.15*sy, 0.35*sx,  0.35*sy, 10, tocolor(205,110,205,250), false )

	dxDrawText('> Test de Rol Vendetta RP <',  sx/2 - 0.175*sx, sy/2 - 0.14*sy, 0.35*sx + (sx/2 - 0.175*sx),  0.3*sy + (sy/2 - 0.14*sy), tocolor(0,32,232,255), 1, font2, "center", "top", false, false,false)
	
	dxDrawText(' - Pregunta -', sx * 0.3262, sy * 0.4023, sx * 0.6738, sy * 0.4258, tocolor(255,255,255,255), 1, font2, "center", "center", false, true,false)
	dxDrawText(''..quest[1],  sx * 0.3262, sy * 0.4336, sx * 0.6738, sy * 0.4753, tocolor(255,255,255,255), 1, font1, "center", "top", false, true,false)
        
   	dxDrawRectangle(sx * 0.3398, sy * 0.4922, sx * 0.0176, sy * 0.0221, tocolor(255,255,255,200), false)
	dxDrawText(""..quest[2], sx * 0.3652, sy * 0.4922, sx * 0.6494, sy * 0.5326, tocolor(255, 255, 255, 255), 1.00, font1, "left", "top", true, true, false, false, false)
    
    if selected == 1 then
   		dxDrawRectangle(sx * 0.3398 + mx, sy * 0.4922 + mx, sx * 0.0176 - mx*2, sy * 0.0221 - mx*2, tocolor(0,32,232,200), false)
    end

    dxDrawRectangle(sx * 0.3398, sy * 0.5469, sx * 0.0176, sy * 0.0221, tocolor(255,255,255,200), false)
    dxDrawText(""..quest[3], sx * 0.3652, sy * 0.5469, sx * 0.6494, sy * 0.5872, tocolor(255, 255, 255, 255), 1.00, font1, "left", "top", true, true, false, false, false)
    
    if selected == 2 then
   		dxDrawRectangle(sx * 0.3398 + mx, sy * 0.5469 + mx, sx * 0.0176 - mx*2, sy * 0.0221 - mx*2, tocolor(0,32,232,200), false)
    end

    dxDrawRectangle(sx * 0.3398, sy * 0.6042, sx * 0.0176, sy * 0.0221, tocolor(255,255,255,200), false)
    dxDrawText(""..quest[4], sx * 0.3652, sy * 0.6042, sx * 0.6494, sy * 0.6445, tocolor(255, 255, 255, 255), 1.00, font1, "left", "top", true, true, false, false, false)

    if selected == 3 then
   		dxDrawRectangle(sx * 0.3398 + mx, sy * 0.6042 + mx, sx * 0.0176 - mx*2, sy * 0.0221 - mx*2, tocolor(0,32,232,200), false)
    end

    dxDrawRoundedRectangle(sx * 0.4297 + p1, sy * 0.6523 + p1, sx * 0.1406 - p1*2, sy * 0.0352 - p1*2, tocolor(0,32,232,200), 12)
    dxDrawText("Aceptar", sx * 0.4297 + p1, sy * 0.6523 + p1, (sx * 0.1406 + sx * 0.4297) - p1, (sy * 0.0352 + sy * 0.6523) - p1, tocolor(255, 255, 255, 255), 1.00, font2, "center", "center", false, false, false, false, false)

    

    if getKeyState( 'mouse1' ) and not click then

    	if isCursorOver(sx * 0.3398, sy * 0.4922, sx * 0.0176, sy * 0.0221) then
    		selected = 1
    	elseif isCursorOver(sx * 0.3398, sy * 0.5469, sx * 0.0176, sy * 0.0221) then
    		selected = 2
    	elseif isCursorOver(sx * 0.3398, sy * 0.6042, sx * 0.0176, sy * 0.0221) then
    		selected = 3
    	elseif isCursorOver(sx * 0.4297 + p1, sy * 0.6523 + p1, sx * 0.1406 - p1*2, sy * 0.0352 - p1*2) then

    		p1 = 0.004 * sx
			if not tp3 or not tp3:isValid() then tp3 = Timer(function() p1=0 validateAnswer() end,50,1) end

     	end

    end


    click = getKeyState( 'mouse1' )
end
--addEventHandler( "onClientRender", getRootElement(), onTestRol)

function validateAnswer()

	if selected then

		if current <= total then

			if preguntas[current][5] == selected then
				correctas = correctas + 1
			end

			current = current + 1

			if current > total then
				if correctas >= minimas then

					notiTest('Pasaste el test de rol, guardando...',0,32,232)

					setTimer(removeTestRol, 5000,1)
					

				else

					triggerServerEvent('server:noPasedRolTest_', resourceRoot)

				end
			end

			selected = false
		end

	else
		notiTest('Selecciona una respuesta',255,0,0)
	end

end


function notiTest(text,r,g,b)
	NotiRol = text
	R,G,B = r or 255,g or 255,b or 255
	if timeNotiRol and timeNotiRol:isValid() then
		resetTimer( timeNotiRol )
	else
		timeNotiRol=Timer(function() NotiRol = ''; R,G,B = 255,255,255 end,5000,1)
	end
end

function removeTestRol()
	removerTestRoll = true
	removeEventHandler("onClientRender", getRootElement(), onTestRol)
	triggerServerEvent('server:saveRolTest_', resourceRoot)
end

function displayTestRol()
	addEventHandler( "onClientRender", getRootElement(), onTestRol)
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius, segs)
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

        dxDrawCircle(x, y, radius, 180, 270, color, color, segs or 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, segs or 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, segs or 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, segs or 7)
    end
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