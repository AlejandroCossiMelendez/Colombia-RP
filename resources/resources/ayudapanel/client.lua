local screenH, screenW = guiGetScreenSize()
local x, y = (screenH/1366), (screenW/768)

Font_1 = dxCreateFont("font/font.ttf", 16)
Font_2 = dxCreateFont("font/font.ttf", 11)
Font_3 = dxCreateFont("font/font.ttf", 13)

local J_ajuda = fileOpen("txt/ajuda.txt", true)
local ajuda = fileRead(J_ajuda, 50000)

local J_comandos = fileOpen("txt/comandos.txt", true)
local comandos = fileRead(J_comandos, 50000)

local J_radio = fileOpen("txt/radio.txt", true)
local radio = fileRead(J_radio, 50000)

local J_regras = fileOpen("txt/regras.txt", true)
local regras = fileRead(J_regras, 50000)

local J_vendas = fileOpen("txt/vendas.txt", true)
local vendas = fileRead(J_vendas, 50000)

txt = guiCreateMemo(x*379, y*306, x*607, y*267, "", false)    
guiMemoSetReadOnly (txt, true)
guiSetVisible (txt, false)   

cor = {}

Painel = false
function DxAjuda()

	cor[1] = tocolor(0, 205, 255, 105)
	cor[2] = tocolor(0, 205, 255, 55)
	cor[3] = tocolor(0, 205, 255, 5)
	cor[4] = tocolor(0, 205, 255, 105)
	cor[5] = tocolor(0, 205, 255, 55)
	cor[6] = tocolor(0, 205, 255, 5)
	cor[7] = tocolor(0, 205, 255, 105)
	cor[8] = tocolor(0, 205, 255, 55)
	cor[9] = tocolor(0, 205, 255, 5)
	cor[10] = tocolor(0, 205, 255, 105)
	cor[11] = tocolor(0, 205, 255, 55)
	cor[12] = tocolor(0, 205, 255, 5)
	cor[13] = tocolor(0, 205, 255, 105)
	cor[14] = tocolor(0, 205, 255, 55)
	cor[15] = tocolor(0, 205, 255, 5)
	cor[16] = tocolor(0, 205, 255, 105)
	cor[17] = tocolor(0, 205, 255, 55)
	cor[18] = tocolor(0, 205, 255, 5)

	if cursorPosition(x*557, y*587, x*252, y*24) then cor[1] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*555, y*585, x*256, y*28) then cor[2] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*553, y*583, x*260, y*32) then cor[3] = tocolor(0, 250, 255, 75) end
	if cursorPosition(x*376, y*249, x*108, y*24) then cor[4] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*374, y*247, x*112, y*28) then cor[5] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*372, y*245, x*116, y*32) then cor[6] = tocolor(0, 250, 255, 75) end
	if cursorPosition(x*503, y*249, x*108, y*24) then cor[7] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*501, y*247, x*112, y*28) then cor[8] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*499, y*245, x*116, y*32) then cor[9] = tocolor(0, 250, 255, 75) end
	if cursorPosition(x*629, y*249, x*108, y*24) then cor[10] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*627, y*247, x*112, y*28) then cor[11] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*625, y*245, x*116, y*32) then cor[12] = tocolor(0, 250, 255, 75) end
	if cursorPosition(x*756, y*249, x*108, y*24) then cor[13] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*754, y*247, x*112, y*28) then cor[14] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*752, y*245, x*116, y*32) then cor[15] = tocolor(0, 250, 255, 75) end
	if cursorPosition(x*883, y*249, x*108, y*24) then cor[16] = tocolor(0, 250, 255, 255) end
	if cursorPosition(x*881, y*247, x*112, y*28) then cor[17] = tocolor(0, 250, 255, 155) end
	if cursorPosition(x*879, y*245, x*116, y*32) then cor[18] = tocolor(0, 250, 255, 75) end

        dxDrawRectangle(x*350, y*180, x*666, y*456, tocolor(0, 0, 0, 200), false)
        --[[dxDrawRectangle(x*352, y*182, x*662, y*452, tocolor(0, 0, 0, 60), false)
        dxDrawRectangle(x*354, y*184, x*658, y*448, tocolor(0, 0, 0, 60), false)
        dxDrawRectangle(x*356, y*186, x*654, y*444, tocolor(0, 0, 0, 60), false)
        dxDrawRectangle(x*358, y*188, x*650, y*440, tocolor(0, 0, 0, 60), false)--]]
        dxDrawText("Panel De Ayuda | Verso RP", x*358, y*190, x*1008, y*226, tocolor(255, 255, 255, 255), x*1.00, Font_1, "center", "center", false, false, false, false, false)
        --dxDrawText("-------------------------------------------------------------------------------------------------------------------------------------------------------------------", x*358, y*227, x*1008, y*237, tocolor(255, 255, 255, 255), x*1.00, "default", "center", "center", false, false, false, false, false)
        --dxDrawText("-------------------------------------------------------------------------------------------------------------------------------------------------------------------", x*358, y*286, x*1008, y*296, tocolor(255, 255, 255, 255), x*1.00, "default", "center", "center", false, false, false, false, false)

        --dxDrawRectangle(x*557, y*587, x*252, y*24, cor[1], false)
        --dxDrawRectangle(x*555, y*585, x*256, y*28, cor[2], false)
        --dxDrawRectangle(x*553, y*583, x*260, y*32, cor[3], false)
        --dxDrawText("Cerrar Panel", x*555, y*585, x*811, y*613, tocolor(255, 255, 255, 255), x*1.00, Font_3, "center", "center", false, false, false, false, false)

        dxDrawRectangle(x*376, y*249, x*108, y*24, cor[4], false)
        --dxDrawRectangle(x*374, y*247, x*112, y*28, cor[5], false)
        --dxDrawRectangle(x*372, y*245, x*116, y*32, cor[6], false)

        dxDrawRectangle(x*503, y*249, x*108, y*24, cor[7], false)
        --dxDrawRectangle(x*501, y*247, x*112, y*28, cor[8], false)
        --dxDrawRectangle(x*499, y*245, x*116, y*32, cor[9], false)

        dxDrawRectangle(x*629, y*249, x*108, y*24, cor[10], false)
        --dxDrawRectangle(x*627, y*247, x*112, y*28, cor[11], false)
        --dxDrawRectangle(x*625, y*245, x*116, y*32, cor[12], false)

        dxDrawRectangle(x*756, y*249, x*108, y*24, cor[13], false)
        --dxDrawRectangle(x*754, y*247, x*112, y*28, cor[14], false)
        --dxDrawRectangle(x*752, y*245, x*116, y*32, cor[15], false)

        dxDrawRectangle(x*883, y*249, x*108, y*24, cor[16], false)
        --dxDrawRectangle(x*881, y*247, x*112, y*28, cor[17], false)
        --dxDrawRectangle(x*879, y*245, x*116, y*32, cor[18], false)

        dxDrawText("General", x*374, y*247, x*486, y*275, tocolor(255, 255, 255, 255), x*1.00, Font_2, "center", "center", false, false, false, false, false)
        dxDrawText("Comandos", x*500, y*247, x*613, y*275, tocolor(255, 255, 255, 255), x*1.00, Font_2, "center", "center", false, false, false, false, false)
        dxDrawText("Conceptos", x*627, y*247, x*739, y*275, tocolor(255, 255, 255, 255), x*1.00, Font_2, "center", "center", false, false, false, false, false)
        dxDrawText("Soy Nuevo", x*754, y*247, x*866, y*275, tocolor(255, 255, 255, 255), x*1.00, Font_2, "center", "center", false, false, false, false, false)
        dxDrawText("VIPS", x*881, y*247, x*993, y*275, tocolor(255, 255, 255, 255), x*1.00, Font_2, "center", "center", false, false, false, false, false)
end
	
function clickVip1(button, state)
	if Painel and button == "left" and state == "down" then
		if cursorPosition(x*372, y*245, x*116, y*32) then
			playSoundFrontEnd(1)
			guiSetText(txt,ajuda)
		elseif cursorPosition(x*499, y*245, x*116, y*32) then
			playSoundFrontEnd(1)
			guiSetText(txt,comandos)
		elseif cursorPosition(x*625, y*245, x*116, y*32) then
			playSoundFrontEnd(1)
			guiSetText(txt,radio)
		elseif cursorPosition(x*752, y*245, x*116, y*32) then
			playSoundFrontEnd(1)
			guiSetText(txt,regras)
		elseif cursorPosition(x*879, y*245, x*116, y*32) then
			playSoundFrontEnd(1)
			guiSetText(txt,vendas)
		elseif cursorPosition(x*553, y*583, x*260, y*32) then
			playSoundFrontEnd(1)
			removeEventHandler ("onClientRender", root, DxAjuda)
			Painel = false 
			showCursor (false)
			guiSetVisible (txt, false)
        end
    end
end
addEventHandler("onClientClick", getRootElement(), clickVip1)
	
function abrir()
    if Painel == false then
        addEventHandler ("onClientRender", root, DxAjuda)
        showCursor(true)
		Painel = true
        guiSetVisible (txt, true)
    else
        removeEventHandler ("onClientRender", root, DxAjuda)
        Painel = false 
        showCursor (false)
        guiSetVisible (txt, false)
    end
end
bindKey ("F1", "down", abrir)

function cursorPosition(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function filedelet ()
if fileExists("client.lua") then
   fileDelete("client.lua")
 end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), filedelet)