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

bindport = "k", -- Tecla para abrir as portas e portões

protecaoacl = false, -- Proteção por acl na Base (true = sim | false = nao)

tempoportao = 4000, -- Tempo que vai demorar para o portão fechar (em milisegundos)

idioma = "espanol", -- Idioma das mensagens no chat (portugues, english, espanol)

bases = { -- BASES ESPALHADAS PELO MAPA

--------------------------------------------------------------------------------------------------------------------------

{ -- INICIO
    "pmesp", -- TEXTURA DA BASE. OPÇÕES ("bope", "eb", "fn", "pcesp", "pf", "pmerj", "pmesc", "pmesp", "pmmg", "rota")
        2218.8962, -1343.045, 29.01837, -- PosX, PosY, PosZ
            0, -- RotaçãoZ
                acls = {"CDJ", "Desarrollador"} -- Acls da base
}, -- FIM

--------------------------------------------------------------------------------------------------------------------------

{ -- INICIO
    "pmerj", -- TEXTURA DA BASE. OPÇÕES ("bope", "eb", "fn", "pcesp", "pf", "pmerj", "pmesc", "pmesp", "pmmg", "rota")
        2482.8999023438, -1545.0999755859, 29.10000038147, -- PosX, PosY, PosZ
            180, -- RotaçãoZ
                acls = {"CDG", "Desarrollador"} -- Acls da base
}, -- FIM

--------------------------------------------------------------------------------------------------------------------------

{ -- INICIO
    "pmesc", -- TEXTURA DA BASE. OPÇÕES ("bope", "eb", "fn", "pcesp", "pf", "pmerj", "pmesc", "pmesp", "pmmg", "rota")
        2898.8999023438, -1970.3000488281, 16.200000762939, -- PosX, PosY, PosZ
            270, -- RotaçãoZ
                acls = {"ELN", "Desarrollador"} -- Acls da base
}, -- FIM
    
--------------------------------------------------------------------------------------------------------------------------
    -- PARA ADICIONAR MAIS BASES SO COPIAR OQUE ESTA ACIMA ENTRE {  }, E COLAR AQUI EM BAIXO




    
},

idbase = 5426, -- ID do objeto da base

}
