-- Interfaz de Garaje (refactor limpio)

-- Estado de UI y fuentes
local uiState = {
  isOpen = false,
  vehicles = {},
  selectedIndex = nil,
  scrollOffsetPx = 0,
}

local fontsCache = {}
local listRenderTarget = nil
local listRTWidth, listRTHeight = 0, 0

local function getFigmaFont(fontName, fontSize)
  local cacheKey = tostring(fontName) .. "-" .. tostring(fontSize)
  if not fontsCache[cacheKey] then
    fontsCache[cacheKey] = dxCreateFont("fonts/" .. fontName .. ".ttf", fontSize, false, "cleartype")
  end
  return fontsCache[cacheKey]
end

-- Compatibilidad: alias
local function getFont(fontName, fontSize)
  return getFigmaFont(fontName, fontSize)
end

local function clamp(value, minValue, maxValue)
  if value < minValue then return minValue end
  if value > maxValue then return maxValue end
  return value
end

local function colorLerpByValue(value, minValue, maxValue, colorStart, colorEnd)
  if maxValue == minValue then
    return tocolor(colorEnd[1], colorEnd[2], colorEnd[3], 255)
  end
  local t = (value - minValue) / (maxValue - minValue)
  t = clamp(t, 0, 1)
  local r = math.floor(colorStart[1] + (colorEnd[1] - colorStart[1]) * t)
  local g = math.floor(colorStart[2] + (colorEnd[2] - colorStart[2]) * t)
  local b = math.floor(colorStart[3] + (colorEnd[3] - colorStart[3]) * t)
  return tocolor(r, g, b, 255)
end

local function isCursorInRect(x, y, width, height)
  if not isCursorShowing() then
    return false
  end
  local cursorXNorm, cursorYNorm = getCursorPosition()
  if not cursorXNorm or not cursorYNorm then
    return false
  end
  local screenW, screenH = guiGetScreenSize()
  local cursorX = cursorXNorm * screenW
  local cursorY = cursorYNorm * screenH
  return (x <= cursorX and cursorX <= x + width and y <= cursorY and cursorY <= y + height)
end

-- Zoom de UI similar al export de Figma
local function getUiZoom()
  local screenW = guiGetScreenSize()
  local sx = screenW
  local zoom = 1
  if type(sx) == "table" then
    sx = screenW[1]
  end
  sx = sx or select(1, guiGetScreenSize())
  if sx and sx < 2048 then
    zoom = math.min(2.2, 2048 / sx)
  end
  return zoom
end

-- Métricas consistentes para la lista dentro de BGINTERNO
local function getListMetrics(z)
  local screenW, screenH = guiGetScreenSize()
  local innerX, innerY, innerW, innerH = screenW/2 - 375*z, screenH/2 - 109*z, 750*z, 280*z
  local listX = screenW / 2 - 350*z
  local listY = screenH / 2 - 91*z
  local listW = 700*z
  local listBottomPadding = 20*z
  local listH = (innerY + innerH) - listY - listBottomPadding
  local rowHeight = 50*z
  local rowSpacing = 10*z
  local rowFullH = rowHeight + rowSpacing
  local barW = 10*z
  return {
    listX = listX,
    listY = listY,
    listW = listW,
    listH = listH,
    rowHeight = rowHeight,
    rowSpacing = rowSpacing,
    rowFullH = rowFullH,
    barW = barW,
  }
end

-- Dibujo del panel principal
local function renderGaragePanel()
  if not uiState.isOpen then
    return
  end

  local screenW, screenH = guiGetScreenSize()
  local z = getUiZoom()

  -- Layout Figma (nuevadata) con zoom
  dxDrawImage(screenW/2 - 400*z, screenH/2 - 250*z, 800*z, 500*z, "nuevadata/BGEXTERNO.png")
  dxDrawImage(screenW/2 - 375*z, screenH/2 - 109*z, 750*z, 280*z, "nuevadata/BGINTERNO.png")
  dxDrawImage(screenW/2 - 400*z, screenH/2 - 250*z, 800*z, 70*z,  "nuevadata/Header.png")
  dxDrawImage(screenW/2 - 400*z, screenH/2 - 170*z, 800*z, 60*z,  "nuevadata/Encabezado.png")
  dxDrawImage(screenW/2 - 400*z, screenH/2 - 122*z, 800*z, 3*z,   "nuevadata/LineaInferiorEncabezado.png")
  dxDrawImage(screenW/2 - 300*z, screenH/2 + 182*z, 200*z, 50*z,  "nuevadata/BotonSacarVehiculo.png")
  dxDrawImage(screenW/2 +  100*z, screenH/2 + 182*z, 200*z, 50*z,  "nuevadata/BotonGuardarVehiculo.png")
  dxDrawImage(screenW/2 - 204*z, screenH/2 - 241*z, 42*z,  42*z,  "nuevadata/ICONOGARAGE2.png")
  dxDrawImage(screenW/2 + 162*z, screenH/2 - 241*z, 42*z,  42*z,  "nuevadata/ICONOGARAGE1.png")

  -- Títulos y cabeceras (tipografías escaladas)
  dxDrawText('GARAGE PERSONAL', screenW/2,         screenH/2 - 220*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-Bold', math.floor(18.666*z)), 'center', 'center')
  dxDrawText('ID VEHICULO',     screenW/2 - 300*z, screenH/2 - 147*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-Bold', math.floor(10.666*z)), 'center', 'center')
  dxDrawText('MODELO',          screenW/2 - 100*z, screenH/2 - 147*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-Bold', math.floor(10.666*z)), 'center', 'center')
  dxDrawText('GASOLINA',        screenW/2 + 100*z, screenH/2 - 147*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-Bold', math.floor(10.666*z)), 'center', 'center')
  dxDrawText('ESTADO',          screenW/2 + 300*z, screenH/2 - 145*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-Bold', math.floor(10.666*z)), 'center', 'center')
  dxDrawText('SACAR VEHICULO',  screenW/2 - 200*z, screenH/2 + 207*z, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', math.floor(10.666*z)), 'center', 'center')
  dxDrawText('GUARDAR VEHICULO',screenW/2 + 200*z, screenH/2 + 207*z, nil, nil, tocolor(24, 24, 24, 255),    1, getFigmaFont('Poppins-SemiBold',  math.floor(10.666*z)), 'center', 'center')

  -- Área de lista dentro de BGINTERNO: múltiples filas apiladas con scroll
  local m = getListMetrics(z)
  local pillPaddingX, pillPaddingY = 14*z, 7*z
  local totalRows = #uiState.vehicles
  local contentH = math.max(0, (totalRows > 0) and (totalRows * m.rowFullH - m.rowSpacing) or 0)
  local visibleRows = math.max(1, math.floor((m.listH + m.rowSpacing) / m.rowFullH))
  local maxScrollPx = math.max(0, contentH - m.listH)
  uiState.scrollOffsetPx = clamp(uiState.scrollOffsetPx, 0, maxScrollPx)

  -- Scroll bar
  local showScrollbar = totalRows > visibleRows
  local contentW = m.listW
  local barX, barY, barW, barH
  if showScrollbar then
    barW = m.barW
    barX = m.listX + m.listW - barW
    barY = m.listY
    barH = m.listH
    dxDrawRectangle(barX, barY, barW, barH, tocolor(30, 30, 35, 150))
    local thumbH = math.max(30*z, (barH * m.listH) / math.max(m.listH, contentH))
    local thumbY = barY + ((maxScrollPx == 0) and 0 or (uiState.scrollOffsetPx / maxScrollPx) * (barH - thumbH))
    dxDrawRectangle(barX, thumbY, barW, thumbH, tocolor(100, 100, 120, 220))
    contentW = contentW - (barW + 6*z)
  end

  -- Render Target para clippear filas al área visible
  local rtW = math.floor(contentW)
  local rtH = math.floor(m.listH)
  if rtW ~= listRTWidth or rtH ~= listRTHeight or not isElement(listRenderTarget) then
    if isElement(listRenderTarget) then destroyElement(listRenderTarget) end
    listRenderTarget = dxCreateRenderTarget(rtW, rtH, true)
    listRTWidth, listRTHeight = rtW, rtH
  end

  if isElement(listRenderTarget) then
    dxSetRenderTarget(listRenderTarget, true)

    -- Ítems visibles dentro del RT (coordenadas relativas)
    local firstIndex = math.floor(uiState.scrollOffsetPx / m.rowFullH) + 1
    local lastIndex = math.min(firstIndex + visibleRows + 1, totalRows) -- +1 por seguridad de corte
    for index = firstIndex, lastIndex do
      local localRow = index - firstIndex
      local rowYAbs = m.listY + localRow * m.rowFullH - (uiState.scrollOffsetPx % m.rowFullH)
      local rowY = rowYAbs - m.listY
      if rowY >= -m.rowHeight and rowY <= m.listH then
        dxDrawImage(0, rowY, contentW, m.rowHeight, "nuevadata/FilaHorizonInformacion.png")

        local overlayX = pillPaddingX
        local overlayY = rowY + pillPaddingY
        if uiState.selectedIndex == index then
          dxDrawRectangle(overlayX, overlayY, contentW - 2*pillPaddingX, m.rowHeight - 2*pillPaddingY, tocolor(255, 255, 255, 25))
        elseif isCursorInRect(m.listX + pillPaddingX, rowYAbs + pillPaddingY, contentW - 2*pillPaddingX, m.rowHeight - 2*pillPaddingY) then
          dxDrawRectangle(overlayX, overlayY, contentW - 2*pillPaddingX, m.rowHeight - 2*pillPaddingY, tocolor(255, 255, 255, 15))
        end

        local vehicle = uiState.vehicles[index]
        local marginX = 16*z
        local leftX = 0
        local rightX = contentW
        local idX1      = leftX + marginX
        local idX2      = leftX + contentW * 0.22
        local modelX1   = idX2 + marginX
        local modelX2   = leftX + contentW * 0.56
        local fuelX1    = modelX2 + marginX
        local fuelX2    = leftX + contentW * 0.72
        local statusX1  = fuelX2 + marginX
        local statusX2  = rightX - marginX

        dxDrawText(tostring(vehicle.vehicleID or "-"), idX1, rowY, idX2, rowY + m.rowHeight, tocolor(240, 240, 240, 255), 1, getFigmaFont('Poppins-Medium', math.floor(12*z)), "center", "center", true, false)
        dxDrawText(getVehicleNameFromModel(tonumber(vehicle.model) or vehicle.model), modelX1, rowY, modelX2, rowY + m.rowHeight, tocolor(240, 240, 240, 255), 1, getFigmaFont('Poppins-Medium', math.floor(12*z)), "center", "center", true, false)
        local fuelPercent = tonumber(vehicle.fuel) or math.random(10, 100)
        dxDrawText(string.format("%d%%", fuelPercent), fuelX1, rowY, fuelX2, rowY + m.rowHeight, colorLerpByValue(fuelPercent, 0, 100, {255, 0, 0}, {0, 255, 0}), 1, getFigmaFont('Poppins-Medium', math.floor(12*z)), "center", "center", true, false)
        local isStored = tonumber(vehicle.inactivo) == 1
        local statusText = isStored and "GUARDADO" or "FUERA DE GARAGE"
        local orange = tocolor(255, 165, 0, 255)
        dxDrawText(statusText, statusX1, rowY, statusX2, rowY + m.rowHeight, orange, 1, getFigmaFont('Poppins-Medium', math.floor(12*z)), "center", "center", true, false)
      end
    end

    dxSetRenderTarget()
    dxDrawImage(m.listX, m.listY, contentW, m.listH, listRenderTarget)
  end

  -- Indicadores opcionales (desactivados para diseño limpio)
end

-- Clicks
local function onClientClickHandler(button, state)
  if not uiState.isOpen or button ~= "left" or state ~= "down" then
    return
  end

  local screenW, screenH = guiGetScreenSize()
  local z = getUiZoom()
  local closeBtnX, closeBtnY, closeBtnW, closeBtnH = screenW / 2 + 380, screenH / 2 - 230, 30, 30
  if isCursorInRect(closeBtnX, closeBtnY, closeBtnW, closeBtnH) then
    -- Cerrar panel
    uiState.isOpen = false
    showCursor(false)
    removeEventHandler("onClientRender", root, renderGaragePanel)
    removeEventHandler("onClientClick", root, onClientClickHandler)
    removeEventHandler("onClientKey", root, onClientKeyHandler)
    return
  end

  -- Botones
  local takeBtnX, takeBtnY, takeBtnW, takeBtnH = screenW / 2 - 340*z, screenH / 2 + 178*z, 260*z, 64*z
  local saveBtnX, saveBtnY, saveBtnW, saveBtnH = screenW / 2 +   80*z, screenH / 2 + 178*z, 260*z, 64*z
  if isCursorInRect(takeBtnX, takeBtnY, takeBtnW, takeBtnH) then
    -- Sacar vehículo seleccionado
    if uiState.selectedIndex and uiState.vehicles[uiState.selectedIndex] and uiState.vehicles[uiState.selectedIndex].vehicleID then
      triggerServerEvent("onSacarVehiculo", localPlayer, uiState.vehicles[uiState.selectedIndex].vehicleID)
      -- Cerrar al solicitar
      uiState.isOpen = false
      showCursor(false)
      removeEventHandler("onClientRender", root, renderGaragePanel)
      removeEventHandler("onClientClick", root, onClientClickHandler)
      removeEventHandler("onClientKey", root, onClientKeyHandler)
    else
      outputChatBox("Selecciona un vehículo de la lista.", 255, 0, 0)
    end
    return
  end
  if isCursorInRect(saveBtnX, saveBtnY, saveBtnW, saveBtnH) then
    triggerServerEvent("onGuardarVehiculo", localPlayer)
    return
  end

  -- Selección en la lista (usar las mismas métricas que el render)
  local mSel = getListMetrics(z)
  local listX, listY, listW, listH = mSel.listX, mSel.listY, mSel.listW, mSel.listH
  local rowFullH = mSel.rowFullH
  if isCursorInRect(listX, listY, listW, listH) then
    local cursorXNorm, cursorYNorm = getCursorPosition()
    local cursorX = cursorXNorm * screenW
    local cursorY = cursorYNorm * screenH
    local localY = cursorY - listY + uiState.scrollOffsetPx
    local clickedIndex = math.floor(localY / rowFullH) + 1
    if clickedIndex >= 1 and clickedIndex <= #uiState.vehicles then
      uiState.selectedIndex = clickedIndex
    end
  end

  -- Drag en scrollbar (simple: saltar a posición por click)
  if #uiState.vehicles > 1 then
    local barW = mSel.barW
    local barX = listX + listW - barW
    if isCursorInRect(barX, listY, barW, listH) then
      local _, cursorYNorm = getCursorPosition()
      local cursorY = cursorYNorm * screenH
      local contentH = math.max(0, (#uiState.vehicles > 0) and (#uiState.vehicles * (mSel.rowFullH) - mSel.rowSpacing) or 0)
      local maxScrollPx = math.max(0, contentH - listH)
      local thumbH = math.max(30*z, (listH * listH) / math.max(listH, contentH))
      local relativeY = clamp(cursorY - listY - thumbH / 2, 0, listH - thumbH)
      uiState.scrollOffsetPx = math.floor((relativeY / (listH - thumbH)) * maxScrollPx + 0.5)
    end
  end
end

-- Teclas y rueda
function onClientKeyHandler(key, press)
  if not uiState.isOpen or not press then
    return
  end

  local screenW, screenH = guiGetScreenSize()
  local z = getUiZoom()
  local m = getListMetrics(z)
  local listX, listY, listW, listH = m.listX, m.listY, m.listW, m.listH
  local rowHeight = m.rowHeight

  if key == "enter" then
    -- Acceso rápido a sacar
    if uiState.selectedIndex and uiState.vehicles[uiState.selectedIndex] and uiState.vehicles[uiState.selectedIndex].vehicleID then
      triggerServerEvent("onSacarVehiculo", localPlayer, uiState.vehicles[uiState.selectedIndex].vehicleID)
      uiState.isOpen = false
      showCursor(false)
      removeEventHandler("onClientRender", root, renderGaragePanel)
      removeEventHandler("onClientClick", root, onClientClickHandler)
      removeEventHandler("onClientKey", root, onClientKeyHandler)
    end
  elseif key == "backspace" or key == "escape" then
    -- Cerrar
    uiState.isOpen = false
    showCursor(false)
    removeEventHandler("onClientRender", root, renderGaragePanel)
    removeEventHandler("onClientClick", root, onClientClickHandler)
    removeEventHandler("onClientKey", root, onClientKeyHandler)
  elseif key == "arrow_u" then
    if uiState.selectedIndex and uiState.selectedIndex > 1 then
      uiState.selectedIndex = uiState.selectedIndex - 1
      if (math.floor(uiState.scrollOffsetPx / rowHeight) + 1) > uiState.selectedIndex then
        uiState.scrollOffsetPx = (uiState.selectedIndex - 1) * rowHeight
      end
    elseif not uiState.selectedIndex and #uiState.vehicles > 0 then
      uiState.selectedIndex = 1
    end
  elseif key == "arrow_d" then
    if uiState.selectedIndex and uiState.selectedIndex < #uiState.vehicles then
      uiState.selectedIndex = uiState.selectedIndex + 1
      if (uiState.selectedIndex - 1) * (m.rowFullH) < uiState.scrollOffsetPx then
        uiState.scrollOffsetPx = (uiState.selectedIndex - 1) * m.rowFullH
      elseif (uiState.selectedIndex) * m.rowFullH > uiState.scrollOffsetPx + m.listH then
        uiState.scrollOffsetPx = uiState.scrollOffsetPx + (m.rowFullH)
      end
    elseif not uiState.selectedIndex and #uiState.vehicles > 0 then
      uiState.selectedIndex = 1
    end
  elseif key == "mouse_wheel_up" then
    if isCursorInRect(listX, listY, listW, listH) then
      local contentH = math.max(0, (#uiState.vehicles > 0) and (#uiState.vehicles * m.rowFullH - m.rowSpacing) or 0)
      local maxScrollPx = math.max(0, contentH - m.listH)
      uiState.scrollOffsetPx = clamp(uiState.scrollOffsetPx - 20*z, 0, maxScrollPx)
    end
  elseif key == "mouse_wheel_down" then
    if isCursorInRect(listX, listY, listW, listH) then
      local contentH = math.max(0, (#uiState.vehicles > 0) and (#uiState.vehicles * m.rowFullH - m.rowSpacing) or 0)
      local maxScrollPx = math.max(0, contentH - m.listH)
      uiState.scrollOffsetPx = clamp(uiState.scrollOffsetPx + 20*z, 0, maxScrollPx)
    end
  end
end

-- Abrir / cerrar panel
local function openGaragePanel(vehicles)
  uiState.vehicles = vehicles or {}
  uiState.selectedIndex = nil
  uiState.scrollOffsetPx = 0
  uiState.isOpen = true

  showCursor(true)
  addEventHandler("onClientRender", root, renderGaragePanel)
  addEventHandler("onClientClick", root, onClientClickHandler)
  addEventHandler("onClientKey", root, onClientKeyHandler)

  if fileExists("data/garage_open.mp3") then
    playSound("data/garage_open.mp3", false)
  end
end

local function closeGaragePanel()
  if not uiState.isOpen then return end
  uiState.isOpen = false
  showCursor(false)
  removeEventHandler("onClientRender", root, renderGaragePanel)
  removeEventHandler("onClientClick", root, onClientClickHandler)
  removeEventHandler("onClientKey", root, onClientKeyHandler)
  if fileExists("data/garage_close.mp3") then
    playSound("data/garage_close.mp3", false)
  end
end

-- =====================================================
-- OPTIMIZACIÓN MÁXIMA: Iconos flotantes eliminados completamente
-- =====================================================
-- NOTA: Se eliminó el sistema de iconos flotantes garaje.png para máximo rendimiento
-- Los markers físicos del garaje siguen funcionando normalmente

-- El onClientRender que dibujaba las imágenes flotantes ha sido eliminado
-- Esto reduce significativamente el consumo de CPU del resource

-- Eventos de red
addEvent("onEnviarVehiculos", true)
addEventHandler("onEnviarVehiculos", root, function(vehicles)
  if type(vehicles) ~= "table" then vehicles = {} end
  if #vehicles > 0 then
    outputDebugString("Recibidos " .. #vehicles .. " vehículos del servidor")
    for _, v in ipairs(vehicles) do
      outputDebugString("Vehículo ID: " .. tostring(v.vehicleID) .. ", Estado inactivo: " .. tostring(v.inactivo or "N/A"))
    end
  end
  openGaragePanel(vehicles)
end)

addEvent("abrirMenuGaraje", true)
addEventHandler("abrirMenuGaraje", root, function()
  triggerServerEvent("onSolicitarVehiculos", localPlayer)
end)

-- API local por compatibilidad (si otros scripts llaman)
function cerrarPanelGaraje()
  closeGaragePanel()
end



