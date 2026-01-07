addEventHandler("onPlayerTriggerEventThreshold", root, function()
    local playerName = getPlayerName(source)
    local playerSerial = getPlayerSerial(source)

    -- Expulsar al jugador
    kickPlayer(source, "Detectado por abuso de eventos (trigger spam).")

    -- Mensajes en consola y chat
    outputChatBox(playerName .. " ha sido expulsado por spam de eventos. SIRILO TE AMA", root, 255, 0, 0)
    outputDebugString("⚠ Expulsado por trigger spam: " .. playerName .. " | Serial: " .. playerSerial)
end)
