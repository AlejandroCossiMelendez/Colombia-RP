function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 32) then
    setElementModel(player, 200)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de the bloods", player, 255, 0, 0)
 end
end
addCommandHandler("rtbls", cambiarModelo)
