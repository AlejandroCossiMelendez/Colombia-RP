--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

ConfigLicense = {

    license = "EW3-78M-9DG-IW4-TRUST" -- Sua licença / Your License / Tu licencia
    
}

--Obs: Não sabe como ativar o mapa? dê uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {

    aclDj = {"KYOTOCLUB","MAFIARUSA","Desarrollador"}, -- Acl que pode abrir o painel de Dj no palco (Pode colocar mais de um, necessario a virgula ex: {"DJ", "DJ2"},)
    
    -- Dica de site para pegar musicas https://site.mtabrasil.com.br/musicas/
    
    
    ----------configurações gerais----------
    lod = false, -- Mantém o mapa visível de longas distâncias (pode impactar o desempenho, use com cautela)


    texturasanim = true, -- texturas das paredes animadas (true = sim | false = não)
    
    pagaringre = true, -- Pagar para entrar na balada (true = sim | false = não)
    
    aclcaixaboate = {"JEFESCLUBKYOTO"}, -- Acl que pode abrir o painel e pegar o dinheiro do lucro da Boate (coloque quantas quiser)(necessario a ,)

    aclvip = {"MAFIARUSA","Desarrollador","KYOTOCLUB","JEFESCLUBKYOTO"},-- Acl que entra sem pagar na boate (Pode colocar mais de um, necessario a virgula ex: {"DJ", "DJ2"},)
    
    valoringre = 500000, -- valor do ingresso para entrar na boate
    
    moedab = "COL$", -- Moeda do seu pais
    
    lingua = "espanol", -- Idioma das frases (portugues, english, espanol)
    
    cormarkers = {244, 7, 253, 100}, -- Cor dos markers dj e ingresso (RGB)
    
    animquartos = true, -- Animação +18 nos quartos (true = sim, false = não)
    
    botaofechar = "tab", -- Botão para fechar o painel Dj
    
    botaoanim = "backspace", -- Botão para parar a animação dos quartos
    ----------peds dançando----------
    peddancando = true, -- Peds dançando (true = sim | false = não)
    
    dancarinas = { -- Posicao dos peds
    {1991.626, -1287.837, 24.984, 0, 0, 270},
    {1986.351, -1287.905, 24.984, 0, 0, 90},
    {1991.217, -1304.091, 24.984, 0, 0, 322},
    {1986.539, -1304.042, 24.984, 0, 0, 46},
    {2048.801, -1279.968, 25.187, 0, 0, 90},
    {2048.722, -1295.128, 25.187, 0, 0, 90},
    },
    
    idspeds = {63,64,85},-- ids dos peds dançando
    
    
    messageopt = "infobox", -- Vincular a sua infobox (caso queira deixe = "infobox", caso não queira deixe "chat" para as mensagens aparecerem no chat)
    
    TrustnotifyS = function (elemento, mensagem, type)
    exports.a_infobox:addBox(elemento, mensagem, type) -- Manda directo a tu infobox
end,

    info = "info", -- Argumento info da sua infobox
    erro = "error", -- Argumento erro da sua infobox
    ----------painel dj----------
    corrgb1 = tocolor(146, 15, 158, 255), -- Cor Rgb do painel de dj (RGB)
    corrgb2 = tocolor(129, 0, 141, 255),-- Cor Rgb do painel de dj (RGB)
    corrgb3 = tocolor(79, 0, 93, 255),-- Cor Rgb do painel de dj (RGB)
    corrgb4 = tocolor(87, 9, 94, 255),-- Cor Rgb do painel de dj (RGB)
    corrgb5 = tocolor(87, 9, 130, 255),-- Cor Rgb do painel de dj (RGB)
    corrgb6 = tocolor(190, 188, 192, 255),-- Cor Rgb do painel de dj (RGB)
    
    ----------painel ingresso----------
    corrgb7 = tocolor(52, 21, 56, 255),-- Cor Rgb do painel de ingresso (RGB)
    corrgb8 = tocolor(92, 61, 96, 255),-- Cor Rgb do painel de ingresso (RGB)




    -----------------------------------------
    -----------Sistema de Dinheiro-----------
    -----------------------------------------

    -- Caso seu sistema de dinheiro seja o mesmo do mta sa mantenha como esta, caso contrario modifique para o seu sistema.
    getMoney = function(player)
        return getPlayerMoney(player) -- Função getPlayerMoney
    end,
    
    giveMoney = function(player, quant)
        return exports.players:giveMoney(player, quant) -- Função givePlayerMoney
    end,
    
    takeMoney = function(player, quant)
        return exports.players:takeMoney(player, quant) -- Função takePlayerMoney
    end,

    
}
