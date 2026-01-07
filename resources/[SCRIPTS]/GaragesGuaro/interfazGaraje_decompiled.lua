-- Decompiled by Owl Decompiler
-- Version App : 1.0
-- discord.gg/owwl

function getResourceImagePath(arg0)
  return ":" .. getResourceName(getThisResource()) .. "/" .. arg0
end
function unloadFonts()
  for forvar3, forvar4 in pairs(var0) do
    if forvar4 and isElement(forvar4) then
      destroyElement(forvar4)
    end
  end
  var0 = {
    figmaFonts = {}
  }
end
function getFigmaFont(arg0, arg1)
  if not var0.figmaFonts[arg0 .. arg1] then
    var0.figmaFonts[arg0 .. arg1] = dxCreateFont("fonts/" .. arg0 .. ".ttf", arg1, false, "cleartype")
  end
  return var0.figmaFonts[arg0 .. arg1]
end
function renderUI()
  if not var0 then
    return
  end
  dxDrawImage(var1 / 2 - 500, var2 / 2 - 300, 1000, 600, "data/bgprincipal.png")
  dxDrawImage(var1 / 2 - 460, var2 / 2 - 157, 920, 365, "data/con-listavehiculos.png")
  dxDrawImage(var1 / 2 - 500, var2 / 2 - 300, 1000, 70, "data/cabecera.png")
  dxDrawImage(var1 / 2 - 248, var2 / 2 - 298, 65, 65, "data/icongarage2.png")
  dxDrawImage(var1 / 2 + 182, var2 / 2 - 298, 65, 65, "data/icongarage.png")
  dxDrawText("GARAGE PERSONAL", var1 / 2, var2 / 2 - 265.5, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Orbitron-Bold", 16), "center", "center")
  dxDrawText("ID VEHICULO", var1 / 2 - 351, var2 / 2 - 180, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-Medium", 16), "center", "center")
  dxDrawText("MODELO", var1 / 2 - 121, var2 / 2 - 180, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-Medium", 16), "center", "center")
  dxDrawText("GASOLINA", var1 / 2 + 118, var2 / 2 - 180, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-Medium", 16), "center", "center")
  dxDrawText("ESTADO", var1 / 2 + 357, var2 / 2 - 180, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-Medium", 16), "center", "center")
  if not isCursorOverRectangle(var1 / 2 - 340, var2 / 2 + 231, 271, 45) or not tocolor(255, 255, 255, 255) then
  end
  dxDrawImage(var1 / 2 - 340, var2 / 2 + 231, 271, 45, "data/botonsacarvehiculos.png", 0, 0, 0, (tocolor(200, 200, 200, 255)))
  if not isCursorOverRectangle(var1 / 2 + 62, var2 / 2 + 231, 271, 45) or not tocolor(255, 255, 255, 255) then
  end
  dxDrawImage(var1 / 2 + 62, var2 / 2 + 231, 271, 45, "data/botonguardarvehiculos.png", 0, 0, 0, (tocolor(200, 200, 200, 255)))
  dxDrawText("SACAR VEHICULO", var1 / 2 - 204, var2 / 2 + 254, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-SemiBold", 16), "center", "center")
  dxDrawText("GUARDAR VEHICULO", var1 / 2 + 200.5, var2 / 2 + 254, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont("Poppins-SemiBold", 16), "center", "center")
  var3 = math.max(0, (#var4 - 6) * 60)
  if #var4 > 6 then
    dxDrawRectangle(var1 / 2 - 440 + 880 - 8 - 5, var2 / 2 - 120, 8, 320, tocolor(30, 30, 35, 150))
    dxDrawRectangle(var1 / 2 - 440 + 880 - 8 - 5, var2 / 2 - 120 + var5 / var3 * (320 - math.max(30, 320 * (6 / #var4))), 8, math.max(30, 320 * (6 / #var4)), tocolor(80, 80, 85, 200))
  end
  dxSetRenderTarget()
  dxSetBlendMode("add")
  dxSetBlendMode("blend")
  for forvar17 = math.floor(var5 / 60) + 1, math.min(math.floor(var5 / 60) + 1 + 6, #var4) do
    if var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 >= var2 / 2 - 120 - 60 and var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 <= var2 / 2 - 120 + 320 then
      if (not (var6 == forvar17) or not tocolor(255, 255, 255, 255)) and (not isCursorOverRectangle(var1 / 2 - 440, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60, 880 - 8 - 10, 60) or not tocolor(255, 255, 255, 230)) then
      end
      dxDrawImage(var1 / 2 - 440, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60, 880 - 8 - 10, 60, "data/tarjetasvehiculos.png", 0, 0, 0, (tocolor(255, 255, 255, 200)))
      if not (var6 == forvar17) or not tocolor(255, 255, 255, 255) then
      end
      dxDrawText(var4[forvar17].vehicleID, var1 / 2 - 440 + 90, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 + 60 / 2, nil, nil, tocolor(240, 240, 240, 255), 1, getFigmaFont("Poppins-Medium", 14), "center", "center")
      if not (var6 == forvar17) or not tocolor(255, 255, 255, 255) then
      end
      dxDrawText(getVehicleNameFromModel(var4[forvar17].model), var1 / 2 - 440 + 320, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 + 60 / 2, nil, nil, tocolor(240, 240, 240, 255), 1, getFigmaFont("Poppins-Medium", 14), "center", "center")
      if var4[forvar17].inactivo ~= 1 or not {
        0,
        255,
        0
      } then
      end
      dxDrawText((var4[forvar17].fuel or math.random(10, 100)) .. "%", var1 / 2 - 440 + 550, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 + 60 / 2, nil, nil, colorGradient(var4[forvar17].fuel or math.random(10, 100), 0, 100, {
        255,
        0,
        0
      }, {
        0,
        255,
        0
      }), 1, getFigmaFont("Poppins-Medium", 14), "center", "center")
      dxDrawText(var4[forvar17].inactivo == 1 and "GUARDADO" or "FUERA DE GARAGE", var1 / 2 - 440 + 775, var2 / 2 - 120 + (forvar17 - (math.floor(var5 / 60) + 1)) * 60 - var5 % 60 + 60 / 2, nil, nil, tocolor(({
        255,
        165,
        0
      })[1], ({
        255,
        165,
        0
      })[2], ({
        255,
        165,
        0
      })[3], 255), 1, getFigmaFont("Poppins-Medium", 14), "center", "center")
    end
  end
  dxSetBlendMode("blend")
  if #var4 > 6 then
    if var5 > 0 then
      dxDrawText("\226\150\178", var1 / 2 - 440 + 880 - 8 - 5 + 8 / 2, var2 / 2 - 120 - 15, nil, nil, tocolor(255, 255, 255, 200), 1, getFigmaFont("Poppins-Medium", 10), "center", "center")
    end
    if var5 < var3 then
      dxDrawText("\226\150\188", var1 / 2 - 440 + 880 - 8 - 5 + 8 / 2, var2 / 2 - 120 + 320 + 5, nil, nil, tocolor(255, 255, 255, 200), 1, getFigmaFont("Poppins-Medium", 10), "center", "center")
    end
  end
end
function handleScroll(arg0, arg1)
  if not var0 then
    return
  end
  if isCursorOverRectangle(var1 / 2 - 440, var2 / 2 - 120, 880, 320) then
    if arg0 == "mouse_wheel_up" then
      var3 = math.max(0, var3 - 20)
    elseif arg0 == "mouse_wheel_down" then
      var3 = math.min(var4, var3 + 20)
    end
  end
end
function colorGradient(arg0, arg1, arg2, arg3, arg4)
  if (arg0 - arg1) / (arg2 - arg1) < 0 then
  else
  end
  return tocolor(math.floor(arg3[1] + (arg4[1] - arg3[1]) * 1), math.floor(arg3[2] + (arg4[2] - arg3[2]) * 1), math.floor(arg3[3] + (arg4[3] - arg3[3]) * 1), 255)
end
function isCursorOverRectangle(arg0, arg1, arg2, arg3)
  if not isCursorShowing() then
    return false
  end
  return arg0 <= getCursorPosition() * var0 and getCursorPosition() * var0 <= arg0 + arg2 and arg1 <= getCursorPosition() * var1 and getCursorPosition() * var1 <= arg1 + arg3
end
function handleClick(arg0, arg1)
  if not var0 or arg0 ~= "left" or arg1 ~= "down" then
    return
  end
  if isCursorOverRectangle(var1 / 2 + 430, var2 / 2 - 290, 30, 30) then
    cerrarPanelGaraje()
    return
  end
  if isCursorOverRectangle(var1 / 2 - 340, var2 / 2 + 231, 271, 45) then
    sacarVehiculo()
    return
  end
  if isCursorOverRectangle(var1 / 2 + 62, var2 / 2 + 231, 271, 45) then
    triggerServerEvent("onGuardarVehiculo", localPlayer)
    return
  end
  for forvar11 = math.floor(var3 / 60) + 1, math.min(math.floor(var3 / 60) + 1 + 6, #var4) do
    if isCursorOverRectangle(var1 / 2 - 440, var2 / 2 - 120 + (forvar11 - (math.floor(var3 / 60) + 1)) * 60 - var3 % 60, 867, 60) then
      var5 = forvar11
      return
    end
  end
  if #var4 > 6 and isCursorOverRectangle(var1 / 2 - 440 + 867 + 5, var2 / 2 - 120, 8, 320) then
    var3 = math.max(0, math.min(var6, (getCursorPosition() * var2 - (var2 / 2 - 120)) / (320 - math.max(30, 320 * (6 / #var4))) * var6))
  end
end
function abrirPanelGaraje(arg0)
  var0 = arg0 or {}
  var1 = nil
  var2 = true
  var3 = 0
  if #var0 > 0 then
    outputDebugString("Recibidos " .. #var0 .. " veh\195\173culos del servidor")
    for forvar4, forvar5 in ipairs(var0) do
      outputDebugString("Veh\195\173culo ID: " .. forvar5.vehicleID .. ", Estado inactivo: " .. (forvar5.inactivo or "N/A"))
    end
  end
  showCursor(true)
  addEventHandler("onClientRender", root, renderUI)
  addEventHandler("onClientClick", root, handleClick)
  addEventHandler("onClientKey", root, manejarTeclas)
  addEventHandler("onClientKey", root, handleScroll)
  if fileExists("data/garage_open.mp3") then
    playSound("data/garage_open.mp3", false)
  end
end
function cerrarPanelGaraje()
  var0 = false
  showCursor(false)
  removeEventHandler("onClientRender", root, renderUI)
  removeEventHandler("onClientClick", root, handleClick)
  removeEventHandler("onClientKey", root, manejarTeclas)
  removeEventHandler("onClientKey", root, handleScroll)
  if fileExists("data/garage_close.mp3") then
    playSound("data/garage_close.mp3", false)
  end
end
function sacarVehiculo()
  if not var0 or not var1[var0] then
    outputChatBox("Selecciona un veh\195\173culo de la lista.", 255, 0, 0)
    return
  end
  if var1[var0].vehicleID then
    triggerServerEvent("onSacarVehiculo", localPlayer, var1[var0].vehicleID)
    cerrarPanelGaraje()
  else
    outputChatBox("Error al obtener el ID del veh\195\173culo seleccionado.", 255, 0, 0)
  end
end
function manejarTeclas(arg0, arg1)
  if not var0 or not arg1 then
    return
  end
  if arg0 == "enter" then
    sacarVehiculo()
  elseif arg0 == "backspace" or arg0 == "escape" then
    cerrarPanelGaraje()
  elseif arg0 == "arrow_u" then
    if var1 and var1 > 1 then
      var1 = var1 - 1
      if math.floor(var2 / 60) + 1 > var1 then
        var2 = (var1 - 1) * 60
      end
    end
  elseif arg0 == "arrow_d" then
    if var1 and var1 < #var3 then
      var1 = var1 + 1
      if var1 >= math.floor(var2 / 60) + 1 + 6 then
        var2 = (var1 - 6) * 60
      end
    elseif not var1 and #var3 > 0 then
      var1 = 1
    end
  end
end
addEventHandler("onClientRender", root, function()
  var0 = (var0 + 2) % 360
  for forvar3, forvar4 in ipairs(getElementsByType("marker")) do
    if getElementData(forvar4, "garajeMarker") and getDistanceBetweenPoints3D(getCameraMatrix()) <= configPanelVehs["Configurar Imagen Markets"].maxRenderDistance and getScreenFromWorldPosition(getElementPosition(forvar4)) and getScreenFromWorldPosition(getElementPosition(forvar4)) then
      dxDrawImage(getScreenFromWorldPosition(getElementPosition(forvar4)) - math.min(configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * (1 / (getDistanceBetweenPoints3D(getCameraMatrix()) * 0.15)), configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * 2) / 2, getScreenFromWorldPosition(getElementPosition(forvar4)) - math.min(configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * (1 / (getDistanceBetweenPoints3D(getCameraMatrix()) * 0.15)), configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * 2) / 2 + math.sin(math.rad(var0)) * (math.min(configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * (1 / (getDistanceBetweenPoints3D(getCameraMatrix()) * 0.15)), configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * 2) * 0.1), math.min(configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * (1 / (getDistanceBetweenPoints3D(getCameraMatrix()) * 0.15)), configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * 2), math.min(configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * (1 / (getDistanceBetweenPoints3D(getCameraMatrix()) * 0.15)), configPanelVehs["Configurar Imagen Markets"].fixedSize * 0.9 * 2), "Imagenes/garaje.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    end
  end
end)
addEventHandler("onClientResourceStart", resourceRoot, function()
end)
addEvent("onEnviarVehiculos", true)
addEventHandler("onEnviarVehiculos", root, abrirPanelGaraje)
addEvent("abrirMenuGaraje", true)
addEventHandler("abrirMenuGaraje", root, function()
  triggerServerEvent("onSolicitarVehiculos", localPlayer)
end)
