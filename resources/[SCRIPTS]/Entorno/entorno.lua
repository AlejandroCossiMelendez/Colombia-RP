function Entorno(source, cmd, ...) 
    local mensaje = table.concat({...}, " ")
    
    if mensaje ~= "" and mensaje:gsub("%s+", "") ~= "" then
        if exports.players:isLoggedIn(source) then
            local nombre = getPlayerName(source)
            
            if nombre then
                for _, v in ipairs(getElementsByType("player")) do
                    if v then
                        if hasObjectPermissionTo(v, "command.goto", false) then
                            outputChatBox("#FFD700[#FFA500 VISTA STAFF ENTORNO#FFD700] ["..nombre.."]: " .. mensaje, v, 255, 255, 255, true)
                        else
                            outputChatBox("#FFD700[#FFA500 ENTORNO#FFD700]: " .. mensaje .. ".", v, 255, 255, 255, true)
                        end
                    end
                end
            end
        else
            outputChatBox("#FFD700Debes iniciar sesión para poder enviar un mensaje de entorno.", source, 255, 0, 0, true)
        end
    else
        outputChatBox("#FFD700No puedes enviar un mensaje vacío.", source, 255, 0, 0, true)
    end
end
addCommandHandler("entorno", Entorno)
