function mensajePolicial(source, commandName, ...)
    local mensajeAnuncio = table.concat({...}, " ")
    if exports.factions:isPlayerInFaction(source, 13) then
        if mensajeAnuncio ~= "" and mensajeAnuncio ~= " " then
            for k, v in ipairs(getElementsByType("player")) do
                outputChatBox("#FF0000[ ILEGAL ] #FFFFFF[#0F0F0FCosa Nostra#FFFFFF] : #FFFFFF"..mensajeAnuncio, v, 255, 255, 255, true)
            end
        else
            outputChatBox("Tienes que ingresar un texto para el anuncio", source, 255, 0, 0, false)
        end
    else
        outputChatBox("No puedes usar esto si no perteneces a la mafia", source, 255, 0, 0, false)
    end
end
addCommandHandler("cst", mensajePolicial)