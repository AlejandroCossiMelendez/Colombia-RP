--[[
 ______    ______      _____       ____        ______                 
/\__  _\  /\__  _\    /\  __`\    /\  _`\     /\  _  \     /'\_/`\    
\/_/\ \/  \/_/\ \/    \ \ \/\ \   \ \,\L\_\   \ \ \L\ \   /\      \   
   \ \ \     \ \ \     \ \ \ \ \   \/_\__ \    \ \  __ \  \ \ \__\ \  
    \ \ \     \_\ \__   \ \ \_\ \    /\ \L\ \   \ \ \/\ \  \ \ \_/\ \ 
     \ \_\    /\_____\   \ \_____\   \ `\____\   \ \_\ \_\  \ \_\\ \_\
      \/_/    \/_____/    \/_____/    \/_____/    \/_/\/_/   \/_/ \/_/
                                                     
                         » CopyRight © 2024
                 » Meu discord discord.gg/sY5wHR8hW3                                                                          
]]--

ConfigLicense = {
    license = "D2B-9B4-DE8-01F-TIOSAM" -- KEY DO USUARIO
}

Config = {

    ["ACESSO"] = {
	
        [1] = {
		
		    ["ACLsPermitidas"] = {"MAFIARUSA","Desarrollador"}, -- ACLS COM PERMISSÃO PARA ACESSAR 
            ["MarkerDJ"] = { ["Marker"] = {651.1416015625, -1152.0068359375, 40.5859375 -1, "cylinder", 1.1, 43, 210, 104, 255}, ["Blip"] = 0}, -- POSICÃO DO MARKER E ID DO BLIP 
			
        },

        [2] = {
		
		    ["ACLsPermitidas"] = {"Console", "Admin"}, -- ACLS COM PERMISSÃO PARA ACESSAR 
            ["MarkerDJ"] = { ["Marker"] = {236.848, -1199.513, 76.14 -1, "cylinder", 1.1, 43, 210, 104, 255}, ["Blip"] = 0}, -- POSICÃO DO MARKER E ID DO BLIP 
			
        },		
		
    },	

    ["VOLUME"] = {
	
        ["VolumeFixo"] = 0.5, -- VOLUME PADRÃO PARA MUSICAS QUE IRÃO NO PAINEL DJ
        ["DistanciaMinima"] = 1, -- DISTANCIA MINIMA DE ALCANCE DO SOM DO PAINEL DE DJ
        ["DistanciaMaxima"] = 50, -- DISTANCIA MAXIMA DE ALCANCE DO SOM DO PAINEL DE DJ
						
    },	
	
    ["OUTROS"] = {
	
		["QuerBlur"] = true; -- true PARA ATIVAR O Blur, false PARA DESATIVAR	
        ["NomeBlur"] = "Blur"; -- NOME DO RESOURCE Blur EM SEU SERVIDOR			
		
    },	

}

function message(player, text, type)
    exports['dxmessages']:addBox(player, text, type) -- EXPORTS DA SUA INFOBOX
end