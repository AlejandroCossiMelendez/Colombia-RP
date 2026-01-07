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

-- Iniciar todos los recursos ubicados en resources/[SCRIPTS] con un solo comando
local scriptsResources = {
	"Velocimetro","tlfysy","TiempoReal","TexturaAtm","SPOILER_Radar",
	"sistema_progressbar","SirenasPDyEJC","Script-Sorteo","Script-Avisarsura",
	"Script-Avisarmecailegal","Script-Avisarmeca2","sacar_muerto","RolCabeza",
	"roboatm","robarD1","robar","puertasguaro","presence","PlacaCOL",
	"PanelSura","PanelAyuda","panelArresto","ONak","ONactos","Notis",
	"Notificaciones","mrp_factions","motos","Miras","mira-punto",
	"MensajesAutomaticos","MCInfoBox","maximap","Manosarriba",
	"maniobras-moto","LucesCarros","loadscreen","kitNuevos","infobox",
	"Headshot","gps-guarocity","GaragesGuaro","flag","F10-Logo","explosiones",
	"EquipacionPD","equipacionEJC","entrar-baul","Entorno","dxInfo",
	"Distance","discord_webhooks","discord","Despojar","danodearmas",
	"Creador_Blips","Contador","compradepiezas","ChalecoVisible",
	"capital-scoreboard","camaras","Blindaje","bindeos","bienvenida","AntiCJ",
	"alerta_NGR"
}

addCommandHandler("startscripts", function(player)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.startResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	local started, skipped, failed = {}, {}, {}
	for _, resName in ipairs(scriptsResources) do
		local res = getResourceFromName(resName)
		if res then
			local state = getResourceState(res)
			if state == "running" then
				table.insert(skipped, resName)
			else
				if startResource(res) then
					table.insert(started, resName)
				else
					table.insert(failed, resName)
				end
			end
		else
			table.insert(failed, resName)
		end
	end

	local function msg(txt, color)
		if player then
			outputChatBox(txt, player, color[1], color[2], color[3])
		else
			outputServerLog(txt)
		end
	end

	msg("[startscripts] Iniciados: " .. table.concat(started, ", "), {0,255,0})
	if #skipped > 0 then
		msg("[startscripts] Ya estaban corriendo: " .. table.concat(skipped, ", "), {255,255,0})
	end
	if #failed > 0 then
		msg("[startscripts] Fallaron / no encontrados: " .. table.concat(failed, ", "), {255,0,0})
	end
end)

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


			

