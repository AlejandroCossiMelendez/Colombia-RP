function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 7) then
    setElementModel(player, 248)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de Mercado Libre", player, 255, 0, 0)
 end
end
addCommandHandler("ropaml", cambiarModelo)
