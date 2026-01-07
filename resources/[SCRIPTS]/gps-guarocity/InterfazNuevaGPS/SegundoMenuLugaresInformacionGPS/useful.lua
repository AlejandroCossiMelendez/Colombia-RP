	dxDrawText('Sistema de GPS - La Capital RP', sx/2 + -220, sy/2 + -437, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

	dxDrawText('Seleccion una lugar:', sx/2 + -146, sy/2 + -350, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

	dxDrawText('Informacion del lugar:', sx/2 + -159, sy/2 + 76, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

	dxDrawText('MARCAR GPS', sx/2 + -252, sy/2 + 365, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

	dxDrawText('VOLVER<!newline!>', sx/2 + 102, sy/2 + 365, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')

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