--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

ConfigLicense = {

    license = "EW3-78M-9DG-IW4-TRUST" -- Sua licença / Your License / Tu licencia
    
}

--Obs: Não sabe como ativar o mapa? dê uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {
    
acldj = {"Desarrollador"}, -- Acl que tem acesso ao telão
      
cormarker = {75, 25, 118, 200}, -- Cor RGB do marker
            
teclafechar = "tab", -- Tecla para fechar os paineis (Coloque tudo minusculo)

idioma = "espanol", -- Idioma das mensagens: ("portugues" | "english" | "espanol")
          
valoringresso = 500000, -- Valor do ingresso

moeda = "$", -- Moeda desejada

browservolume = 0.8, -- Altura do som do telão

aclentradaarena = {"VIP", "Desarrollador"}, -- Acl que pode entrar sem pagar na Arena (coloque quantas quiser)(necessario a ,)

aclcaixaarena = {"Desarrollador"},-- Acl que pode retirar o dinheiro lucrado na arena (coloque quantas quiser)(necessario a ,)
     
infobox = true, -- Infobox (true = sim, false = mensagens serão exibidas no chat)
        
TrustnotifyS = function (player, message, type) -- Vincule a sua infobox, colocando abaixo o trigger ou o export (Lado do servidor)

 exports.InfoSirilo:addBoxSiri(player, message, type)

end,
      
info = "info", -- Argumento info da sua infobox
erro = "error", -- Argumento erro da sua infobox



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
