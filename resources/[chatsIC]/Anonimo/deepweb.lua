function deepweb(source, cmd, ...)
    local mensaje = table.concat({...}, " ")
    if mensaje ~= "" and mensaje:gsub("%s+", "") ~= "" then
        if exports.players:isLoggedIn(source) then
            local nombre = getPlayerName(source)
            if nombre then
                for _, v in ipairs(getElementsByType("player")) do
                    if v then
                        if hasObjectPermissionTo(v, "command.goto", false) then
                            outputChatBox("#FFFFFF[#0A0A0A VISTA STAFF ANONIMO#FFFFFF] ["..nombre.."]: " .. mensaje, v, 255, 255, 255, true)
                        else
                            outputChatBox("#FFFFFF[#0A0A0A ANONIMO#FFFFFF]: " .. mensaje .. ".", v, 255, 255, 255, true)
                        end
                    end
                end
            end
        else
            outputChatBox("Debes iniciar sesión para poder enviar un mensaje.", source, 255, 0, 0, true)
        end
    else
        outputChatBox("No puedes enviar un mensaje vacío.", source, 255, 0, 0, true)
    end
end
addCommandHandler("an", deepweb)