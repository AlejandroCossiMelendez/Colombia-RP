-- Variables globales al inicio
local sx, sy
local fonts = {}
local scale -- Nueva variable para la escala

-- Añadir estas variables globales al inicio del archivo
local buttonCerrar = {
	x = 0,
	y = 0,
	width = 206,
	height = 61
}

-- Añadir estas variables globales al inicio del archivo
local idInput = {
	text = "",
	active = false,
	x = 0,
	y = 0,
	width = 294,
	height = 49
}

-- Añadir estas variables globales al inicio del archivo
local cursorState = false
local lastCursorToggle = 0

-- Añadir después de las variables globales
local codigosPenales = {
    -- Capítulo 1 - Infracciones de Tráfico
    {id = "1.1", descripcion = "Giro indebido", sancion = "Multa de $150.000"},
    {id = "1.2", descripcion = "Circular en Sentido contrario", sancion = "Multa de $1.500.000"},
    {id = "1.3", descripcion = "Estacionar en zona no habilitadas y obstrucción de vía", sancion = "Vehículo al Depósito y multa de $450.000"},
    {id = "1.4", descripcion = "Ignorar las Señalizaciones de Tránsito", sancion = "Multa de $450.000"},
    {id = "1.5", descripcion = "Saltarse un Semáforo", sancion = "Multa de $1.000.000"},
    {id = "1.6", descripcion = "Obstruir el paso a un vehículo de la Policía", sancion = "Multa de $2.500.000"},
    {id = "1.7", descripcion = "Omitir un Control de Tráfico", sancion = "Multa de $2.000.000 + 10 min de Prisión"},
    {id = "1.8", descripcion = "Exceso de velocidad", sancion = "Multa de $1.500.000 y Retirada del Vehículo si supera los 130 Km/h"},
    {id = "1.9", descripcion = "Conducción temeraria", sancion = "Multa de $2.500.000 y Vehículo al Depósito + 30 min de Prisión"},
    {id = "1.10", descripcion = "Conducción bajo efectos de sustancias", sancion = "Multa de $1.800.000 y 10 min de Prisión"},
    {id = "1.11", descripcion = "Circular sin medidas de Seguridad", sancion = "Multa de $500.000"},
    {id = "1.12", descripcion = "Circular sin Licencia de conducción", sancion = "Multa de $1.000.000"},
    {id = "1.13", descripcion = "Vehículo mal Estacionado", sancion = "Multa de $2.500.000 y vehículo al Depósito"},
    {id = "1.14", descripcion = "Vehículo con matrícula llevada o Tapada", sancion = "Multa de $1.500.000 y vehículo al Depósito"},
    {id = "1.15", descripcion = "Vehículo con Nitro", sancion = "Multa de $1.000.000 + Retirada de Nitro"},

    -- Capítulo 2 - Agresión, Disturbios y conductas erróneas
    {id = "2.0", descripcion = "Complicidad en delito", sancion = "Multa de $5.000.000 y 35 min de Prisión"},
    {id = "2.1", descripcion = "Alteración del Orden Público", sancion = "Multa de $1.350.000 y 35 min de Prisión"},
    {id = "2.2", descripcion = "Faltas de respeto hacia otro civil", sancion = "Multa de $150.000 + 30 min si persiste"},
    {id = "2.3", descripcion = "Daño a Mobiliario/Bienes Públicos", sancion = "Multa de $1.000.000 a $5.000.000 + 35 min si persiste"},
    {id = "2.4", descripcion = "Daño a Mobiliario/Bienes Privados", sancion = "Multa de $1.800.000 a $3.500.000 + 35 min si persiste"},
    {id = "2.5", descripcion = "Violación", sancion = "Multa de $15.000.000 y 55 min de Prisión"},
    {id = "2.6", descripcion = "Violación a menor de edad", sancion = "Multa de $20.000.000 y 60 min de Prisión"},
    {id = "2.7", descripcion = "Suplantación de identidad", sancion = "Multa de $1.500.000 y 20 min de Prisión"},
    {id = "2.8", descripcion = "Circular con rostro Oculto", sancion = "Multa de $1.500.000 y 30 min de Prisión"},
    {id = "2.9", descripcion = "Fraude o engaño", sancion = "Multa de $1.000.000 y 30 min de Prisión"},
    {id = "2.10", descripcion = "Acoso sexual", sancion = "Multa de $1.200.000 y 25 min de Prisión"},
    {id = "2.11", descripcion = "Negación de identificación", sancion = "Multa de $2.500.000 y retención"},
    {id = "2.12", descripcion = "Maltrato animal", sancion = "Multa de $2.500.000 y 30 min de Prisión"},
    {id = "2.13", descripcion = "Violación de perímetro", sancion = "Multa de $1.800.000 y 15 min de Prisión"},
    {id = "2.14", descripcion = "Exhibicionismo", sancion = "Multa de $950.000"},
    {id = "2.15", descripcion = "Desacato a Estado de Alarma", sancion = "Multa de $3.500.000 y 25 min de Prisión"},

    -- Capítulo 3 - Robos y Asaltos
    {id = "3.1", descripcion = "Robo a vehículo", sancion = "Multa de $5.500.000 y 40 min de Prisión"},
    {id = "3.2", descripcion = "Robo mediante intimidación", sancion = "Multa de $1.600.000 y 35 min de Prisión"},
    {id = "3.3", descripcion = "Robo con arma de fuego", sancion = "Multa de $3.100.000 y 50 min de Prisión"},
    {id = "3.4", descripcion = "Robo menor (Tienda,24/7)", sancion = "Multa de $6.000.000 y 60 min de Prisión"},
    {id = "3.5", descripcion = "Robo mayor (Bancos,Empresas)", sancion = "Multa de $8.250.000 y 60 min de Prisión"},
    {id = "3.6", descripcion = "Robo a entidades federales", sancion = "Multa de $4.500.000 y 60 min de Prisión"},
    {id = "3.7", descripcion = "Allanamiento de morada", sancion = "Multa de $1.500.000 y 55 min de Prisión"},
    {id = "3.8", descripcion = "Robo por Abuso de confianza", sancion = "Multa de $3.500.000 y 30 min de Prisión"},

    -- Capítulo 4 - Armas y Objetos Ilegales
    {id = "4.1", descripcion = "Posesión de arma Blanca Ilegal", sancion = "Multa de $1.500.000 + Retirada del Arma"},
    {id = "4.2", descripcion = "Posesión de arma de Fuego Ilegal", sancion = "Multa de $5.000.000 y 25 min (bajo calibre) / $8.000.000 y 45 min (alto calibre)"},
    {id = "4.3", descripcion = "Posesión de Estupefacientes", sancion = "Multa de $2.000.000 por unidad + 30 min por cada 3+ unidades"},
    {id = "4.4", descripcion = "Tráfico de Drogas (+10 unidades)", sancion = "Multa de $10.000.000 por unidad + 30 min de Prisión"},
    {id = "4.5", descripcion = "Tráfico de armas", sancion = "Bajo calibre: $15.000.000 y 30 min / Alto calibre: $20.000.000 y 10 min"},
    {id = "4.6", descripcion = "Consumo de estupefacientes", sancion = "Multa de $3.000.000 y retirada"},

    -- Capítulo 5 - Delitos Contra la Administración
    {id = "5.1", descripcion = "Desacato a la Autoridad", sancion = "Multa de $500.000 + 35 min de Prisión"},
    {id = "5.2", descripcion = "Insultar a Funcionario Público", sancion = "Multa de $750.000 + 30 min de Prisión"},
    {id = "5.3", descripcion = "Agredir/Amenazar a Funcionario", sancion = "Multa de $1.700.000 + 35 min de Prisión"},
    {id = "5.4", descripcion = "Resistirse al arresto", sancion = "Multa de $550.000 + 35 min de Prisión"},
    {id = "5.5", descripcion = "Falso testimonio", sancion = "Multa de $1.500.000 + 50 min de Prisión"},
    {id = "5.6", descripcion = "Huida de la Justicia", sancion = "Multa de $2.800.000 + 55 min de Prisión"},
    {id = "5.7", descripcion = "Secuestro a Funcionario", sancion = "Multa de $4.000.000 + 60 min de Prisión"},
    {id = "5.8", descripcion = "Intento Homicidio Funcionario", sancion = "Multa de $6.000.000 + 60 min / Cadena perpetua si reincide"},
    {id = "5.9", descripcion = "Homicidio a Funcionario", sancion = "60 min de Prisión"},
    {id = "5.10", descripcion = "Magnicidio", sancion = "Multa de $7.000.000 + 55 min de Prisión"},
    {id = "5.11", descripcion = "Intento de magnicidio", sancion = "Multa de $10.500.000 + 55 min de Prisión"},
    {id = "5.12", descripcion = "Robo datos alto secreto", sancion = "25 min de Prisión"},
    {id = "5.13", descripcion = "Robo a agentes", sancion = "Multa de $3.500.000 + 45 min de Prisión"},
    {id = "5.14", descripcion = "Malversación de fondos", sancion = "45 min de Prisión"},
    {id = "5.15", descripcion = "Soborno o intento", sancion = "Multa de $6.000.000"},
    {id = "5.16", descripcion = "Atentado terrorista", sancion = "180 min de Prisión (Requiere STAFF)"},
    {id = "5.17", descripcion = "Intento atentado terrorista", sancion = "Multa de $15.000.000 y 60 min (Requiere STAFF)"},
    {id = "5.18", descripcion = "Cohecho propio", sancion = "Multa de $10.500.000 y 60 min (Requiere STAFF)"},

    -- Capítulo 6 - Identificaciones
    {id = "6.1", descripcion = "Negarse a entregar DNI", sancion = "Multa de $5.000.000"},
    {id = "6.2", descripcion = "Negarse a entregar Licencia", sancion = "Multa de $4.000.000"},
    {id = "6.3", descripcion = "No querer entregar DNI", sancion = "Multa de $2.500.000"},
    {id = "6.4", descripcion = "No querer entregar Licencia", sancion = "Multa de $3.500.000"}
}

-- Variables para el scroll
local scrollOffset = 0
local maxScroll = 0 -- Se calculará dinámicamente
local scrollSpeed = 59 -- Altura de cada código penal

-- Añadir esta variable global al inicio del archivo
local hoverIndex = nil
local selectedIndex = nil

-- Añadir estas variables globales al inicio del archivo
local playerInfo = {
    name = "",
    found = false
}

-- Añadir una variable para controlar si se ha intentado buscar
local searchAttempted = false

-- Añadir variable global para el botón atribuir
local buttonAtribuir = {
    x = 0,
    y = 0,
    width = 293,
    height = 63
}

-- Añadir variable global para el botón arrestar
local buttonArrestar = {
    x = 0,
    y = 0,
    width = 204,
    height = 61
}

-- Variable para controlar qué botón tiene hover
local hoverButton = nil

-- Añadir estas variables globales al inicio del archivo
local selectedArticles = {}
local totalMinutes = 0

-- Función para calcular la escala basada en la resolución
function calculateScale()
	local baseWidth = 1920 -- Resolución base para la que fue diseñado
	local baseHeight = 1080
	local scaleX = sx / baseWidth
	local scaleY = sy / baseHeight
	return math.min(scaleX, scaleY) -- Usamos la escala más pequeña para mantener proporciones
end

-- Función de inicialización modificada
function initializeUI()
	sx, sy = guiGetScreenSize()
	scale = calculateScale()
	
	-- Calcular maxScroll dinámicamente
	maxScroll = math.max(0, #codigosPenales - 9) -- Mostrar 9 códigos a la vez
	
	-- Crear fuentes con tamaño escalado
	if not fonts["Jua-Regular-26"] then
		fonts["Jua-Regular-26"] = dxCreateFont("fonts/Jua-Regular.ttf", math.floor(26 * scale), false, "antialiased")
	end
	if not fonts["Jua-Regular-21"] then
		fonts["Jua-Regular-21"] = dxCreateFont("fonts/Jua-Regular.ttf", math.floor(21 * scale), false, "antialiased")
	end
	if not fonts["Jua-Regular-16"] then
		fonts["Jua-Regular-16"] = dxCreateFont("fonts/Jua-Regular.ttf", math.floor(16 * scale), false, "antialiased")
	end
	
	-- Actualizar coordenadas del botón atribuir
	buttonAtribuir.x = sx/2 + (100 * scale)
	buttonAtribuir.y = sy/2 + (183 * scale)
	buttonAtribuir.width = 293 * scale
	buttonAtribuir.height = 63 * scale

	-- Actualizar coordenadas del botón arrestar
	buttonArrestar.x = sx/2 + (264 * scale)
	buttonArrestar.y = sy/2 + (261 * scale)
	buttonArrestar.width = 204 * scale
	buttonArrestar.height = 61 * scale

	-- Actualizar coordenadas del botón cerrar (ya existente)
	buttonCerrar.x = sx/2 + (30 * scale)
	buttonCerrar.y = sy/2 + (261 * scale)
	buttonCerrar.width = 206 * scale
	buttonCerrar.height = 61 * scale
	
	-- Actualizar coordenadas del input
	idInput.x = sx/2 + (89 * scale)
	idInput.y = sy/2 - (203 * scale)
	idInput.width = 294 * scale
	idInput.height = 49 * scale
end

local panelVisible = false

function renderUI()
	if not sx or not sy then
		initializeUI()
	end
	
	-- Aplicar escala a todas las coordenadas y dimensiones
	dxDrawImage(sx/2 - (592 * scale), sy/2 - (388 * scale), 1127 * scale, 846 * scale, 'data/FondoTablet.png')
	dxDrawImage(sx/2 - (574 * scale), sy/2 - (365 * scale), 1090 * scale, 766 * scale, 'data/fondoContenido.png')
	dxDrawText('PANEL DE ARRESTOS', sx/2 - (21.5 * scale), sy/2 - (336.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-26"], 'center', 'center')
	dxDrawImage(sx/2 - (554 * scale), sy/2 - (280 * scale), 536 * scale, 613 * scale, 'data/cuadroCodigos.png')
	dxDrawText('CODIGOS PENALES', sx/2 - (288.5 * scale), sy/2 - (256 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-21"], 'center', 'center')
	dxDrawText('ID DE LA PERSONA', sx/2 + (235.5 * scale), sy/2 - (253.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-21"], 'center', 'center')
	dxDrawText('PROCEDIMIENTOS', sx/2 + (246.5 * scale), sy/2 + (150.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-21"], 'center', 'center')
	dxDrawImage(sx/2 + (89 * scale), sy/2 - (203 * scale), 294 * scale, 49 * scale, 'data/cuandroTextoID.png')
	dxDrawImage(sx/2 + (100 * scale), sy/2 + (183 * scale), 293 * scale, 63 * scale, 'data/botonAtribuir.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (198 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (140 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (82 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (24 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (-34 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (-92 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (-150 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (-208 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 - (543 * scale), sy/2 - (-266 * scale), 514 * scale, 59 * scale, 'data/cuadroPenales.png')
	dxDrawImage(sx/2 + (30 * scale), sy/2 + (261 * scale), 206 * scale, 61 * scale, 'data/botonCerrar.png')
	dxDrawImage(sx/2 + (264 * scale), sy/2 + (261 * scale), 204 * scale, 61 * scale, 'data/botonArrestar.png')
	dxDrawText('ATRIBUIR', sx/2 + (249 * scale), sy/2 + (217.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')
	dxDrawText('CERRAR', sx/2 + (132.5 * scale), sy/2 + (290 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')
	dxDrawText('ARRESTAR', sx/2 + (365.5 * scale), sy/2 + (290 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')
	dxDrawImage(sx/2 + (30 * scale), sy/2 - (139 * scale), 424 * scale, 254 * scale, 'data/cuadroInformacion.png')
	dxDrawText('INFORMACION', sx/2 + (246 * scale), sy/2 - (105.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-21"], 'center', 'center')
	
	-- Mostrar la información del jugador y artículos seleccionados
	if playerInfo.found then
		local yOffset = sy/2 - (50 * scale)
		-- Mostrar nombre del jugador
		dxDrawText('Nombre: ' .. playerInfo.name, 
			sx/2 + (50 * scale), 
			yOffset,
			sx/2 + (400 * scale), 
			nil, 
			tocolor(255, 255, 255, 255), 
			scale * 1.3, 
			"default-bold", 
			'left', 
			'top'
		)
		
		-- Mostrar artículos seleccionados
		yOffset = yOffset + (30 * scale)
		dxDrawText('Artículos:', 
			sx/2 + (50 * scale), 
			yOffset,
			sx/2 + (400 * scale), 
			nil, 
			tocolor(255, 255, 255, 255), 
			scale * 1.3, 
			"default-bold", 
			'left', 
			'top'
		)
		
		-- Listar artículos horizontalmente
		yOffset = yOffset + (25 * scale)
		local articleText = ""
		local first = true
		for id, _ in pairs(selectedArticles) do
			if not first then
				articleText = articleText .. ", "
			end
			articleText = articleText .. id
			first = false
		end
		
		dxDrawText(articleText, 
			sx/2 + (50 * scale), 
			yOffset,
			sx/2 + (400 * scale), 
			nil, 
			tocolor(255, 255, 255, 255), 
			scale * 1.3, 
			"default-bold", 
			'left', 
			'top'
		)
		
		-- Mostrar tiempo total
		yOffset = yOffset + (30 * scale)
		dxDrawText('Tiempo total acumulado: ' .. totalMinutes .. ' min', 
			sx/2 + (50 * scale), 
			yOffset,
			sx/2 + (400 * scale), 
			nil, 
			tocolor(255, 255, 255, 255), 
			scale * 1.3, 
			"default-bold", 
			'left', 
			'top'
		)
	elseif searchAttempted then
		dxDrawText('Jugador no encontrado', 
			sx/2 + (50 * scale), 
			sy/2 - (50 * scale), 
			sx/2 + (400 * scale), 
			nil, 
			tocolor(255, 0, 0, 255), 
			scale * 1.3, 
			"default-bold", 
			'left', 
			'top'
		)
	end
	
	dxDrawImage(sx/2 + (153 * scale), sy/2 - (83 * scale), 166 * scale, 166 * scale, 'data/logopolicia.png')
	dxDrawImage(sx/2 + (440.743 * scale), sy/2 - (360.780 * scale), 49.972 * scale, 49.972 * scale, 'data/bateria.png')
	dxDrawImage(sx/2 + (395 * scale), sy/2 - (360 * scale), 47 * scale, 47 * scale, 'data/wifiIcon.png')
	dxDrawImage(sx/2 + (-60 * scale), sy/2 - (-405 * scale), 47 * scale, 47 * scale, 'data/botonTablet.png')
	
	-- Dibujar el texto ingresado y el cursor
	local textToShow = idInput.text
	if idInput.active then
		-- Hacer que el cursor parpadee cada 500ms
		if getTickCount() - lastCursorToggle > 500 then
			cursorState = not cursorState
			lastCursorToggle = getTickCount()
		end
		
		-- Añadir el cursor parpadeante al texto
		if cursorState then
			textToShow = textToShow .. "|"
		end
	end
	
	dxDrawText(textToShow, 
		sx/2 + (89 * scale), -- X inicial del cuadro
		sy/2 - (203 * scale), -- Y inicial del cuadro
		sx/2 + (89 * scale) + (294 * scale), -- X final del cuadro
		sy/2 - (203 * scale) + (49 * scale), -- Y final del cuadro
		tocolor(0, 0, 0, 255), -- Color negro
		scale, 
		fonts["Jua-Regular-16"],
		"center", -- Centrado horizontal
		"center"  -- Centrado vertical
	)

    -- Dibujar los códigos penales con scroll
    local currentMouseX, currentMouseY = getCursorPosition()
    if currentMouseX then
        currentMouseX, currentMouseY = currentMouseX * sx, currentMouseY * sy
        hoverIndex = nil -- Resetear el hover en cada frame
    end

    for i = 1, 9 do
        local index = i + scrollOffset
        if codigosPenales[index] then
            local codigo = codigosPenales[index]
            local yPos = sy/2 - (198 * scale) + ((i-1) * 59 * scale)
            
            -- Fondo del código penal con efecto de selección
            if index == selectedIndex then
                dxDrawImage(sx/2 - (543 * scale), yPos, 514 * scale, 59 * scale, 'data/cuadroPenales.png', 0, 0, 0, tocolor(0, 260, 0, 200))
            end
            dxDrawImage(sx/2 - (543 * scale), yPos, 514 * scale, 59 * scale, 'data/cuadroPenales.png')
            
            -- ID y Descripción
            dxDrawText(codigo.id .. " - " .. codigo.descripcion,
                sx/2 - (533 * scale),
                yPos + (5 * scale),
                sx/2 - (43 * scale),
                yPos + (25 * scale),
                index == selectedIndex and tocolor(0, 255, 0, 255) or tocolor(255, 255, 255, 255),
                scale * 1.3,
                "default-bold",
                "left",
                "center",
                true
            )
            
            -- Sanción
            dxDrawText(codigo.sancion,
                sx/2 - (533 * scale),
                yPos + (25 * scale),
                sx/2 - (43 * scale),
                yPos + (54 * scale),
                index == selectedIndex and tocolor(0, 255, 0, 255) or tocolor(255, 255, 255, 255),
                scale * 1.2,
                "default-bold",
                "left",
                "center",
                true
            )
        end
    end

    -- Dibujar botón Atribuir con efecto hover
    if hoverButton == "atribuir" then
        dxDrawImage(sx/2 + (100 * scale), sy/2 + (183 * scale), 293 * scale, 63 * scale, 'data/botonAtribuir.png', 0, 0, 0, tocolor(0, 255, 0, 200))
    end
    dxDrawImage(sx/2 + (100 * scale), sy/2 + (183 * scale), 293 * scale, 63 * scale, 'data/botonAtribuir.png')
    dxDrawText('ATRIBUIR', sx/2 + (249 * scale), sy/2 + (217.5 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')

    -- Dibujar botón Cerrar con efecto hover
    if hoverButton == "cerrar" then
        dxDrawImage(sx/2 + (30 * scale), sy/2 + (261 * scale), 206 * scale, 61 * scale, 'data/botonCerrar.png', 0, 0, 0, tocolor(0, 255, 0, 200))
    end
    dxDrawImage(sx/2 + (30 * scale), sy/2 + (261 * scale), 206 * scale, 61 * scale, 'data/botonCerrar.png')
    dxDrawText('CERRAR', sx/2 + (132.5 * scale), sy/2 + (290 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')

    -- Dibujar botón Arrestar con efecto hover
    if hoverButton == "arrestar" then
        dxDrawImage(sx/2 + (264 * scale), sy/2 + (261 * scale), 204 * scale, 61 * scale, 'data/botonArrestar.png', 0, 0, 0, tocolor(0, 255, 0, 200))
    end
    dxDrawImage(sx/2 + (264 * scale), sy/2 + (261 * scale), 204 * scale, 61 * scale, 'data/botonArrestar.png')
    dxDrawText('ARRESTAR', sx/2 + (365.5 * scale), sy/2 + (290 * scale), nil, nil, tocolor(255, 255, 255, 255), scale, fonts["Jua-Regular-16"], 'center', 'center')
end

function togglePanel()
	if not panelVisible then
		initializeUI() -- Aseguramos que las variables estén inicializadas
		toggleUI(true)
	else
		toggleUI(false)
	end
end

function isPointInside(x, y, area)
	return (x >= area.x and x <= area.x + area.width) and (y >= area.y and y <= area.y + area.height)
end

function handleClick(button, state, x, y)
	if not panelVisible then return end
	
	if button == "left" and state == "down" then
		if isPointInside(x, y, buttonCerrar) then
			togglePanel()
		elseif isPointInside(x, y, buttonArrestar) and playerInfo.found and totalMinutes > 0 then
			-- Crear la razón basada en los artículos seleccionados
			local razon = ""
			for id, _ in pairs(selectedArticles) do
				if razon ~= "" then
					razon = razon .. ", "
				end
				razon = razon .. "Art. " .. id
			end
			
			-- Enviar la información de arresto al servidor
			triggerServerEvent("onArrestarJugador", localPlayer, idInput.text, totalMinutes, razon)
			-- Cerrar el panel después de arrestar
			togglePanel()
		elseif isPointInside(x, y, buttonAtribuir) and selectedIndex then
			local codigo = codigosPenales[selectedIndex]
			local minutes = extractMinutes(codigo.sancion)
			if not selectedArticles[codigo.id] then
				selectedArticles[codigo.id] = true
				totalMinutes = totalMinutes + minutes
			end
		end
		
		-- Activar/desactivar el input
		if isPointInside(x, y, idInput) then
			idInput.active = true
		else
			idInput.active = false
		end

		-- Verificar si se hizo clic en algún código penal
		for i = 1, 9 do
			local index = i + scrollOffset
			if codigosPenales[index] then
				local yPos = sy/2 - (198 * scale) + ((i-1) * 59 * scale)
				if isMouseOverCode(x, y, yPos, 59 * scale) then
					selectedIndex = index -- Guardar el índice seleccionado
					break
				end
			end
		end
	end
end

-- Modificar la función handleKeyPress para incluir la búsqueda cuando se presiona Enter
function handleKeyPress(button, press)
    if not panelVisible then return end
    
    if button == "backspace" and press and idInput.active then
        handleBackspace()
        -- Resetear el estado de búsqueda cuando se borra
        searchAttempted = false
    elseif button == "enter" and press and idInput.active and idInput.text ~= "" then
        searchAttempted = true -- Marcar que se intentó buscar
        triggerServerEvent("onRequestPlayerInfo", localPlayer, idInput.text)
    end
end

-- Añadir función para manejar el scroll
function handleScroll(button, press)
    if not panelVisible then return end
    
    if button == "mouse_wheel_up" then
        scrollOffset = math.max(0, scrollOffset - 1)
    elseif button == "mouse_wheel_down" then
        scrollOffset = math.min(maxScroll, scrollOffset + 1)
    end
end

function toggleUI(visible)
    if visible then
        showChat(false)
        showCursor(true)
        addEventHandler("onClientRender", root, renderUI)
        addEventHandler("onClientClick", root, handleClick)
        addEventHandler("onClientCharacter", root, handleInput)
        addEventHandler("onClientKey", root, handleKeyPress)
        cursorState = false
        lastCursorToggle = getTickCount()
        scrollOffset = 0
        panelVisible = true
        selectedIndex = nil
        searchAttempted = false
        selectedArticles = {}
        totalMinutes = 0
        addEventHandler("onClientRender", root, updateButtonHover)
    else
        showChat(true)
        showCursor(false)
        removeEventHandler("onClientRender", root, renderUI)
        removeEventHandler("onClientClick", root, handleClick)
        removeEventHandler("onClientCharacter", root, handleInput)
        removeEventHandler("onClientKey", root, handleKeyPress)
        idInput.text = ""
        idInput.active = false
        cursorState = false
        scrollOffset = 0
        panelVisible = false
        selectedIndex = nil
        -- Resetear la información del jugador
        playerInfo.name = ""
        playerInfo.found = false
        searchAttempted = false
        selectedArticles = {}
        totalMinutes = 0
        triggerServerEvent("onResetMinutes", localPlayer) -- Resetear minutos al cerrar
        removeEventHandler("onClientRender", root, updateButtonHover)
        hoverButton = nil
    end
end

addEventHandler("onClientResourceStart", resourceRoot, initializeUI)
addEvent("onOpenPanelPD", true)
addEventHandler("onOpenPanelPD", localPlayer, function()
	togglePanel()
end)

-- Iniciar con el panel oculto
toggleUI(false)

-- Añadir función para manejar el texto ingresado
function handleInput(character)
	if not panelVisible or not idInput.active then return end
	
	if #idInput.text < 15 then -- Límite de 15 caracteres
		idInput.text = idInput.text .. character
	end
end

function handleBackspace()
	if not panelVisible or not idInput.active then return end
	
	if #idInput.text > 0 then
		idInput.text = string.sub(idInput.text, 1, -2)
	end
end

-- Añadir esta función para verificar si el mouse está sobre un código penal
function isMouseOverCode(x, y, codeY, height)
    if not panelVisible then return false end
    local mouseX, mouseY = getCursorPosition()
    if not mouseX then return false end
    
    mouseX, mouseY = mouseX * sx, mouseY * sy
    local codeX = sx/2 - (543 * scale)
    local codeWidth = 514 * scale
    
    return (mouseX >= codeX and mouseX <= codeX + codeWidth and
            mouseY >= codeY and mouseY <= codeY + height)
end

-- Añadir esta función para recibir la información del jugador desde el servidor
function updatePlayerInfo(name, found)
    playerInfo.name = name
    playerInfo.found = found
end
addEvent("onReceivePlayerInfo", true)
addEventHandler("onReceivePlayerInfo", localPlayer, updatePlayerInfo)

-- Manejar el scroll de forma separada
function handleMouseWheel(button, press)
    if not panelVisible then return end
    
    if button == "mouse_wheel_up" then
        scrollOffset = math.max(0, scrollOffset - 1)
    elseif button == "mouse_wheel_down" then
        scrollOffset = math.min(maxScroll, scrollOffset + 1)
    end
end
addEventHandler("onClientKey", root, handleMouseWheel)

-- Función para extraer los minutos de la sanción
function extractMinutes(sancion)
    local minutes = 0
    for num in string.gmatch(sancion, "(%d+)%s*min") do
        minutes = minutes + tonumber(num)
    end
    return minutes
end

-- Añadir función para actualizar el estado del hover
function updateButtonHover()
    if not panelVisible then return end

    local mouseX, mouseY = getCursorPosition()
    if not mouseX then 
        hoverButton = nil
        return 
    end

    mouseX, mouseY = mouseX * sx, mouseY * sy

    -- Verificar cada botón
    if isPointInside(mouseX, mouseY, buttonAtribuir) then
        hoverButton = "atribuir"
    elseif isPointInside(mouseX, mouseY, buttonCerrar) then
        hoverButton = "cerrar"
    elseif isPointInside(mouseX, mouseY, buttonArrestar) then
        hoverButton = "arrestar"
    else
        hoverButton = nil
    end
end