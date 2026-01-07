--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

ConfigLicense = {

    license = "EW3-78M-9DG-IW4-TRUST" -- Sua licença / Your License / Tu licencia
    
}

--Obs: Não sabe como ativar o mapa? dê uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {

    -- Configuração dos veiculos expostos 
    
    veiculos = true, -- Veiculos expostos (true = sim | false = não)
    
    veiculosConfig = { -- model = ID, PosZ = altura = color = {PrimariaR, PrimariaG, PrimariaB, SecundariaR, SecundariaG, SecundariaB}
        {model = 535, posZ = 25.057825088501, color = {54, 57, 63, 245, 245, 245}, veh = true},
        {model = 541, posZ = 24.966619491577, color = {216, 199, 163, 98, 68, 40}, veh = true},
        {model = 429, posZ = 24.881120681763, color = {98, 24, 24, 98, 68, 40}, veh = true},
        {model = 451, posZ = 24.781631469727, color = {34, 60, 74, 98, 68, 40}, veh = true},
        {model = 562, posZ = 24.781631469727, color = {59, 67, 49, 98, 68, 40}, veh = true},
        {model = 522, posZ = 25.037252426147, color = {54, 57, 63, 54, 57, 63}, veh = true},
        {model = 522, posZ = 25.037252426147, color = {59, 67, 49, 59, 67, 49}, veh = true},
        {model = 522, posZ = 25.037252426147, color = {216, 199, 163, 216, 199, 163}, veh = true},
    },
    
    placaveiculos = "CAPITALRP", -- Placa dos veiculos em exposição
}
