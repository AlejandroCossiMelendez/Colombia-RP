function cambiarModelo(player)
    if exports.factions:isPlayerInFaction(player, 3) then
    setElementModel(player, 309)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de mecanicos", player, 255, 0, 0)
 end
end
addCommandHandler("rmc1", cambiarModelo)

function cambiarModelo2(player)
    if exports.factions:isPlayerInFaction(player, 3) then
    setElementModel(player, 50)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de mecanicos", player, 255, 0, 0)
 end
end
addCommandHandler("rmc2", cambiarModelo2)

function cambiarModelo3(player)
    if exports.factions:isPlayerInFaction(player, 36) then
    setElementModel(player, 305)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de mecanicos", player, 255, 0, 0)
 end
end
addCommandHandler("rmocho", cambiarModelo3)

function cambiarModelo4(player)
    if exports.factions:isPlayerInFaction(player, 3) then
    setElementModel(player, 69)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de mecanicos", player, 255, 0, 0)
 end
end
addCommandHandler("rmc3", cambiarModelo4)

function cambiarModelo5(player)
    if exports.factions:isPlayerInFaction(player, 3) then
    setElementModel(player, 298)
    outputChatBox("Te has puesto el uniforme de trabajo", player, 0, 255, 0) 
      else
        outputChatBox("No formas parte de mecanicos", player, 255, 0, 0)
 end
end
addCommandHandler("rmc4", cambiarModelo5)