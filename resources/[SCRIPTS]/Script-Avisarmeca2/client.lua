--------------------Creditos-------------------
--Anthony Diaz

-- Manejador para notificaciones (opcional)
function onCallNotification(type, message, show)
    -- Aquí puedes agregar código para mostrar notificaciones en el cliente
    -- Por ejemplo: mostrar un GUI, sonido, etc.
    outputChatBox("Notificacion: " .. message, 255, 255, 0)
end
addEvent("callNotification", true)
addEventHandler("callNotification", getRootElement(), onCallNotification)