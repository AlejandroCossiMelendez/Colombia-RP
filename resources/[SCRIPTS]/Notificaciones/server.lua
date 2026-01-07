function addNotification(player, text, type)
    triggerClientEvent(player, "add:notification", player, text, type)
end