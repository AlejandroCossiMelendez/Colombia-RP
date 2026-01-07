-- Clean utils for dx SVG rectangles

SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()
SCREEN_SCALE = math.max(0.6, SCREEN_HEIGHT / 1080)

-- NOTE: Original uses a var0 cache keyed by SVG markup. Keep behavior.
local svgCache = {}

function dxDrawRoundedRectangle(x, y, width, height, borderRadius, gradientStartColor, gradientEndColor, color)
  gradientEndColor = gradientEndColor or gradientStartColor
  local key = tostring(width)..":"..tostring(height)..":filled:"..tostring(borderRadius)..":"..tostring(gradientStartColor)..":"..tostring(gradientEndColor)
  if isElement(svgCache[key]) then
    return dxDrawImage(x, y, width, height, svgCache[key], 0, 0, 0, color)
  end
  local svg = string.format([[        <svg width="%0.1f" height="%0.1f">
            <defs>
                <linearGradient id="grad1" x1="0%%" y1="0%%" x2="100%%" y2="0%%">
                    <stop offset="0%%" style="stop-color:%s;stop-opacity:1" />
                    <stop offset="100%%" style="stop-color:%s;stop-opacity:1" />
                </linearGradient>
            </defs>
            <rect x="0.5" y="0.5" rx="%d" ry="%d" width="%0.1f" height="%0.1f" fill="url(#grad1)" />
        </svg>
    ]], width + 0.5, height + 0.5, gradientStartColor, gradientEndColor, borderRadius, borderRadius, width - 0.5, height - 0.5)
  local texture = svgCreate(width, height, svg)
  if not texture then return false end
  svgCache[key] = texture
  dxSetTextureEdge(texture, "clamp")
  return dxDrawImage(x, y, width, height, texture, 0, 0, 0, color)
end

function dxDrawUnfilledRectangle(x, y, width, height, borderRadius, gradientStartColor, gradientEndColor, color, strokeWidth)
  gradientEndColor = gradientEndColor or gradientStartColor
  strokeWidth = strokeWidth or 1
  local key = tostring(width)..":"..tostring(height)..":unfilled:"..tostring(borderRadius)..":"..tostring(gradientStartColor)..":"..tostring(gradientEndColor)..":"..tostring(strokeWidth)
  if isElement(svgCache[key]) then
    return dxDrawImage(x, y, width, height, svgCache[key], 0, 0, 0, color)
  end
  local svg = string.format([[        <svg width="%0.1f" height="%0.1f">
            <defs>
                <linearGradient id="grad1" x1="0%%" y1="0%%" x2="100%%" y2="0%%">
                    <stop offset="0%%" style="stop-color:%s;stop-opacity:1" />
                    <stop offset="100%%" style="stop-color:%s;stop-opacity:1" />
                </linearGradient>
            </defs>
            <rect x="0.5" y="0.5" rx="%d" ry="%d" width="%0.1f" height="%0.1f" fill="none" stroke="url(#grad1)" stroke-width="%d" />
        </svg>
    ]], width + 0.5, height + 0.5, gradientStartColor, gradientEndColor, borderRadius, borderRadius, width - 0.5, height - 0.5, strokeWidth)
  local texture = svgCreate(width, height, svg)
  if not texture then return false end
  svgCache[key] = texture
  dxSetTextureEdge(texture, "clamp")
  return dxDrawImage(x, y, width, height, texture, 0, 0, 0, color)
end


-- Soft alpha stripe inside rounded rect (diffuse highlight). If vertical==true, the gradient goes top->bottom.
function dxDrawRoundedAlphaStripe(x, y, width, height, borderRadius, colorHex, centerOpacity, color, vertical)
  centerOpacity = tonumber(centerOpacity) or 0.5
  if centerOpacity < 0 then centerOpacity = 0 end
  if centerOpacity > 1 then centerOpacity = 1 end
  local orient = vertical and "v" or "h"
  local key = table.concat({width, height, borderRadius, colorHex or "#ffffff", string.format("%.2f", centerOpacity), orient}, ":")
  key = "alphaStripe:"..key
  if not isElement(svgCache[key]) then
    local x1, y1, x2, y2 = "0%", "0%", "100%", "0%"
    if vertical then x1, y1, x2, y2 = "0%", "0%", "0%", "100%" end
    local svg = string.format([[        <svg width="%0.1f" height="%0.1f">
            <defs>
                <linearGradient id="grad1" x1="%s" y1="%s" x2="%s" y2="%s">
                    <stop offset="0%%" style="stop-color:%s;stop-opacity:0" />
                    <stop offset="50%%" style="stop-color:%s;stop-opacity:%0.2f" />
                    <stop offset="100%%" style="stop-color:%s;stop-opacity:0" />
                </linearGradient>
            </defs>
            <rect x="0.5" y="0.5" rx="%d" ry="%d" width="%0.1f" height="%0.1f" fill="url(#grad1)" />
        </svg>
    ]], width + 0.5, height + 0.5, x1, y1, x2, y2, colorHex or "#ffffff", colorHex or "#ffffff", centerOpacity, colorHex or "#ffffff", borderRadius, borderRadius, width - 0.5, height - 0.5)
    local texture = svgCreate(width, height, svg)
    if texture then
      svgCache[key] = texture
      dxSetTextureEdge(texture, "clamp")
    end
  end
  local tex = svgCache[key]
  if not isElement(tex) then return false end
  return dxDrawImage(x, y, width, height, tex, 0, 0, 0, color)
end


