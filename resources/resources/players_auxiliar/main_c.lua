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
        setPedLookAt( getLocalPlayer( ), x, y, z )
    end
)

local barras = true
local yo = true
local sX, sY = guiGetScreenSize ()
local barrasData = {x = sX - 165, y = sY/2 - 150, w = 154, h = 61, state = 1, list = {{"Sed", color = tocolor(255, 75, 75, 150)}, {"Cansancio", color = tocolor(75, 255, 75, 150)}, {"Hambre", color = tocolor(75, 75, 255, 150)}, {"Musculatura", color = tocolor(198, 216, 2, 255)}, {"Gordura", color = tocolor(216, 155, 2, 255)}}}

function dxYoYBarras()
	if exports.players:isLoggedIn() then
		
		if yo == true then
			dxDrawText("/yo "..getElementData(getLocalPlayer(), "yo") or "Civil Desconocido", 21/1280*sX, 777/800*sY, 435/1280*sX, 561/800*sY, tocolor(255, 255, 255, 255), 0.85, "default-bold", "left", "top", false, false, false, false, false)	
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
	createTrayNotification("Vuelve pronto, si te quedas AFK en via publica te podremos sancionar. ATT: Verso RP")
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
				outputChatBox("Conexion De Red Mala", 255, 0, 0)
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

function tlag(cmd, n)
	if n and tonumber(n) then
		outputChatBox("Distancia ajustada a "..tostring(n), 0, 255, 0)
		setFarClipDistance(tonumber(n))
	end
end
--addCommandHandler("tlag", tlag)