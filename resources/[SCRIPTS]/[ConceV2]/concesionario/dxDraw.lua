local screen = { guiGetScreenSize() }
local sx, sy = (screen[1] / 1366), (screen[2] / 768)
dxDraw = {}
functions = {}
local TEST = false
-- dxDraw's --
function dxDraw:Text( text, leftX, topY, rightX, bottomY, ... )
    dxDrawText( text, sx * leftX, sy * topY, sx * rightX, sy * bottomY, ... )
end

function dxDraw:Rectangle( leftX, topY, rightX, bottomY, color, postGUI, ... )
    dxDrawRectangle( sx * leftX, sy * topY, sx * rightX, sy * bottomY, color, postGUI, ... )
end

function dxDraw:Line( startX, startY, endX, endY, color, width, postGUI, ... )
    dxDrawLine( sx * startX, sy * startY, sx * endX, sy * endY, color, width, postGUI, ... )
end

function dxDraw:Image( leftX, topY, rightX, bottomY, texture, rotation, rotationCenterX, rotationCenterY, color, postGUI, ... )
    dxDrawImage( sx * leftX, sy * topY, sx * rightX, sy * bottomY, texture, rotation, rotationCenterX, rotationCenterY, color, postGUI, ... )
end

function dxDraw:RoundedRectangle(x, y, rx, ry, color, radius)
    rx = sx * rx - radius * 2
    ry = sy * ry - radius * 2
    x = sx * x + radius
    y = sy * y + radius
    
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


function dxDraw:Button(buttonType, text, x, y, rx, ry, color, radius)
    rx = sx * rx - radius * 2
    ry = sy * ry - radius * 2
    x = sx * x + radius
    y = sy * y + radius
    if buttonType == 'Rectangle' then
        dxDraw:Rectangle( x, y, rx, ry, color )
        dxDraw:Text( text, sx * x, sy * y, sx * rx + x, sy * ry + y, tocolor( 255, 255, 255 ), 1.5, "arial", 'center', 'center', true, true )
    elseif buttonType == 'RoundedRectangle' then
    if (rx >= 0) and (ry >= 0) then

        dxDrawRectangle( x, y, rx, ry, color)
        dxDrawRectangle( x, y - radius, rx, radius, color)
        dxDrawRectangle( x, y + ry, rx, radius, color)
        dxDrawRectangle( x - radius, y, radius, ry, color)
        dxDrawRectangle( x + rx, y, radius, ry, color)

        dxDrawCircle( x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle( x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle( x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle( x, y + ry, radius, 90, 180, color, color, 7)
        dxDraw:Text( text, sx * x, sy * y, sx * rx + x, sy * ry + y, tocolor( 255, 255, 255 ), 1.5, "arial", 'center', 'center', true, true )
    end
    end
end



local EditBox = {}
local editSelected;

function dxDraw:EditBox(key, text, onlyNumbersOrLetters, x, y, w, h, font, masked, max, color2, alignX, caretVisible)
    EditBox[key] = EditBox[key] or { text = '', max = max, over = false }

    font = font or 'default-bold'
    color2 = color2 or tocolor(255, 255, 255, 255)
    local v = EditBox[key]

    v.over = functions:isMouseInPosition(x, y, w, h)

    if onlyNumbersOrLetters == false then
        v.text = v.text
    elseif onlyNumbersOrLetters == 'number' then
        v.text = v.text:gsub('[^%d]', '')
    elseif onlyNumbersOrLetters == 'text' then
        v.text = v.text:gsub('[^%a]', '')
    end

    if #v.text == 0 then
        dxDraw:Text(text, x + 5, y, x + w - 10, y + h, color2, 1.3, font, alignX or 'left', 'center', true, false, false)
    end

    local displayText = masked and string.gsub(v.text, '.', '•') or v.text
    local textWidth = dxGetTextWidth(displayText, 1, font)
    local textAlignment = textWidth <= w - 10 and 'left' or 'right'
    
    dxDraw:Text(displayText, x + 5, y, x + w - 10, y + h, color2, 1.3, font, textAlignment, 'center', true, false, false)

    if editSelected == key and (caretVisible == nil or caretVisible) then
        local caretX = textAlignment == 'left' and x + 5 + textWidth or x + w - 10
        dxDraw:Line(caretX, y + 18, caretX, y + h - 18, color2, 1, false)
    end

    if editSelected == key then
        if getKeyState('backspace') and (not tickDelete or getTickCount() - tickDelete >= 90) then
            if #v.text > 0 then
                v.text = v.text:sub(1, #v.text - 1)
            end
            tickDelete = getTickCount()
        elseif tickDelete then
            tickDelete = nil
        end
    end

    return v.text
end

addEventHandler("onClientPaste", root, function(text)
    local key = editSelected
    if key and EditBox[key] then
        if EditBox[key].max == false or (#EditBox[key].text < EditBox[key].max) then
            EditBox[key].text = text
        end
    end
end)

addEventHandler('onClientClick', getRootElement(),
    function(button, state, cx, cy)
        if (button == 'left') and (state == 'down') then

            local key
            for k, v in pairs(EditBox) do
                if v.over then
                    key = k
                    break
                end
            end

            if key and EditBox[key] then
                guiSetInputEnabled( true )
                editSelected = key
            else
                if editSelected then
                    guiSetInputEnabled( false )
                    editSelected = nil
                end
            end

        end
    end
)

addEventHandler('onClientCharacter', getRootElement(),
    function(c)
        if (isChatBoxInputActive()) or (isConsoleActive()) or (isMainMenuActive()) then
            return
        end

        local key = editSelected
        if key and EditBox[key] then
            if EditBox[key].max == false or (EditBox[key].max == -1) or (#EditBox[key].text < EditBox[key].max) then
                EditBox[key].text = EditBox[key].text..c
            end
        end
    end
)

function functions:editGetText(key)
	return EditBox[key] and EditBox[key].text or false
end

function functions:editSetText(key, txt)
	EditBox[key]      = EditBox[key] or {}
	EditBox[key].text = txt
end


-- Funtions utils --
-- function functions:getDistanceBetween( arg1, arg2 )
-- 	local e1 = Vector3( arg1:getPosition() )
-- 	local e2 = Vector3( arg2:getPosition() )
-- 	local distance = getDistanceBetweenPoints3D( e1, e2 )
-- 	return distance
-- end

function functions:checkACL( player, acl )
    local aclGroup = aclGetGroup( acl )
    if aclGroup then
        return aclGroup:doesContainObject( 'user.' .. player.account.name )
    end
    return false
end



function functions:settingNumber( number, state, decimalSeparator, decimals, method )
    if state == 'formatNumber' then
        for i = 1, tostring( number ):len() / 3 do
            number = string.gsub( number, '^(-?%d+)(%d%d%d)', '%1' .. decimalSeparator .. '%2' )
        end
        return number

    elseif state == 'round' then
        decimals = decimals or 0
        local factor = 10 ^ decimals
        if ( method == 'ceil' or method == 'floor' ) then
            return math[method]( tonumber( number ) * factor ) / factor
        else
            return tonumber( ( '%' .. decimalSeparator .. '' .. decimals .. 'f' ):format( number ):gsub( '[.,]', decimalSeparator ) )
        end
    else
        return 'Invalid state'
    end
end

function functions:isMouseInPosition ( x, y, w, h )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxC, syC = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxC ), ( cy * syC )
	
	return (cx >= sx * x and cx <= sx * (x + w)) and (cy >= sy * y and cy <= sy * (y + h))
end

--Examples:

addEventHandler('onClientRender', root,
    function()
    if TEST then
        if functions:isMouseInPosition(524, 450, 50, 50) then
            dxDraw:Rectangle(524, 450, 50, 50, tocolor(14, 14, 14, 210), false)
        else
            dxDraw:Rectangle(524, 450, 50, 50, tocolor(35, 35, 35, 210), false)
        end

        dxDraw:Text(functions:settingNumber(functions:settingNumber( 100000.8985, 'round', ', ', 2, 'floor'), 'formatNumber', '.'), 524, 250, 574, 270, tocolor(255, 255, 255, 255), 1.00, 'default-bold', 'center', 'center', false, false, false, false, false)

        -- dxDraw:Rectangle(524, 450, 50, 50, tocolor(14, 14, 14, 210), false)
        -- dxDraw:Image(524, 450, 50, 50, ':guieditor/images/examples/mtalogo.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
    end
end
)

function as ()
    print (math.random(0,600))
end







function ola()
    if TEST then
        if functions:isMouseInPosition(755, 276, 249, 85) then
            dxDraw:Button('RoundedRectangle', "perraaaaaaaaa", 755, 276, 249, 85, tocolor(14, 14, 14, 210), 7)
        else
            dxDraw:Button('RoundedRectangle', "perraaaaaaaaa", 755, 276, 249, 85, tocolor(35, 35, 35, 210), 7)
        end
    end
end
addEventHandler("onClientRender", root, ola)



