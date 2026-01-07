function renderUI()
	dxDrawImage(sx/2 - 350, sy/2 - 450, 700, 900, 'data/BGEXTERIOR.png')
	dxDrawImage(sx/2 - 314, sy/2 - 342, 300, 150, 'data/BotonTrabajos.png')
	dxDrawImage(sx/2 - 314, sy/2 - 157, 300, 150, 'data/BotonTiendas.png')
	dxDrawImage(sx/2 - 314, sy/2 + 28, 300, 150, 'data/BotonIlegales.png')
	dxDrawImage(sx/2 - 314, sy/2 + 213, 300, 150, 'data/BotonRopa.png')
	dxDrawImage(sx/2 + 22, sy/2 + 28, 300, 150, 'data/BotonLegales.png')
	dxDrawImage(sx/2 + 22, sy/2 + 213, 300, 150, 'data/BotonOtros.png')
	dxDrawImage(sx/2 + 22, sy/2 - 157, 300, 150, 'data/BotonConcesionario.png')
	dxDrawImage(sx/2 + 22, sy/2 - 342, 300, 150, 'data/BotonLugares.png')
	dxDrawImage(sx/2 - 350, sy/2 - 450, 700, 70, 'data/Header.png')
	dxDrawText('Sistema de GPS - La Capital RP', sx/2 - 220, sy/2 - 437, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('TRABAJOS', sx/2 - 239, sy/2 - 268, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('TIENDAS', sx/2 - 224, sy/2 - 83, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('ILEGALES', sx/2 - 226, sy/2 + 102, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('LEGALES', sx/2 + 113, sy/2 + 102, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('ROPA', sx/2 - 204, sy/2 + 287, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('OTROS', sx/2 + 123, sy/2 + 297, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('LUGARES', sx/2 + 109, sy/2 - 268, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('CONCESIONARIO', sx/2 + 53, sy/2 - 83, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawImage(sx/2 + 299, sy/2 - 436, 46, 46, 'data/IconoCerrar.png')
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
end

toggleUI(true)