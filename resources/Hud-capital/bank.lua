--[[
    Integración de saldo bancario para HUD
    Descripción: Maneja las solicitudes de saldo bancario del HUD
]]

-- Función para obtener el saldo bancario del jugador y enviarlo al cliente
function getBalance(player)
    if isElement(player) then
        -- Acceder al saldo bancario con protección contra errores
        local currentBalance = 0
        local success = pcall(function()
            currentBalance = exports.bank:getDinero(player) or 0
        end)
        
        -- Si no se pudo obtener el saldo, usar un valor de respaldo
        if not success then
            -- Intentar obtener el saldo de otra manera (getElementData) como respaldo
            currentBalance = getElementData(player, "bankmoney") or 0
        end
        
        -- Enviar el saldo al cliente
        triggerClientEvent(player, "onClientRequestBalance", player, currentBalance)
    end
end
addEvent("onRequestBalance", true)
addEventHandler("onRequestBalance", root, getBalance)

-- Cuando un jugador ingresa al servidor, actualizar su saldo
addEventHandler("onPlayerJoin", root, function()
    -- Darle tiempo al jugador para cargar completamente
    setTimer(function(player)
        if isElement(player) then
            getBalance(player)
        end
    end, 5000, 1, source)
end) 