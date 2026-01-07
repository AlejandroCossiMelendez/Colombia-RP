-- Clean server main for Spawn Selector

function SetVisible(player, lastPosition, rotation, interior, dimension, skin)
  if not isElement(player) or getElementType(player) ~= "player" then return false end
  if type(lastPosition) ~= "table" then return false end
  if type(rotation) ~= "number" then return false end
  if type(interior) ~= "number" then return false end
  if type(dimension) ~= "number" then return false end
  if type(skin) ~= "number" then return false end
  -- Send visibility on client with default true and start index 1; client will add "Última posición" camera
  triggerClientEvent(player, "mrp_spawn->onSetVisible", resourceRoot, lastPosition, true, 1, interior, dimension)
  return true
end

addEvent("mrp_spawn->onRequestSpawn", true)
addEventHandler("mrp_spawn->onRequestSpawn", resourceRoot, function(position, rotation, skin, interior, dimension)
  if not isElement(client) or getElementType(client) ~= "player" then return end
  if type(position) ~= "table" then return end
  if type(rotation) ~= "number" then return end
  if type(skin) ~= "number" then return end
  if type(interior) ~= "number" then return end
  if type(dimension) ~= "number" then return end

  spawnPlayer(client, position[1], position[2], position[3], rotation, skin, interior, dimension)
  fadeCamera(client, true)
  setCameraTarget(client, client)
  setCameraInterior(client, interior)
  triggerClientEvent(client, "mrp_spawn->onSpawn", resourceRoot)
end)

addEventHandler("onResourceStart", resourceRoot, function()
  if getResourceName(getThisResource()) ~= "mrp_spawn" then
    outputDebugString("[Medellin] 'mrp_spawn' resource has been canceled. Please, rename the resource folder to 'mrp_spawn'.", 2)
    cancelEvent()
    return
  end
  outputDebugString("[Medellin] 'mrp_spawn' resource has started.")
  outputDebugString("[Medellin] This resource was made exclusively for Medellin Roleplay.")
  outputDebugString("[Medellin] Authors: ZeDD (.zeddito) & TRtam (unademuza)")
end)


