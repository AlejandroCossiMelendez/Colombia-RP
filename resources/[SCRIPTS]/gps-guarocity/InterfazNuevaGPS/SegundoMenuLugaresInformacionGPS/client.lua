function renderUI()
	dxDrawImage(sx/2 - 350, sy/2 - 450, 700, 900, 'data/BGEXTERIOR2.png')
	dxDrawImage(sx/2 - 350, sy/2 - 450, 700, 70, 'data/Header2.png')
	dxDrawImage(sx/2 + 299, sy/2 - 436, 46, 46, 'data/IconoCerrar.png')
	dxDrawImage(sx/2 - 310, sy/2 - 285, 620, 350, 'data/BGINTERNO-LUGARES.png')
	dxDrawImage(sx/2 - 310, sy/2 + 130, 620, 200, 'data/BGINTERNO-INFORMACION.png')
	dxDrawText('Sistema de GPS - La Capital RP', sx/2 - 220, sy/2 - 437, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('Seleccion una lugar:', sx/2 - 146, sy/2 - 350, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('Informacion del lugar:', sx/2 - 159, sy/2 + 76, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawImage(sx/2 - 280, sy/2 - 262, 560, 70, 'data/CampoTituloLugar.png')
	dxDrawImage(sx/2 - 283, sy/2 + 352, 250, 70, 'data/BotorMarcarGPS.png')
	dxDrawImage(sx/2 + 32, sy/2 + 352, 250, 70, 'data/BotonVolver.png')
	dxDrawText('MARCAR GPS', sx/2 - 252, sy/2 + 365, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
	dxDrawText('VOLVER\n', sx/2 + 102, sy/2 + 365, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Poppins-SemiBold', 28), 'left', 'top')
end

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
end

toggleUI(true)