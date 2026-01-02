local ifp = engineLoadIFP( "empe.ifp", "empe" )

addEvent( "empe", true )
addEventHandler( "empe", root,
	function(enable)
		if (enable) then setPedAnimation(source, "empe", "BIKEd_drivebyRHS", -1, true, false)
		else setPedAnimation(source)
		end		
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent("onClientSync", resourceRoot)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if ifp then
			for _,player in ipairs(getElementsByType("player")) do
				local _, empe = getPedAnimation(player)
				if (empe == "BIKEd_drivebyRHS") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end
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