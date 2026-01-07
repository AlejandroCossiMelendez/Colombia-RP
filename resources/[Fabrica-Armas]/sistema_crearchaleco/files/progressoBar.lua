
local screenW2, screenH2   = guiGetScreenSize()
local resW2, resH2       = 1920,1080
local x2, y2               = (screenW2/resW2), (screenH2/resH2)

downloading = false
local start = {}
function dxDrawLoading ()
    local now = getTickCount()
    seconds = second or timer
	local color = color or tocolor(0,0,0,170)
	local color2 = color2 or tocolor(139,0,139,170)
	local size = size or x2*1.00
    local with = interpolateBetween(0,0,0,0.2531,0,0, (now - start) / ((start + seconds) - start), "Linear")
    local text = interpolateBetween(0,0,0,100,0,0,(now - start) / ((start + seconds) - start),"Linear")
        dxDrawRectangle(screenW2 * 0.3792, screenH2 * 0.6907, screenW2 * 0.2635, screenH2 * 0.0407, tocolor(0, 0, 0, 193), false)
        dxDrawRectangle(screenW2 * 0.3844, screenH2 * 0.7000, screenW2 * with, screenH2 * 0.0222, tocolor(0, 65, 213), false)
        dxDrawText(math.floor(text).."%", screenW2 * 0.3792, screenH2 * 0.6907, screenW2 * 0.6427, screenH2 * 0.7315, tocolor(255, 255, 255, 254), x2*1.00, "default-bold", "center", "center", false, false, false, false, false)
	if msgProgress then
	     dxDrawText("#0041D5"..msgProgress or "", screenW2 * 0.3203, screenH2 * 0.6546, screenW2 * 0.7000, screenH2 * 0.6880, tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, false, false, true, false)
	end
 end

function progressServiceMBar (timeP, msgP)
     if not (downloading == false) then
         removeEventHandler("onClientRender", root, dxDrawLoading)		
    	 downloading = false 
	 end
	 if msgP then
	     msgProgress = msgP
	 end
	     if timeP then
	         timer = timeP*1000
	         setTimer(progressServiceMBar, timer, 1)
             addEventHandler("onClientRender", root, dxDrawLoading)
		     downloading = true
		     start = getTickCount()
             else
             removeEventHandler("onClientRender", root, dxDrawLoading)		
    		 downloading = false 
     end
end
addEvent("progressServiceM", true)
addEventHandler("progressServiceM", root, progressServiceMBar)

local x2,y2 = guiGetScreenSize()
 function isCursorOnElement(x2,y2,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x2 and cursorx < x2 + w and cursory > y2 and cursory < y2 + h then
		return true
	else
		return false
	end
end