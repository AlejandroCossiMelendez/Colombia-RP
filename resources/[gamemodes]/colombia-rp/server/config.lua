-- Configuración del servidor
Config = {}

-- Configuración de MySQL
Config.Database = {
    host = "127.0.0.1",
    port = 3306,
    database = "mta_login",
    username = "mta_user",
    password = "15306266_Mta",
    charset = "utf8"
}

-- Configuración del servidor
Config.Server = {
    maxCharacters = 3, -- Máximo de personajes por usuario
    defaultMoney = 5000, -- Dinero inicial
    defaultSkin = 0, -- Skin por defecto
    defaultPosX = 1959.55,
    defaultPosY = -1714.46,
    defaultPosZ = 10.0,
    defaultRotation = 0,
    defaultInterior = 0,
    defaultDimension = 0,
    defaultHealth = 100.0,
    defaultHunger = 100,
    defaultThirst = 100
}

-- Configuración de necesidades
Config.Needs = {
    hungerDecreaseRate = 1, -- Disminuye cada X segundos
    thirstDecreaseRate = 1, -- Disminuye cada X segundos
    hungerDecreaseAmount = 1, -- Cantidad a disminuir
    thirstDecreaseAmount = 1, -- Cantidad a disminuir
    updateInterval = 60000 -- Actualizar cada 60 segundos
}

