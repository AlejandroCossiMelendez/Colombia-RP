--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

ConfigLicense = {

    license = "EW3-78M-9DG-IW4-TRUST" -- Sua licença / Your License / Tu licencia
    
}

--Obs: Não sabe como ativar o mapa? dê uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {

    lod = false,  -- Mantém o mapa visível de longas distâncias (pode impactar o desempenho, use com cautela)

    -- Ativa ou desativa o sistema de roubo a banco.
    -- true = Ativado | false = Desativado
    sistemaroubo = true, 


    -- Define o idioma dos sistemas suportados.
    -- Opções: "portugues", "english", "espanol"
    idioma = "espanol",


    -- Valor necessário para iniciar o roubo no banco.
    valorinicio = 50000000, 


    -- Teclas configuráveis para interações no sistema.
    teclaprim = "k",  -- Tecla principal de ação
    teclasec = "j",   -- Tecla secundária de ação
    teclanegative = "n", -- Tecla para ações negativas ou de cancelamento


    -- Configuração da cor dos marcadores no jogo.
    -- Formato: {R, G, B, Alpha}
    cormarker = {48, 71, 86, 100},


    -- Configurações do ped (personagem NPC) que auxilia no planejamento do roubo.
    idped = 44,        -- ID do ped
    nomeped = "Lester", -- Nome do ped


    -- Configurações de permissões ACL.
    aclpolicial = {"Policia"}, -- ACL que será avisada durante o roubo e pode interagir com o painel de Hackeamento Externo
    quantpolicia = 3, -- Define quantos jogadores na acl Policial precisam estar online para poder iniciar o roubo.

    
    aclroubo = {"Everyone"},   -- ACL permitida para iniciar o roubo (Everyone = Todos os jogadores)


    -- Tempos relacionados ao sistema de roubo.
    temporoubo = 15,  -- Tempo disponível para completar o roubo (em minutos)
    temporestart = 30, -- Tempo de espera para roubar o banco novamente (em minutos)

   AvisarPoliciais = function (player)
    avisarPolicia(player) -- Llama a tu función del resource policia
end,


    -- Valores aleatórios para recompensas em malotes e caixas eletrônicos.
    -- Formato: {valor mínimo, valor máximo}
    valormalotes = {10000000, 30000000}, -- Valores ao pegar malotes de dinheiro
    valorcaixa = {1000000, 3000000},     -- Valores ao pegar dinheiro no caixa eletrônico

    --------------------------------------------------------------------------------------------------------
    -- Sistema de Infobox.
    -- true = Ativado | false = Desativado
    -- Se desativado, as mensagens serão exibidas no chat.
    infobox = true, 

    -- Função para integração com o sistema de notificações personalizado.
    TrustnotifyS = function (player, message, type)
        exports.a_infoBox:addBox(player, message, type) -- Coloque o seu sistema de notificação (Lado do Servidor)
    end,

    -- Configuração de tipos de mensagens no sistema de notificações.
    info = "info",   -- Tipo de mensagem informativa
    erro = "error",  -- Tipo de mensagem de erro
    --------------------------------------------------------------------------------------------------------

    -----------------------------------------
    --------- Sistema de Dinheiro ------------
    -----------------------------------------
    -- Ajuste as funções de dinheiro para o sistema financeiro utilizado no servidor.
    -- Caso use o sistema padrão do MTA:SA, mantenha como está.

    getMoney = function(player)
        return getPlayerMoney(player) -- Obtém quando dinheiro o jogador possui
    end,

    giveMoney = function(player, quant)
        return exports.players:giveMoney(player, quant) -- Dá dinheiro ao jogador (pode configurar para receber dinheiro sujo caso desejar)
    end,

    takeMoney = function(player, quant)
        return exports.players:takeMoney(player, quant) -- Retira dinheiro do jogador
    end,

    -----------------------------------------
    ------------- Anti Conflito --------------
    -----------------------------------------
    -- IDs de objetos utilizados nos resources.
    idbanco = 4556,  -- ID do objeto do banco
    idporta = 4580,  -- ID da porta giratória
    idvidro = 4747,  -- ID do vidro do banco
    idserra = 4615,  -- ID do objeto serra
    idmoney = 4602   -- ID do malote de dinheiro

	
}
