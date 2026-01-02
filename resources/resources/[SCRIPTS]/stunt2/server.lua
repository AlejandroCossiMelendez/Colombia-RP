local animEnable = {}
local syncPlayers = {}

addCommandHandler("stunt2",
	function(player)
		if (not animEnable[player]) then
			animEnable[player] = true
			triggerClientEvent(syncPlayers, "stribo", player, true)
			outputChatBox("", player, 0, 255, 0, true)
		else
			animEnable[player] = false
			triggerClientEvent(syncPlayers, "stribo", player, false)
			outputChatBox("", player, 255, 0, 0, true)
		end
	end
)

addEvent("onClientSync", true )
addEventHandler("onClientSync", resourceRoot,
    function()
        table.insert(syncPlayers, client)
		for player, enable in ipairs(animEnable) do
			if (enable) then
				triggerClientEvent(client, "stribo", player, true)
			end
		end
    end 
)

addEventHandler("onPlayerQuit", root,
    function()
        for i, player in ipairs(syncPlayers) do
            if source == player then 
                table.remove(syncPlayers, i)
                break
            end 
        end
        if (animEnable[source] == true or animEnable[source] == false) then animEnable[source] = nil end
    end
)


--[[
 ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 ███╗   ███╗████████╗ █████╗    ███████╗ █████╗     ███╗   ███╗ ██████╗ ██████╗ ███████╗█
 ████╗ ████║╚══██╔══╝██╔══██╗██╗██╔════╝██╔══██╗    ████╗ ████║██╔═══██╗██╔══██╗██╔════╝█
 ██╔████╔██║   ██║   ███████║╚═╝███████╗███████║    ██╔████╔██║██║   ██║██║  ██║███████╗█
 ██║╚██╔╝██║   ██║   ██╔══██║██╗╚════██║██╔══██║    ██║╚██╔╝██║██║   ██║██║  ██║╚════██║█
 ██║ ╚═╝ ██║   ██║   ██║  ██║╚═╝███████║██║  ██║    ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████║█
 █╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════█
 █                                                                                      █
 █                ┌───────────────────────────────────────────────────┐                 █
 █                ┤MAIS DE 1000 MODS DESCOMPILADOS COM DOWNLOAD DIRETO┤                 █
 █                └───────────────────────────────────────────────────┘                 █
 █                   ┌─────────────────────────────────────────────┐                    █
 █                   ┤ A MAIOR COMUNIDADE DE MODS DO MTA BRASIL 🥇 ┤                    █
 █                   └─────────────────────────────────────────────┘                    █
 █                          ┌───────────────────────────────┐                           █
 █                          ┤  LINK DE CONVITE PERMANENTE:  ┤                           █
 █                          ┤ https://discord.gg/KXV2GHtJtg ┤                           █
 █                          ┤ https://discord.gg/KXV2GHtJtg ┤                           █
 █                          ┤ https://discord.gg/KXV2GHtJtg	┤                           █
 █                          └───────────────────────────────┘                           █
 █ ┌────────────────────────────────────────┐                                           █
 ├≡┤ Canais que postamos mods todos os dias │                                           █
 █ └────────────────────────────────────────┘                                           █
 █ ┤ Veiculos-Low-Poly                                                                  █
 █ ┤ Armas-Exclusivas                                                                   █
 █ ┤ Skins-Exclusivas                                                                   █
 █ ┤ Concessionárias                                                                    █
 █ ┤ Modelagens                                                                         █
 █ ┤ Sons-Armas                                                                         █
 █ ┤ Exclusivos - Mods Exclusivos                                                       █
 █ ┤ Interiores                                                                         █
 █ ┤ Animações                                                                          █
 █ ┤ Resources                                                                          █
 █ ┤ ls-full-br - Uma conversão de mapas para deixar los santos brasileira              █
 █ ┤ Calçadas                                                                           █
 █ ┤ Mapas                                                                              █
 █ ┤ Radar                                                                              █
 █ ┤ Huds                                                                               █
 █                                                                                      █
 ██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██
 ]]