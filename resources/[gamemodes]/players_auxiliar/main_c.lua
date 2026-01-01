--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

engineSetAsynchronousLoading( true, true )
setWorldSoundEnabled(5, false)
addEventHandler( "onClientCursorMove", getRootElement( ),
    function ( _, _, _, _, x, y, z )
    	if localPlayer:isDucked() then
        	setPedLookAt( getLocalPlayer( ), x, y, z )
        end
    end
)

local barras = true
local yo = true
local sX, sY = guiGetScreenSize ()
local barrasData = {x = sX - 165, y = sY/2 - 50, w = 154, h = 61, state = 1, list = {{"Sed", color = tocolor(255, 75, 75, 255)}, {"Cansancio", color = tocolor(75, 255, 75, 255)}, {"Hambre", color = tocolor(75, 75, 255, 255)}, {"Musculatura", color = tocolor(198, 216, 2, 255)}, {"Gordura", color = tocolor(216, 155, 2, 255)}}}
local oY, oX = 0.68, 0.057
font2 = 'default-bold'

local tickNeces = getTickCount(  )

function dxYoYBarras()
	if exports.players:isLoggedIn() then
		
		local hambre = math.max(0,math.floor(getElementData(localPlayer, 'hambre')))
		local sed = math.max(0,math.floor(getElementData(localPlayer, 'sed')))

		if getTickCount(  ) - tickNeces > 1000 then

			if hambre <= 0 or sed <= 0 then
				setElementHealth(localPlayer, getElementHealth( localPlayer ) - 2 )
			end

			tickNeces = getTickCount(  ) 
		end

		local veh = localPlayer.vehicle
		if not veh or veh:getController() ~= localPlayer then
			
			local cansancio = math.max(0,math.floor(getElementData(localPlayer, 'cansancio')))
			local muscle = math.max(0,math.floor(100*(getPedStat(getLocalPlayer(), 23)/1000)))
			local fat = math.max(0,math.floor(100*(getPedStat(getLocalPlayer(), 21)/1000)))

			dxDrawImage(sX*(0.79725+oX*1.7), sY*(0.25+oY), sX*0.07, sX*0.02, 'files/bar.png',0,0,0,tocolor (0,0,0, 180))
			dxDrawImage(sX*(0.79725+oX*2.7), sY*(0.237+oY), sX*0.04, sX*0.04, 'files/fondo.png',0,0,0,tocolor (253, 130, 21, 255))
			dxDrawImage(sX*(0.79725+oX*2.9), sY*(0.251+oY), sX*0.017, sX*0.019, 'files/comida.png')
			dxDrawText2(hambre..'%',sX*(0.79725+oX*1.7), sY*(0.25+oY),sX*0.07, sX*0.02, tocolor(255,255,255), 1, font2, 'center', 'center')

			dxDrawImage(sX*(0.79725+oX*1.7), sY*(0.25+oY/1.1), sX*0.07, sX*0.02, 'files/bar.png',0,0,0,tocolor (0,0,0, 180))
			dxDrawImage(sX*(0.79725+oX*2.7), sY*(0.237+oY/1.1), sX*0.04, sX*0.04, 'files/fondo.png',0,0,0,tocolor (5, 134, 212, 255))
			dxDrawImage(sX*(0.79725+oX*2.9), sY*(0.251+oY/1.1), sX*0.017, sX*0.019, 'files/sed.png')
			dxDrawText2(sed..'%',sX*(0.79725+oX*1.7), sY*(0.25+oY/1.1),sX*0.07, sX*0.02, tocolor(255,255,255), 1, font2, 'center', 'center')

			dxDrawImage(sX*(0.79725+oX*1.7), sY*(0.25+oY/1.215), sX*0.07, sX*0.02, 'files/bar.png',0,0,0,tocolor (0,0,0, 180))
			dxDrawImage(sX*(0.79725+oX*2.7), sY*(0.237+oY/1.215), sX*0.04, sX*0.04, 'files/fondo.png',0,0,0,tocolor (75, 255, 75, 255))
			dxDrawImage(sX*(0.79725+oX*2.9), sY*(0.251+oY/1.215), sX*0.017, sX*0.019, 'files/cansancio.png')
			dxDrawText2(cansancio..'%',sX*(0.79725+oX*1.7), sY*(0.25+oY/1.215),sX*0.07, sX*0.02, tocolor(255,255,255), 1, font2, 'center', 'center')

			dxDrawImage(sX*(0.79725+oX*1.7), sY*(0.25+oY/1.36), sX*0.07, sX*0.02, 'files/bar.png',0,0,0,tocolor (0,0,0, 180))
			dxDrawImage(sX*(0.79725+oX*2.7), sY*(0.237+oY/1.36), sX*0.04, sX*0.04, 'files/fondo.png',0,0,0,tocolor (255, 75, 75, 255))
			dxDrawImage(sX*(0.79725+oX*2.9), sY*(0.251+oY/1.36), sX*0.017, sX*0.019, 'files/fuerte.png')
			dxDrawText2(muscle..'%',sX*(0.79725+oX*1.7), sY*(0.25+oY/1.36),sX*0.07, sX*0.02, tocolor(255,255,255), 1, font2, 'center', 'center')

			dxDrawImage(sX*(0.79725+oX*1.7), sY*(0.25+oY/1.55), sX*0.07, sX*0.02, 'files/bar.png',0,0,0,tocolor (0,0,0, 180))
			dxDrawImage(sX*(0.79725+oX*2.7), sY*(0.237+oY/1.55), sX*0.04, sX*0.04, 'files/fondo.png',0,0,0,tocolor (216, 155, 2, 255))
			dxDrawImage(sX*(0.79725+oX*2.9), sY*(0.251+oY/1.55), sX*0.017, sX*0.019, 'files/gordo.png')
			dxDrawText2(fat..'%',sX*(0.79725+oX*1.7), sY*(0.25+oY/1.55),sX*0.07, sX*0.02, tocolor(255,255,255), 1, font2, 'center', 'center')
		end

		if yo == true then
			dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 21/1280*sX, 769/800*sY, 435/1280*sX, 561/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 21/1280*sX, 767/800*sY, 435/1280*sX, 559/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 19/1280*sX, 769/800*sY, 433/1280*sX, 561/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 19/1280*sX, 767/800*sY, 433/1280*sX, 559/800*sY, tocolor(0, 0, 0, 255), 1.00, "default", "left", "top", false, false, false, false, false)
			dxDrawText("/yo: "..getElementData(getLocalPlayer(), "yo") or "Sin /yo asignado.", 20/1280*sX, 768/800*sY, 434/1280*sX, 560/800*sY, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)	
		end
	end
end
addEventHandler("onClientRender", root, dxYoYBarras)

function toggleHUDSec()
	barrasData.state = barrasData.state == 1 and 2 or 1
	if yo == true then yo = false else yo = true end
end
addCommandHandler("hud",toggleHUDSec)

function handleMinimize()
	createTrayNotification("Vendetta RolePlay: ¡Por favor, no tardes en volver! Te recordamos que estar A.F.K. puede ser sancionable.")
	setElementData(getLocalPlayer(), "minpa", true)
end
addEventHandler("onClientMinimize", root, handleMinimize)

function handleRestore()
	setElementData(getLocalPlayer(), "minpa", false)
end
addEventHandler("onClientRestore", root, handleRestore)

function sendNotificationPC (text)
	if text then
		createTrayNotification(tostring(text))
	end
end
addEvent("onSendNotification", true)
addEventHandler("onSendNotification", getRootElement(), sendNotificationPC)

addEventHandler( "onClientPlayerNetworkStatus", root,
	function( status, ticks )
		if status == 1 then
			if ticks > 3000 then
				outputChatBox("Hemos detectado un problema en tu conexión. Por favor, revísala.", 255, 0, 0)
			end
		end
	end
)

local run = 0
local down = 0


addEventHandler( "onClientPreRender", getRootElement(), 
	function( slice )
		if isPedWearingJetpack(getLocalPlayer()) then return end
		if ( not isPedInVehicle( getLocalPlayer( ) ) and getPedControlState( "sprint" ) ) or down > 0 then
			run = run + slice
			if run >= 40000 then
				if isPedOnGround( getLocalPlayer( ) ) then
					setElementData(getLocalPlayer(), "cansancio", getElementData(getLocalPlayer(), "cansancio")-5)
					run = 15000
				    local gordura = getPedStat(getLocalPlayer(), 21)
					if gordura >= 1 then
					triggerServerEvent ("onGestionarPeso",getLocalPlayer(),21,gordura-1) 
					end
				else
					toggleControl( 'sprint', false )
					setTimer( toggleControl, 5000, 1, 'sprint', true )
				end
			end
			if not getPedControlState( "sprint" ) then
				down = math.max( 0, down - slice )
			else
				down = 500
			end
		else
			if run > 0 then
				run = math.max( 0, run - math.ceil( slice / 3 ) )
			end
		end
	end
)
--Mostrar Zona Actual
local screenWidth, screenHeight = guiGetScreenSize ( ) -- Get the screen resolution (width and height)


function createText ( )
	if getElementData(localPlayer, "nohud") then return end -- Para poder retirarlo si se pone /hud
	if not exports.players:isLoggedIn() then return end
    local playerX, playerY, playerZ = getElementPosition ( localPlayer )       -- Get our player's coordinates.
    local playerZoneName = getZoneName ( playerX, playerY, playerZ )          -- Get name of the zone the player is in.

    -- Draw zone name text's shadow.
    dxDrawText ( playerZoneName, 1204, screenHeight - 761, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1.52, "arial" )
    -- Draw zone name text.
    dxDrawText ( playerZoneName, 1204, screenHeight - 763, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1.50, "arial" )
end

function HandleTheRendering ( )
    --addEventHandler ( "onClientRender", root, createText ) -- keep the text visible with onClientRender.
end

addEventHandler ( "onClientResourceStart", resourceRoot, HandleTheRendering )


function tlag(cmd, n)
	if n and tonumber(n) then
		outputChatBox("Distancia ajustada a "..tostring(n), 0, 255, 0)
		setFarClipDistance(tonumber(n))
	end
end
--addCommandHandler("tlag", tlag)

function dxDrawText2(t,x,y,w,h,...)
	return dxDrawText(t,x,y,w+x,h+y,...)
end