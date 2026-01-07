-- Decompiled by Owl Decompiler
-- Version App : 1.0
-- discord.gg/owwl

function crearMarkersGarajes()
  if not configPanelVehs["Posiciones Garajes"].poscionesGarajes or type(configPanelVehs["Posiciones Garajes"].poscionesGarajes) ~= "table" then
    outputDebugString("Error: La configuraci\195\179n 'Posiciones Garajes' no es v\195\161lida o no est\195\161 definida.", 1)
    return
  end
  for forvar3, forvar4 in ipairs(configPanelVehs["Posiciones Garajes"].poscionesGarajes) do
    table.insert(var0, (createMarker(unpack(forvar4))))
    setElementData(createMarker(unpack(forvar4)), "garajeMarker", true)
    addEventHandler("onMarkerHit", createMarker(unpack(forvar4)), function(arg0)
      if getElementType(arg0) == "player" then
        if exports.players:isLoggedIn(arg0) then
          triggerClientEvent(arg0, "abrirMenuGaraje", arg0)
        else
          outputChatBox("Inicia Sesi\195\179n Primero.", arg0, 255, 0, 0)
        end
      end
    end)
  end
  outputDebugString("[Garajes] Markers creados con \195\169xito.", 3)
end
function enviarDatosGaraje()
  if exports.players:getCharacterID(client) then
    if exports.sql:query_assoc("SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. exports.players:getCharacterID(client)) and #exports.sql:query_assoc("SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. exports.players:getCharacterID(client)) > 0 then
      for forvar4, forvar5 in ipairs((exports.sql:query_assoc("SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. exports.players:getCharacterID(client)))) do
        forvar5.inactivo = tonumber(forvar5.inactivo)
        if forvar5.inactivo == nil then
          forvar5.inactivo = 1
        elseif forvar5.inactivo == 0 and (not exports.vehicles:getVehicle(tonumber(forvar5.vehicleID)) or not isElement((exports.vehicles:getVehicle(tonumber(forvar5.vehicleID))))) then
          forvar5.inactivo = 1
          exports.sql:query_free("UPDATE vehicles SET inactivo = 1 WHERE vehicleID = " .. forvar5.vehicleID)
        end
        forvar5.fuel = tonumber(forvar5.fuel) or math.random(50, 100)
        forvar5.health = tonumber(forvar5.health) or math.random(70, 100)
      end
      outputDebugString("[Garajes] Enviando " .. #exports.sql:query_assoc("SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. exports.players:getCharacterID(client)) .. " veh\195\173culos al jugador " .. getPlayerName(client))
      triggerClientEvent(client, "onEnviarVehiculos", client, (exports.sql:query_assoc("SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. exports.players:getCharacterID(client))))
    else
      triggerClientEvent(client, "onEnviarVehiculos", client, {})
      outputChatBox("No tienes veh\195\173culos en tu garaje.", client, 255, 255, 0)
    end
  else
    outputChatBox("Error al obtener el ID del personaje, reporta de inmediato", client, 255, 0, 0)
  end
end
function sacarVehiculo(arg0, arg1)
  if isPedInVehicle(client) then
    geral.sNotify(client, "No puedes sacar un veh\195\173culo mientras est\195\161s dentro de otro.", "error")
    return
  end
  if not tonumber(arg1) then
    outputChatBox("ID inv\195\161lido.", client, 255, 0, 0)
    return
  end
  if exports.sql:query_assoc_single("SELECT cepo FROM vehicles WHERE vehicleID = " .. tostring(tonumber(arg1))) then
    if tonumber(exports.sql:query_assoc_single("SELECT cepo FROM vehicles WHERE vehicleID = " .. tostring(tonumber(arg1))).cepo) == 1 then
      geral.sNotify(client, "No puedes traer un veh\195\173culo que tiene cepo.", "info")
      return
    end
    if exports.players:takeMoney(client, configPanelVehs.General.costoSacarVeh) then
      if 0 < configPanelVehs.General.costoSacarVeh then
        geral.sNotify(client, "Has sacado el veh\195\173culo con ID " .. tostring(tonumber(arg1)) .. ". Se te ha cobrado $" .. configPanelVehs.General.costoSacarVeh .. ".", "success")
      else
        geral.sNotify(client, "Has sacado el veh\195\173culo con ID " .. tostring(tonumber(arg1)) .. ".", "success")
      end
      exports.sql:query_free("UPDATE vehicles SET inactivo = 0 WHERE vehicleID = " .. tonumber(arg1))
      exports.vehicles:reloadVehicle(tonumber(arg1))
      setTimer(function(arg0, arg1)
        if exports.vehicles:getVehicle(tonumber(arg0)) then
          setElementPosition(exports.vehicles:getVehicle(tonumber(arg0)), getElementPosition(arg1) + 4, getElementPosition(arg1) + 1, getElementPosition(arg1))
          setElementDimension(exports.vehicles:getVehicle(tonumber(arg0)), getElementDimension(arg1))
          setElementInterior(exports.vehicles:getVehicle(tonumber(arg0)), getElementInterior(arg1))
          setElementFrozen(exports.vehicles:getVehicle(tonumber(arg0)), false)
        else
          geral.sNotify(arg1, "Error al encontrar el veh\195\173culo despu\195\169s de recargar.", "error")
        end
      end, 1000, 1, arg1, client)
    else
      geral.sNotify(client, "No tienes suficiente dinero para sacar tu veh\195\173culo. Costo: $" .. configPanelVehs.General.costoSacarVeh, "error")
    end
  else
    geral.sNotify(client, "Veh\195\173culo eliminado o no encontrado, lo sentimos.", "error")
  end
end
function guardarVehiculo()
  if getPedOccupiedVehicle(source) then
    if exports.vehicles:getOwner(getPedOccupiedVehicle(source)) and exports.vehicles:getOwner(getPedOccupiedVehicle(source)) == exports.players:getCharacterID(source) then
      if getElementData(getPedOccupiedVehicle(source), "idveh") then
        exports.sql:query_free("UPDATE vehicles SET inactivo = 1, health = " .. getElementHealth(getPedOccupiedVehicle(source)) .. ", fuel = " .. (getElementData(getPedOccupiedVehicle(source), "fuel") or 100) .. " WHERE vehicleID = " .. getElementData(getPedOccupiedVehicle(source), "idveh"))
        destroyElement(getPedOccupiedVehicle(source))
        geral.sNotify(source, "Tu veh\195\173culo ha sido guardado correctamente.", "success")
        setTimer(function(arg0)
          if isElement(arg0) then
            enviarDatosGaraje()
          end
        end, 500, 1, source)
      else
        geral.sNotify(source, "No se encontr\195\179 el ID del veh\195\173culo.", "error")
      end
    else
      geral.sNotify(source, "No puedes guardar este veh\195\173culo porque no te pertenece.", "error")
    end
  else
    geral.sNotify(source, "No est\195\161s dentro de un veh\195\173culo para guardar.", "error")
  end
end
function guardarVehiculosSinConductor(arg0)
  if not hasObjectPermissionTo(arg0, "command.adminchat", false) then
    outputChatBox("((Acceso Denegado)).", arg0, 255, 0, 0)
    return
  end
  for forvar5, forvar6 in ipairs(getElementsByType("vehicle")) do
    if isElement(forvar6) and not getVehicleOccupant(forvar6) and getElementInterior(forvar6) == 0 and getElementDimension(forvar6) == 0 and getElementData(forvar6, "idveh") and getElementData(forvar6, "idowner") and 0 < tonumber(getElementData(forvar6, "idowner")) then
      exports.sql:query_free("UPDATE vehicles SET inactivo = 1, health = " .. getElementHealth(forvar6) .. ", fuel = " .. (getElementData(forvar6, "fuel") or 100) .. " WHERE vehicleID = " .. getElementData(forvar6, "idveh"))
      destroyElement(forvar6)
    end
  end
  if 0 < 0 + 1 then
    outputChatBox("Se han guardado " .. 0 + 1 .. " veh\195\173culos sin conductor y con due\195\177o en los garajes.", arg0, 0, 255, 0)
  else
    outputChatBox("No se encontraron veh\195\173culos sin conductor y con due\195\177o para guardar.", arg0, 255, 255, 0)
  end
end
addEventHandler("onResourceStart", resourceRoot, function()
  crearMarkersGarajes()
end)
addEvent("onSolicitarVehiculos", true)
addEventHandler("onSolicitarVehiculos", root, enviarDatosGaraje)
addEvent("onSacarVehiculo", true)
addEventHandler("onSacarVehiculo", root, function(arg0)
  sacarVehiculo(client, arg0)
end)
addEvent("onGuardarVehiculo", true)
addEventHandler("onGuardarVehiculo", root, guardarVehiculo)
addCommandHandler(configPanelVehs.General.comandoGuardar, guardarVehiculosSinConductor)
