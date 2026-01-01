--***********************************--
--***********************************--
--            Jail System            --
--            By Al3grab             --
--            Client Side            --
--***********************************--
--***********************************--

--  1.0  Made At 3/9/2011 | 12:15 PM  --
--  2.0  Made At 3/2/2012 | 06:15 PM  --
--  2.1  Made At 22/5/2012 | 4:00 PM  --

lp = getLocalPlayer()
rRoot = getResourceRootElement(getThisResource())
setElementData(lp,"jailed",false)
------
addEventHandler("onClientResourceStart",rRoot,function()
triggerServerEvent("getDataz",lp,lp)
outputDebugString("Jail System v2.1 By Al3grab | Started")
end )
desz = {}
addEvent("sendDataz",true)
addEventHandler("sendDataz",root,function(jTable,tTable)

------

jWin = guiCreateWindow(460,172,445,416,"Sistema de Sancion",false)
--- Center Window ---
local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize(jWin,false)
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition(jWin,x,y,false)
----- Center Window -----
guiSetVisible(jWin,false)
guiWindowSetSizable(jWin,false)
-------------------------
jBut = guiCreateButton(247,338,167,31,"Sancionar",false,jWin)
tGrid = guiCreateGridList(240,184,190,144,false,jWin)
guiGridListSetSelectionMode(tGrid,0)
-------
--
sEdit = guiCreateEdit(14,380,217,23,"Buscar ..",false,jWin)
--
--------
local timeC = guiGridListAddColumn( tGrid, "Time", 0.85 )
if timeC then
for k,v in ipairs ( tTable ) do
local time = v[1]
local des = v[2]
local row = guiGridListAddRow ( tGrid )
desz[row] = des
guiGridListSetItemText ( tGrid, row, timeC, time.." "..des, false, true )
end
local row = guiGridListAddRow ( tGrid )
guiGridListSetItemText ( tGrid, row, timeC,"Other ..", false, true )
end
--------
jGrid = guiCreateGridList(240,31,190,144,false,jWin)
guiGridListSetSelectionMode(jGrid,0)
--------
local jailC = guiGridListAddColumn( jGrid, "Jail", 0.85 )
for k,v in ipairs ( jTable ) do
local name = v[1]
local row = guiGridListAddRow ( jGrid )
guiGridListSetItemText ( jGrid, row, jailC, name, false, false )
end
jcBut = guiCreateButton(246,378,172,24,"Cerrar",false,jWin)

function jailShow ()
	guiSetVisible(jWin,not guiGetVisible ( jWin ) )
	showCursor(guiGetVisible ( jWin ) )
	guiSetInputEnabled(guiGetVisible ( jWin ) )
	destroyElement(pList)
	-- Players List
  		 pList = guiCreateGridList(14,31,218,338,false,jWin)	
		 column = guiGridListAddColumn( pList, "Player", 0.85 )
		if ( column ) then
		for id, player in ipairs(getElementsByType("player")) do
			 row = guiGridListAddRow ( pList )
			guiGridListSetItemText ( pList, row, column, getPlayerName ( player ), false, false )
		end
		end
	-- Players List
end
addEvent("jailShow",true)
addEventHandler("jailShow",root,jailShow)

function changeText(button,state,x,y)
		selectedRow, selectedCol = guiGridListGetSelectedItem( pList )
		sPlayer = guiGridListGetItemText( pList, selectedRow, selectedCol )
		local thePlr = getPlayerFromName(sPlayer)
		if thePlr then
			local isJailed = getElementData(thePlr,"jailed")
			if isJailed == false then
				guiSetText(jBut,"Sancionar")
			elseif isJailed == true then
				guiSetText(jBut,"Quitar Sancion")
			end
		end
	
end
addEventHandler("onClientGUIClick",root,changeText)

function onClick (button, state, absoluteX, absoluteY)
	selectedRow, selectedCol = guiGridListGetSelectedItem( pList )
		sPlayer = guiGridListGetItemText( pList, selectedRow, selectedCol )
		jail = guiGridListGetItemText ( jGrid, guiGridListGetSelectedItem ( jGrid ), 1 )
		time = guiGridListGetItemText ( tGrid, guiGridListGetSelectedItem ( tGrid ), 1 )
		timeDes = tostring(desz[guiGridListGetSelectedItem ( tGrid )])
	if ( source == jBut ) then
		if guiGetText(jBut) == "Sancionar" then
			if time ~= "Other .." then
				triggerServerEvent("JailHimx",lp,sPlayer,jail,time,timeDes)
			else
				createTimeSelect(sPlayer,jail)
			end
		elseif guiGetText(jBut) == "Quitar Sancion" then
			triggerServerEvent("unJailHim",lp,sPlayer)
	end
----------
elseif ( source == jcBut ) then
	guiSetVisible (jWin, false)
	showCursor (false)
	guiSetInputEnabled(false)
	end
	end
addEventHandler( "onClientGUIClick", root, onClick )

------------
end )

addEventHandler("onClientPlayerDamage",root,function(at)
if getElementData(source,"jailed") == true then
if at then cancelEvent() end
end
end	)

-------

addEventHandler("onClientGUIClick",root,function()
if source == sEdit then
	guiSetText(sEdit,"")
	--[[
else
	guiSetText(sEdit,"Search ..")
	--]]
end end )

addEventHandler("onClientGUIChanged",root,function()
if source == sEdit then
	------
	guiGridListClear(pList)
	for k,v in ipairs ( getElementsByType("player") ) do
		local name = string.lower(getPlayerName(v))
		if name then
			if string.find (name,string.lower(guiGetText(sEdit)) ) then
				row = guiGridListAddRow ( pList )
				guiGridListSetItemText ( pList, row, column, getPlayerName ( v ), false, false )
				end
			end
		end
	end
	------
end )
------
function createTimeSelect(theJailed,theJail)
	if not tostring(theJailed) then outputChatBox("** #FFFF00Please Select a Player !",255,0,0,true) return  end
	if not tostring(theJail) then outputChatBox("** #FFFF00Please Select a Jail !",255,0,0,true) return end	
	if isElement(TimeSelect_Window) then return end	
	TimeSelect_Window = guiCreateWindow(550,397,270,125,"Enter Time",false)
	--
	local screenW,screenH=guiGetScreenSize()
	local windowW,windowH=guiGetSize(TimeSelect_Window,false)
	local x,y = (screenW-windowW)/2,(screenH-windowH)/2
	guiSetPosition(TimeSelect_Window,x,y,false)
	--
--	guiSetVisible(jWin,false)
	--
	TimeSelect_Edit = guiCreateEdit(15,37,89,26,"",false,TimeSelect_Window)
	TimeSelect_Label = guiCreateLabel(110,41,10,15,"in",false,TimeSelect_Window)
	TimeSelect_Grid = guiCreateGridList(126,31,130,95,false,TimeSelect_Window)
	guiGridListSetSelectionMode(TimeSelect_Grid,2)
	---
	column = guiGridListAddColumn( TimeSelect_Grid, "", 0.80 )
	r1 = guiGridListAddRow(TimeSelect_Grid)
	r2 = guiGridListAddRow(TimeSelect_Grid)
	r3 = guiGridListAddRow(TimeSelect_Grid)
	guiGridListSetItemText ( TimeSelect_Grid , r1, column, "Horas", false, false )
	guiGridListSetItemText ( TimeSelect_Grid , r2, column,"Minutos", false, false )
	guiGridListSetItemText ( TimeSelect_Grid , r3, column, "Segundos", false, false )
	TimeSelect_Button = guiCreateButton(14,72,91,40,"OK",false,TimeSelect_Window)
	--
	function onOk()
	if source == TimeSelect_Button then
		--
		removeEventHandler("onClientGUIClick",root,onOk)
		--
		----------------
		theTime = guiGetText(TimeSelect_Edit)
		timeType = guiGridListGetItemText ( TimeSelect_Grid, guiGridListGetSelectedItem ( TimeSelect_Grid ) )
		--
		destroyElement(TimeSelect_Window)
		jailShow ()
		--
		if tonumber(theTime) then
			if tostring(timeType) then
				triggerServerEvent("JailHimx",lp,theJailed,theJail,theTime.." "..timeType,timeType,true)
			else
				outputChatBox("** #FFFF00Please Select , Hours or Minutes or Seconds !",255,0,0,true)
			end
		else
			outputChatBox("** #FFFF00Por favor seleccione el tiempo !",255,0,0,true)
		end
		----------------
	end
	end
	addEventHandler("onClientGUIClick",root,onOk)
end