local sx,sy = guiGetScreenSize(  )
local Noti = 'Cuenta creada con exitó'
addEventHandler( "onClientRender", getRootElement(),
	function()

		dxDrawImage(sx*0.3, sy*0.28, sx*0.4, sy*0.045, 'file/logo.png')

		dxDrawRoundedRectangle(sx*0.35, sy*0.35, sx*0.3, sy*0.3, tocolor(0,0,0, 180), 20)
		dxDrawImage(sx*0.5-sx*0.040/2, sy*0.355, sx*0.040, sy*0.040, 'file/user.png')
		dxDrawImage(sx*0.5-sx*0.040/2, sy*0.445, sx*0.040, sy*0.040, 'file/pass.png')

		dxDrawRectangle(sx*0.5 - sx*0.19/2, sy*0.55, sx*0.19, sy*0.035, tocolor(255,151,16,150),false)
		dxDrawText('Iniciar Sesión', sx*0.5 - sx*0.19/2, sy*0.55, sx*0.19+sx*0.5 - sx*0.19/2, sy*0.035+sy*0.55, tocolor(255,255,255), 0.6, 0.7, 'bankgothic', "center", "center", false, false, false, false, false, 0, 0, 0)
		dxDrawRectangle(sx*0.5 - sx*0.19/2, sy*0.6, sx*0.19, sy*0.035, tocolor(255,151,16,150),false)
		dxDrawText('Registrarme', sx*0.5 - sx*0.19/2, sy*0.6, sx*0.19+sx*0.5 - sx*0.19/2, sy*0.035+sy*0.6, tocolor(255,255,255), 0.6, 0.7, 'bankgothic', "center", "center", false, false, false, false, false, 0, 0, 0)

		if #Noti > 0 then 
			dxDrawRectangle(0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' ), tocolor(0,0,0,150), false)
			dxDrawText(Noti, 0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' )+(sy/2 + (0.33*sy)/1.5), tocolor(255,151,16,255), 1, 'default-bold', "center", "center", false, false,false)
		end
	end
)

Usuario = dxEdit(sx*0.5 - sx*0.17/2, sy*0.4, sx*0.17, sy*0.038, 'Ususario', 'default-bold', tocolor(255,255,255,200), tocolor(50,50,50,255), true, false, 2.7, nil, tocolor(255,151,16,150))
Clave = dxEdit(sx*0.5 - sx*0.17/2, sy*0.49, sx*0.17, sy*0.038, 'Contraseña', 'default-bold', tocolor(255,255,255,200), tocolor(50,50,50,255), true, false, 2.7, nil, tocolor(255,151,16,150))



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
