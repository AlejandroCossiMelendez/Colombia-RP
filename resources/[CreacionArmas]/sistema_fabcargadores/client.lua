local fabrica = createMarker ( 2560.97265625, -1291.3818359375, 1044.125 -1, "cylinder", 1, 0, 0, 0, 155 )
setElementDimension(fabrica, 1980)
setElementInterior(fabrica, 2)


addEventHandler("onClientRender", root,
function()
	if (getDistanceBetweenPoints3D( 2353.3125, -646.6533203125, 128.06198120117, getElementPosition(getLocalPlayer()))) < 15 then
		local coords = {getScreenFromWorldPosition( 2353.3125, -646.6533203125, 128.06198120117)}
		if coords[1] and coords[2] then
			dxDrawText("", coords[1], coords[2], coords[1], coords[2], tocolor(250, 0, 0), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		end
	end
end)

function crearPanelArmas()
    if isElementWithinMarker(localPlayer, fabrica) then
        local screenW, screenH = guiGetScreenSize()
        ventana = guiCreateWindow((screenW - 600) / 2, (screenH - 470) / 2, 600, 470, "Fabricar cargadores", false)
        guiWindowSetSizable(ventana, false)

        guieditora= guiCreateGridList(9, 37, 580, 325, false, ventana)
        guiGridListAddColumn(guieditora, "ID", 0.07)
        guiGridListAddColumn(guieditora, "Cargador", 0.35)
        guiGridListAddColumn(guieditora, "Balas", 0.2)
        guiGridListAddColumn(guieditora, "Polvora", 0.2)
        guiGridListAddColumn(guieditora, "Aluminio", 0.2)

        boton = guiCreateButton(235, 380, 132, 33, "Fabricar", false, ventana)
        guiSetProperty(boton, "NormalTextColour", "FFAAAAAA")   
        
        cerrar = guiCreateButton(277, 430, 46, 23, "Cerrar", false, ventana)
        guiSetProperty(cerrar, "NormalTextColour", "FFAAAAAA") 

        addEventHandler("onClientGUIClick", boton, fabricarParte, false)
        addEventHandler("onClientGUIClick", cerrar, cerrarPanel, false)

        showCursor(true)
        cargarPartes()
    end
end

addEventHandler('onClientMarkerHit', fabrica,
function ( hitPlayer )
    if ( hitPlayer == localPlayer ) then
		crearPanelArmas()
        showCursor( true )
    end
end )

function cerrarPanel()

    destroyElement(ventana)
    showCursor(false)

end


function fabricarParte()

    local row = guiGridListGetSelectedItem(guieditora)
    if (not row or row == -1) then outputChatBox("Seleccione un cargador para fabricar.", 255, 0, 0) return end
    local cargador = guiGridListGetItemText(guieditora, row, 1)
    local polvora = guiGridListGetItemText(guieditora, row, 4)
    local chatarra = guiGridListGetItemText(guieditora, row, 5)

    triggerServerEvent("fabCargador", localPlayer, cargador, polvora, chatarra)

    destroyElement(ventana)
    showCursor(false)
end

function cargarPartes()

    guiGridListClear(guieditora)

    local parte1 = guiGridListAddRow(guieditora)
    guiGridListSetItemText(guieditora, parte1, 1, "1", false, false)
    guiGridListSetItemText(guieditora, parte1, 2, "Cargador de Colt-45", false, false)
    guiGridListSetItemText(guieditora, parte1, 3, "13", false, false)

    guiGridListSetItemText(guieditora, parte1, 4, "2", false, false)
    guiGridListSetItemText(guieditora, parte1, 5, "5", false, false)
    ----------------------------------------------------------------------------------------------------
    local parte2 = guiGridListAddRow(guieditora)
    guiGridListSetItemText(guieditora, parte2, 1, "2", false, false)
    guiGridListSetItemText(guieditora, parte2, 2, "Cargador de Tec-9", false, false)
    guiGridListSetItemText(guieditora, parte2, 3, "30", false, false)

    guiGridListSetItemText(guieditora, parte2, 4, "4", false, false)
    guiGridListSetItemText(guieditora, parte2, 5, "8", false, false)
    ----------------------------------------------------------------------------------------------------
    local parte3 = guiGridListAddRow(guieditora)
    guiGridListSetItemText(guieditora, parte3, 1, "3", false, false)
    guiGridListSetItemText(guieditora, parte3, 2, "Cargador de AK-47", false, false)
    guiGridListSetItemText(guieditora, parte3, 3, "30", false, false)

    guiGridListSetItemText(guieditora, parte3, 4, "9", false, false)
    guiGridListSetItemText(guieditora, parte3, 5, "2", false, false)

end