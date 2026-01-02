function mensajePolicial(source, commandName, ...)
    local mensajeAnuncio = table.concat({...}, " ")
    if exports.factions:isPlayerInFaction(source, 53) then
        if mensajeAnuncio ~= "" and mensajeAnuncio ~= " " then
            for k, v in ipairs(getElementsByType("player")) do
                outputChatBox("#FFFFFF[ LEGAL ] #FFFFFFAnuncios [#101010Inter #FF7800Rapidisimo#FFFFFF] : #FFFFFF"..mensajeAnuncio, v, 255, 255, 255, true)
            end
        else
            outputChatBox("Tienes que ingresar un texto para el anuncio", source, 255, 0, 0, false)
        end
    else
        outputChatBox("No puedes usar esto si no perteneces a la empresa", source, 255, 0, 0, false)
    end
end
addCommandHandler("irc", mensajePolicial)