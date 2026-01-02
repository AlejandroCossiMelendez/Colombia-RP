function mensajePolicial(source, commandName, ...)
    local mensajeAnuncio = table.concat({...}, " ")
    if exports.factions:isPlayerInFaction(source, 46) then
        if mensajeAnuncio ~= "" and mensajeAnuncio ~= " " then
            for k, v in ipairs(getElementsByType("player")) do
                outputChatBox("#FF0000[ ILEGAL ] #FFFFFF[#FFB900Tren De Aragua#FFFFFF] : #FFFFFF"..mensajeAnuncio, v, 255, 255, 255, true)
            end
        else
            outputChatBox("Tienes que ingresar un texto para el anuncio", source, 255, 0, 0, false)
        end
    else
        outputChatBox("No puedes usar esto si no perteneces a la organizacion", source, 255, 0, 0, false)
    end
end
addCommandHandler("tda", mensajePolicial)