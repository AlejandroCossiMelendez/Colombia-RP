function mensajePolicial(source, commandName, ...)
    local mensajeAnuncio = table.concat({...}, " ")
    if exports.factions:isPlayerInFaction(source, 18) then
        if mensajeAnuncio ~= "" and mensajeAnuncio ~= " " then
            for k, v in ipairs(getElementsByType("player")) do
                outputChatBox("#FFFFFF[ LEGAL ] #FFFFFF[#00A6E5Noticias #00E51FRCN#FFFFFF]#FFFFFF: "..mensajeAnuncio, v, 255, 255, 255, true)
            end
        else
            outputChatBox("Tienes que ingresar un texto para el anuncio", source, 255, 0, 0, false)
        end
    else
        outputChatBox("No puedes usar esto si no perteneces a rcn", source, 255, 0, 0, false)
    end
end
addCommandHandler("rcn", mensajePolicial)