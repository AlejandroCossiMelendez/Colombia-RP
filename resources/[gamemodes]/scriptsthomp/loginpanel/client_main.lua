local sx, sy	= guiGetScreenSize()
local loginError = ""

local rtick = getTickCount(  )

function renderLogin()

	local it = interpolateBetween( 0,0,0,0.005,0,0, (getTickCount(  )-rtick)/800, "SineCurve" )
	dxDrawImage(sx*(0.3-it), sy*(0.28-it), sx*(0.4+it*2), sy*(0.045+it*2), 'file/logo.png')

	dxDrawRoundedRectangle(sx*0.35, sy*0.35, sx*0.3, sy*0.3, tocolor(0,0,0, 180), 20)
	dxDrawImage(sx*0.5-sx*0.040/2, sy*0.355, sx*0.040, sy*0.040, 'file/user.png')
	dxDrawImage(sx*0.5-sx*0.040/2, sy*0.445, sx*0.040, sy*0.040, 'file/pass.png')

	dxDrawRectangle(sx*0.5 - sx*0.19/2, sy*0.55, sx*0.19, sy*0.035, tocolor(255,151,16,150),false)
	dxDrawText('Iniciar Sesión', sx*0.5 - sx*0.19/2, sy*0.55, sx*0.19+sx*0.5 - sx*0.19/2, sy*0.035+sy*0.55, tocolor(255,255,255), 0.6, 0.7, 'bankgothic', "center", "center", false, false, false, false, false, 0, 0, 0)
	dxDrawRectangle(sx*0.5 - sx*0.19/2, sy*0.6, sx*0.19, sy*0.035, tocolor(255,151,16,150),false)
	dxDrawText('Registrarme', sx*0.5 - sx*0.19/2, sy*0.6, sx*0.19+sx*0.5 - sx*0.19/2, sy*0.035+sy*0.6, tocolor(255,255,255), 0.6, 0.7, 'bankgothic', "center", "center", false, false, false, false, false, 0, 0, 0)

	if #loginError > 0 then 
		dxDrawRectangle(0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' ), tocolor(0,0,0,150), false)
		dxDrawText(loginError, 0, (sy/2 + (0.33*sy)/1.5), sx, dxGetFontHeight(1, 'default-bold' )+(sy/2 + (0.33*sy)/1.5), tocolor(255,151,16,255), 1, 'default-bold', "center", "center", false, false,false)
	end

	if not mouseClick and getKeyState( 'mouse1' ) then
		if isCursorOver(sx*0.5 - sx*0.19/2, sy*0.55, sx*0.19, sy*0.035) then
			local username = dxEditGetText(UsuarioE)
			local password = dxEditGetText(ClaveE)
			outputConsole(username..''..password)
			if #username >= 3 and #password >= 5 then
				triggerServerEvent("server:login",localPlayer,username,password)
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 5 then
					loginError = "La clave debe de ser de 5 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		elseif isCursorOver(sx*0.5 - sx*0.19/2, sy*0.6, sx*0.19, sy*0.035) then
			local username = dxEditGetText(UsuarioE)
			local password = dxEditGetText(ClaveE)
			if #username >= 3 and #password >= 8 then
				if true then
					triggerServerEvent("server:register",localPlayer,username,password)
				end
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 8 then
					loginError = "La clave debe de ser de 8 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		end
	end
	mouseClick = getKeyState( 'mouse1' )
end




function resetLoginError()
	loginError = ""
end

addEvent( "players:loginResult", true )
addEventHandler( "players:loginResult", getLocalPlayer( ),
	function( code )
		if code == 1 then
			loginError = "Usuario o contraseña incorrectos."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 2 then
			--show( 'banned', true )
			loginError = "El usuario se encuentra baneado."
		elseif code == 3 then
            --showChat(true)
            --show( 'activation_required', false )
			--iniTest()
			loginError = "El usuario requiere pasar test de rol."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 4 then
			loginError = "Error desconocido, inténtalo de nuevo."
		elseif code == 5 then
			loginError = "Otra persona está usando tu cuenta."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 6 then
			--show( 'deactivation', true )
			loginError = "El usuario está desactivado."
			setTimer(resetLoginError, 2000, 1)
		end
	end
)
	
addEvent( "players:registrationResult", true )
addEventHandler( "players:registrationResult", getLocalPlayer( ),
	function( code, message )
		if code == 0 then
			local username = dxEditGetText(UsuarioE)
			local password = dxEditGetText(ClaveE)
			triggerServerEvent("server:login",getLocalPlayer(),username,password)
		elseif code == 1 then
			loginError = "Error en el registro, prueba más tarde."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 2 then
			loginError = "Error, el registro está deshabilitado."
		elseif code == 3 then
			loginError = "Error, este usuario ya existe."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 4 then
			loginError = "Error en el registro, prueba más tarde."
			setTimer(resetLoginError, 2000, 1)
		elseif code == 5 then
			loginError = "Solo se permite una cuenta por serial."
		elseif code == 6 then
			loginError = "Solo se permiten dos cuentas por IP."
	    end
	end	
)

addEvent( "client:recoverFailed", true )
addEventHandler( "client:recoverFailed", getLocalPlayer( ),
	function( )
		loginError = "Error grave, inténtalo más tarde."
		setTimer(resetLoginError, 2000, 1)
	end	
)

addEvent("client:init:callBack",true)
addEventHandler("client:init:callBack",root,
function(serialRegistered)
	triggerServerEvent('server:checkRolTest_', resourceRoot)
end
)

addEvent("client:checkRolTest_",true)
addEventHandler("client:checkRolTest_",root,
	function(bool)
		showCursor(true)
		if bool then
			if not UsuarioE and not ClaveE then
				addEventHandler( "onClientRender", getRootElement(),renderLogin)
				UsuarioE = dxEdit(sx*0.5 - sx*0.17/2, sy*0.4, sx*0.17, sy*0.038, 'Ususario', 'default-bold', tocolor(255,255,255,200), tocolor(50,50,50,255), true, false, 2.7, nil, tocolor(255,151,16,150))
				ClaveE = dxEdit(sx*0.5 - sx*0.17/2, sy*0.49, sx*0.17, sy*0.038, 'Contraseña', 'default-bold', tocolor(255,255,255,200), tocolor(50,50,50,255), true, true, 2.7, nil, tocolor(255,151,16,150))
			end
		else
			displayTestRol()
		end
	end
)

addEvent("onDestroyLoginPanel",true)
addEventHandler("onDestroyLoginPanel",root,
function()
	showCursor(false)
	removeEventHandler("onClientRender",root,renderLogin)

	if UsuarioE then
		dxEditDestroy(UsuarioE)
	end
	if ClaveE then
		dxEditDestroy(ClaveE)
	end
end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
	--	triggerEvent('client:init:callBack', localPlayer)
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

--[[

function blurRender ()
    if isElement( lp.blur.shader ) and isElement( lp.blur.screensource ) then
		dxUpdateScreenSource(lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "ScreenSource", lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "UVSize", sX, sY)
		dxSetShaderValue(lp.blur.shader, "BlurStrength", 9 )	
        dxDrawImage(0, 0, sX, sY, lp.blur.shader)
    else
		if not isElement( lp.blur.shader ) then
			lp.blur.shader = dxCreateShader("img/blur.fx")
		end
		if not isElement( lp.blur.screensource ) then
			lp.blur.screensource = dxCreateScreenSource(sX,sY)
		end		
		dxSetShaderValue(lp.blur.shader, "ScreenSource", lp.blur.screensource)
		dxSetShaderValue(lp.blur.shader, "UVSize", sX, sY)
		dxSetShaderValue(lp.blur.shader, "BlurStrength", 9 )	
        dxDrawImage(0, 0, sX, sY, lp.blur.shader)
	end
end       

function drawLogin()
	dxDrawText2("Vendetta RolePlay",sX/2 - (400*x)/2,0,400*x,160*y,tocolor(255,255,255,255),3*fontsize,"arial","center","bottom")
	dxDrawRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(0,0,0,100),8*x)
	
	dxDrawEdit(UsuarioE)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + 105*y,30*y,30*y,"img/username.png")
	
	dxDrawEdit(ClaveE)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,30*y,30*y,"img/password.png")
	                                  
	dxDrawText2(tostring(loginError),(sX/2 - (270*x)/2),sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,255),1.8*fontsize,"default-bold","center","center")
	
	dxDrawButton(lp.login.button)
	
	dxDrawButton(lp.forgotpass.fpass)
	dxDrawEmptyRectangle(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,tocolor(0,0,0,255),1)
end

function drawRegister()
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 25*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 125*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 225*y,22*x,2,tocolor(0,0,0,150))
	dxDrawText2("¿No tienes cuenta? ¡Crea una!",(sX/2 - (400*x)/2) - 280*x,0,250*x,250*y,tocolor(255,255,255,255),1.5*fontsize,"arial","center","bottom")
	dxDrawRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(0,0,0,100),1)
	
	if not lp.hasAccount then               
		dxDrawEdit(UsuarioE)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (60*y),30*y,30*y,"img/username.png")
		
		dxDrawEdit(ClaveE)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (100*y),30*y,30*y,"img/password.png")
		
		dxDrawEdit(lp.register.repassword)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (140*y),30*y,30*y,"img/password.png")

		dxDrawButton(lp.register.button)
	else
		dxDrawText2("¡Sólo 1 cuenta por PC!",(sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,255),1.8*fontsize,"default-bold","center","center")
	end
end

function drawForgot()
	dxDrawRectangle((sX/2 - (400*x)/2) + 200*x,sY/2 + (410*y)/2 + 8*x,2,22*x,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(0,0,0,100),1)
	dxDrawEdit(lp.forgotpass.pass)
	dxDrawButton(lp.forgotpass.button)
end
local lp = {
			hasAccount		= true,
			blur			= {
							shader 			= dxCreateShader("img/blur.fx"),
							screensource	= dxCreateScreenSource(sX,sY),
			},
			
			login			= {
							showpass		= false,
							savepass		= false,
			},
			
			register 		= {
							
			},
			
			forgotpass		= {
			
			},

}

function showLogin(serialRegistered)
	showCursor(true)
	
	lp.login.button = dxCreateButton(sX/2 - (150*x)/2,( sY/2 - (410*y)/2 ) + (260*y),150*x,30*y,"Login",tocolor(0,0,0,255))
	UsuarioE = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + 105*y,270*x,30*y,1.5*fontsize,"Usuario")
	if serialRegistered then
		lp.hasAccount = true
	else
		lp.hasAccount = false
	end
	lp.login.password = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,270*x,30*y,1.5*fontsize,"Clave")
	dxSetEditMask(lp.login.password,true)
	
	lp.register.button = dxCreateButton((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (100*x)/2,( sY/2 - (250*y)/2 ) + (200*y),100*x,30*y,"Registrar",tocolor(0,0,0,255))
	UsuarioE = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (60*y),170*x,30*y,1.5*fontsize,"Usuario")
	ClaveE = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (100*y),170*x,30*y,1.5*fontsize,"Clave")
	dxSetEditMask(ClaveE,true)
	lp.register.repassword = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (140*y),170*x,30*y,1.5*fontsize,"Confirma clave")
	dxSetEditMask(lp.register.repassword,true)
	
	lp.forgotpass.fpass = dxCreateButton(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,"¿Olvidaste tu clave?",tocolor(41,130,206,255),1*fontsize)
	lp.forgotpass.pass = dxCreateEdit((sX/2 - (230*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 20*y,230*x,30*y,1.5*fontsize,"Nueva clave")
	lp.forgotpass.button = dxCreateButton((sX/2 - (100*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 70*y,100*x,20*y,"Continuar",tocolor(0,0,0,255),1*fontsize)
	
	addEventHandler("onClientRender",root,blurRender)
	addEventHandler("onClientRender",root,drawLogin)
	addEventHandler("onClientRender",root,drawRegister)
	
end]]

