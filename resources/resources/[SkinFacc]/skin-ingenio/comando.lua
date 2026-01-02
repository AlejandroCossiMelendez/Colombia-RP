function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 54) then
    setElementModel(player, 277)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de la empresa", player, 255, 0, 0)
 end
end
addCommandHandler("rings", cambiarModelo)
