-- Sistema de camaras de seguridad.



----- Definición del panel.
function VerCamaras()
		local x,y = guiGetScreenSize()
		local width,height = 450,470
		x = x-width
		y = (y-height)/2
		cams_wnd = guiCreateWindow(x,y,width,height, "Camaras de Seguridad  -|-|-|-  Cambiar Lentes", false)
		button_cam_one = guiCreateButton(38,30,180,30, "Frente De Comisaria", false,cams_wnd)
		button_cam_two = guiCreateButton(38,75,180,30, "Entrada 1", false,cams_wnd)
		button_cam_three = guiCreateButton(38,120,180,30, "Tiendas D1", false,cams_wnd)
		button_cam_four = guiCreateButton(38,165,180,30, "Puente Blanco", false,cams_wnd)
		button_cam_five = guiCreateButton(38,210,180,30, "Comuna 13 - 1", false,cams_wnd)
		button_cam_six = guiCreateButton(38,255,180,30, "Comuna 13 - 2", false,cams_wnd)
		button_cam_seven = guiCreateButton(38,300,180,30, "Pizza Mania", false,cams_wnd)
		button_cam_eight = guiCreateButton(38,345,180,30, "Hospital", false,cams_wnd)
		button_cam_nine = guiCreateButton(38,390,180,30, "Puente Rojo", false,cams_wnd)
		button_cam_close = guiCreateButton(38,435,180,30, "Cerrar", false,cams_wnd)
		button_vid_normal = guiCreateButton(233,30,180,30, "Normal", false,cams_wnd)
		button_vid_night = guiCreateButton(233,75,180,30, "Nocturna", false,cams_wnd)
		button_vid_teplo = guiCreateButton(233,120,180,30, "Termica", false,cams_wnd)
		showCursor(true)
		setElementFrozen(getLocalPlayer(),true)
end
addEvent("VerCamarasPolicia", true)
addEventHandler("VerCamarasPolicia", getLocalPlayer(), VerCamaras)


-------- Camaras Definidas
addEventHandler("onClientGUIClick",getRootElement(),function()
	if (source == button_vid_normal) then
        setCameraGoggleEffect("normal")
	end
	if (source == button_vid_night) then
        setCameraGoggleEffect("nightvision")
	end
	if (source == button_vid_teplo) then
        setCameraGoggleEffect("thermalvision")
	end
	if (source == button_cam_one) then
        fadeCamera (true)
        setCameraMatrix(650.71484375, -576.4072265625, 20.875968933105, -2056.7568359375 , 318.5869140625 , 15.192873001099 , 0 , 90 )
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de el frente",0,255,0)
	end
	if (source == button_cam_two) then
        fadeCamera (true)
        setCameraMatrix( 667.2646484375, -603.271484375, 27.502040863037, -1533.166015625, 762.693359375, -10.608016967773 , 0 , 80)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de la entrada 1",0,255,0)
	end
	if (source == button_cam_three) then
        fadeCamera (true)
        setCameraMatrix( 272.7236328125, -80.431640625, 6.9043884277344, -1454.212890625, 858.783203125, -9.8239154815674, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del D1",0,255,0)
	end
	if (source == button_cam_four) then
        fadeCamera (true)
        setCameraMatrix(630.1337890625, 342.126953125, 22.282518386841, -2111.203125, 339.1494140625, 29.513427734375, 0, 100)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de Puente blanco",0,255,0)
	end
	if (source == button_cam_five) then
        fadeCamera (true)
        setCameraMatrix( 1113.556640625, 1.7958984375, 69.566925048828, -2098.64453125, -105.71484375, 16.507440567017, 0, 130)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de comuna 13",0,255,0)
	end
	if (source == button_cam_six) then
        fadeCamera (true)
        setCameraMatrix(993.474609375, -2.2939453125, 98.506698608398, -2376.9140625, -131.2490234375, -0.23512749373913, 0, 100)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de Comuna 13",0,255,0)
	end
	if (source == button_cam_seven) then
        fadeCamera (true)
        setCameraMatrix(1371.09765625, 257.7685546875, 22.020946502686, -1680.4990234375, -21.48046875, -14.644105911255, 0 , 120)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de pizza mania",0,255,0)
	end
	if (source == button_cam_eight) then
        fadeCamera (true)
        setCameraMatrix( -273.8857421875, 1056.998046875, 26.887149810791, -2614.69140625, 679.3935546875, -27.277629852295, 0, 100)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Hospital",0,255,0)
	end
	if (source == button_cam_nine) then
        fadeCamera (true)
        setCameraMatrix(-178.6611328125, 243.9296875, 14.577333450317, -2676.369140625, 390.162109375, -17.432621002197, 0, 90)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Ayuntamiento",0,255,0)
	end
	if (source == button_cam_close) then
        fadeCamera (true)
		setCameraTarget (getLocalPlayer())
	    showCursor(false)
		guiSetVisible(cams_wnd,false)
		setCameraGoggleEffect("normal")
		setElementFrozen(getLocalPlayer(),false)
	    outputChatBox("Has Apagado el ordenador de las cámaras",0,255,0)
	    setElementData(getLocalPlayer(),"concamaraspd",false)
	end
end)