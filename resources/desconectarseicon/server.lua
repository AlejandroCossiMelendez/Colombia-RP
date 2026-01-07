-- Función para crear el CJ oscuro y el texto flotante cuando el jugador se desconecta o usa el comando
function createDisconnectMarker(player, reason)
    -- Obtenemos la posición del jugador
    local x, y, z = getElementPosition(player)
    local rot = getPedRotation(player)

    -- Obtenemos el nombre del jugador
    local playerName = getPlayerName(player)

    -- Obtenemos la fecha y hora actual
    local time = getRealTime()
    local dateStr = string.format("%04d-%02d-%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)

    -- Creamos el CJ oscuro en la posición donde el jugador se desconectó (o ejecutó el comando)
    local cjPed = createPed(0, x, y, z) -- ID 0 es Carl Johnson (CJ)
    setElementRotation(cjPed, 0, 0, rot) -- Rotación del CJ como la del jugador
    setElementAlpha(cjPed, 150) -- << EDITA AQUÍ LA OPACIDAD DEL CJ (0-255, siendo 255 completamente visible)
    setElementCollisionsEnabled(cjPed, false) -- Hacemos que sea traspasable

    -- Creamos un texto flotante con el nombre del jugador, razón de desconexión, fecha y hora
    local floatingText = string.format("%s se ha desconectado.\nRazón: %s\nFecha y Hora: %s", playerName, reason, dateStr)

    -- Creamos un elemento de servidor para almacenar el texto flotante
    local textElement = createElement("text")
    setElementPosition(textElement, x, y, z + 1.5) -- Ajustamos la altura para que el texto esté sobre CJ
    setElementData(textElement, "text", floatingText) -- Guardamos el texto en el elemento

    -- Programamos la eliminación del CJ y texto después de 60 segundos
    setTimer(function()
        if isElement(cjPed) then destroyElement(cjPed) end
        if isElement(textElement) then destroyElement(textElement) end
    end, 60 * 1000, 1) -- 60 segundos en milisegundos
end

-- Evento que se ejecuta cuando un jugador se desconecta
addEventHandler("onPlayerQuit", root, function(quitType)
    -- Determinamos el motivo de desconexión
    local reason = "Desconocido" -- Por defecto

    if quitType == "Quit" then
        reason = "El jugador ha salido."
    elseif quitType == "Timed out" then
        reason = "El jugador perdió la conexión (Timed Out)."
    elseif quitType == "Kicked" then
        reason = "El jugador fue expulsado (Kick)."
    elseif quitType == "Banned" then
        reason = "El jugador fue baneado (Ban)."
    end

    -- Creamos el marcador de desconexión con el motivo adecuado
    createDisconnectMarker(source, reason)
end)

-- Comando /testdisconnect para probar el CJ oscuro y el texto flotante
addCommandHandler("testdisconnect", function(player, commandName, ...)
    -- Obtenemos la razón (si se proporciona) o "Test" como predeterminado
    local reason = table.concat({...}, "Test") or "Test"

    -- Llamamos la función para crear el ped y el texto flotante
    createDisconnectMarker(player, reason)
end)