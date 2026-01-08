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

-- Comando para iniciar múltiples recursos: /start recurso1 recurso2 recurso3
addCommandHandler("start", function(player, commandName, ...)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.startResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	local resources = {...}
	if #resources == 0 then
		if player then
			outputChatBox("Sintaxis: /start [recurso1] [recurso2] [recurso3] ...", player, 255, 255, 255)
			outputChatBox("Ejemplo: /start gobierno factions sql", player, 255, 255, 255)
		else
			outputServerLog("Sintaxis: start [recurso1] [recurso2] [recurso3] ...")
		end
		return
	end

	local started, skipped, failed = {}, {}, {}
	
	for _, resName in ipairs(resources) do
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

	if #started > 0 then
		msg("[start] Iniciados: " .. table.concat(started, ", "), {0,255,0})
	end
	if #skipped > 0 then
		msg("[start] Ya estaban corriendo: " .. table.concat(skipped, ", "), {255,255,0})
	end
	if #failed > 0 then
		msg("[start] Fallaron / no encontrados: " .. table.concat(failed, ", "), {255,0,0})
	end
	
	if #started == 0 and #skipped == 0 and #failed == 0 then
		msg("[start] No se especificaron recursos válidos.", {255,255,0})
	end
	
	-- Mostrar panel al jugador si hay resultados
	if player and (#started > 0 or #skipped > 0 or #failed > 0) then
		triggerClientEvent(player, "resource:showPanel", player, "start", started, skipped, failed)
	end
end)

-- Comando para detener múltiples recursos: /stop recurso1 recurso2 recurso3
addCommandHandler("stop", function(player, commandName, ...)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.stopResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	local resources = {...}
	if #resources == 0 then
		if player then
			outputChatBox("Sintaxis: /stop [recurso1] [recurso2] [recurso3] ...", player, 255, 255, 255)
			outputChatBox("Ejemplo: /stop gobierno factions sql", player, 255, 255, 255)
		else
			outputServerLog("Sintaxis: stop [recurso1] [recurso2] [recurso3] ...")
		end
		return
	end

	local stopped, skipped, failed = {}, {}, {}
	
	for _, resName in ipairs(resources) do
		local res = getResourceFromName(resName)
		if res then
			local state = getResourceState(res)
			if state == "stopped" or state == "loaded" then
				table.insert(skipped, resName)
			elseif state == "running" then
				if stopResource(res) then
					table.insert(stopped, resName)
				else
					table.insert(failed, resName)
				end
			else
				table.insert(failed, resName)
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

	if #stopped > 0 then
		msg("[stop] Detenidos: " .. table.concat(stopped, ", "), {255,165,0})
	end
	if #skipped > 0 then
		msg("[stop] Ya estaban detenidos: " .. table.concat(skipped, ", "), {255,255,0})
	end
	if #failed > 0 then
		msg("[stop] Fallaron / no encontrados: " .. table.concat(failed, ", "), {255,0,0})
	end
	
	if #stopped == 0 and #skipped == 0 and #failed == 0 then
		msg("[stop] No se especificaron recursos válidos.", {255,255,0})
	end
	
	-- Mostrar panel al jugador si hay resultados
	if player and (#stopped > 0 or #skipped > 0 or #failed > 0) then
		triggerClientEvent(player, "resource:showPanel", player, "stop", stopped, skipped, failed)
	end
end)

-- Comando para reiniciar múltiples recursos: /restart recurso1 recurso2 recurso3
addCommandHandler("restart", function(player, commandName, ...)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.restartResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	local resources = {...}
	if #resources == 0 then
		if player then
			outputChatBox("Sintaxis: /restart [recurso1] [recurso2] [recurso3] ...", player, 255, 255, 255)
			outputChatBox("Ejemplo: /restart gobierno factions sql", player, 255, 255, 255)
		else
			outputServerLog("Sintaxis: restart [recurso1] [recurso2] [recurso3] ...")
		end
		return
	end

	local restarted, failed = {}, {}
	
	for _, resName in ipairs(resources) do
		local res = getResourceFromName(resName)
		if res then
			if restartResource(res) then
				table.insert(restarted, resName)
			else
				table.insert(failed, resName)
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

	if #restarted > 0 then
		msg("[restart] Reiniciados: " .. table.concat(restarted, ", "), {0,255,255})
	end
	if #failed > 0 then
		msg("[restart] Fallaron / no encontrados: " .. table.concat(failed, ", "), {255,0,0})
	end
	
	if #restarted == 0 and #failed == 0 then
		msg("[restart] No se especificaron recursos válidos.", {255,255,0})
	end
	
	-- Mostrar panel al jugador si hay resultados
	if player and (#restarted > 0 or #failed > 0) then
		triggerClientEvent(player, "resource:showPanel", player, "restart", restarted, {}, failed)
	end
end)

-- Comando para ver el estado de un recurso específico
addCommandHandler("resinfo", function(player, commandName, resName)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.startResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	if not resName then
		if player then
			outputChatBox("Sintaxis: /resinfo [nombre_recurso]", player, 255, 255, 255)
			outputChatBox("Ejemplo: /resinfo factions", player, 255, 255, 255)
		else
			outputServerLog("Sintaxis: resinfo [nombre_recurso]")
		end
		return
	end

	local res = getResourceFromName(resName)
	if res then
		local state = getResourceState(res)
		local name = getResourceName(res)
		
		local function msg(txt, color)
			if player then
				outputChatBox(txt, player, color[1], color[2], color[3])
			else
				outputServerLog(txt)
			end
		end
		
		msg("=== Información del Recurso: " .. name .. " ===", {255,255,255})
		msg("Estado: " .. state, 
			state == "running" and {0,255,0} or 
			state == "stopped" and {255,165,0} or 
			{255,255,0})
		
		if state ~= "running" then
			msg("El recurso NO está corriendo. Usa /start " .. name .. " para iniciarlo.", {255,0,0})
		end
	else
		local function msg(txt, color)
			if player then
				outputChatBox(txt, player, color[1], color[2], color[3])
			else
				outputServerLog(txt)
			end
		end
		msg("Recurso '" .. resName .. "' no encontrado.", {255,0,0})
	end
end)

-- Comando para ver el estado de múltiples recursos comunes
addCommandHandler("resstatus", function(player, commandName)
	-- Solo permite a jugadores con permisos adecuados o a la consola
	if player and not hasObjectPermissionTo(player, "function.startResource", false) then
		outputChatBox("No tienes permisos para usar este comando.", player, 255, 0, 0)
		return
	end

	local importantResources = {"factions", "sql", "players", "gobierno", "server"}
	local running = {}
	local stopped = {}
	local failed = {}
	
	for _, resName in ipairs(importantResources) do
		local res = getResourceFromName(resName)
		if res then
			local state = getResourceState(res)
			if state == "running" then
				table.insert(running, resName)
			else
				table.insert(stopped, resName .. " (" .. state .. ")")
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
	
	msg("=== Estado de Recursos Importantes ===", {255,255,255})
	if #running > 0 then
		msg("✓ Corriendo: " .. table.concat(running, ", "), {0,255,0})
	end
	if #stopped > 0 then
		msg("✗ Detenidos: " .. table.concat(stopped, ", "), {255,0,0})
	end
	if #failed > 0 then
		msg("✗ No encontrados: " .. table.concat(failed, ", "), {255,0,0})
	end
	
	-- Mostrar panel al jugador
	if player then
		triggerClientEvent(player, "resource:showPanel", player, "status", running, {}, stopped)
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


			

