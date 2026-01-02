function CrearVentanaArmasA()
	PanelArmasVenta = guiCreateWindow(350,250,450,490,"Pedir Importación Ilegal",false)
	guiCreateLabel(35,35,340,60,"Cajas de armas con 1 unidad disponible",false,PanelArmasVenta)
	textito = guiCreateLabel(35,50,360,60,"Estás Armas son precios facciónarios luego tu asigna tus precios",false,PanelArmasVenta)
	guiLabelSetColor(textito, 255, 0, 0)
	BotonCerrar = guiCreateButton(185,390,70,60,"CERRAR",false,PanelArmasVenta)
		
		
		Comprar_AK47    = guiCreateButton(29,210,60,40,"AK-47\n15.000.000$",false,PanelArmasVenta)
		Comprar_UZI     = guiCreateButton(109,210,70,40,"UZI\n12.000.000$",false,PanelArmasVenta)
		Comprar_Pistola   = guiCreateButton(29,330,60,40,"Pistola\n8.000.000$",false,PanelArmasVenta)
		Comprar_Recortada  = guiCreateButton(349,330,60,40,"Recortada\n30.000.000$",false,PanelArmasVenta)

		
		addEventHandler("onClientGUIClick", Comprar_AK47, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_UZI, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Pistola, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Recortada, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", BotonCerrar, abrirpanelarmasNew)

		
		
		
		guiCreateStaticImage(30,140,60,60,"imagenesA/30.png", false,PanelArmasVenta )
		guiCreateStaticImage(110,140,60,60,"imagenesA/28.png", false,PanelArmasVenta )
		guiCreateStaticImage(30,260,60,60,"imagenesA/22.png", false,PanelArmasVenta )
		guiCreateStaticImage(350,260,60,60,"imagenesA/26.png", false,PanelArmasVenta )
		guiCreateStaticImage(20,80,800,80,"imagenesA/logoarmas.png", false,PanelArmasVenta )
		
	guiWindowSetSizable(PanelArmasVenta,false)
	guiSetVisible(PanelArmasVenta,false)
end
addEventHandler("onClientResourceStart", getRootElement(), CrearVentanaArmasA)


function ComprarArmasIlegalesBoton(button, state)

	if (button == "left") then
	
		if(source == Comprar_AK47) then
			triggerServerEvent("PanelComprarArmasAntiHackersPorfavorNomas", localPlayer, "arma_ak47")	
		elseif(source == Comprar_UZI) then
			triggerServerEvent("PanelComprarArmasAntiHackersPorfavorNomas", localPlayer, "arma_uzi")
		elseif(source == Comprar_Pistola) then
			triggerServerEvent("PanelComprarArmasAntiHackersPorfavorNomas", localPlayer, "arma_pistola")
        elseif(source == Comprar_Recortada) then
			triggerServerEvent("PanelComprarArmasAntiHackersPorfavorNomas", localPlayer, "arma_recortada")
		end
	
	end
end

function abrirpanelarmasNew ( )
	guiSetVisible ( PanelArmasVenta, not guiGetVisible ( PanelArmasVenta ) )
    showCursor ( not isCursorShowing( ) )
end
addEvent("AbrirPanelArmasIlegal", true)
addEventHandler("AbrirPanelArmasIlegal", getLocalPlayer(), abrirpanelarmasNew)




