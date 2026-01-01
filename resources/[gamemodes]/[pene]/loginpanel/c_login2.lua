--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local startCamera = getTickCount()
local actualCamera = 1





addEvent("client:forgotpass:callBack",true)
addEventHandler("client:forgotpass:callBack",root,
function(usernameCheck)
	if usernameCheck == true then
		addEventHandler("onClientRender",root,drawForgot)
	else
		addNotificationPanel('No puedes cambiar la clave a ese usuario...', {255, 0, 0})
		return
	end
end
)

addEvent( "client:recoverFailed", true )
addEventHandler( "client:recoverFailed", getLocalPlayer( ),
	function( )
		addNotificationPanel('Error Edvis20, intentelo más tarde y avise a un Administrador...', {255, 0, 0})
		return
	end	
)

addEvent( "players:loginResult", true )
addEventHandler( "players:loginResult", getLocalPlayer( ),
	function( code )
		if code == 1 then
			--loginError = "Usuario o contraseña incorrectos."
			--dxSetButtonEnabled(lp.login.button,true)
			--setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('Usuario o contraseña incorrectos...', {255, 0, 0})
			return
		elseif code == 2 then
			--show( 'banned', true )
			--loginError = "El usuario se encuentra baneado."
			addNotificationPanel('El usuario se encuentra baneado', {255, 0, 0})
			return
		elseif code == 3 then
            --showChat(true)
            --show( 'activation_required', false )
			--iniTest()
			--loginError = "El usuario requiere pasar test de rol."
			--dxSetButtonEnabled(lp.login.button,true)
			--setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('El usuario requiere pasar test de rol', {255, 0, 0})
			return
		elseif code == 4 then
			--loginError = "Error desconocido, inténtalo de nuevo."
			addNotificationPanel('Error desconocido, inténtalo de nuevo.', {255, 0, 0})
			return
		elseif code == 5 then
			--loginError = "Otra persona está usando tu cuenta."
			--dxSetButtonEnabled(lp.login.button,true)
			--setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('Otra persona está usando tu cuenta.', {255, 0, 0})
			return
		elseif code == 6 then
			--show( 'deactivation', true )
		--	loginError = "El usuario está desactivado."
		--	dxSetButtonEnabled(lp.login.button,true)
		--	setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('El usuario está desactivado.', {255, 0, 0})
			return
		elseif code == 7 then
			--show( 'deactivation', true )
			addNotificationPanel('Hora de hacer el test....', {255, 0, 0})
			triggerServerEvent ( "hacerTests", localPlayer )
			return
			--loginError = "Hacer test....."
		elseif code == 69 then
			--show( 'deactivation', true )
			addNotificationPanel('¡Hora del trailer!', {255, 0, 0})
			--triggerServerEvent ( "hacerTests", localPlayer )
			Fumada()
			return
			--loginError = "Hacer test....."
		end
	end
)

addEvent( "players:registrationResult", true )
addEventHandler( "players:registrationResult", getLocalPlayer( ),
	function( code, message )
		if code == 0 then
			local username = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
			local password = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')
			triggerServerEvent("server:login",getLocalPlayer(),username,password)
		elseif code == 1 then
			--loginError = "Error en el registro, prueba más tarde."
			--dxSetButtonEnabled(lp.register.button,true)
			--setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('Error en el registro, prueba más tarde.', {255, 0, 0})
			return
		elseif code == 2 then
			--loginError = "Error, el registro está deshabilitado."
			addNotificationPanel('Error, el registro está deshabilitado.', {255, 0, 0})
			return
		elseif code == 3 then
			--loginError = "Error, este usuario ya existe."
			--dxSetButtonEnabled(lp.register.button,true)
			--setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('Error, este usuario ya existe.', {255, 0, 0})
			return
		elseif code == 4 then
		--	loginError = "Error en el registro, prueba más tarde."
		--	dxSetButtonEnabled(lp.register.button,true)
		--	setTimer(resetLoginError, 2000, 1)
			addNotificationPanel('Error en el registro, prueba más tarde.', {255, 0, 0})
			return
		elseif code == 5 then
			--loginError = "Solo se permite una cuenta por serial."
			addNotificationPanel('Solo se permite una cuenta por serial.', {255, 0, 0})
			return
		elseif code == 6 then
			--loginError = "Solo se permiten dos cuentas por IP."
			addNotificationPanel('Solo se permiten dos cuentas por IP.', {255, 0, 0})
			return
	    end
	end	
)



local camPosition = {
  {-350.84765625, 968.5625, 61.665813446045,-153.0634765625, 833.068359375, 66.786506652832,15000,'Linear'},
  {-153.0634765625, 833.068359375, 66.786506652832,26.5166015625, 868.9677734375, 66.420745849609,8000,'Linear'},
  {26.5166015625, 868.9677734375, 66.420745849609,42.1845703125, 1142.359375, 48.239540100098,5000,'Linear'},
  {42.1845703125, 1142.359375, 48.239540100098,-68.396484375, 1213.033203125, 48.8376808166,8000,'OutQuad'},  
  {-68.396484375, 1213.033203125, 48.8376808166,-350.84765625, 968.5625, 61.665813446045,10000,'OutQuad'},  
}


function camera_render()
  local x,y,z = interpolateBetween(camPosition[actualCamera][1], camPosition[actualCamera][2], camPosition[actualCamera][3], camPosition[actualCamera][4], camPosition[actualCamera][5], camPosition[actualCamera][6], (getTickCount() - startCamera) / camPosition[actualCamera][7], camPosition[actualCamera][8])
  setCameraMatrix(x,y,z,-232.9033203125, 1090.5625, 62.517227172852)

  if (getTickCount()-startCamera) > camPosition[actualCamera][7] then
    if camPosition[actualCamera + 1] then
      actualCamera = actualCamera + 1
    else
      actualCamera = 1
    end

    startCamera = getTickCount()
  end
end

local sw,sh = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minzoom = 2
if sw < baseX then
    zoom = math.min(minzoom, baseX/sw)
end

local tick = getTickCount()
local action = 'login'
local regulamin = 0
local actionTick = false
local actionTypeLogin = 1
local actionTypeRegister = 1
local actionTypeContra = 1

local login,password = '',''

local notifications = {
  tick = getTickCount(),
  text = '',
  color = {255, 0, 0},
  back = false
}

images = {
  ['logo'] = exports['dxLibary']:createTexture(':loginpanel/images/logo.png', 'dxt5', false, 'clamp'),
  ['logo2'] = exports['dxLibary']:createTexture(':loginpanel/images/logo2.png', 'dxt5', false, 'clamp'),
  ['puls'] = exports['dxLibary']:createTexture(':loginpanel/images/puls.png', 'dxt5', false, 'clamp'),
}

local spawns = {
    {1464.6962890625,-1025.240234375,23.828125},
    {1815.591796875,-1406.1787109375,13.424609184265},
    {1898.0341796875, -1204.642578125, 19.497230529785},
    {1722.421875, -1880.5751953125, 13.564747810364},
    {1479.29296875,-1616.33203125,14.039297103882},
    {1128.494140625,-1458.0419921875,15.796875},
    {1954.005859375,-2177.2236328125,13.546875},
    {2176.724609375,-1761.84375,13.546875},
    {814.47265625,-1352.251953125,13.533407211304},
    {2232.46875,-1159.724609375,25.890625},
    {1225.6953125,-1094.9832763672,25.525096893311},
}

local cameras = {
  {pos={1679.4040527344,-1817.7581787109,59.880001068115,1679.9091796875,-1818.5628662109,59.568103790283, 1720.4075927734,-1739.6469726563,60.955799102783,1719.9841308594,-1738.8822021484,60.47021484375}, time=10},
  {pos={1720.4075927734,-1739.6469726563,60.955799102783,1719.9841308594,-1738.8822021484,60.47021484375, 1903.7032470703,-1752.0319824219,60.912601470947,1904.5310058594,-1752.3333740234,60.439357757568}, time=10},
  {pos={1903.7032470703,-1752.0319824219,60.912601470947,1904.5310058594,-1752.3333740234,60.439357757568, 2089.9248046875,-1929.3918457031,53.578701019287,2089.1147460938,-1928.9437255859,53.200824737549}, time=10},
  {pos={2089.9248046875,-1929.3918457031,53.578701019287,2089.1147460938,-1928.9437255859,53.200824737549, 2233.6147460938,-1644.34765625,54.288501739502,2234.0554199219,-1645.0322265625,53.707847595215}, time=10},
  {pos={2233.6147460938,-1644.34765625,54.288501739502,2234.0554199219,-1645.0322265625,53.707847595215, 1931.4125976563,-1443.5472412109,53.998699188232,1930.9786376953,-1442.7963867188,53.500869750977}, time=10},
  {pos={1931.4125976563,-1443.5472412109,53.998699188232,1930.9786376953,-1442.7963867188,53.500869750977, 1887.1563720703,-1227.5179443359,53.669399261475,1887.8627929688,-1226.9365234375,53.265636444092}, time=10},
}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function addNotificationPanel(text, color)
  notifications['text'] = text
  notifications['color'] = color
  notifications['tick'] = getTickCount()
  notifications['back'] = false
  notifications['visible'] = true
end
addEvent('addNotificationPanel', true)
addEventHandler('addNotificationPanel', resourceRoot, addNotificationPanel)




local checkbox = exports['dxLibary']:createTexture(':loginpanel/images/checkbox.png', 'dxt5', false, 'clamp')
local checkbox_selected = exports['dxLibary']:createTexture(':loginpanel/images/checkbox_selected.png', 'dxt5', false, 'clamp')


function lechuga()

 -- local action = 'login'
  startCamera = getTickCount()
  actualCamera = 1
  addEventHandler('onClientRender', root, camera_render)

  addEventHandler('onClientRender',getRootElement(),gui)
  
  
  
  exports['editbox']:createCustomEditbox('LOGGING-LOGIN1', 'Usuario...', sw, sh, 323/zoom, 42/zoom, false, '')
  exports['editbox']:createCustomEditbox('LOGGING-HASH1', 'Contraseña...', sw, sh, 323/zoom, 42/zoom, true, '')

 
  
  
  
  --setPlayerHudComponentVisible('all', false)
  setElementData(localPlayer, 'grey_shader', 1)
  --setElementData(localPlayer, 'wPaneluLogowania', true)
 -- setElementData(localPlayer, 'pokaz:hud', false)
  showCursor(true)
  showChat(false)
  fadeCamera(true)
  music(true)
  addEventHandler('onClientClick', root, clicked)
 -- triggerServerEvent('getSave', resourceRoot)

end

function gui()




  local tickTime = 500
  local animations = {
    ['button'] = {
      actionTick ~= false and {interpolateBetween(sw, 0, 0, 800, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(800, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {800, -1500},
    },
    ['checkbox'] = {
      actionTick ~= false and {interpolateBetween(sw - 30, 0, 0, 825, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(825, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {825, -1500},
    },
    ['editbox'] = {
      actionTick ~= false and {interpolateBetween(sw, 0, 0, 800, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack'), interpolateBetween(800, 0, 0, -1500, 0, 0, (getTickCount()-actionTick)/tickTime, 'OutBack')} or {800, -1500},
    },
  }
-- Login
  if action == 'login' then
    exports['editbox']:customEditboxSetPosition('LOGGING-LOGIN1', animations['editbox'][1][actionTypeLogin]/zoom, 444/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH1', animations['editbox'][1][actionTypeLogin]/zoom, 510/zoom)

  	exports['dxLibary']:dxLibary_createButton('Loguearse', animations['button'][1][actionTypeLogin]/zoom, 622/zoom, 324/zoom, 35/zoom, 3)

    if getElementData(localPlayer, 'zapamietajLogin') == 1 then
      dxDrawImage(animations['button'][1][actionTypeLogin]/zoom, 582/zoom, 19/zoom, 19/zoom, checkbox_selected, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
      dxDrawImage(animations['button'][1][actionTypeLogin]/zoom, 582/zoom, 19/zoom, 19/zoom, checkbox, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end

  	exports['dxLibary']:dxLibary_shadowText2('Recordar login', animations['checkbox'][1][actionTypeLogin]/zoom, 582/zoom, 953/zoom, 600/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'left', 'top', false, false, false, false, false)

    local x = math.sin(getTickCount()/500)*1
  	dxDrawImage((644 + x)/zoom, 220/zoom, 632/zoom, 194/zoom, images['logo'])

    local a = (math.sqrt(getSoundFFTData(sound, 2048, 2)[1])*256) or 150
    dxDrawImage((650 + x)/zoom, 190/zoom, 250/zoom, 250/zoom, images['puls'], 0, 0, 0, tocolor(0, 255, 0, a), false)

  	exports['dxLibary']:dxLibary_text('¿No tienes cuenta?  ¡Entonces registrate :D!', animations['button'][1][actionTypeLogin]/zoom + 1, 645/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('¿No tienes cuenta?  #FFFF00¡Entonces registrate :D!', animations['button'][1][actionTypeLogin]/zoom, 645/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	
	 exports['dxLibary']:dxLibary_text('¿Olvidaste tu contraseña?  ¡Entonces haz click aquí!', animations['button'][1][actionTypeLogin]/zoom + 1, 700/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('¿Olvidaste tu contraseña?  #FFFF00¡Entonces haz click aquí!', animations['button'][1][actionTypeLogin]/zoom, 700/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	
	
	exports['dxLibary']:dxLibary_text('PANEL DE LOGUEO', animations['button'][1][actionTypeLogin]/zoom + 1, 125/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 2, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('PANEL DE #FFFF00LOGUEO', animations['button'][1][actionTypeLogin]/zoom, 125/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, true, false)
-- REGISTRARSE
	elseif action == 'register' then
    exports['editbox']:customEditboxSetPosition('LOGGING-LOGIN1', animations['editbox'][1][actionTypeRegister]/zoom, 444/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH1', animations['editbox'][1][actionTypeRegister]/zoom, 510/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH2', animations['editbox'][1][actionTypeRegister]/zoom, 575/zoom)

    exports['dxLibary']:dxLibary_createButton('Crear cuenta', animations['button'][1][actionTypeRegister]/zoom, 675/zoom, 324/zoom, 35/zoom, 3)

    if regulamin == 1 then
      dxDrawImage(animations['button'][1][actionTypeRegister]/zoom, 640/zoom, 19/zoom, 19/zoom, checkbox_selected, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
      dxDrawImage(animations['button'][1][actionTypeRegister]/zoom, 640/zoom, 19/zoom, 19/zoom, checkbox, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end

  	exports['dxLibary']:dxLibary_shadowText2('Acepto todas las reglas del foro', animations['checkbox'][1][actionTypeRegister]/zoom, 640/zoom, 953/zoom, 600/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'left', 'top', false, false, false, false, false)

    local x = math.sin(getTickCount()/500)*1
  	dxDrawImage((644 + x)/zoom, 220/zoom, 632/zoom, 194/zoom, images['logo'])

    local a = (math.sqrt(getSoundFFTData(sound, 2048, 2)[1])*256) or 150
    dxDrawImage((650 + x)/zoom, 190/zoom, 250/zoom, 250/zoom, images['puls'], 0, 0, 0, tocolor(0, 255, 0, a), false)

  	exports['dxLibary']:dxLibary_text('¿Ya tienes cuenta?  ¡Entonces logueate!', animations['button'][1][actionTypeRegister]/zoom + 1, 750/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('¿Ya tienes cuenta?  #FFFF00¡Entonces logueate!', animations['button'][1][actionTypeRegister]/zoom, 750/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
	
	exports['dxLibary']:dxLibary_text('PANEL DE REGISTRO', animations['button'][1][actionTypeRegister]/zoom + 1, 125/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 2, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('PANEL DE #FFFF00REGISTRO', animations['button'][1][actionTypeRegister]/zoom, 125/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, true, false)
	
	-- Olvide mi contraseeña
	elseif action == 'contra' then
    exports['editbox']:customEditboxSetPosition('LOGGING-LOGIN1', animations['editbox'][1][actionTypeContra]/zoom, 444/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH1', animations['editbox'][1][actionTypeContra]/zoom, 510/zoom)
    exports['editbox']:customEditboxSetPosition('LOGGING-HASH2', animations['editbox'][1][actionTypeContra]/zoom, 575/zoom)

    exports['dxLibary']:dxLibary_createButton('Restablecer contraseña', animations['button'][1][actionTypeContra]/zoom, 675/zoom, 324/zoom, 35/zoom, 3)


  	exports['dxLibary']:dxLibary_text('¿Quieres volver donde antes?  ¡Entonces haz click aquí!', animations['button'][1][actionTypeContra]/zoom + 1, 750/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 1, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('¿Quieres volver donde antes?  #FFFF00¡Entonces haz click aquí!', animations['button'][1][actionTypeContra]/zoom, 750/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 1, 'default', 'center', 'center', false, false, false, true, false)


	exports['dxLibary']:dxLibary_text('PANEL DE RESTABLECEDOR DE CONTRASEÑA', animations['button'][1][actionTypeRegister]/zoom + 1, 125/zoom + 1, 1123/zoom + 1, 705/zoom + 1, tocolor(0, 0, 0, 255), 2, 'default', 'center', 'center', false, false, false, true, false)
  	exports['dxLibary']:dxLibary_text('PANEL DE RESTABLECEDOR DE #FFFF00CONTRASEÑA', animations['button'][1][actionTypeRegister]/zoom, 125/zoom, 1123/zoom, 705/zoom, tocolor(255, 255, 255, 255), 2, 'default', 'center', 'center', false, false, false, true, false)

    local x = math.sin(getTickCount()/500)*1
  	dxDrawImage((644 + x)/zoom, 220/zoom, 632/zoom, 194/zoom, images['logo'])

    local a = (math.sqrt(getSoundFFTData(sound, 2048, 2)[1])*256) or 150
    dxDrawImage((650 + x)/zoom, 190/zoom, 250/zoom, 250/zoom, images['puls'], 0, 0, 0, tocolor(0, 255, 0, a), false)


  end

  if notifications['visible'] == true then
    if (getTickCount()-notifications['tick']) > 5000 and notifications['back'] ~= true then
      notifications['back'] = true
      notifications['tick'] = getTickCount()
    elseif (getTickCount()-notifications['tick']) > 1000 and notifications['back'] == true then
      notifications['text'] = ''
      notifications['back'] = false
      notifications['visible'] = false
      return
    end

    local y = notifications['back'] ~= true and interpolateBetween(-47, 0, 0, 22, 0, 0, (getTickCount()-notifications['tick'])/1000, 'OutBack') or interpolateBetween(22, 0, 0, -47, 0, 0, (getTickCount()-notifications['tick'])/1000, 'OutBack')

    customWindow(698/zoom, y/zoom, 524/zoom, 47/zoom, tocolor(notifications['color'][1], notifications['color'][2], notifications['color'][3], 200))

    exports['dxLibary']:dxLibary_shadowText2(notifications['text'], 698/zoom, y/zoom, 524/zoom + 698/zoom, 47/zoom + y/zoom, tocolor(notifications['color'][1], notifications['color'][2], notifications['color'][3], 255), 2, 'default', 'center', 'center', false, true, true, false, false)
  end
end

function customWindow(x, y, w, h, color)
  dxDrawRectangle(x, y, w, h, tocolor(15, 15, 15, 200), false)
  dxDrawRectangle(x, (y + h), w, 2, color, false)
end

function clicked(btn, state)
  if btn ~= 'left' or state ~= 'down' then return end

  if isMouseIn(799/zoom, 582/zoom, 19/zoom, 18/zoom) and action == 'login' then
    setElementData(localPlayer,'zapamietajLogin', (getElementData(localPlayer, 'zapamietajLogin') == 1 and 0 or 1))
  elseif isMouseIn(799/zoom, 640/zoom, 19/zoom, 18/zoom) and action == 'register' then
    regulamin = regulamin == 1 and 0 or 1
  elseif isMouseIn(799/zoom, 622/zoom, 324/zoom, 35/zoom) and action == 'login' then
  
  
  
	local username = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
	local password = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')

  
  
   -- local login = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
   -- local haslo = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')


	if string.len(username) >= 3 and string.len(password) >= 8 then
		triggerServerEvent("server:login",localPlayer,username,password)
		--dxSetButtonEnabled(lp.login.button,false)
	else
		if string.len(username) < 3 then
			addNotificationPanel('El usuario debe contener al menos 3 caracteres..', {255, 0, 0})
			return
		elseif string.len(password) < 8 then
			addNotificationPanel('La contraseña debe tener al menos 8 caracteres.', {255, 0, 0})
			return
		end
	end




    --if string.len(login) < 4 then
   --   addNotificationPanel('El usuario debe contener al menos 4 caracteres..', {255, 0, 0})
	--	  return
  --  elseif string.len(haslo) < 7 then
    --  addNotificationPanel('La contraseña debe tener al menos 7 caracteres.', {255, 0, 0})
   --   return
  --  end

   -- triggerServerEvent('logowanie:zaloguj', resourceRoot, localPlayer, login, haslo)
	
	
	
	
	
	
  elseif isMouseIn(799/zoom, 675/zoom, 324/zoom, 35/zoom) and action == 'register' then
    if regulamin ~= 1 then
      addNotificationPanel('Primero acepta las reglas.', {255, 0, 0})
      return
    end




    local username = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
    local password = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')
    local repassword = exports['editbox']:getCustomEditboxText('LOGGING-HASH2')


	if string.len(username) >= 3 and string.len(password) >= 8 then
		if password == repassword then
			triggerServerEvent("server:register",localPlayer,username,password)
			--dxSetButtonEnabled(lp.register.button,false)
		else
			addNotificationPanel('Tienes algo mal, revisa todo bien.', {255, 0, 0})
			return
		end
	else
		if string.len(username) < 3 then
			addNotificationPanel('El usuario debe contener al menos 3 caracteres..', {255, 0, 0})
			return
		elseif string.len(password) < 8 then
			addNotificationPanel('La contraseña debe tener al menos 8 caracteres.', {255, 0, 0})
			return
		end
		--setTimer(resetLoginError, 2000, 1)
	
	end
	
  elseif isMouseIn(799/zoom, 675/zoom, 324/zoom, 35/zoom) and action == 'contra' then


    local username = exports['editbox']:getCustomEditboxText('LOGGING-LOGIN1')
    local password = exports['editbox']:getCustomEditboxText('LOGGING-HASH1')
    local repassword = exports['editbox']:getCustomEditboxText('LOGGING-HASH2')


	if string.len(username) >= 3 and string.len(password) >= 8 then
		if password == repassword then
			--triggerServerEvent("server:register",localPlayer,username,password)
			triggerServerEvent("server:changePassword",localPlayer,username,password)
			--dxSetButtonEnabled(lp.register.button,false)
		else
			addNotificationPanel('Tienes algo mal, revisa todo bien.', {255, 0, 0})
			return
		end
	else
		if string.len(username) < 3 then
			addNotificationPanel('El usuario debe contener al menos 3 caracteres..', {255, 0, 0})
			return
		elseif string.len(password) < 8 then
			addNotificationPanel('La contraseña debe tener al menos 8 caracteres.', {255, 0, 0})
			return
		elseif string.len(username) <= 0 then
			addNotificationPanel('Escribe tu nombre de usuario.', {255, 0, 0})
			return
		elseif string.len(password) <= 0 then
			addNotificationPanel('Escribe tu nueva contraseña.', {255, 0, 0})
			return
		end
		--setTimer(resetLoginError, 2000, 1)
	end
	
	


   -- triggerServerEvent('logowanie:rejestracja', resourceRoot, localPlayer, login, haslo, haslo2)
  elseif isMouseIn(806/zoom, 665/zoom, 306/zoom, 20/zoom) and action == 'login' then
    setTimer(function()
      action = 'register'
      actionTick = getTickCount()
    end, 100, 1)
    actionTick = getTickCount()
    actionTypeLogin = 2
    actionTypeRegister = 1
	actionTypeContra = 1
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', '')
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', '')
	exports['editbox']:createCustomEditbox('LOGGING-HASH2', 'Repetir contraseña...', sw, sh, 323/zoom, 42/zoom, true, '')
  elseif isMouseIn(806/zoom, 718/zoom, 306/zoom, 20/zoom) and action == 'register' then
    exports['editbox']:destroyCustomEditbox('LOGGING-HASH2')
    setTimer(function()
      action = 'login'
      actionTick = getTickCount()
    end, 300, 1)
    actionTick = getTickCount()
    actionTypeRegister = 2
    actionTypeLogin = 1
	actionTypeContra = 1
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', login)
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', password)
  elseif isMouseIn(806/zoom, 690/zoom, 306/zoom, 20/zoom) and action == 'login' then
    setTimer(function()
      action = 'contra'
      actionTick = getTickCount()
    end, 300, 1)
    actionTick = getTickCount()
	actionTypeContra = 1
	actionTypeRegister = 1
    actionTypeLogin = 2 -- ESTE EN 2
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', '')
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', '')
	exports['editbox']:createCustomEditbox('LOGGING-HASH2', 'Repetir contraseña...', sw, sh, 323/zoom, 42/zoom, true, '')
  elseif isMouseIn(806/zoom, 718/zoom, 306/zoom, 20/zoom) and action == 'contra' then
    exports['editbox']:destroyCustomEditbox('LOGGING-HASH2')
    setTimer(function()
      action = 'login'
      actionTick = getTickCount()
    end, 300, 1)
    actionTick = getTickCount()
	actionTypeContra = 2
	actionTypeLogin = 1 -- ESTE EN 2
	actionTypeRegister = 2
    exports['editbox']:customEditboxSetText('LOGGING-LOGIN1', login)
    exports['editbox']:customEditboxSetText('LOGGING-HASH1', password)
  end
end




--[[
addEvent("onClientdxButtonClick",true)
addEventHandler("onClientdxButtonClick",root,
function(plr)
	if plr == localPlayer then
		if source == lp.login.button then
			local username = dxGetEditText(lp.login.username)
			local password = dxGetEditText(lp.login.password)
			if #username >= 3 and #password >= 5 then
				triggerServerEvent("server:login",plr,username,password)
				dxSetButtonEnabled(lp.login.button,false)
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 5 then
					loginError = "La clave debe de ser de 5 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.register.button then
			local username = dxGetEditText(lp.register.username)
			local password = dxGetEditText(lp.register.password)
			local repassword = dxGetEditText(lp.register.repassword)
			if #username >= 3 and #password >= 8 then
				if password == repassword then
					triggerServerEvent("server:register",plr,username,password)
					dxSetButtonEnabled(lp.register.button,false)
				end
			else
				if #username < 3 then
					loginError = "El usuario debe de ser de 3 caracteres o más."
				elseif #password < 8 then
					loginError = "La clave debe de ser de 8 caracteres o más."
				end
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.forgotpass.fpass then
			local username = dxGetEditText(lp.login.username)
			if #username > 0 then
				triggerServerEvent("server:forgotpass",plr,username)
			else
				loginError = "¡Introduce primero tu usuario!"
				setTimer(resetLoginError, 2000, 1)
			end
		elseif source == lp.forgotpass.button then
			local username = dxGetEditText(lp.login.username)
			if #username > 0 then
				local password = dxGetEditText(lp.forgotpass.pass)
				if #password >= 8 then
					triggerServerEvent("server:changePassword",plr,username,password)
					removeEventHandler("onClientRender",root,drawForgot)
				else
					if password > 0 then
						loginError = "La clave debe de ser de 8 caracteres o más."
						setTimer(resetLoginError, 2000, 1)
					else
						loginError = "¡Introduce tu nueva clave!"
						setTimer(resetLoginError, 2000, 1)
					end
				end
			else
				loginError = "¡Introduce primero tu usuario!"
				setTimer(resetLoginError, 2000, 1)
			end
		end
	end
end
)

--]]



-- usefull function created by Asper

  function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return end
    
    local mouse = {getCursorPosition()}
    local myX, myY = (mouse[1] * sw), (mouse[2] * sh)
    if (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)) then
        return true
    end
    
    return false
end

local click = false
function onClick(x, y, w, h, called)
    if(isMouseInPosition(x, y, w, h) and not click and getKeyState("mouse1"))then
        click = true
        called()
    elseif(not getKeyState("mouse1") and click)then
        click = false
    end
end

--



addEvent("client:init:callBack",true)
addEventHandler("client:init:callBack",root,
function()
	lechuga()
end
)



addEvent("empezar:nuevopersonaje",true)
addEventHandler("empezar:nuevopersonaje",root,
function()
	Fumada()
end
)
--[[

function Fumada()

		-- eel de vc
        veh = createVehicle(519,-1735.80078125, 220.48828125, 344.10159301758,0,0,180)
		
		-- el dde ls
		--veh = createVehicle(519,898.04577636719,-2587.9560546875,427.64086914063,0,0,270)
		
        setVehicleLandingGearDown(veh,false)
        setElementFrozen(veh,true)
        setVehicleEngineState(veh, true)
        kamera = 1
        samolot1 = getTickCount()
        addEventHandler('onClientRender',getRootElement(),camera)
end
addCommandHandler("penelope", Fumada)
--]]






addEvent('onDestroyLoginPanel',true)
addEventHandler( 'onDestroyLoginPanel', getLocalPlayer(),
function()
	--action = 'login'
	showCursor(false)
    exports['editbox']:destroyCustomEditbox('LOGGING-LOGIN1')
    exports['editbox']:destroyCustomEditbox('LOGGING-HASH1')
    exports['editbox']:destroyCustomEditbox('LOGGING-HASH2')
    removeEventHandler('onClientRender', root, gui)
    removeEventHandler('onClientClick', root, clicked)
    showCursor(false)
    removeEventHandler('onClientRender', root, camera_render)
    --showCursor(true)
    setElementData(localPlayer, 'grey_shader', 0)
	fadeCamera(false)
	if not exports.players:isLoggedIn() then
	--setTimer ( function()
		setCameraMatrix( -96.908203125, 1139.4208984375, 42.813411712646, -90000.4130859375, 10.1376953125, 10.696334838867, 0, 70)
		fadeCamera(true)
	--end, 1250, 1 )
	end
	--setTimer(fadeCamera,1700,1,false, 1.0, 0, 0, 0)
    showChat(true)
    music(false)
	
	
end)




addEvent('loadingScreen', true)
addEventHandler('loadingScreen', resourceRoot, function()
  exports['ladowanie']:createLoadingScreen('Cargando...', 3000, true)
  --exports.tekstury:loadTextures()
end)




