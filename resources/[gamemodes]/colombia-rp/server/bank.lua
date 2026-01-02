-- Sistema de Bancos adaptado para Colombia RP
local banks = {}
local blips = {}

-- Función para verificar si un jugador está cerca de un banco
function bancoCercano(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end
    
    if not getElementData(player, "character:selected") then
        return false
    end
    
    local x, y, z = getElementPosition(player)
    for key, value in pairs(banks) do
        if isElement(key) then
            local x2, y2, z2 = getElementPosition(key)
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            local comp = 0
            if getElementType(key) == "object" then
                comp = 1.5 -- ATM
            elseif getElementType(key) == "ped" then
                comp = 10 -- Banco con NPC
            end
            
            if distance <= comp then
                if getElementType(key) == "object" then
                    return 1 -- ATM
                else
                    return 2 -- Banco con NPC
                end
            end
        end
    end
    return false
end

-- Función para obtener el dinero del banco
function getCharacterBank(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return 0
    end
    
    local bank = getElementData(player, "character:bank")
    return bank or 0
end

-- Función para establecer el dinero del banco
function setCharacterBank(player, amount)
    if not isElement(player) or getElementType(player) ~= "player" or amount < 0 then
        return false
    end
    
    setElementData(player, "character:bank", amount)
    
    -- Guardar en base de datos
    local characterId = getElementData(player, "character:id")
    if characterId then
        -- Primero verificar si la columna existe, si no, la agregamos después
        executeDatabase("UPDATE characters SET banco = ? WHERE id = ?", amount, characterId)
    end
    
    return true
end

-- Función para ingresar dinero
local function ingresarDinero(player, cmd, cantidad)
    if not getElementData(player, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    local bancoTipo = bancoCercano(player)
    if not bancoTipo or bancoTipo > 1 then
        outputChatBox("No estás cerca de un dependiente del banco.", player, 255, 0, 0)
        return
    end
    
    if not cantidad then
        outputChatBox("Sintaxis: /" .. cmd .. " [cantidad]", player, 255, 255, 255)
        return
    end
    
    cantidad = tonumber(math.floor(cantidad))
    if not cantidad or cantidad < 1 then
        outputChatBox("No puedes ingresar esta cantidad de dinero.", player, 255, 0, 0)
        return
    end
    
    -- Verificar que tenga suficiente dinero
    local currentMoney = getElementData(player, "character:money") or 0
    if currentMoney < cantidad then
        outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
        return
    end
    
    -- Quitar dinero y agregar al banco
    if takeCharacterMoney(player, cantidad) then
        local currentBank = getCharacterBank(player)
        if setCharacterBank(player, currentBank + cantidad) then
            outputChatBox("Has ingresado $" .. cantidad .. " en tu cuenta.", player, 0, 255, 0)
            outputChatBox("Balance actual: $" .. getCharacterBank(player) .. ".", player, 0, 255, 0)
        else
            -- Si falla, devolver el dinero
            giveCharacterMoney(player, cantidad)
            outputChatBox("Error al ingresar el dinero. Inténtalo más tarde.", player, 255, 0, 0)
        end
    else
        outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
    end
end

-- Comandos para ingresar dinero
addCommandHandler("ingresar", ingresarDinero)
addCommandHandler("depositar", ingresarDinero)

-- Función para retirar dinero
local function retirarDinero(player, cmd, cantidad)
    if not getElementData(player, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    if not bancoCercano(player) then
        outputChatBox("No estás cerca de un cajero o de un dependiente del banco.", player, 255, 0, 0)
        return
    end
    
    if not cantidad then
        outputChatBox("Sintaxis: /" .. cmd .. " [cantidad]", player, 255, 255, 255)
        return
    end
    
    cantidad = tonumber(math.floor(cantidad))
    if not cantidad or cantidad < 1 then
        outputChatBox("No puedes retirar esta cantidad de dinero.", player, 255, 0, 0)
        return
    end
    
    local currentBank = getCharacterBank(player)
    if currentBank < cantidad then
        outputChatBox("No tienes tanto dinero en tu cuenta bancaria.", player, 255, 0, 0)
        return
    end
    
    -- Quitar del banco y dar dinero
    if setCharacterBank(player, currentBank - cantidad) then
        if giveCharacterMoney(player, cantidad) then
            outputChatBox("Has retirado $" .. cantidad .. " de tu cuenta.", player, 0, 255, 0)
            outputChatBox("Balance actual: $" .. getCharacterBank(player) .. ".", player, 0, 255, 0)
        else
            -- Si falla, devolver al banco
            setCharacterBank(player, currentBank)
            outputChatBox("Error al retirar el dinero. Inténtalo más tarde.", player, 255, 0, 0)
        end
    else
        outputChatBox("Error al retirar el dinero. Inténtalo más tarde.", player, 255, 0, 0)
    end
end

-- Comandos para retirar dinero
addCommandHandler("retirar", retirarDinero)
addCommandHandler("sacar", retirarDinero)

-- Función para consultar saldo
local function consultarSaldo(player)
    if not getElementData(player, "character:selected") then
        outputChatBox("No tienes un personaje seleccionado.", player, 255, 0, 0)
        return
    end
    
    if not bancoCercano(player) then
        outputChatBox("No estás cerca de un cajero o de un dependiente del banco.", player, 255, 0, 0)
        return
    end
    
    local balance = getCharacterBank(player)
    outputChatBox("El balance de tu cuenta es de $" .. balance .. ".", player, 0, 255, 0)
end

-- Comandos para consultar saldo
addCommandHandler("saldo", consultarSaldo)
addCommandHandler("balance", consultarSaldo)

-- Cargar bancos desde la base de datos al iniciar
addEventHandler("onResourceStart", resourceRoot, function()
    -- Verificar si existe la columna banco en characters, si no, agregarla
    local columns = queryDatabase("SHOW COLUMNS FROM characters LIKE 'banco'")
    if not columns or #columns == 0 then
        executeDatabase("ALTER TABLE characters ADD COLUMN banco INT NOT NULL DEFAULT 0")
        outputServerLog("[BANK] Columna 'banco' agregada a la tabla 'characters'")
    end
    
    -- Verificar si existe la tabla banks, si no, crearla
    local result = queryDatabase("SHOW TABLES LIKE 'banks'")
    if not result or #result == 0 then
        -- Crear tabla banks si no existe
        executeDatabase([[
            CREATE TABLE IF NOT EXISTS banks (
                bankID INT AUTO_INCREMENT PRIMARY KEY,
                x FLOAT NOT NULL,
                y FLOAT NOT NULL,
                z FLOAT NOT NULL,
                rotation FLOAT DEFAULT 0,
                interior INT DEFAULT 0,
                dimension INT DEFAULT 0,
                skin INT DEFAULT -1
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        outputServerLog("[BANK] Tabla 'banks' creada")
    end
    
    -- Cargar bancos existentes
    local banksData = queryDatabase("SELECT * FROM banks ORDER BY bankID ASC")
    if banksData then
        for _, bankData in ipairs(banksData) do
            local bank = nil
            if bankData.skin == -1 then
                -- Crear ATM (objeto)
                bank = createObject(2942, bankData.x, bankData.y, bankData.z, 0, 0, bankData.rotation)
            else
                -- Crear NPC del banco (ped)
                bank = createPed(bankData.skin or 211, bankData.x, bankData.y, bankData.z, 0, false)
                setPedRotation(bank, bankData.rotation)
            end
            
            if bank then
                setElementInterior(bank, bankData.interior)
                setElementDimension(bank, bankData.dimension)
                banks[bank] = bankData.bankID
                banks[bankData.bankID] = {bank = bank}
            end
        end
        outputServerLog("[BANK] " .. #banksData .. " bancos/ATMs cargados")
    end
end)

-- Comando para crear ATM (solo admin)
addCommandHandler("createatm", function(player, cmd)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    local x, y, z = getElementPosition(player)
    z = z - 0.35
    local rotation = (getPedRotation(player) + 180) % 360
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    
    local success = executeDatabase("INSERT INTO banks (x, y, z, rotation, interior, dimension, skin) VALUES (?, ?, ?, ?, ?, ?, ?)",
        x, y, z, rotation, interior, dimension, -1)
    
    if success then
        local bank = createObject(2942, x, y, z, 0, 0, rotation)
        if bank then
            setElementInterior(bank, interior)
            setElementDimension(bank, dimension)
            local bankID = queryDatabase("SELECT LAST_INSERT_ID() as id")
            if bankID and bankID[1] then
                local id = bankID[1].id
                banks[bank] = id
                banks[id] = {bank = bank}
                outputChatBox("Has creado un ATM. ID: " .. id .. ".", player, 0, 255, 153)
            end
        end
    else
        outputChatBox("Error al crear el ATM.", player, 255, 0, 0)
    end
end)

-- Comando para crear banco con NPC (solo admin)
addCommandHandler("createbank", function(player, cmd)
    if not isPlayerAdmin(player) then
        outputChatBox("No tienes permiso para usar este comando.", player, 255, 0, 0)
        return
    end
    
    local x, y, z = getElementPosition(player)
    local rotation = getPedRotation(player)
    local interior = getElementInterior(player)
    local dimension = getElementDimension(player)
    
    local success = executeDatabase("INSERT INTO banks (x, y, z, rotation, interior, dimension, skin) VALUES (?, ?, ?, ?, ?, ?, ?)",
        x, y, z, rotation, interior, dimension, 211)
    
    if success then
        local bank = createPed(211, x, y, z, 0, false)
        if bank then
            setPedRotation(bank, rotation)
            setElementInterior(bank, interior)
            setElementDimension(bank, dimension)
            local bankID = queryDatabase("SELECT LAST_INSERT_ID() as id")
            if bankID and bankID[1] then
                local id = bankID[1].id
                banks[bank] = id
                banks[id] = {bank = bank}
                outputChatBox("Has creado un banco. ID: " .. id .. ".", player, 0, 255, 153)
            end
        end
    else
        outputChatBox("Error al crear el banco.", player, 255, 0, 0)
    end
end)

-- Cargar banco desde la base de datos al seleccionar personaje
-- Esto se hace en characters.lua, pero aquí tenemos funciones auxiliares

