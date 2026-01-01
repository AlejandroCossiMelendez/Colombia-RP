
--COPYRIGHT ( No borrar por favor. )
-----------------------------------------------------------------------------------------------------------------------------------------------
--PANEL CREADO POR <~KaMiKaZe~> ...
--Gracias por descargar ^-^
--Publicado el día 17/06/18
--Mi Perfil de MTA https://forum.mtasa.com/profile/62475--/
---------------------------------------------------------------------------------------------------------------------------------------------------------
--COPYRIGHT ( No borrar por favor. )

--Función útil ( https://wiki.multitheftauto.com/wiki/GetCurrentFPS )

local fps = false
function getCurrentFPS() --Función útil ( https://wiki.multitheftauto.com/wiki/GetCurrentFPS )
    return fps
end

local function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

--Panel Creado Usando GUIEDITOR...

GUIEditor = {
    label = {}
}

--Panel Creado Usando GUIEDITOR...

-- PANEL

local screenW, screenH = guiGetScreenSize()
local window = guiCreateWindow((screenW - 323) / 2, (screenH - 383) / 2, 323, 370, "Sistema Anti-Lag", false)
guiWindowSetSizable(window, false)
guiSetAlpha(window, 1.00)
vision = guiCreateScrollBar(33, 61, 244, 20, true, false, window)
guiScrollBarSetScrollPosition(vision,50)
GUIEditor.label[1] = guiCreateLabel(102, 35, 165, 16, "Distancia de Visión", false, window)
GUIEditor.label[2] = guiCreateLabel(102, 91, 165, 16, "Distancia de Neblina", false, window)
niebla = guiCreateScrollBar(33, 117, 244, 20, true, false, window)
guiScrollBarSetScrollPosition(niebla,50)
GUIEditor.label[3] = guiCreateLabel(102, 147, 165, 16, "Tamaño del Sol", false, window)
sol = guiCreateScrollBar(33, 173, 244, 20, true, false, window)
guiScrollBarSetScrollPosition(sol,50) 
GUIEditor.label[4] = guiCreateLabel(102, 203, 165, 16, "Tamaño de la Luna", false, window)
luna = guiCreateScrollBar(33, 229, 244, 20, true, false, window)
guiScrollBarSetScrollPosition(luna,50)
oclusion = guiCreateCheckBox(34, 272, 14, 15, "", true, false, window)
GUIEditor.label[5] = guiCreateLabel(52, 272, 60, 15, "Oclusiones", false, window)
lluvia = guiCreateCheckBox(138, 272, 14, 15, "", true, false, window)
GUIEditor.label[6] = guiCreateLabel(157, 272, 60, 15, "Lluvia", false, window)
nubes = guiCreateCheckBox(225, 272, 14, 15, "", true, false, window)
GUIEditor.label[7] = guiCreateLabel(243, 272, 60, 15, "Nubes", false, window)
clou = guiCreateButton(287, 25, 23, 24, "X", false, window)   
GUIEditor.label[8] = guiCreateLabel(4, 343, 309, 15, "                                    [ + ]", false, window)
GUIEditor.label[9] = guiCreateLabel(4, 329, 309, 15, "-------------------------------------------------------------------------------------", false, window)    
GUIEditor.label[10] = guiCreateLabel(7, 63, 26, 18, " 0%", false, window)
GUIEditor.label[11] = guiCreateLabel(277, 63, 36, 18, " 100%", false, window)
GUIEditor.label[12] = guiCreateLabel(277, 119, 36, 18, " 100%", false, window)
GUIEditor.label[13] = guiCreateLabel(7, 119, 26, 18, " 0%", false, window)
GUIEditor.label[14] = guiCreateLabel(7, 175, 26, 18, " 0%", false, window)
GUIEditor.label[15] = guiCreateLabel(8, 231, 26, 18, " 0%", false, window)
GUIEditor.label[16] = guiCreateLabel(277, 175, 36, 18, " 100%", false, window)
GUIEditor.label[17] = guiCreateLabel(277, 231, 36, 18, " 100%", false, window)
guiSetAlpha( GUIEditor.label[10], 0 ) guiLabelSetColor( GUIEditor.label[10], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[11], 0 ) guiLabelSetColor( GUIEditor.label[11], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[12], 0 ) guiLabelSetColor( GUIEditor.label[12], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[13], 0 ) guiLabelSetColor( GUIEditor.label[13], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[14], 0 ) guiLabelSetColor( GUIEditor.label[14], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[15], 0 ) guiLabelSetColor( GUIEditor.label[15], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[16], 0 ) guiLabelSetColor( GUIEditor.label[16], 255, 0, 0 )
guiSetAlpha( GUIEditor.label[17], 0 ) guiLabelSetColor( GUIEditor.label[17], 255, 0, 0 )
GUIEditor.label[18] = guiCreateLabel(34, 304, 61, 15, "FPS |", false, window)   -- CONTADOR DE FPS
del_arboles = guiCreateCheckBox(10, 368, 14, 15, "", false, false, window)
GUIEditor.label[19] = guiCreateLabel(34, 368, 94, 15, "Remover arboles", false, window)
guiSetVisible( window, false )	

--ABRIR PANEL	   
	 
function abrirp()
guiSetVisible( window, true )
showCursor( true )
end
addCommandHandler("anti-lag", abrirp)

addEventHandler("onClientGUIScroll", guiRoot,
function ()
if source == luna then -- TAMAÑO DE LA LUNA
local lun = guiScrollBarGetScrollPosition(luna)
if lun == 100 then
setMoonSize(5)
end		  
if lun == 0 then
setMoonSize(0)
end		  	  
if lun == 30 then
setMoonSize(1)
end		  	 
if lun == 50 then
setMoonSize(2)
end		  
if lun == 70 then
setMoonSize(3)
end		
if lun == 90 then
setMoonSize(4)
end		
elseif source == sol then -- TAMAÑO DEL SOL
local so = guiScrollBarGetScrollPosition(sol)
if so == 100 then
setSunSize(5)
end
if so == 0 then
setSunSize(0)
end		  
if so == 30 then
setSunSize(1)
end  
if so == 50 then
setSunSize(2)
end	  
if so == 70 then
setSunSize(3)
end	
if so == 80 then
setSunSize(4)
end	
elseif source == vision then -- DISTANCIA DE VISIÓN
local vis = guiScrollBarGetScrollPosition(vision)
if vis == 100 then
setFarClipDistance( 3000 )
end
if vis == 0 then
setFarClipDistance( 50 )
end		  
if vis == 10 then
setFarClipDistance( 300 )
end	
if vis == 20 then
setFarClipDistance( 400 )
end	
if vis == 30 then
setFarClipDistance( 500 )
end	
if vis == 40 then
setFarClipDistance( 600 )
end	
if vis == 50 then
setFarClipDistance( 700 )
end	
if vis == 60 then
setFarClipDistance( 800 )
end	
if vis == 70 then
setFarClipDistance( 900 )
end	
if vis == 80 then
setFarClipDistance( 1000 )
end		
if vis == 90 then
setFarClipDistance( 2000 )
end			  
elseif source == niebla then -- DISTANCIA DE NEBLINA
local nie = guiScrollBarGetScrollPosition(niebla)
if nie == 100 then
setFogDistance( 50 )
end
if nie == 0 then
setFogDistance( 0 )
end  
if nie == 10 then
setFogDistance( 5 )
end
if nie == 20 then
setFogDistance( 10 )
end	
if nie == 30 then
setFogDistance( 15 )
end
if nie == 40 then
setFogDistance( 20 )
end
if nie == 50 then
setFogDistance( 25 )
end
if nie == 60 then
setFogDistance( 30 )
end
if nie == 70 then
setFogDistance( 35 )
end
if nie == 80 then
setFogDistance( 40 )
end	
if nie == 90 then
setFogDistance( 45 )
end		  	  	  		  	  	  
end
end
)

addEventHandler("onClientGUIClick", guiRoot,
function()
if source == clou then --CERRAR PANEL
guiSetVisible( window, false )
showCursor( false )
elseif source == oclusion then --OCLUSIÓN
local check = guiCheckBoxGetSelected(oclusion)
if check then
setOcclusionsEnabled( true )
else
setOcclusionsEnabled( false )
end	  
elseif source == lluvia then --LLUVIA
local check = guiCheckBoxGetSelected(lluvia)
if check then
resetRainLevel()
else
setRainLevel(0)
end  
elseif source == nubes then -- NUBLES
local check = guiCheckBoxGetSelected(nubes)
if check then
setCloudsEnabled ( true )
else
setCloudsEnabled ( false )
end  
elseif source == del_arboles then
local check = guiCheckBoxGetSelected(del_arboles)
if check then
for i=615,904 do      
removeWorldModel(i,999999999999999999999,0,0,0)  
end 
else
for i=615,904 do      
restoreWorldModel(i,999999999999999999999,0,0,0)  
end 
end  
elseif source == GUIEditor.label[8] then
if ( getElementData( localPlayer, "ANTI-LAG:showMore" ) == false ) then
guiSetSize( window, 323, 397, false )
guiSetSize( del_arboles, 14, 15, false )
setElementData( localPlayer, "ANTI-LAG:showMore", true )
guiSetText( GUIEditor.label[8], "                                    [ - ]" )
else
guiSetSize( window, 323, 370, false )
guiSetText( GUIEditor.label[8], "                                    [ + ]" )
setElementData( localPlayer, "ANTI-LAG:showMore", false )
end
end
end
)

addEventHandler("onClientMouseEnter", root,
function()
if source == vision then
guiSetAlpha( GUIEditor.label[10], 255 )
guiSetAlpha( GUIEditor.label[11], 255 )
elseif source == niebla then
guiSetAlpha( GUIEditor.label[12], 255 )
guiSetAlpha( GUIEditor.label[13], 255 )
elseif source == sol then
guiSetAlpha( GUIEditor.label[14], 255 )
guiSetAlpha( GUIEditor.label[16], 255 )
elseif source == luna then
guiSetAlpha( GUIEditor.label[15], 255 )
guiSetAlpha( GUIEditor.label[17], 255 )
elseif source == GUIEditor.label[8] then
guiLabelSetColor( GUIEditor.label[8], 200, 0, 0 )
end
end
)

addEventHandler("onClientMouseLeave", root,
function()
if source == vision then
guiSetAlpha( GUIEditor.label[10], 0 )
guiSetAlpha( GUIEditor.label[11], 0 )
elseif source == niebla then
guiSetAlpha( GUIEditor.label[12], 0 )
guiSetAlpha( GUIEditor.label[13], 0)
elseif source == sol then
guiSetAlpha( GUIEditor.label[14], 0 )
guiSetAlpha( GUIEditor.label[16], 0 )
elseif source == luna then
guiSetAlpha( GUIEditor.label[15], 0 )
guiSetAlpha( GUIEditor.label[17], 0 )
elseif source == GUIEditor.label[8] then
guiLabelSetColor( GUIEditor.label[8], 255, 255, 255 )
end
end
)

addEventHandler("onClientRender", root,
function()
guiSetText( GUIEditor.label[18], "FPS | "..math.floor(getCurrentFPS()) ) -- CONTADOR DE FPS
end
)
