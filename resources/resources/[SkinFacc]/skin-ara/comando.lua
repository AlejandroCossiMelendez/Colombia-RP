function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 49) then
    setElementModel(player, 173)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de Ara", player, 255, 0, 0)
 end
end
addCommandHandler("ropaara", cambiarModelo)
