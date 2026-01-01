--[[
Copyright (c) 2010 MTA: Paradise

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

local localPlayer = getLocalPlayer( )
local screenX, screenY = guiGetScreenSize( )
local myFont1 = dxCreateFont( "Lato-Italic.ttf", 18 )

addEventHandler( "onClientRender", root,
	function( )
		if getPedAnimation( localPlayer ) and exports.players:isLoggedIn( ) and not guiGetInputEnabled( ) and not (getElementHealth(localPlayer)<5) then
			local text = "Presiona 'ESPACIO' para parar la animación"
			dxDrawText( text, 4, 4, screenX, screenY * 0.95 + 2, tocolor( 0, 0, 0, 255 ), 1, myFont1, "center", "bottom", false, false, true )
			dxDrawText( text, 0, 0, screenX, screenY * 0.95, tocolor( 255, 255, 255, 255 ), 1, myFont1, "center", "bottom", false, false, true )
		end
	end
)

bindKey ( "space", "down",
	function ( )
		if getPedAnimation( localPlayer ) and exports.players:isLoggedIn( ) and not getElementData(localPlayer, "tazeado") and not getElementData(localPlayer, "esposado") and not getElementData(localPlayer, "cansado") and not (getElementHealth(localPlayer)<5) then
			triggerServerEvent( "anims:reset", localPlayer )
		end
	end
)
