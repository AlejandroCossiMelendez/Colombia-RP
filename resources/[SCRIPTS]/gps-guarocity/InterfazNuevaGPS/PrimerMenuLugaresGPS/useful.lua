dxDrawText('Sistema de GPS - La Capital RP', sx/2 + -220, sy/2 + -437, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('TRABAJOS', sx/2 + -239, sy/2 + -268, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('TIENDAS', sx/2 + -224, sy/2 + -83, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('ILEGALES', sx/2 + -226, sy/2 + 102, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('LEGALES', sx/2 + 113, sy/2 + 102, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('ROPA', sx/2 + -204, sy/2 + 287, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('OTROS', sx/2 + 123, sy/2 + 297, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('LUGARES', sx/2 + 109, sy/2 + -268, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

dxDrawText('CONCESIONARIO', sx/2 + 53, sy/2 + -83, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

 sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
fonts = {
    figmaFonts = {},
}

function unloadFonts()
    for k,v in pairs(fonts) do
        if v and isElement(v) then destroyElement(v) end
    end
    fonts = {
        figmaFonts = {},
    }
end

function loadFonts(array)
    unloadFonts()
    for _,v in pairs(array) do
        fonts[v[1]] = dxCreateFont(v[2], v[3], v[4], 'proof')
    end
end

function getFigmaFont(font, size)
    local figmaFonts = fonts.figmaFonts
    if not figmaFonts[font..size] then
        figmaFonts[font..size] = exports['figma']:getFont(font, size)
    end

    return figmaFonts[font..size]
end
