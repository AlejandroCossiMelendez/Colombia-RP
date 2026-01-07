--[[
Copyright (c) 2020 MTA: Paradise y DownTown RolePlay

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

function getVersion( )
	return "2"
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		setGameType( "CapitalRoleplay" )
		setRuleValue( "version", getVersion( ) )
		setMapName( "CapitalRP" )
		
		setTimer( 
			function( )

				outputServerLog(" ")
				outputServerLog("  ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗     ██████╗ ██████╗ ")
				outputServerLog(" ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║     ██╔══██╗██╔══██╗")
				outputServerLog(" ██║     ███████║██████╔╝██║   ██║   ███████║██║     ██████╔╝██████╔╝")
				outputServerLog(" ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║     ██╔══██╗██╔═══╝ ")
				outputServerLog(" ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗██║  ██║██║      ")
				outputServerLog("  ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝      ")
				outputServerLog(" ")
																					
			end, 50, 1
		)
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		removeRuleValue( "version" )
	end
)


			

