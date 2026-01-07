-- Sistema de camaras de seguridad.



----- Definición del panel.
function VerCamaras()
		local x,y = guiGetScreenSize()
		local width,height = 500,550
		x = x-width
		y = (y-height)/2
		cams_wnd = guiCreateWindow(x,y,width,height, "Camaras de Seguridad  -|-|-|-  Cambiar Lentes", false)
		button_cam_one = guiCreateButton(38,30,180,30, "Transito", false,cams_wnd)
		button_cam_two = guiCreateButton(38,75,180,30, "Transito 2", false,cams_wnd)
		button_cam_three = guiCreateButton(38,120,180,30, "Tiendas D1", false,cams_wnd)
		button_cam_four = guiCreateButton(38,165,180,30, "Puente Blanco", false,cams_wnd)
		button_cam_five = guiCreateButton(38,210,180,30, "Favela - 1", false,cams_wnd)
		button_cam_six = guiCreateButton(38,255,180,30, "Favela - 2", false,cams_wnd)
		button_cam_seven = guiCreateButton(38,300,180,30, "Pizza Mania", false,cams_wnd)
		button_cam_eight = guiCreateButton(38,345,180,30, "Hospital", false,cams_wnd)
		button_cam_nine = guiCreateButton(38,390,180,30, "Puente Rojo", false,cams_wnd)
		button_cam_ten = guiCreateButton(38,435,180,30, "Prision", false,cams_wnd)
		button_cam_eleven = guiCreateButton(38,480,180,30, "Celdas Prision", false,cams_wnd)
		button_cam_close = guiCreateButton(38,525,180,30, "Cerrar", false,cams_wnd)
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
        setCameraMatrix(1214.2830810547, 187.95782470703, 27.946784973145, 1301.1400146484 , 227.19784545898 , -2.3203494548798 , 0 , 90 )
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de el frente",0,255,0)
	end
	if (source == button_cam_two) then
        fadeCamera (true)
        setCameraMatrix( 1246.1137695312, 172.90405273438, 25.389245986938, 1308.8875732422, 247.2067565918, 2.1823453903198 , 0 , 80)
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
        setCameraMatrix(621.79406738281, 278.95068359375, 28.787073135376, 608.98449707031, 376.26751708984, 9.6729955673218, 0, 100)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de Puente blanco",0,255,0)
	end
	if (source == button_cam_five) then
        fadeCamera (true)
        setCameraMatrix( 736.72552490234, 846.64202880859, 9.2811965942383, 651.47515869141, 866.66009521484, -39.00594329834, 0, 90)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de comuna 13",0,255,0)
	end
	if (source == button_cam_six) then
        fadeCamera (true)
        setCameraMatrix(529.82775878906, 920.3876953125, -20.681652069092, 618.65802001953, 878.62847900391, -39.79573059082, 0, 100)
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
        setCameraMatrix(-256.01403808594, 212.91575622559, 24.673578262329, -177.46505737305, 273.21008300781, 10.721819877625, 0, 90)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Ayuntamiento",0,255,0)
	end
	if (source == button_cam_ten) then
        fadeCamera (true)
        setCameraMatrix(217.83976745605, 1348.1408691406, 26.119180679321, 163.70529174805, 1427.3277587891, -2.1456830501556, 0, 90)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Ayuntamiento",0,255,0)
	end
	if (source == button_cam_eleven) then
        fadeCamera (true)
        setCameraMatrix(128.09791564941, 1409.6561279297, 21.450695037842, 222.33515930176, 1413.4093017578, -11.794689178467, 0, 120)
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