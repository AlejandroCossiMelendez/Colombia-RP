--[[
 ______   _________  ______     ________  __       _______    __  __    ________     
/_____/\ /________/\/_____/\   /_______/\/_/\     /______/\  /_/\/_/\  /_______/\    
\::::_\/_\__.::.__\/\:::_ \ \  \__.::._\/\:\ \    \::::__\/__\:\ \:\ \ \__.::._\/    
 \:\/___/\  \::\ \   \:(_) ) )_   \::\ \  \:\ \    \:\ /____/\\:\ \:\ \   \::\ \     
  \_::._\:\  \::\ \   \: __ `\ \  _\::\ \__\:\ \____\:\\_  _\/ \:\ \:\ \  _\::\ \__  
    /____\:\  \::\ \   \ \ `\ \ \/__\::\__/\\:\/___/\\:\_\ \ \  \:\_\:\ \/__\::\__/\ 
    \_____\/   \__\/    \_\/ \_\/\________\/ \_____\/ \_____\/   \_____\/\________\/ 
                                                                                                                                                                                                                
                          » CopyRight © 2022
                » Meu discord: strilgui#0001
--]]

screen = {guiGetScreenSize ()}
resolution = {1920 , 1080}
sx, sy = screen[1] / resolution[1], screen[2] / resolution[2]

function setScreenPosition (x, y, w, h)
    local sx = (x / resolution[1]) * screen[1]
    local sy = (y / resolution[2]) * screen[2]
    local sw = (w / resolution[1]) * screen[1]
    local sh = (h / resolution[2]) * screen[2]
    -- Snap to pixel grid to evitar artefactos/líneas por subpíxeles
    return math.floor(sx + 0.5), math.floor(sy + 0.5), math.floor(sw + 0.5), math.floor(sh + 0.5)
end

function isCursorOnElement (x, y, w, h)
    if isCursorShowing () then
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return mx > x and mx < x + w and my > y and my < y + h
    end
    return false
end

_dxCreateFont = dxCreateFont
function dxCreateFont (path, scale, ...)
    local _, scale, _, _ = setScreenPosition (0, scale, 0, 0)

    return _dxCreateFont (path, scale, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImage (x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawImageSection (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end

-- Safer helper that preserves our scaling and forwards all args
function dxDrawTextOutlined(text, x, y, w, h, ...)
    local xx, yy, ww, hh = setScreenPosition(x, y, w, h)
    local args = { ... }
    local cShadow = tocolor(0, 0, 0, 170)

    -- Copia segura para la sombra, forzando colorCoded = false para evitar letras amarillas desplazadas
    local shadowArgs = { unpack(args) }
    shadowArgs[1] = cShadow                      -- color
    if shadowArgs[9] == nil then shadowArgs[9] = false end -- colorCoded
    shadowArgs[9] = false

    _dxDrawText(text, xx,     yy + 1, xx + ww, yy + 1 + hh, unpack(shadowArgs))
    _dxDrawText(text, xx + 1, yy,     xx + 1 + ww, yy + hh, unpack(shadowArgs))

    return _dxDrawText(text, xx, yy, xx + ww, yy + hh, ...)
end

_isCursorOnElement = isCursorOnElement
function isCursorOnElement (x, y, w, h)
    local x, y, w, h = setScreenPosition (x, y, w, h)

    return _isCursorOnElement (x, y, w, h)
end

--/ Save login e Senha 
function loadLoginFromXML()
    local xml_save_log_File = xmlLoadFile('assets/xml/userdata.xml')
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile('assets/xml/userdata.xml', 'Login')
    end
    local usernameNode = xmlFindChild(xml_save_log_File, 'username', 0)
    local passwordNode = xmlFindChild(xml_save_log_File, 'password', 0)
    if usernameNode and passwordNode then
        return xmlNodeGetValue(usernameNode), xmlNodeGetValue(passwordNode)
    end
    xmlUnloadFile(xml_save_log_File)
end

function saveLoginToXML(username, password)
    local xml_save_log_File = xmlLoadFile('assets/xml/userdata.xml')
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile('assets/xml/userdata.xml', 'Login')
    end
    if (username ~= '') then
        local usernameNode = xmlFindChild(xml_save_log_File, 'username', 0)
        if not usernameNode then
            usernameNode = xmlCreateChild(xml_save_log_File, 'username')
        end
        xmlNodeSetValue(usernameNode, tostring(username))
    end
    if (password ~= '') then
        local passwordNode = xmlFindChild(xml_save_log_File, 'password', 0)
        if not passwordNode then
            passwordNode = xmlCreateChild(xml_save_log_File, 'password')
        end
        xmlNodeSetValue(passwordNode, tostring(password))
    end
    xmlSaveFile(xml_save_log_File)
    xmlUnloadFile(xml_save_log_File)
end
addEvent('strilgui.saveLoginToXML', true)
addEventHandler('strilgui.saveLoginToXML', getRootElement(), saveLoginToXML)

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
