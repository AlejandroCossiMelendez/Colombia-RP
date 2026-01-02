function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 31) then
    setElementModel(player, 113)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de enclave abogados s.a.s", player, 255, 0, 0)
 end
end
addCommandHandler("abogado1", cambiarModelo)

function cambiarModelo2(player)
    if exports.factions:isPlayerInFaction(player, 31) then
    setElementModel(player, 187)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de enclave abogados s.a.s", player, 255, 0, 0)
 end
end
addCommandHandler("abogado2", cambiarModelo2)

function cambiarModelo3(player)
    if exports.factions:isPlayerInFaction(player, 31) then
    setElementModel(player, 295)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de enclave abogados s.a.s", player, 255, 0, 0)
 end
end
addCommandHandler("abogado3", cambiarModelo3)