--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

ConfigLicense = {

    license = "EW3-78M-9DG-IW4-TRUST" -- Sua licença / Your License / Tu licencia
    
}

--Obs: Não sabe como ativar o mapa? dê uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {

sistemaelev = true, -- Sistema do elevador (true = sim | false = não)

idioma = "espanol", -- Idioma do sistema (portugues, english, espanol)

teclaacao = "k", -- Tecla para usar o sistema de elevador
teclasubir = "1", -- Tecla para subir o elevador
tecladescer = "2", -- Tecla para descer o elevador

lod = true, -- Renderizar o guindaste de longas distancias

idelev = 1900, -- Id do objeto do elevador


--------------------------------------------------------------------------------------------------------
-- Sistema de Infobox.
-- true = Ativado | false = Desativado
-- Se desativado, as mensagens serão exibidas no chat.
infobox = true, 

-- Função para integração com o sistema de notificações personalizado.
TrustnotifyS = function (player, message, type)
     exports.InfoSirilo:addBoxSiri(player, message, type) -- Coloque o seu sistema de notificação (Lado do Servidor)
end,

-- Configuração de tipos de mensagens no sistema de notificações.
info = "info",   -- Tipo de mensagem informativa
erro = "error",  -- Tipo de mensagem de erro
--------------------------------------------------------------------------------------------------------

    
}
