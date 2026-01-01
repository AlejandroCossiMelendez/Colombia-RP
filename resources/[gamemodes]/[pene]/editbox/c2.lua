--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local dxLibary = exports.dxLibary

local sw,sh = guiGetScreenSize()
local baseX = 1920
local scale = 1
local minScale = 2
if sw < baseX then
    scale = math.min(minScale, baseX/sw)
end

local wraca = false

guiSetInputEnabled(false)

local tick = getTickCount()

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function isEventHandlerAdded(eventName, rootName, fnc)
  if type(eventName) == 'string' and isElement(rootName) and type(fnc) == 'function' then
    local eventHandlers = getEventHandlers(eventName, rootName)
    if type(eventHandlers) == 'table' and #eventHandlers > 0 then
      for i,v in ipairs(eventHandlers) do
        if v == fnc then
          return true
        end
      end
    end
  end
  return false
end

local edits = {}

function createCustomEditbox(name, text, x, y, w, h, masked, txt, handler, _, showed)
	name = name or ''
	text = text or ''
	x,y,w,h = x,y,w,h or 0,0,100,25
	txt = txt or ''
	masked = masked or false
	handler = handler or false

	table.insert(edits, {name,txt,x,y,w,h,masked,false,text,false,255,handler})

	openGui(showed)
end

function openGui(s)
	if not isEventHandlerAdded('onClientRender', root, gui) then
		if(not s)then
			addEventHandler('onClientRender', root, gui)
		end
		addEventHandler('onClientCharacter', root, setSelectedEditBoxText)
		addEventHandler('onClientKey', root, key)
		addEventHandler('onClientClick', root, clicked)
	end
end

function closeGui()
	if isEventHandlerAdded('onClientRender', root, gui) then
		removeEventHandler('onClientRender', root, gui)
		removeEventHandler('onClientCharacter', root, setSelectedEditBoxText)
		removeEventHandler('onClientKey', root, key)
		removeEventHandler('onClientClick', root, clicked)
	end
	stopPaste()
end

function destroyCustomEditbox(name)
	for i,v in ipairs(edits) do
		if v[1] == name then
			table.remove(edits, i)
			guiSetInputEnabled(false)
			break
		end
	end
end

function getCustomEditboxText(name)
	local text = ''
	for i,v in ipairs(edits) do
		if v[1] == name then
			text = v[2]
			break
		end
	end
	return text
end

function customEditboxSetText(name, text)
	for i,v in ipairs(edits) do
		if v[1] == name then
			v[2] = text
			break
		end
	end
end

function customEditboxSetAlpha(name, alpha)
	for i,v in ipairs(edits) do
		if v[1] == name then
			v[11] = alpha
			break
		end
	end
end

function customEditboxGetSelected(name)
	local text = ''
	for i,v in ipairs(edits) do
		if v[1] == name then
			text = v[8]
			break
		end
	end
	return text
end

function getEditboxSelected(name)
	local selected = false
	for i,v in ipairs(edits) do
		if v[1] == name then
			selected = v[8]
			break
		end
	end
	return selected
end

function customEditboxSetPosition(name, x, y)
	for i,v in ipairs(edits) do
		if v[1] == name then
			v[3] = x
			v[4] = y
			break
		end
	end
end

function setSelectedEditBoxText(text)
	for i,v in ipairs(edits) do
		if v[8] == true then
			v[2] = v[2]..text
			break
		end
	end
end

function setSelectedEditBoxTextImportant(text)
	for i,v in ipairs(edits) do
		if v[8] == true then
			v[2] = text
			break
		end
	end
end

local sizex = math.floor(sh * 0.002)

local tick = getTickCount()
local trzyma_ms = 0
local font = dxLibary:dxLibary_getFont(3)
local rgb = {235,235,235}

function gui()
    if #edits < 1 then
		closeGui()
    end

	for i,v in ipairs(edits) do
		local text = ''
		if v[8] == true then
			if v[7] == true then
				text = string.rep('*', string.len(v[2]))
			else
				text = v[2]
			end

			if getKeyState('backspace') then
				trzyma_ms = trzyma_ms + 0.05
			else
				trzyma_ms = 0
			end

			if getKeyState('backspace') and (getTickCount() - tick) > (80 / trzyma_ms) then
				v[2] = string.sub(v[2], 0, string.len(v[2])-1)
				tick = getTickCount()
			end
		else
			text = v[2]
		end

		if v[8] == true then
			local x = interpolateBetween(v[5], 0, 0, 0, 0, 0, (getTickCount()-v[10])/250, 'Linear')
			dxDrawImage(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, 'images/pasek.png', 0, 0, 0, tocolor(rgb[1], rgb[2], rgb[3], v[11]), true)
			dxDrawRectangle(v[3], v[4]+v[6]-sizex, x, 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), true)

			if not v[12] then
				dxLibary:dxLibary_text(v[9],v[3]+1,v[4]-(40/scale)+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),1,'default','left','center',true,false,true)
				dxLibary:dxLibary_text(v[9],v[3],v[4]-(40/scale),v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3], v[11]),1,'default','left','center',true,false,true)
			end

			dxLibary:dxLibary_text(text,v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,true)
			dxLibary:dxLibary_text(text,v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,true)

			local width = dxGetTextWidth(text, 1, font)
			if (v[3] + width) <= (v[3] + v[5]) then
				local a = v[11] > 75 and interpolateBetween(75, 0, 0, 255, 0, 0, (getTickCount() - tick)/1500, 'SineCurve') or v[11]
				dxDrawRectangle(v[3] + width + 1/scale, v[4] + (v[6] / 4), 2/scale, (v[6] / 2), tocolor(0, 255, 100, a), true)
			else
				v[2] = string.sub(v[2], 0, string.len(v[2]) - 1)
			end
		else
			if v[10] ~= false then
				local x = interpolateBetween(0, 0, 0, v[5], 0, 0, (getTickCount()-v[10])/250, 'Linear')
				dxDrawImage(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, 'images/pasek.png', 0, 0, 0, tocolor(rgb[1], rgb[2], rgb[3], v[11]), true)
				dxDrawRectangle(v[3], v[4]+v[6]-sizex, x, 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), true)
			else
				dxDrawRectangle(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), true)
			end

			if string.len(v[2]) > 0 then
				local txt = v[2]
				if v[7] == true then
					txt = string.rep('*', string.len(v[2]))
				end

				dxLibary:dxLibary_text(txt,v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,true)
				dxLibary:dxLibary_text(txt,v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,true)
			else
				dxLibary:dxLibary_text(v[9],v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,true)
				dxLibary:dxLibary_text(v[9],v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,true)
			end
		end
	end
end

function new_gui(visibled)
	if #edits < 1 then
		closeGui()
  end

	for _,k in pairs(visibled) do
	for i,v in ipairs(edits) do
		if(v[1] == k)then
		local text = ''
		if v[8] == true then
			if v[7] == true then
				text = string.rep('*', string.len(v[2]))
			else
				text = v[2]
			end

			if getKeyState('backspace') then
				trzyma_ms = trzyma_ms + 0.05
			else
				trzyma_ms = 0
			end

			if getKeyState('backspace') and (getTickCount() - tick) > (80 / trzyma_ms) then
				v[2] = string.sub(v[2], 0, string.len(v[2])-1)
				tick = getTickCount()
			end
		else
			text = v[2]
		end

		if v[8] == true then
			local x = interpolateBetween(v[5], 0, 0, 0, 0, 0, (getTickCount()-v[10])/250, 'Linear')
			dxDrawImage(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, 'images/pasek.png', 0, 0, 0, tocolor(rgb[1], rgb[2], rgb[3], v[11]), false)
			dxDrawRectangle(v[3], v[4]+v[6]-sizex, x, 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), false)

			if not v[12] then
				dxLibary:dxLibary_text(v[9],v[3]+1,v[4]-(40/scale)+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),1,'default','left','center',true,false,false)
				dxLibary:dxLibary_text(v[9],v[3],v[4]-(40/scale),v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3], v[11]),1,'default','left','center',true,false,false)
			end

			dxLibary:dxLibary_text(text,v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,false)
			dxLibary:dxLibary_text(text,v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,false)

			local width = dxGetTextWidth(text, 1, font)
			if (v[3] + width) <= (v[3] + v[5]) then
				local a = v[11] > 75 and interpolateBetween(75, 0, 0, 255, 0, 0, (getTickCount() - tick)/1500, 'SineCurve') or v[11]
				dxDrawRectangle(v[3] + width + 1/scale, v[4] + (v[6] / 4), 2/scale, (v[6] / 2), tocolor(0, 100, 255, a), falsee)
			else
				v[2] = string.sub(v[2], 0, string.len(v[2]) - 1)
			end
		else
			if v[10] ~= false then
				local x = interpolateBetween(0, 0, 0, v[5], 0, 0, (getTickCount()-v[10])/250, 'Linear')
				dxDrawImage(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, 'images/pasek.png', 0, 0, 0, tocolor(rgb[1], rgb[2], rgb[3], v[11]), false)
				dxDrawRectangle(v[3], v[4]+v[6]-sizex, x, 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), false)
			else
				dxDrawRectangle(v[3], v[4]+v[6]-sizex, v[5], 2.5/scale, tocolor(rgb[1], rgb[2], rgb[3], v[11]), false)
			end

			if string.len(v[2]) > 0 then
				local txt = v[2]
				if v[7] == true then
					txt = string.rep('*', string.len(v[2]))
				end

				dxLibary:dxLibary_text(txt,v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,false)
				dxLibary:dxLibary_text(txt,v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,false)
			else
				dxLibary:dxLibary_text(v[9],v[3]+1,v[4]+1,v[5]+v[3]+1,v[6]+v[4]+1,tocolor(0, 0, 0,v[11]),3,'default','left','center',true,false,false)
				dxLibary:dxLibary_text(v[9],v[3],v[4],v[5]+v[3],v[6]+v[4],tocolor(rgb[1], rgb[2], rgb[3],v[11]),3,'default','left','center',true,false,false)
			end
		end
		end
		end
	end
end

function key(key, press)
	if not press then return end

	if key == 'tab' then
		for i = 1,#edits do
			if edits[i][8] == true then
				if edits[i+1] and not wraca then
					if (i+1) == #edits then
						wraca = true
					end

					edits[i][8] = false
					edits[i+1][8] = true
					edits[i][10] = getTickCount()
					edits[i+1][10] = getTickCount()
					return
				elseif edits[i-1] then
					if (i-1) == 1 then
						wraca = false
					end

					edits[i][8] = false
					edits[i-1][8] = true
					edits[i][10] = getTickCount()
					edits[i-1][10] = getTickCount()
					return
				end
			end
		end
	end
end

function clicked(btn, state)
	if btn ~= 'state' and state ~= 'down' then return end

	for i,v in ipairs(edits) do
		if isMouseIn(v[3], v[4], v[5], v[6]) then
			if v[8] ~= true then
				if i == 1 then
					wraca = false
				else
					wraca = true
				end

				for _,k in ipairs(edits) do
					k[8] = false
				end

				v[8] = true
				guiSetInputEnabled(true)
				v[10] = getTickCount()
				startPaste()
				return
			end
		end

		if v[8] == true then
			v[8] = false
			guiSetInputEnabled(false)
			v[10] = getTickCount()
			stopPaste()
		end
	end
end