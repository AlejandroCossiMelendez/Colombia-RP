thisResource = getThisResource()
thisResourceName = getResourceName(thisResource)

-- Sistema de fuentes local
local customFonts = {}

function getFigmaFont(fontName, size)
    local fontKey = fontName .. "_" .. size
    
    if not customFonts[fontKey] then
        customFonts[fontKey] = dxCreateFont(":" .. thisResourceName .. "/Poppins-SemiBold.ttf", size, false, "proof")
    end
    
    return customFonts[fontKey] or "default-bold"
end

function getPositionFromElementOffset(element,offX,offY,offZ) 
    local m = getElementMatrix ( element )  -- Get the matrix 
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform 
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2] 
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3] 
    return x, y, z                               -- Return the transformed point 
end 

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end