-- Clean selector UI and input

local isVisible = false
local fade = 0
local fadeTick = 0

-- UI constants (can be tuned)
local CARD_PADDING = 16
local CARD_RADIUS = 12
local TITLE_SCALE = 1.0 * SCREEN_SCALE
local TITLE_FONT = "default-bold"
local DESC_SCALE = 0.9 * SCREEN_SCALE
local DESC_FONT = "default"
local ICON_SIZE = math.floor(48 * SCREEN_SCALE)
local Icons = {
  IoArrowBackCircle = nil,
  IoArrowForwardCircle = nil,
}

-- Fonts & palette (Colombia)
local robotoRegular = nil
local robotoMedium = nil

local COL_YELLOW = { 252, 209, 22 }
local COL_BLUE   = { 0, 56, 147 }
local COL_RED    = { 206, 17, 38 }

local function ensureFonts()
  if not isElement(robotoRegular) then
    robotoRegular = dxCreateFont("fonts/Roboto-Regular.ttf", math.floor(16 * SCREEN_SCALE), false, "antialiased")
  end
  if not isElement(robotoMedium) then
    robotoMedium = dxCreateFont("fonts/Roboto-Medium.ttf", math.floor(18 * SCREEN_SCALE), false, "antialiased")
  end
end

local function destroyFonts()
  if isElement(robotoRegular) then destroyElement(robotoRegular) robotoRegular = nil end
  if isElement(robotoMedium) then destroyElement(robotoMedium) robotoMedium = nil end
end

local card = nil
local currentIndex = 1

local function max(a, b) return (a > b) and a or b end

local function createSelectorCard(spawnItem)
  local t = {}
  t.x, t.y = 0, 0
  t.padding = CARD_PADDING
  t.border_radius = CARD_RADIUS
  t.title = spawnItem.title
  t.title_width = dxGetTextWidth(t.title, TITLE_SCALE, TITLE_FONT)
  t.title_height = 24 * SCREEN_SCALE
  t.description = "Presiona 'Enter' para seleccionar este spawn"
  t.description_width = dxGetTextWidth(t.description, DESC_SCALE, DESC_FONT)
  t.description_height = 18 * SCREEN_SCALE
  t.info_width = max(t.title_width, t.description_width)
  t.info_height = t.title_height + t.description_height
  t.width = t.info_width + t.padding * 4 + ICON_SIZE * 2
  t.height = t.title_height + t.description_height + t.padding * 2
  t.inner_width = t.width - t.padding * 2
  t.inner_height = t.height - t.padding * 2
  t.info_x = 0
  t.info_y = (t.inner_height - t.info_height) / 2
  t.icon_size = ICON_SIZE
  t.left_arrow = Icons.IoArrowBackCircle
  t.left_arrow_x = 0
  t.left_arrow_y = (t.inner_height - t.icon_size) / 2
  t.right_arrow = Icons.IoArrowForwardCircle
  t.right_arrow_x = t.width - t.padding * 2 - t.icon_size
  t.right_arrow_y = (t.inner_height - t.icon_size) / 2
  t.title_x = (t.inner_width - t.title_width) / 2
  t.title_y = 0
  t.description_x = (t.inner_width - t.description_width) / 2
  t.description_y = t.title_height
  return t
end

local function renderSelectorCard(card, cursorX, cursorY)
  cursorX = cursorX - card.x
  cursorY = cursorY - card.y
  dxDrawRoundedRectangle(card.x, card.y, card.width, card.height, card.border_radius, "white", nil, tocolor(34,34,34, 200 * fade))
  if type(card.left_arrow) == "string" and fileExists(card.left_arrow) then
    dxDrawImage(card.x + card.padding + card.left_arrow_x, card.y + card.padding + card.left_arrow_y, card.icon_size, card.icon_size, card.left_arrow, 0, 0, 0, tocolor(255,255,255, 255 * fade))
  end
  if type(card.right_arrow) == "string" and fileExists(card.right_arrow) then
    dxDrawImage(card.x + card.padding + card.right_arrow_x, card.y + card.padding + card.right_arrow_y, card.icon_size, card.icon_size, card.right_arrow, 0, 0, 0, tocolor(255,255,255, 255 * fade))
  end
  dxDrawText(card.title, card.x + card.padding + card.info_x + card.title_x, card.y + card.padding + card.info_y + card.title_y, card.x + card.padding + card.info_x + card.title_x + card.title_width, card.y + card.padding + card.info_y + card.title_y + card.title_height, tocolor(255,255,255, 255 * fade), TITLE_SCALE, TITLE_FONT)
  dxDrawText(card.description, card.x + card.padding + card.info_x + card.description_x, card.y + card.padding + card.info_y + card.description_y, card.x + card.padding + card.info_x + card.description_x + card.description_width, card.y + card.padding + card.info_y + card.description_y + card.description_height, tocolor(255,255,255, 255 * fade), DESC_SCALE, DESC_FONT)
end

local function render()
  local now = getTickCount()
  local progress = (now - (fadeTick or now)) / 500
  if progress < 0 then progress = 0 end
  if progress > 1 then progress = 1 end
  fade = interpolateBetween(fade, 0, 0, isVisible and 1 or 0, 0, 0, progress, "Linear")
  if not isVisible and fade == 0 then
    removeEventHandler("onClientRender", root, render)
    return
  end
  local cx, cy = getCursorPosition()
  if not cx or not cy then
    cx, cy = 0.5, 0.5
  end
  -- Bottom-centered Colombian banner with animations
  local scale = SCREEN_SCALE
  local width = math.floor(math.min(SCREEN_WIDTH * 0.8, 860 * scale))
  local height = math.floor(math.max(56 * scale, 60))
  local radius = math.floor(14 * scale)
  local padding = math.floor(6 * scale)
  local x = (SCREEN_WIDTH - width) / 2
  local targetY = SCREEN_HEIGHT - height - math.floor(32 * scale)
  local slideDistance = math.floor(24 * scale)
  local y = targetY + (1 - fade) * slideDistance

  -- shadow
  dxDrawRoundedRectangle(x, y + math.floor(4 * scale), width, height, radius, "#000000", "#000000", tocolor(0, 0, 0, 130 * fade))
  -- base container
  dxDrawRoundedRectangle(x, y, width, height, radius, "#1b1b1b", "#121212", tocolor(255, 255, 255, 240 * fade))

  -- flag stripes (yellow 50%, blue 25%, red 25%)
  local innerX = x + padding
  local innerY = y + padding
  local innerW = width - padding * 2
  local innerH = height - padding * 2
  local hYellow = math.floor(innerH * 0.5)
  local hBlue = math.floor(innerH * 0.25)
  local hRed = innerH - hYellow - hBlue
  dxDrawRectangle(innerX, innerY, innerW, hYellow, tocolor(COL_YELLOW[1], COL_YELLOW[2], COL_YELLOW[3], math.floor(215 * fade)))
  dxDrawRectangle(innerX, innerY + hYellow, innerW, hBlue, tocolor(COL_BLUE[1], COL_BLUE[2], COL_BLUE[3], math.floor(215 * fade)))
  dxDrawRectangle(innerX, innerY + hYellow + hBlue, innerW, hRed, tocolor(COL_RED[1], COL_RED[2], COL_RED[3], math.floor(215 * fade)))

  -- soft border
  dxDrawUnfilledRectangle(x, y, width, height, radius, "#ffffff", "#ffffff", tocolor(255, 255, 255, math.floor(45 * fade)), math.max(1, math.floor(1 * scale)))

  -- sheen desactivado para mayor rendimiento y look clásico

  -- keycap "ENTER"
  local keyH = math.floor(innerH * 0.58)
  local keyW = math.floor(math.max(70 * scale, keyH * 2.2))
  local keyX = x + math.floor(16 * scale)
  local keyY = y + (height - keyH) / 2
  dxDrawRoundedRectangle(keyX, keyY, keyW, keyH, math.floor(keyH / 2), "#fdfdfd", "#ffffff", tocolor(255, 255, 255, math.floor(230 * fade)))
  dxDrawUnfilledRectangle(keyX, keyY, keyW, keyH, math.floor(keyH / 2), "#000000", "#000000", tocolor(0, 0, 0, math.floor(70 * fade)), math.max(1, math.floor(1 * scale)))
  local keyFont = isElement(robotoMedium) and robotoMedium or "default-bold"
  dxDrawText("ENTER", keyX, keyY, keyX + keyW, keyY + keyH, tocolor(20, 20, 20, math.floor(245 * fade)), 1, keyFont, "center", "center", false, false, false, true)

  -- message
  local msg = "Presiona ENTER para spawnear"
  local textX = keyX + keyW + math.floor(12 * scale)
  local textY = y
  local textW = x + width - math.floor(16 * scale)
  local textH = y + height
  local msgFont = isElement(robotoMedium) and robotoMedium or "default-bold"
  local pulse = 0.5 + 0.5 * math.sin((now % 1500) / 1500 * 2 * math.pi)
  local alpha = math.floor((210 + 45 * pulse) * fade)
  dxDrawText(msg, textX + 1, textY + 1, textW + 1, textH + 1, tocolor(0, 0, 0, alpha), 1, msgFont, "left", "center", false, false, false, true)
  dxDrawText(msg, textX, textY, textW, textH, tocolor(255, 255, 255, math.floor(255 * fade)), 1, msgFont, "left", "center", false, false, false, true)
end

function SetVisible(flag)
  isVisible = flag
  fadeTick = getTickCount()
  if flag then
    ensureFonts()
    fadeCamera(true, 0.5)
    local name = SetCamera(currentIndex)
    if name then settings.notify_c(name, "info") end
    removeEventHandler("onClientRender", root, render)
    addEventHandler("onClientRender", root, render, false)
  end
end

addEventHandler("onClientKey", root, function(key, pressed)
  if not isVisible or not pressed then return end
  -- Si es personaje nuevo, forzamos única opción (índice actual) sin navegación
  local isNewChar = false
  -- Determinamos "nuevo" vía interior/dimension/posición inicial si el server nos la puso; si
  -- hubiese un flag explícito podríamos leerlo del evento. Por ahora no permitimos navegación.
  if key == "enter" and CameraManager:get_camera_by_index(currentIndex) then
    playSoundFrontEnd(1)
    local cam = CameraManager:get_camera_by_index(currentIndex)
    triggerServerEvent("mrp_spawn:performSpawn", resourceRoot, { cam.x, cam.y, cam.z }, 0, getElementModel(localPlayer) or 0, cam.int or 0, cam.dim or 0)
  end
end, false)

addEvent("mrp_spawn->onSpawn", true)
addEventHandler("mrp_spawn->onSpawn", resourceRoot, function()
  StopCurrentCamera()
  SetVisible(false)
end)

addEvent("mrp_spawn->onSetVisible", true)
addEventHandler("mrp_spawn->onSetVisible", resourceRoot, function(lastPosition, visible, startIndex, interior, dimension)
  if not AddCamera("Ultima posicion", lastPosition[1], lastPosition[2], lastPosition[3], 70, 5, interior, dimension, true) then
    settings.notify_c("Ha ocurrido un error, por favor reconecta y/o contacta con un administrador", "error")
    return
  end
  isVisible = visible
  currentIndex = startIndex
  card = createSelectorCard({ title = "Selector de Spawn" })
  SetVisible(true)
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
  ensureFonts()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
  destroyFonts()
end)


