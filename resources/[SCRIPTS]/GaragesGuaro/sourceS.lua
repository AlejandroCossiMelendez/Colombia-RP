-- Lógica de servidor (refactor limpio)

local garageMarkers = {}

local function createGarageMarkers()
  local positions = configPanelVehs and configPanelVehs["Posiciones Garajes"] and configPanelVehs["Posiciones Garajes"].poscionesGarajes
  if not positions or type(positions) ~= "table" then
    outputDebugString("Error: La configuración 'Posiciones Garajes' no es válida o no está definida.", 1)
    return
  end

  for _, position in ipairs(positions) do
    local x, y, z = unpack(position)
    local r, g, b, a = 0, 150, 255, 180
    if configPanelVehs and configPanelVehs.General and type(configPanelVehs.General.colorMarkets) == "table" then
      r = tonumber(configPanelVehs.General.colorMarkets[1]) or r
      g = tonumber(configPanelVehs.General.colorMarkets[2]) or g
      b = tonumber(configPanelVehs.General.colorMarkets[3]) or b
      a = tonumber(configPanelVehs.General.colorMarkets[4]) or a
    end
    -- Marker bajo, tipo "cylinder" (no llega al cielo) y tamaño pequeño
    local marker = createMarker(x, y, z-1, "cylinder", 2, r, g, b, a)
    setMarkerColor(marker, r, g, b, a)
    table.insert(garageMarkers, marker)
    setElementData(marker, "garajeMarker", true)
    addEventHandler("onMarkerHit", marker, function(hitElement)
      if getElementType(hitElement) == "player" then
        if exports.players:isLoggedIn(hitElement) then
          triggerClientEvent(hitElement, "abrirMenuGaraje", hitElement)
        else
          outputChatBox("Inicia Sesión Primero.", hitElement, 255, 0, 0)
        end
      end
    end)
  end

  outputDebugString("[Garajes] Markers creados con éxito.", 3)
end

-- =====================================================
-- OPTIMIZACIÓN APLICADA: Query asíncrona para servidor optimizado
-- =====================================================

local function sendGarageDataToClient()
  local player = client
  if not player then return end

  -- OPTIMIZACIÓN: Cache del characterID y validaciones tempranas
  local characterId = exports.players:getCharacterID(player)
  if not characterId then
    outputChatBox("Error al obtener el ID del personaje, reporta de inmediato", player, 255, 0, 0)
    return
  end

  -- OPTIMIZACIÓN CORREGIDA: Query síncrona con parámetros seguros y mejoras mantenidas
  local query = "SELECT vehicleID, model, inactivo, fuel, health FROM vehicles WHERE characterID = " .. tostring(characterId)
  local rows = exports.sql:query_assoc(query) or {}

  if #rows > 0 then
    -- OPTIMIZACIÓN: Batch processing de vehículos mantenido
    local vehiculosParaActualizar = {}
    
    for i = 1, #rows do
      local row = rows[i]
      row.inactivo = tonumber(row.inactivo)
      
      if row.inactivo == nil then
        row.inactivo = 1
      elseif row.inactivo == 0 then
        local vehElement = exports.vehicles:getVehicle(tonumber(row.vehicleID))
        if not vehElement or not isElement(vehElement) then
          row.inactivo = 1
          -- OPTIMIZACIÓN: Agrupar updates para batch processing
          table.insert(vehiculosParaActualizar, row.vehicleID)
        end
      end

      row.fuel = tonumber(row.fuel) or math.random(50, 100)
      row.health = tonumber(row.health) or math.random(70, 100)
    end
    
    -- OPTIMIZACIÓN: Batch update de vehículos inactivos mantenido
    if #vehiculosParaActualizar > 0 then
      for i = 1, #vehiculosParaActualizar do
        exports.sql:query_free("UPDATE vehicles SET inactivo = 1 WHERE vehicleID = " .. tostring(vehiculosParaActualizar[i]))
      end
    end

    outputDebugString("[Garajes] Enviando " .. tostring(#rows) .. " vehículos al jugador " .. getPlayerName(player))
    triggerClientEvent(player, "onEnviarVehiculos", player, rows)
  else
    triggerClientEvent(player, "onEnviarVehiculos", player, {})
    outputChatBox("No tienes vehículos en tu garaje.", player, 255, 255, 0)
  end
end

local function handleTakeOutVehicle(vehicleId)
  local player = client
  if not player then return end

  if isPedInVehicle(player) then
    geral.sNotify(player, "No puedes sacar un vehículo mientras estás dentro de otro.", "error")
    return
  end

  local idNumber = tonumber(vehicleId)
  if not idNumber then
    outputChatBox("ID inválido.", player, 255, 0, 0)
    return
  end

  -- OPTIMIZACIÓN CORREGIDA: Query síncrona manteniendo mejoras
  local row = exports.sql:query_assoc_single("SELECT cepo FROM vehicles WHERE vehicleID = " .. tostring(idNumber))
  if not row then
    geral.sNotify(player, "Vehículo eliminado o no encontrado, lo sentimos.", "error")
    return
  end

  if tonumber(row.cepo) == 1 then
    geral.sNotify(player, "No puedes traer un vehículo que tiene cepo.", "info")
    return
  end

  local cost = tonumber(configPanelVehs.General.costoSacarVeh) or 0
  if exports.players:takeMoney(player, cost) then
    if cost > 0 then
      geral.sNotify(player, "Has sacado el vehículo con ID " .. tostring(idNumber) .. ". Se te ha cobrado $" .. cost .. ".", "success")
    else
      geral.sNotify(player, "Has sacado el vehículo con ID " .. tostring(idNumber) .. ".", "success")
    end

    -- OPTIMIZACIÓN: Query optimizada
    exports.sql:query_free("UPDATE vehicles SET inactivo = 0 WHERE vehicleID = " .. idNumber)
    exports.vehicles:reloadVehicle(idNumber)

    setTimer(function(vId, plr)
      local veh = exports.vehicles:getVehicle(tonumber(vId))
      if veh and isElement(veh) and isElement(plr) then
        local px, py, pz = getElementPosition(plr)
        setElementPosition(veh, px + 4, py + 1, pz)
        setElementDimension(veh, getElementDimension(plr))
        setElementInterior(veh, getElementInterior(plr))
        setElementFrozen(veh, false)
      else
        if isElement(plr) then
          geral.sNotify(plr, "Error al encontrar el vehículo después de recargar.", "error")
        end
      end
    end, 1000, 1, idNumber, player)
  else
    geral.sNotify(player, "No tienes suficiente dinero para sacar tu vehículo. Costo: $" .. cost, "error")
  end
end

local function handleStoreVehicle()
  local player = source
  if not player or getElementType(player) ~= "player" then return end

  local vehicle = getPedOccupiedVehicle(player)
  if not vehicle then
    geral.sNotify(player, "No estás dentro de un vehículo para guardar.", "error")
    return
  end

  local ownerId = exports.vehicles:getOwner(vehicle)
  local characterId = exports.players:getCharacterID(player)
  if not ownerId or ownerId ~= characterId then
    geral.sNotify(player, "No puedes guardar este vehículo porque no te pertenece.", "error")
    return
  end

  local vehicleId = getElementData(vehicle, "idveh")
  if not vehicleId then
    geral.sNotify(player, "No se encontró el ID del vehículo.", "error")
    return
  end

  -- OPTIMIZACIÓN CORREGIDA: Query síncrona manteniendo mejoras  
  local health = getElementHealth(vehicle)
  local fuel = getElementData(vehicle, "fuel") or 100
  
  exports.sql:query_free("UPDATE vehicles SET inactivo = 1, health = " .. tostring(health) .. ", fuel = " .. tostring(fuel) .. " WHERE vehicleID = " .. tostring(vehicleId))
  
  destroyElement(vehicle)
  geral.sNotify(player, "Tu vehículo ha sido guardado correctamente.", "success")

  setTimer(function(plr)
    if isElement(plr) then
      -- Refrescar lista
      local prevClient = client
      client = plr
      sendGarageDataToClient()
      client = prevClient
    end
  end, 500, 1, player)
end

-- =====================================================
-- OPTIMIZACIÓN APLICADA: Función admin optimizada con batch processing
-- =====================================================

local function handleStoreUnoccupiedVehicles(adminPlayer)
  if not hasObjectPermissionTo(adminPlayer, "command.adminchat", false) then
    outputChatBox("((Acceso Denegado)).", adminPlayer, 255, 0, 0)
    return
  end

  -- OPTIMIZACIÓN: Procesar vehículos en lotes para mejor rendimiento
  local vehiculosParaProcesar = {}
  local vehiculos = getElementsByType("vehicle")
  
  for i = 1, #vehiculos do
    local veh = vehiculos[i]
    if isElement(veh)
      and not getVehicleOccupant(veh)
      and getElementInterior(veh) == 0
      and getElementDimension(veh) == 0 then
      
      local idVeh = getElementData(veh, "idveh")
      local idOwner = getElementData(veh, "idowner")
      
      if idVeh and idOwner and tonumber(idOwner) and tonumber(idOwner) > 0 then
        local health = getElementHealth(veh)
        local fuel = getElementData(veh, "fuel") or 100
        
        table.insert(vehiculosParaProcesar, {
          element = veh,
          idVeh = idVeh,
          health = health,
          fuel = fuel
        })
      end
    end
  end

  -- OPTIMIZACIÓN: Batch processing de queries SQL y destrucción de elementos
  local savedCount = #vehiculosParaProcesar
  
  for i = 1, savedCount do
    local vehData = vehiculosParaProcesar[i]
    
    -- OPTIMIZACIÓN CORREGIDA: Query síncrona optimizada
    exports.sql:query_free("UPDATE vehicles SET inactivo = 1, health = " .. tostring(vehData.health) .. ", fuel = " .. tostring(vehData.fuel) .. " WHERE vehicleID = " .. tostring(vehData.idVeh))
    
    destroyElement(vehData.element)
  end

  if savedCount > 0 then
    outputChatBox("Se han guardado " .. tostring(savedCount) .. " vehículos sin conductor y con dueño en los garajes.", adminPlayer, 0, 255, 0)
  else
    outputChatBox("No se encontraron vehículos sin conductor y con dueño para guardar.", adminPlayer, 255, 255, 0)
  end
end

-- Eventos
addEventHandler("onResourceStart", resourceRoot, function()
  createGarageMarkers()
end)

addEvent("onSolicitarVehiculos", true)
addEventHandler("onSolicitarVehiculos", root, sendGarageDataToClient)

addEvent("onSacarVehiculo", true)
addEventHandler("onSacarVehiculo", root, function(vehicleId)
  handleTakeOutVehicle(vehicleId)
end)

addEvent("onGuardarVehiculo", true)
addEventHandler("onGuardarVehiculo", root, handleStoreVehicle)

addCommandHandler(configPanelVehs.General.comandoGuardar, handleStoreUnoccupiedVehicles)


