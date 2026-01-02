sx,sy = guiGetScreenSize()
textsToDraw = {}
maxrange = 15
addEventHandler("onClientRender",root,
    function()
        for a,b in pairs(textsToDraw) do
            x,y,z = b[1],b[2],b[3]
            scx,scy = getScreenFromWorldPosition (x,y,z)
            camX,camY,camZ = getCameraMatrix()
            if scx and scy and getDistanceBetweenPoints3D(camX,camY,camZ,x,y,z+5) <= maxrange then 
            dxDrawFramedText(b[4],scx-0.5*dxGetTextWidth(b[4],0.2,"arial"),scy+30-0.5*dxGetFontHeight(0.2,"arial"),sx, sy+5,tocolor ( b[5], b[6], b[7], 255 ), 1.3,"arial")
            end
        end
    end
)

function AgregarTextoMarcadores(x,y,z,text,r,g,b)
    table.insert(textsToDraw,{x,y,z,text,r,g,b})
end

function dxDrawFramedText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI , frameColor )
	color = color or tocolor ( 255 , 255 , 255 , 255 )
	frameColor = frameColor or tocolor ( 0 , 0 , 0 , 255 )
	scale = scale or 0.0
	font = font or "arial"
	alignX = alignX or "left"
	alignY = alignY or "top"
	clip = clip or false
	wordBreak = wordBreak or false
	postGUI = postGUI or false
	dxDrawText ( message , left + 1 , top + 1 , width + 1 , height + 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left + 1 , top - 1 , width + 1 , height - 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top + 1 , width - 1 , height + 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left - 1 , top - 1 , width - 1 , height - 1 , frameColor , scale , font , alignX , alignY , clip , wordBreak , postGUI )
	dxDrawText ( message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI )
end

AgregarTextoMarcadores(2410.0146484375, 99.486328125, 27.96773147583-1,"/Trabajar /Renunciar",0,255,18)
AgregarTextoMarcadores(2410.0146484375, 99.486328125, 27.96773147583-1.5,"Carpintero",255,255,255)
AgregarTextoMarcadores(2420.8427734375, 83.5205078125, 26.470560073853,"Click derecho para procesar",0,255,18)
AgregarTextoMarcadores(2419.69140625, 97.9677734375, 26.4765625,"Click derecho para recoger",0,255,18)
AgregarTextoMarcadores(2407.015625, 83.916801452637, 26.473546981812+0.5,"/vendersilla",0,255,18)




