function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 25) then
    setElementModel(player, 38)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de terpel", player, 255, 0, 0)
 end
end
addCommandHandler("ropatpl", cambiarModelo)
