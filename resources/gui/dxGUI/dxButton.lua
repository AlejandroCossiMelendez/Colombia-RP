local sX, sY = guiGetScreenSize()
local font = dxCreateFont( "dxGUI/fonts/basic_bold.ttf", (sX / 1366) * 13 )

function dxCreateButton(x, y, w, h, text, parent, postGUI)
	if x and y and w and h then
		local button = createElement ( "dxGUI", "dxButton" )
		if button then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.text = text or ""
			data.hover = false
			data.post = postGUI
			data.parent = parent or false
			data.draw = false
			if addComponentToDraw(button, data, "dxButton") then
				return button
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxButton.")
	end
	return false
end

function dxDrawButton(x, y, w, h, text, c, postGUI)
	if c == "normal" then
		dxDrawRoundedRectangle(x, y, w, h, tocolor(32, 34, 46), 6)
	elseif c == "hover" then
		dxDrawRoundedRectangle(x+3, y+3, w-6, h-6, tocolor(31, 38, 255), 6)
		dxDrawRoundedRectangle(x, y, w, h, tocolor(32+15, 34+15, 46+15), 6)
	elseif c == "click" then
		dxDrawRoundedRectangle(x, y, w, h, tocolor(32, 34, 46), 6)
	end
	dxDrawText( text or "", x, y, w + x, y + h, tocolor(255, 255, 255 ,255), 1, font, "center", "center", false, true, postGUI )
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