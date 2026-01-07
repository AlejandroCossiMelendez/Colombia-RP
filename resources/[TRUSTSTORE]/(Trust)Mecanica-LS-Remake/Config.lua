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
    
portao = true, -- Sistema de portão por acl (true = sim | false = não)

portaoautomatico = true, -- Portão abrir automaticamente ao aproximar dele para quem tem permissão (true = sim | false = nao) Caso coloque false voce vai precisar apertar a tecla definida abaixo para abrir

protecaoacl = false, -- Proteção por acl no segundo andar da mecânica (true = sim | false = não)

bindport = "k", -- Tecla para abrir as portas e portões

idioma = "espanol", -- Idioma das mensagens no chat (portugues, english, espanol)

aclpt = {"Everyone"}, -- Acls que podem trancar / destrancar os portões

tempoportao = 4000, -- Tempo que vai demorar para o portão fechar (em milisegundos)


-- Configuração dos veiculos expostos 

veiculos = true, -- Veiculos expostos (true = sim | false = não)

placaveiculos = "CAPITAL", -- Placa dos veiculos em exposição

veiculosConfig = { -- model = ID, PosZ = altura = color = {PrimariaR, PrimariaG, PrimariaB, SecundariaR, SecundariaG, SecundariaB}
    {model = 535, posZ = 32.52373, color = {30, 30, 30, 245, 245, 245}},
    {model = 451, posZ = 32.35379, color = {200, 0, 0, 98, 68, 40}},
},


}
