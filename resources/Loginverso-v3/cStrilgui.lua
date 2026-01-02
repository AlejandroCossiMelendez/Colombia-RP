local config = getConfig ( )

local randomMusic = math.random( #config['music'])

ifs = {
    ['fonts'] = {
        dxCreateFont ( 'assets/fonts/font.ttf', 16),
        dxCreateFont ( 'assets/fonts/medium.otf', 10),
        dxCreateFont ( 'assets/fonts/bold.otf', 12),
        dxCreateFont ( 'assets/fonts/font.ttf', 18),
        dxCreateFont ( 'assets/fonts/font.ttf', 12),
    },
    
    ['aba'] = 'Login',
    
    ['tick'] = {},
    
    ['edits'] = {},
    
    ['select'] = 0,
    
    ['statistics'] = { 
        ['soundRandom'] = 'assets/sounds/'..config['music'][randomMusic]['filename']..'',
        ['music'] = 'Pause',
    },
}

function painelLogin()

    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - ifs['tick'][2]) / 1200), 'Linear')
    if ifs['aba'] == 'Login' then
        dxDrawText('Verso Roleplay', 750, 310, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        dxDrawText('Gracias Por Unirte Al Servidor, Recuerda Que Debes Estudiar \nConceptos De Rol Para Evitar Sanciones', 750, 360, 500, 200, tocolor(200, 200, 200, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, false, false)

        if isCursorOnElement(1010, 765, 220, 30) then
            dxDrawText('No Tengo Cuenta #F7EF53[Crear Una]', 750, 680, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, true, false)
        else
            dxDrawText('No Tengo Cuenta [Crear Una]', 750, 680, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, true, false)
        end

        if ifs['select'] == 1 then 
            dxDrawImage( 700, 520, 600, 60, 'assets/imgs/rectangle_2.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        else
            dxDrawImage( 700, 520, 600, 60, 'assets/imgs/rectangle.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end
        
        if ifs['select'] == 2 then 
            dxDrawImage( 700, 590, 600, 60, 'assets/imgs/rectangle_2.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        else
            dxDrawImage( 700, 590, 600, 60, 'assets/imgs/rectangle.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end
        
        if isCursorOnElement(700, 680, 600, 60) then
            dxDrawImage( 700, 680, 600, 60, 'assets/imgs/rectangle_3.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawImage( 675, 665, 655, 90, 'assets/imgs/effect.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawText('Entrar', 750, 610, 500, 200, tocolor(247, 239, 87, alpha), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        else 
            dxDrawImage( 700, 680, 600, 60, 'assets/imgs/rectangle_3.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawText('Entrar', 750, 610, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        end
        
        dxDrawText(ifs['select'] == 1 and guiGetText(ifs['edits'][1])..'|' or guiGetText(ifs['edits'][1]), 720, 450, 500, 200, tocolor(247, 239, 83, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        if guiGetText(ifs['edits'][2]) ~= 'Contrasena' then
            dxDrawText(ifs['select'] == 2 and string.gsub(guiGetText(ifs['edits'][2]), '.', '*')..'|' or string.gsub(guiGetText(ifs['edits'][2]), '.', '*'), 720, 520, 500, 200, tocolor(247, 239, 83, 255), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        else 
            dxDrawText(ifs['select'] == 2 and 'Contrasena|' or 'Contrasena', 720, 520, 500, 200, tocolor(247, 239, 83, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        end
        
    elseif ifs['aba'] == 'Registro' then 
        dxDrawText('Registrarse', 750, 310, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        dxDrawText('Introduce tus datos de inicio de seccion para entrar a \nVerso Roleplay', 750, 360, 500, 200, tocolor(200, 200, 200, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, false, false)

        if isCursorOnElement(1010, 835, 220, 30) then
            dxDrawText('Ya Tengo Cuenta #F7EF53[Iniciar Sesion]', 750, 750, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, true, false)
        else
            dxDrawText('Ya Tengo Cuenta [Iniciar Sesion]', 750, 750, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][3], 'center', 'center', false, false, false, true, false)
        end
        
        if ifs['select'] == 1 then 
            dxDrawImage( 700, 520, 600, 60, 'assets/imgs/rectangle_2.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        else
            dxDrawImage( 700, 520, 600, 60, 'assets/imgs/rectangle.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end
        
        if ifs['select'] == 2 then 
            dxDrawImage( 700, 590, 600, 60, 'assets/imgs/rectangle_2.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        else
            dxDrawImage( 700, 590, 600, 60, 'assets/imgs/rectangle.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end

        if ifs['select'] == 3 then 
            dxDrawImage( 700, 660, 600, 60, 'assets/imgs/rectangle_2.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        else
            dxDrawImage( 700, 660, 600, 60, 'assets/imgs/rectangle.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
        end

        if isCursorOnElement(700, 750, 600, 60) then
            dxDrawImage( 700, 750, 600, 60, 'assets/imgs/rectangle_3.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawImage( 675, 735, 655, 90, 'assets/imgs/effect.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawText('Registrar', 750, 680, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        else 
            dxDrawImage( 700, 750, 600, 60, 'assets/imgs/rectangle_3.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
            dxDrawText('Registrar', 750, 680, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][4], 'center', 'center', false, false, false, false, false)
        end
        
        dxDrawText(ifs['select'] == 1 and guiGetText(ifs['edits'][1])..'|' or guiGetText(ifs['edits'][1]), 720, 450, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        if guiGetText(ifs['edits'][2]) ~= 'Contrasena' then
            dxDrawText(ifs['select'] == 2 and string.gsub(guiGetText(ifs['edits'][2]), '.', '*')..'|' or string.gsub(guiGetText(ifs['edits'][2]), '.', '*'), 720, 520, 500, 200, tocolor(255, 255, 255, 255), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        else 
            dxDrawText(ifs['select'] == 2 and 'Contrasena|' or 'Contrasena', 720, 520, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        end

        if guiGetText(ifs['edits'][3]) ~= 'Confirmar Contrasena' then  
            dxDrawText(ifs['select'] == 3 and string.gsub(guiGetText(ifs['edits'][3]), '.', '*')..'|' or string.gsub(guiGetText(ifs['edits'][3]), '.', '*'), 720, 590, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        else
            dxDrawText(ifs['select'] == 3 and 'Confirmar Contrasena|' or 'Confirmar Contrasena', 720, 590, 500, 200, tocolor(255, 255, 255, alpha), 1, ifs['fonts'][5], 'left', 'center', false, false, true, true, false)
        end

    end
end

addEventHandler('onClientClick', root, 
function(b, s)
    if (b == 'left') and (s == 'down') then
        if ifs['panelOpened'] then
            ifs['select'] = 0
            if ifs['aba'] == 'Registro' then
                if isCursorOnElement(1010, 835, 220, 30) then 
                    playSound('assets/sounds/click.wav')
                    if ifs['aba'] == 'Registro' then
                        ifs['aba'] = 'Login' 
                    elseif ifs['aba'] == 'Login' then
                        ifs['aba'] = 'Registro'
                    end
                    guiSetText(ifs['edits'][1], 'Usuario')
                    guiSetText(ifs['edits'][2], 'Contrasena')
                    ifs['tick'][1] = getTickCount()
                    ifs['tick'][2] = getTickCount()
                elseif isCursorOnElement(700, 750, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    if guiGetText(ifs['edits'][2]) == guiGetText(ifs['edits'][3]) then 
                        triggerServerEvent('strilgui.register', localPlayer, localPlayer, guiGetText(ifs['edits'][1]), guiGetText(ifs['edits'][2]))
                    else 
                        exports.Scripts_dxInfo:dxInfoAddBox('Rellene la informacion necesaria!', 'help')
                    end
                elseif isCursorOnElement(700, 520, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    if guiEditSetCaretIndex(ifs['edits'][1], string.len(guiGetText(ifs['edits'][1]))) then
                        guiBringToFront(ifs['edits'][1])
                        guiSetInputMode('no_binds_when_editing')
                        ifs['select'] = 1
                        if guiGetText(ifs['edits'][1]) == 'Usuario' then 
                            guiSetText(ifs['edits'][1], '')
                        end
                    end
                    if guiGetText(ifs['edits'][2]) == '' then 
                        guiSetText(ifs['edits'][2], 'Contrasena')
                    end
                    if guiGetText(ifs['edits'][3]) == '' then 
                        guiSetText(ifs['edits'][3], 'Confirmar Contrasena')
                    end
                elseif isCursorOnElement(700, 590, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    if guiEditSetCaretIndex(ifs['edits'][2], string.len(guiGetText(ifs['edits'][2]))) then
                        guiBringToFront(ifs['edits'][2])
                        guiSetInputMode('no_binds_when_editing')
                        ifs['select'] = 2
                        if guiGetText(ifs['edits'][2]) == 'Contrasena' then 
                            guiSetText(ifs['edits'][2], '')
                        end
                    end
                    if guiGetText(ifs['edits'][1]) == '' then 
                        guiSetText(ifs['edits'][1], 'Usuario')
                    end
                    if guiGetText(ifs['edits'][3]) == '' then 
                        guiSetText(ifs['edits'][3], 'Confirmar Contrasena')
                    end
                elseif isCursorOnElement(700, 660, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    if guiEditSetCaretIndex(ifs['edits'][3], string.len(guiGetText(ifs['edits'][3]))) then
                        guiBringToFront(ifs['edits'][3])
                        guiSetInputMode('no_binds_when_editing')
                        ifs['select'] = 3
                        if guiGetText(ifs['edits'][3]) == 'Confirmar Contrasena' then 
                            guiSetText(ifs['edits'][3], '')
                        end
                    end
                    if guiGetText(ifs['edits'][1]) == '' then 
                        guiSetText(ifs['edits'][1], 'Usuario')
                    end
                    if guiGetText(ifs['edits'][2]) == '' then 
                        guiSetText(ifs['edits'][2], 'Contrasena')
                    end
                end
                
            elseif ifs['aba'] == 'Login' then
                if isCursorOnElement(700, 680, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    triggerServerEvent('strilgui.loggin', localPlayer, localPlayer, guiGetText(ifs['edits'][1]), guiGetText(ifs['edits'][2]) )
                elseif isCursorOnElement(700, 520, 600, 60) then
                    playSound('assets/sounds/click.wav')
                    if guiEditSetCaretIndex(ifs['edits'][1], string.len(guiGetText(ifs['edits'][1]))) then
                        guiBringToFront(ifs['edits'][1])
                        guiSetInputMode('no_binds_when_editing')
                        ifs['select'] = 1
                        if guiGetText(ifs['edits'][1]) == 'Usuario' then 
                            guiSetText(ifs['edits'][1], '')
                        end
                    end
                    if guiGetText(ifs['edits'][2]) == '' then 
                        guiSetText(ifs['edits'][2], 'Contrasena')
                    end
                elseif isCursorOnElement(700, 590, 600, 60) then 
                    playSound('assets/sounds/click.wav')
                    if guiEditSetCaretIndex(ifs['edits'][2], string.len(guiGetText(ifs['edits'][2]))) then
                        guiBringToFront(ifs['edits'][2])
                        guiSetInputMode('no_binds_when_editing')
                        ifs['select'] = 2
                        if guiGetText(ifs['edits'][2]) == 'Contrasena' then 
                            guiSetText(ifs['edits'][2], '')
                        end
                    end
                    if guiGetText(ifs['edits'][1]) == '' then 
                        guiSetText(ifs['edits'][1], 'Usuario')
                    end
                elseif isCursorOnElement(1010, 765, 220, 30) then 
                    playSound('assets/sounds/click.wav')
                    if ifs['aba'] == 'Login' then
                        ifs['aba'] = 'Registro' 
                    elseif ifs['aba'] == 'Registro' then
                        ifs['aba'] = 'Login'
                    end
                    guiSetText(ifs['edits'][1], 'Usuario')
                    guiSetText(ifs['edits'][2], 'Contrasena')
                    guiSetText(ifs['edits'][3], 'Confirmar Contrasena')
                    ifs['tick'][1] = getTickCount()
                    ifs['tick'][2] = getTickCount()
                end
            end
        end
    end
end
)

function openLogin()
    if not isEventHandlerAdded('onClientRender', root, painelLogin) then
        if not ifs['panelOpened'] then
            ifs['panelOpened'] = true
            ifs['aba'] = 'Login'
            ifs['tick'][1] = getTickCount()
            ifs['tick'][2] = getTickCount()
            ifs['som'] = playSound( ifs['statistics']['soundRandom'], true, true )
            setSoundVolume(ifs['som'], 0.2)
            ifs['statistics']['soundPlayed'] = true
            editBox('add') 
            showCursor(true)
            showChat(false)
            toggleAllControls( false )
            setElementFrozen(localPlayer, false)
            user, password = loadLoginFromXML()
            if (user) and (password) then 
                guiSetText(ifs['edits'][1], user)
                guiSetText(ifs['edits'][2], password)
                check = true
            end
            addEventHandler('onClientRender', root, painelLogin)
        else
            ifs['panelOpened'] = false
            ifs['aba'] = nil
            showCursor( false )
            showChat( true )
            toggleAllControls( true )
            setElementFrozen(localPlayer, true)
            editBox()
            ifs['som'] = stopSound( ifs['statistics']['soundRandom'] )
            ifs['statistics']['soundPlayed'] = nil
            removeEventHandler('onClientRender', root, painelLogin)
        end
    end
end
addEventHandler('onClientResourceStart', getResourceRootElement(getThisResource()), openLogin)
addEventHandler('onPlayerJoin', root, openLogin)
addEvent("showLoginPanel", true)
addEventHandler("showLoginPanel", getRootElement(), openLogin)

addEvent("client:init:callBack",true)
addEventHandler("client:init:callBack",root,
function(serialRegistered)
	showLogin(serialRegistered)
end
)

addEvent('strilgui.removelogin', true)
addEventHandler('strilgui.removelogin', root, 
function()
    if ifs['panelOpened'] then
        ifs['panelOpened'] = false
        stopSound( ifs['som'] )
        ifs['statistics']['soundPlayed'] = nil
        ifs['statistics']['imgRandom'] = nil
        ifs['aba'] = nil
        toggleAllControls( true )
        showCursor(false)
        showChat(true)
        editBox()
        removeEventHandler('onClientRender', root, painelLogin)
    end 
end
)
addEvent('onDestroyLoginPanel', true)
addEventHandler('onDestroyLoginPanel', root, 
function()
    if ifs['panelOpened'] then
        ifs['panelOpened'] = false
        stopSound( ifs['som'] )
        ifs['statistics']['soundPlayed'] = nil
        ifs['statistics']['imgRandom'] = nil
        ifs['aba'] = nil
        toggleAllControls( true )
        showCursor(false)
        showChat(true)
        editBox()
        removeEventHandler('onClientRender', root, painelLogin)
    end 
end
)


function editBox(action)
    if (action == 'add') then 
        ifs['edits'][1] = guiCreateEdit(1000, 1000, 0, 0, 'Usuario', false)
        ifs['edits'][2] = guiCreateEdit(1000, 1000, 0, 0, 'Contrasena', false)
        ifs['edits'][3] = guiCreateEdit(1000, 1000, 0, 0, 'Confirmar Contrasena', false)
        guiEditSetMaxLength(ifs['edits'][1], 20)
        guiEditSetMaxLength(ifs['edits'][2], 20)
        guiEditSetMaxLength(ifs['edits'][3], 20)
    else 
        for i = 0, 2 do 
            if isElement(ifs['edits'][i]) then destroyElement(ifs['edits'][i]) end 
        end 
    end
end

addEvent( "players:loginResult", true )
addEventHandler( "players:loginResult", getLocalPlayer( ),
	function( code )
		if code == 1 then
            exports.Scripts_dxInfo:dxInfoAddBox('Usuario o contrasena incorrectos!.', 'error')
		elseif code == 2 then
            exports.Scripts_dxInfo:dxInfoAddBox('El usuario se encuentra baneado.', 'error')
		elseif code == 3 then
            exports.Scripts_dxInfo:dxInfoAddBox('El usuario requiere pasar test de rol.', 'error')
		elseif code == 4 then
            exports.Scripts_dxInfo:dxInfoAddBox('Error desconocido, intentalo de nuevo.', 'error')
		elseif code == 5 then
			exports.Scripts_dxInfo:dxInfoAddBox('Otra persona esta ocupando esta cuenta.', 'error')
		elseif code == 6 then
			exports.Scripts_dxInfo:dxInfoAddBox('Error el usuario esta desactivado.', 'error')
		end
	end
)
	
addEvent( "players:registrationResult", true )
addEventHandler( "players:registrationResult", getLocalPlayer( ),
	function( code )
		if code == 0 then
			local username = guiGetText(ifs['edits'][1])
			local password = guiGetText(ifs['edits'][2])
			triggerServerEvent("players:login",localPlayer,username,password)
		elseif code == 1 then
            exports.Scripts_dxInfo:dxInfoAddBox('Error en el registro, verifica tus datos.', 'error')
		elseif code == 2 then
            exports.Scripts_dxInfo:dxInfoAddBox('Error en el registro, inhabilitado.', 'error')
		elseif code == 3 then
			exports.Scripts_dxInfo:dxInfoAddBox('Error, este usuario ya existe.', 'error')
		elseif code == 4 then
			exports.Scripts_dxInfo:dxInfoAddBox('Error en el registro, prueba mas tarde.', 'error')
		elseif code == 5 then
			exports.Scripts_dxInfo:dxInfoAddBox('Ya has creado una cuenta, inicia sesion.', 'success')
		elseif code == 6 then
			exports.Scripts_dxInfo:dxInfoAddBox('Solo se permiten dos cuentas por IP.', 'error')
	    end
	end	
)
