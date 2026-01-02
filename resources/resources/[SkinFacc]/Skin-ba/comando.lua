function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 39) then
    setElementModel(player, 14)
    outputChatBox("Te has puesto la ropa de banda", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de barrio antioquia", player, 255, 0, 0)
 end
end
addCommandHandler("ropaba", cambiarModelo)
