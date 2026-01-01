local robotoFontx32  = guiCreateFont("rcs/roboto.ttf", 48)
local robotoFontx16  = guiCreateFont("rcs/roboto.ttf", 16)
local robotoFontx20 = guiCreateFont("rcs/roboto.ttf", 30)
local robotoFontx12  = guiCreateFont("rcs/roboto.ttf", 12)

-- PANEL

GUIEditor = {
    label = {}
}
local screenW, screenH = guiGetScreenSize()
local x, y = 1, 1

    huellaPanel = guiCreateStaticImage((screenW - (475*x)) / 2, (screenH - (287*y)) / 2, (475*x), (287*y), "rcs/huella.png", false)
    guiSetVisible(huellaPanel, false)
    closeButton1 = guiCreateButton(445*x, 0*y, 20*x, 20*y, "X", false, huellaPanel)
        atmPanel = guiCreateStaticImage((screenW - (475*x)) / 2, (screenH - (287*y)) / 2, (475*x), (287*y), "rcs/background.png", false)
        guiSetVisible(atmPanel, false)
        GUIEditor.label[1] = guiCreateLabel(180*x, 10*y, 47*x, 79*y, "A", false, atmPanel)
        guiSetFont(GUIEditor.label[1], robotoFontx32)
        guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
        GUIEditor.label[2] = guiCreateLabel(215*x, 10*y, 47*x, 79*y, "T", false, atmPanel)
        guiSetFont(GUIEditor.label[2], robotoFontx32)
        guiLabelSetColor(GUIEditor.label[2], 255, 165, 4)
        guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
        GUIEditor.label[3] = guiCreateLabel(260*x, 10*y, 47*x, 79*y, "M", false, atmPanel)
        guiSetFont(GUIEditor.label[3], robotoFontx32)
        guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
        GUIEditor.label[4] = guiCreateLabel(19*x, 109*y, 136*x, 50*y, "¡Bienvenido!", false, atmPanel)
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", false)
        guiSetFont(GUIEditor.label[4], robotoFontx16)
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")
        montoLabel = guiCreateEdit(12*x, 166*y, 153*x, 39*y, "Monto", false, atmPanel)
        retirarButton = guiCreateButton(17*x, 215*y, 148*x, 36*y, "Retirar", false, atmPanel)
        closeButton = guiCreateButton(445*x, 0*y, 20*x, 20*y, "X", false, atmPanel)
        saldoLabel = guiCreateLabel(213*x, 167*y, 235*x, 38*y, "$0000000", false, atmPanel)
        guiSetFont(saldoLabel, robotoFontx20)
        GUIEditor.label[5] = guiCreateLabel(200*x, 109*y, 247*x, 57*y, "Tu saldo es de:", false, atmPanel)
        guiLabelSetHorizontalAlign(GUIEditor.label[5], "left", false)
        guiSetFont(GUIEditor.label[5], robotoFontx12)
        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")    

        comprarTarjetaWindow = guiCreateWindow((screenW - (350*x)) / 2, (screenH - (199*y)) / 2, 350*x, 199*y, "¡No tienes una tarjeta!", false)
        guiWindowSetSizable(comprarTarjetaWindow, false)
        guiSetVisible(comprarTarjetaWindow, false)

        GUIEditor.label[6] = guiCreateLabel(7*x, 21*y, 333*x, 78*y, "Debido a que no posees una tarjeta, no puedes acceder a nuestros cajeros. Compra una tarjeta por $200 para acceder.", false, comprarTarjetaWindow)
        guiLabelSetHorizontalAlign(GUIEditor.label[6], "left", true)
        guiLabelSetVerticalAlign(GUIEditor.label[6], "center")
        comprarTarjetaButton = guiCreateButton(10*x, 106*y, 330*x, 35*y, "Comprar tarjeta", false, comprarTarjetaWindow)
        salirCompra = guiCreateButton(10*x, 151*y, 330*x, 35*y, "Salir", false, comprarTarjetaWindow)    

        accionesWindow = guiCreateWindow((screenW - (411*x)) / 2, (screenH - (260*y)) / 2, 411*x, 260*y, "Acciones bancarias", false)
        guiWindowSetSizable(accionesWindow, false)
        guiSetVisible(accionesWindow, false)
        GUIEditor.label[7] = guiCreateLabel(14*x, 22*y, 387*x, 42*y, "Bienvenido al banco. \nAquí puedes ingresar y retirar dinero de tu cuenta de banco.", false, accionesWindow)
        guiLabelSetHorizontalAlign(GUIEditor.label[7], "center", true)
        closeButton2 = guiCreateButton(381*x, 20*y, 20*x, 20*y, "X", false, accionesWindow)
        cantidadAccionesEdit = guiCreateEdit(44*x, 76*y, 334*x, 56*y, "Cantidad", false, accionesWindow)
        ingresardineroButton = guiCreateButton(46*x, 147*y, 332*x, 40*y, "Ingresar dinero a la cuenta bancaria", false, accionesWindow)
        retirarDineroButton = guiCreateButton(46*x, 197*y, 332*x, 40*y, "Retirar dinero de la cuenta bancaria", false, accionesWindow)    

--"SELECT * FROM banks ORDER BY bankID ASC"

addEventHandler("onClientGUIFocus", montoLabel, function()
    if guiGetText(montoLabel) == "Monto" then 
        guiSetText(montoLabel, "")
        guiSetProperty(montoLabel, "ValidationString", "^[0-9]*$")
    end
end, false)

addEventHandler("onClientGUIFocus", cantidadAccionesEdit, function()
    if guiGetText(cantidadAccionesEdit) == "Cantidad" then 
        guiSetText(cantidadAccionesEdit, "")
        guiSetProperty(cantidadAccionesEdit, "ValidationString", "^[0-9]*$")
    end
end, false)

addEventHandler("onClientGUIClick", closeButton, function()
    guiSetVisible(atmPanel, false)
    showCursor(false)
    reconociendo = false
end, false)

addEventHandler("onClientGUIClick", closeButton1, function()
    guiSetVisible(huellaPanel, false)
    showCursor(false)
end, false)

addEventHandler("onClientGUIClick", closeButton2, function()
    guiSetVisible(accionesWindow, false)
    showCursor(false)
    
end, false)

addEventHandler("onClientGUIClick", comprarTarjetaButton, function()
    triggerServerEvent("comprarTarjeta", localPlayer)
    guiSetVisible(comprarTarjetaWindow, false)
    showCursor(false)
end, false)

addEventHandler("onClientGUIClick", salirCompra, function()
    guiSetVisible(comprarTarjetaWindow, false)
    showCursor(false)
end, false)
local reconociendo = false
addEventHandler("onClientGUIClick", huellaPanel, function()
    guiSetVisible(huellaPanel, false)
    showCursor(false)
    outputChatBox("[CAJERO] Por favor, espera un momento mientras reconocemos tu huella..", 255, 255, 255)
    reconociendo = true
    setTimer(guiSetVisible, 2000, 1,atmPanel, true)
    setTimer(showCursor, 2000, 1, true)
    setTimer(outputChatBox, 2000, 1, "[CAJERO] Huella reconocida con éxito. Bienvenido de nuevo.", 0, 255, 0)
end, false)

addEventHandler("onClientGUIClick", retirarDineroButton, function()
    local money = getElementData(localPlayer, "moneyInBank")
    local moneyToOut = guiGetText(cantidadAccionesEdit)
    if (moneyToOut == "") or (moneyToOut == "Cantidad") then 
        outputChatBox("[CAJERO] ¡Debes especificar la cantidad a retirar!", 255, 0, 0)
    else
        moneyToOut = tonumber(moneyToOut)
        if moneyToOut > 0 then 
            if (moneyToOut == money) or (moneyToOut < money) then 
                triggerServerEvent("retirarDinero", localPlayer, moneyToOut)
                guiSetEnabled(retirarDineroButton, false)
                guiSetEnabled(ingresardineroButton, false)
                guiSetVisible(accionesWindow, false)
                showCursor(false)
                reconociendo = false
                outputChatBox("[CAJERO] Retiraste $".. moneyToOut .. " de tu cuenta de banco con éxito.", 0, 255, 0)
            else
                outputChatBox("[CAJERO] No tienes tanto dinero en el banco.", 255, 0, 0)
            end
        else
            outputChatBox("[CAJERO] No puedes retirar menos de $1.", 255, 0, 0)
        end
    end
end, false)

addEventHandler("onClientGUIClick", ingresardineroButton, function()
    local money = getPlayerMoney(localPlayer)
    local moneyToIn = guiGetText(cantidadAccionesEdit)
    if (moneyToIn == "") or (moneyToIn == "Cantidad") then 
        outputChatBox("[CAJERO] ¡Debes especificar la cantidad a retirar!", 255, 0, 0)
    else
        moneyToIn = tonumber(moneyToIn)
        if moneyToIn > 0 then 
            if (moneyToIn == money) or (moneyToIn < money) then 
                triggerServerEvent("ingresarDinero", localPlayer, moneyToIn)
                guiSetEnabled(retirarDineroButton, false)
                guiSetEnabled(ingresardineroButton, false)
                guiSetVisible(accionesWindow, false)
                showCursor(false)
                outputChatBox("[CAJERO] Ingresaste $".. moneyToIn .. " a tu cuenta de banco con éxito.", 0, 255, 0)
            else
                outputChatBox("[CAJERO] No tienes tanto dinero en la billetera.", 255, 0, 0)
            end
        else
            outputChatBox("[CAJERO] No puedes ingresar menos de $1.", 255, 0, 0)
        end
    end
end, false)

addEventHandler("onClientGUIClick", retirarButton, function()
    local money = getElementData(localPlayer, "moneyInBank")
    local moneyToOut = guiGetText(montoLabel)
    if (moneyToOut == "") or (moneyToOut == "Monto") then 
        outputChatBox("[CAJERO] ¡Debes especificar la cantidad a retirar!", 255, 0, 0)
    else
        moneyToOut = tonumber(moneyToOut)
        if moneyToOut > 0 then 
            if (moneyToOut == money) or (moneyToOut < money) then 
                triggerServerEvent("retirarDinero", localPlayer, moneyToOut)
                guiSetEnabled(retirarButton, false)
                guiSetVisible(atmPanel, false)
                showCursor(false)
                reconociendo = false
                outputChatBox("[CAJERO] Retiraste $".. moneyToOut .. " de tu cuenta de banco con éxito.", 0, 255, 0)
            else
                outputChatBox("[CAJERO] No tienes tanto dinero en el banco.", 255, 0, 0)
            end
        else
            outputChatBox("[CAJERO] No puedes retirar menos de $1.", 255, 0, 0)
        end
    end
end, false)
local atmtable1 = nil

thePed = createPed(211, 2306.9697265625, -7.88671875, 26.7421875, 266.32638549805, true)
setElementFrozen(thePed, true)
setElementDimension(thePed, 0)
setElementInterior(thePed, 0)
addEventHandler("onClientPedDamage", thePed, function()
    cancelEvent()
end)

addEventHandler("onClientClick", root, function(button, state, absX, absDY, wX, wY, wZ, cW)
    if state == 'up' then 
        if isElement(cW) then 
            if (cW == thePed) then 
                if getElementData(localPlayer, "moneyInBank") then 
                    guiSetText(GUIEditor.label[7], "Bienvenido al banco. \nAquí puedes ingresar y retirar dinero de tu cuenta de banco.\nTu saldo es $".. getElementData(localPlayer, "moneyInBank"))
                    guiSetEnabled(retirarDineroButton, true)
                    guiSetEnabled(ingresardineroButton, true)
                    guiSetVisible(accionesWindow, true)
                else
                    guiSetVisible(comprarTarjetaWindow, true)
                end
            end
        end
    end
end)

-----

thePed1 = createPed(211, 359.7138671875, 173.8173828125, 1008.3893432617, 271.24285888672, true)
setElementFrozen(thePed1, true)
setElementDimension(thePed1, 1119)
setElementInterior(thePed1, 3)
addEventHandler("onClientPedDamage", thePed1, function()
    cancelEvent()
end)

addEventHandler("onClientClick", root, function(button, state, absX, absDY, wX, wY, wZ, cW)
    if state == 'up' then 
        if isElement(cW) then 
            if (cW == thePed1) then 
                if getElementData(localPlayer, "moneyInBank") then 
                    guiSetText(GUIEditor.label[7], "Bienvenido al banco. \nAquí puedes ingresar y retirar dinero de tu cuenta de banco.\nTu saldo es $".. getElementData(localPlayer, "moneyInBank"))
                    guiSetEnabled(retirarDineroButton, true)
                    guiSetEnabled(ingresardineroButton, true)
                    guiSetVisible(accionesWindow, true)
                else
                    guiSetVisible(comprarTarjetaWindow, true)
                end
            end
        end
    end
end)



triggerServerEvent("requestATM", localPlayer)
addEvent("returnATM", true)
addEventHandler("returnATM", root, function(ATMTable)
    atmtable1 = nil
    atmtable1 = ATMTable
    for i, bank in ipairs (ATMTable) do 
        addEventHandler("onClientClick", root, function(button, state, absX, absDY, wX, wY, wZ, cW)
            if state == 'up' then 
                if isElement(cW) then 
                    if (cW == bank) then 
                        local x, y, z = getElementPosition(cW)
                        local px, py, pz = getElementPosition(localPlayer)
                        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then 
                            if getElementData(localPlayer, "moneyInBank") then 
                                if not (guiGetVisible(huellaPanel)) or not (guiGetVisible(atmPanel)) or not reconociendo then 
                                    guiSetText(saldoLabel, "$"..tostring(getElementData(localPlayer, "moneyInBank")))
                                    if getElementData(localPlayer, "moneyInBank") >  0 then 
                                        guiLabelSetColor(saldoLabel, 0, 255, 0)
                                    else
                                        guiLabelSetColor(saldoLabel, 255, 0, 0)
                                    end
                                    guiSetEnabled(retirarButton, true)
                                    guiSetVisible(huellaPanel, true)
                                end
                            else
                                if not guiGetVisible(comprarTarjetaWindow) then 
                                    guiSetVisible(comprarTarjetaWindow, true)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end


local veratm = false

function showIDATM()
    if veratm then 
        if atmtable1 then 
            for i, v in ipairs (atmtable1) do 
                dxDrawTextOnElement(v, "ID: "..getElementData(v, "ID"), 2, 30, 255, 255, 255, 255, 5, "pricedown")
            end
        end
    else
        removeEventHandler("onClientRender", root, showIDATM)
    end
end

addEvent("verATM", true)
addEventHandler("verATM", root, function()
    if not (veratm) then 
        veratm = true
        addEventHandler("onClientRender", root, showIDATM)
    else
        removeEventHandler("onClientRender", root, showIDATM)
        veratm = false
    end
end)