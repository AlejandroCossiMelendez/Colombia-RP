-- filepath: c:\Users\brand\OneDrive\Desktop\guaroRP\SirenasPDyEJC\server.lua
-- Evento para sincronizar el claxon
addEvent("sincronizarClaxon", true)
addEventHandler("sincronizarClaxon", root, function(veh)
    triggerClientEvent(root, "reproducirClaxon", root, veh) -- Notificar a todos los clientes
end)

-- Evento para detener el claxon
addEvent("detenerClaxon", true)
addEventHandler("detenerClaxon", root, function()
    triggerClientEvent(root, "detenerClaxon", root) -- Notificar a todos los clientes
end)