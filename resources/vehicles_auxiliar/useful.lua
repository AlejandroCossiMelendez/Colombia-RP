local fonts = {}

function getFont(fontName, size)
    local key = fontName .. size
    if not fonts[key] then
        fonts[key] = dxCreateFont("fonts/" .. fontName .. ".ttf", size, false, "proof")
    end
    return fonts[key]
end

addEventHandler("onClientResourceStop", resourceRoot, function()
    for _, font in pairs(fonts) do
        if isElement(font) then
            destroyElement(font)
        end
    end
end) 