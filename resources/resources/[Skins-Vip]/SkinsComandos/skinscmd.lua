function skinCastilla(player)
    local serialOwner = "C60BACF8A8441506B982055B9ADD8094"
    local playerSerial = getPlayerSerial(player)
    local namePlayer = getPlayerName( player )

    if playerSerial == serialOwner then
        setElementModel(player, 302)
        outputChatBox("Hola de nuevo "..namePlayer.." skin puesta exitosamente", player, 0, 255, 0)
    else
        outputChatBox("Error", player, 255, 0, 0)
    end
end
addCommandHandler("y2k", skinCastilla)

function skinCrespo(player)
    local serialOwner = "0B39FD2C06BAC6B598C2DB50B00B07A2"
    local playerSerial = getPlayerSerial(player)
    local namePlayer = getPlayerName( player )

    if playerSerial == serialOwner then
        setElementModel(player, 136)
        outputChatBox("Hola de nuevo infiel "..namePlayer.." skin puesta exitosamente", player, 0, 255, 0)
    else
        outputChatBox("Error", player, 255, 0, 0)
    end
end
addCommandHandler("crespo", skinCrespo)

function skinGio(player)
    local serialOwner = "E01C4A8BED9F7BE1862102ACFA49A5E3"
    local playerSerial = getPlayerSerial(player)
    local namePlayer = getPlayerName( player )

    if playerSerial == serialOwner then
        setElementModel(player, 91)
        outputChatBox("Hola de nuevo "..namePlayer.." skin puesta exitosamente", player, 0, 255, 0)
    else
        outputChatBox("Error", player, 255, 0, 0)
    end
end
addCommandHandler("gio", skinGio)





addCommandHandler("max", function(player, command, option)
    local skins = {
        [1] = 193,
        [2] = 210,
        [3] = 230,
        [4] = 240
    }

    local allowedSerial = "385017BC34A9F617D1E392094AAA04B3"
    local playerSerial = getPlayerSerial(player)
    local skinOption = tonumber(option)

    if playerSerial == allowedSerial then
        if skins[skinOption] then
            setElementModel(player, skins[skinOption])
            outputChatBox("Has cambiado tu skin " .. skinOption .. ".", player, 0, 255, 0)
        else
            outputChatBox("Error: Opción de skin no válida.", player, 255, 0, 0)
        end
    else
        outputChatBox("Error: No tienes permiso para usar estas skins.", player, 255, 0, 0)
    end
end)
