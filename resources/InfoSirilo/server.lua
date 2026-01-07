-- Función para enviar notificaciones a los jugadores
function addBoxSiri (player, message, type)
    triggerClientEvent(player, 'addBoxSiri', player, message, type)
end

-- Comando para enviar anuncios de prueba (requiere permisos de administrador)
addCommandHandler('pruebas', function (player, _, ...)
    if not exports.factions:isInFaction(player, 1) then
        addBoxSiri(player, 'No tienes acceso a este comando.', 'error')
        return
    end
    
    local aviso = table.concat({...}, ' ')
    if aviso and string.len(aviso) > 0 then
        addBoxSiri(root, aviso, 'admin')
    else
        addBoxSiri(player, 'Por favor, ingresa un mensaje para enviar.', 'warning')
    end
end)

-- Comando para enviar anuncios de la policía
addCommandHandler('Npd', function (player, _, ...)
    if not exports.factions:isPlayerInFaction(player, 1) then
        addBoxSiri(player, 'No tienes acceso a este comando.', 'error')
        return
    end
    
    local aviso = table.concat({...}, ' ')
    if aviso and string.len(aviso) > 0 then
        addBoxSiri(root, aviso, 'infoPD')
    else
        addBoxSiri(player, 'Por favor, ingresa un mensaje para enviar.', 'warning')
    end
end)

addCommandHandler('Nmeca', function (player, _, ...)
    if not exports.factions:isPlayerInFaction(player, 3) then
        addBoxSiri(player, 'No tienes acceso a este comando.', 'error')
        return
    end
    
    local aviso = table.concat({...}, ' ')
    if aviso and string.len(aviso) > 0 then
        addBoxSiri(root, aviso, 'infoMC')
    else
        addBoxSiri(player, 'Por favor, ingresa un mensaje para enviar.', 'warning')
    end
end)

addCommandHandler('Nsura', function (player, _, ...)
    if not exports.factions:isPlayerInFaction(player, 2) then
        addBoxSiri(player, 'No tienes acceso a este comando.', 'error')
        return
    end
    
    local aviso = table.concat({...}, ' ')
    if aviso and string.len(aviso) > 0 then
        addBoxSiri(root, aviso, 'infoSR')
    else
        addBoxSiri(player, 'Por favor, ingresa un mensaje para enviar.', 'warning')
    end
end)


