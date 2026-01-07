function enviarNotificacionPolicia(jugador, ...)
    local mensaje = table.concat({...}, " ") -- Esto une todas las palabras del mensaje
    
    if mensaje == "" then
        outputChatBox("Uso: /policia [mensaje]", jugador, 255, 255, 255)
        return
    end
    
    -- Para debug - verificar si el comando se ejecuta
    
    triggerClientEvent(root, "mostrarNotificacionPolicia", jugador, mensaje)
end
addCommandHandler("policia", enviarNotificacionPolicia)
