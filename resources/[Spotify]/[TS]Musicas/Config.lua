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
    license = "904-93A-ABC-338-TIOSAM" -- KEY DO USUARIO
}
 
Config = {

    ["IMPORTANTE"] = {
	
		['IdiomaNativo'] = "es-ES", -- SELECIONE SEU IDIOMA, pt-BR" CASO FALE PORTUGUES OU ["es-ES"] CASO FALE ESPANHOL
        ["TeclaPainel"] = "f6", -- TECLA PARA ABRIR O PAINEL E FECHAR ( backspace TAMBEM FECHA )
        ["usarJBL"] = true, -- CASO QUEIRA O SISTEMA DE JBL, USE true, CASO NÃO QUEIRA USE false
        ["Comando"] = "parlante", -- COMANDO PARA PEGAR A JBL
        ["IdJBL"] = 2226, -- ID DA MODELAGEM DA JBL
		["PremiumACLs"] = {"Everyone", "Admin"}, -- ACLS COM PERMISSÃO PARA USAR A JBL, CASO QUEIRA DEIXAR TODOS COM A PERMISSAO, DEIXE UMA ACL COMO Everyone
				
	
    },

    ["VOLUME"] = {
	
        ["VolumePJogador"] = 0.5, -- VOLUME PADRÃO PARA MUSICAS QUE IRÃO TOCAR APENAS PARA O JOGADOR
        ["VolumeMaxJogador"] = 5.0, -- VOLUME MAXIMO PARA MUSICAS QUE IRÃO TOCAR APENAS PARA O JOGADOR
        ["VolumePVeiculo"] = 1.0, -- VOLUME PADRÃO PARA MUSICAS EM VEICULOS
        ["VolumeMaxVeiculo"] = 3.0, -- VOLUME MAXIMO PARA MUSICAS EM VEICULOS	
        ["VolumePJBL"] = 1.0, -- VOLUME PADRAO PARA MUSICAS QUE IRÃO TOCAR NA JBL
        ["VolumeMaxJBL"] = 3.0, -- VOLUME MAXIMO PARA A JBL
						
    },	

    ["DISTANCIA"] = {

        ["DistanciaVeiculo"] = { 6, 20 }, -- DISTANCIA MINIMA E MAXIMA DE ALCANCE DO SOM DO VEICULO
		["DistanciaJBL"] = { 6,  20 }, -- DISTANCIA MINIMA E MAXIMA DE ALCANCE DO SOM DA JBL

    },

    ["BloquearVeiculos"] = { -- ID DOS VEICULOS QUE NÃO SERÃO AUTORIZADOS TOCAR MUSICA, 'true' PARA BLOQUEAR
	
        [481] = true, 
        [510] = true, 
        [509] = true, 
        [581] = true, 
        [462] = true, 
        [521] = true, 
        [463] = true, 
        [461] = true,  
        [445] = true,  
        [448] = true, 
        [468] = true, 
        [586] = true, 
    },


	['IdiomaNativo'] = { 
	
		['pt-BR'] = { 
		
			["Diretorio Imagens"] = "files/gfx",
		
			["Texto 01"] = "Erro ao buscar musica",
			["Texto 02"] = "Busque a musica que deseja pelo seu nome",
			["Texto 03"] = "Você precisa estar em um veículo",
			["Texto 04"] = "Você desligou a musica do veículo",
			["Texto 05"] = "Você guardou sua JBL",
			["Texto 06"] = "Você guardou sua JBL",
			["Texto 07"] = "Você não tem permissão para usar uma JBL",
			["Texto 08"] = "O uso de JBL está desativado no momento.",
			["Texto 09"] = "Você não pode pegar uma JBL dentro de um veículo",
			["Texto 10"] = "Você colocou a musica na sua JBL",
			["Texto 11"] = "Você precisa estar com uma JBL na mão para colocar uma musica",
			["Texto 12"] = "Você trocou a musica do veículo",
			["Texto 13"] = "Você não pode tocar uma musica dentro desse veículo, pois ele ja está com o spotify ativo",
			["Texto 14"] = "Não é permitido usar o spotify nesse veículo",
			["Texto 15"] = "Você precisa estar em um veículo para usar o spotify",
			["Texto 16"] = "Selecione a musica que deseja tocar",
			["Texto 17"] = "Nada encontrado no momento",
			["Texto 18"] = "Selecione uma música",
			["Texto 19"] = "Aguarde, você está indo rápido demais",
			["Texto 20"] = "Você desligou a musica que estava tocando apenas pra você",
			["Texto 21"] = "Aguarde, você está indo rápido demais",
			["Texto 22"] = "Pesquise por músicas ou artistas",
			
		},

		["es-ES"] = {
		
			["Diretorio Imagens"] = "files/gfxES",
		
			["Texto 01"] = "Error al buscar música",
			["Texto 02"] = "Busque la música que desea por su nombre",
			["Texto 03"] = "Necesitas estar en un vehículo",
			["Texto 04"] = "Has apagado la música del vehículo",
			["Texto 05"] = "Has guardado tu JBL",
			["Texto 06"] = "Has guardado tu JBL",
			["Texto 07"] = "No tienes permiso para usar un JBL",
			["Texto 08"] = "El uso de JBL está desactivado en este momento.",
			["Texto 09"] = "No puedes coger un JBL dentro de un vehículo",
			["Texto 10"] = "Has puesto la música en tu JBL",
			["Texto 11"] = "Necesitas tener un JBL en la mano para poner una música",
			["Texto 12"] = "Has cambiado la música del vehículo",
			["Texto 13"] = "No puedes reproducir música dentro de este vehículo, ya que ya tiene Spotify activo",
			["Texto 14"] = "No se permite usar Spotify en este vehículo",
			["Texto 15"] = "Necesitas estar en un vehículo para usar Spotify",
			["Texto 16"] = "Selecciona la música que deseas reproducir",
			["Texto 17"] = "Nada encontrado en este momento",
			["Texto 18"] = "Selecciona una canción",
			["Texto 19"] = "Espere, está yendo demasiado rápido",
			["Texto 20"] = "Has apagado la música que estaba reproduciendo solo para ti",
			["Texto 21"] = "Espere, está yendo demasiado rápido",
			["Texto 22"] = "Buscar en Verso Spotify",
			
		}
	};

	
}

function message(player, text, type)
    exports['dxmessages']:addBox(player, text, type) -- EXPORTS DA SUA INFOBOX
end