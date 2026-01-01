painel = false

	function dxpainel()
        dxDrawRectangle(377, 343, 279, 200, tocolor(0, 0, 0, 162), false)
        dxDrawRectangle(377, 343, 279, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(458, 393, 122, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(387, 430, 122, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(520, 430, 122, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(387, 476, 122, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(520, 476, 122, 17, tocolor(14, 114, 190, 247), false)
        dxDrawRectangle(458, 516, 122, 17, tocolor(14, 114, 190, 247), false)
		dxDrawText("Abrir puertas", 484, 343, 615, 357, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("Abrir puertas", 484, 343, 615, 357, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("Capon", 501, 393, 632, 407, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("Puerta-Conductor", 397, 430, 528, 444, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("  Puerta-Pasajero", 525, 430, 656, 444, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("   Izquierda", 409, 476, 540, 490, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("   Derecha", 544, 476, 675, 490, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
        dxDrawText("   Cajuela", 485, 516, 632, 530, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)


    end


function porta1 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (458, 393, 122, 17) then
triggerServerEvent ("porta1", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta1)

function porta2 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (387, 430, 122, 17) then
triggerServerEvent ("porta2", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta2)

function porta3 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (520, 430, 122, 17) then
triggerServerEvent ("porta3", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta3)

function porta4 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (387, 476, 122, 17) then
triggerServerEvent ("porta4", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta4)

function porta5 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (520, 476, 122, 17) then
triggerServerEvent ("porta5", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta5)

function porta6 (_,state)
if painel == true then
if state == "down" then
if isCursorOnElement (458, 516, 122, 17) then
triggerServerEvent ("porta6", getLocalPlayer())
end
end
end
end
addEventHandler ("onClientClick", root, porta6)

function abrir (_,state)
if painel == false then
showCursor(true)
addEventHandler("onClientRender", root, dxpainel)
painel = true
else
showCursor(false)
removeEventHandler("onClientRender", root, dxpainel)
painel = false
end
end
bindKey("F7", "down", abrir)

local x,y = guiGetScreenSize()

function isCursorOnElement(x,y,w,h)
 local mx,my = getCursorPosition ()
 local fullx,fully = guiGetScreenSize()
 cursorx,cursory = mx*fullx,my*fully
 if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
  return true
 else
  return false
 end
end






