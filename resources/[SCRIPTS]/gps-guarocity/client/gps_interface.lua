-- Sistema de GPS con Interface DX Nueva
outputDebugString("[GPS] Iniciando sistema GPS con nueva interfaz DX")

local GPS_UI = {}
GPS_UI.isVisible = false
GPS_UI.currentMenu = nil -- "main" o "locations"
GPS_UI.selectedCategory = nil
GPS_UI.selectedLocation = nil
GPS_UI.selectedLocationData = nil

-- Variables de pantalla
local sx, sy = guiGetScreenSize()

-- Factor de escala basado en resolución
local function getScaleFactor()
    local baseWidth = 1920
    local scale = math.min(1.0, sx / baseWidth)
    return math.max(0.6, scale) -- Mínimo 60% de escala, máximo 100%
end

local scaleFactor = getScaleFactor()

-- Dimensiones escaladas
local function scaleSize(size)
    return math.floor(size * scaleFactor)
end

-- Debug: Verificar disponibilidad de funciones
outputDebugString("[GPS] Verificando disponibilidad de funciones...")
if getFigmaFont then
    outputDebugString("[GPS] ✓ getFigmaFont está disponible")
else
    outputDebugString("[GPS] ⚠ getFigmaFont NO está disponible, usando fuente por defecto")
end
if thisResourceName then
    outputDebugString("[GPS] ✓ thisResourceName está disponible: " .. thisResourceName)
else
    outputDebugString("[GPS] ⚠ thisResourceName NO está disponible")
end

-- Función auxiliar para obtener fuente con fallback
local function getFontWithFallback(fontName, size)
    if getFigmaFont and type(getFigmaFont) == "function" then
        local customFont = getFigmaFont(fontName, size)
        if customFont then
            return customFont
        end
    end
    return "default-bold"
end

-- Función auxiliar para obtener ruta de recurso con fallback
local function getResourcePath()
    if thisResourceName then
        return getResourcePath()
    else
        return ''
    end
end

-- Estados del menú
local MENU_STATES = {
    MAIN = "main",
    LOCATIONS = "locations"
}

-- Datos de ubicaciones (movido desde client/main.lua)
local locations = {
    ["TRABAJOS"] = {
        {"REPARTIDOR DE PIZZA", 2095.2119140625, -1806.76953125, 13.551345825195, "Trabaja como pizzeria en la hermosa ciudad de Bogota"},
        
    },
    ["TIENDAS"] = {
        {"CLARO MOVIL", 1356.34375, 306.3798828125, 19.5546875, "Acá podrás comprar un celular, walkie-talkie y un reloj."},
        {"BURGER KING", 812.4970703125, -1630.3349609375, 13.3828125, "¡El mejor restaurante del mundo!."},
        
 	

        
    },
    ["ILEGALES"] = {
        {"ASALTO AL BARCO", 2785.55078125, -2437.2373046875, 13.634209632874, "Necesitas un C4, Portatil de Hackeo, Usb de Hackeo - Zona muy peligrosa - Ten cuidado"},
        {"CONSTRUCCION ABANDONADA",2574.8369140625, -1287.9404296875, 45.9609375, "Zona peligrosa ve con cuidado "},
        {"FAVELA",2600.1123046875, -1041.8427734375, 69.578125, "Zona peligrosa ve con cuidado,te recomendamos ir en grupo "},
        {"BUNKER 07",1342.806640625, -356.869140625, 3.1250495910645, "Zona roja ten cuidado y mantente alerta "},
        {"CASA MADD DOG",1240.7294921875, -742.318359375, 95.516189575195, "Zona peligrosa ten cuidado y cuida tus espaldas "},
    
    },
    ["LEGALES"] = {
        {"SURA",  1195.7578125, -1303.87890625, 13.369909286499, "Centro de Salud SURA, aca podras recibir asistencia medica y autocuracion."},
        {"POLICIA NACIONAL CAPITAL", 1548.8411865234, -1702.46875, 13.558982849121, "Centro de operacion de la policia nacional"},
        {"EJERCITO NACIONAL - PRISION", 154, -1785.263671875, 4.0968360900879, "Centro Operacion donde el Ejercito Vigila a los reclusos de Guaro City Roleplay."},
        {"MECANICOS CAPITAL CUSTOMS", 1013.1982421875, -1035.146484375, 31.37641906738, "Centro de reparacion y servicios ¿que esperas para tunear tu carro?"},
        {"AUTOESCUELA",1070.8408203125, -1698.7490234375, 13.769689559937, "¿Buscas sacar tu licencia de conduccion? Ven nosotros te ayudamos"},
        {"MERCADOLIBRE",1255.7265625, -1338.3662109375, 12.975471496582, "Te gusta viajar por la ciudad este es tu trabajo"},
        {"TERPEL",2676.76171875, -2406.0498046875, 13.467874526978, "La mejor gasolinera de Colombia"}, 
        

         },
        
    ["ROPA"] = {
        {"URBANSTORE", 996.60192871094, -1585.001953125, 13.72536277771, "Tienda de ropa!! que la gente te distinga por tu forma de vestir"},
        
    },
    ["OTROS"] = {
        {"PARQUE CENTRAL", 1474.00390625, -1658.875, 13.53955078125, "Espacio verde para relajarse y pasarla bien"},
        {"SKATE PARK", 1890.291015625, -1431.943359375, 13.555937767029, "Lugar de adrenalinda y emociones"},
        {"PARQUE SECUNDARIO",1836.7431640625, -1677.2138671875, 13.556212425232, "Espacio verde con varias actividades"},
    },
    ["LUGARES"] = {
        {"AEROPUERTO", 1747.7791748047, -2286.3173828125, 13.504467010498, "Edificio público, acá podrás sacarte el DNI."},
        {"SURA", 1195.7578125, -1303.87890625, 13.369909286499, "Centro de Salud SURA, aca podras recibir asistencia medica y autocuracion."},
        {"PRIMAX", 1949.4775390625, -1776.3466796875, 13.3828125, "¡La mejor gasolinera con el mejor precio!."},
        {"UZNU",2765.6950683594, -1729.0406494141, 9.4556255340576, "Arena de evetos lo mejor para pasartela bien."},
        {"PRIMAX 2", 1021.750793457, -928.35498046875, 42.267490386963, "¡La mejor gasolinera con el mejor precio!."},
        {"WALMART", 1316.2412109375, -914.5146484375, 37.952178955078, "El mejor supermecado para comporar de todo un poco."},
    },
    ["CONCESIONARIO"] = {
        {"CONCESIONARIO CAPITAL", 1771.5654296875, -1154.3603515625, 24.079999923706, "Concesionario de autos y motos"},
    }
}

-- Variables para el scroll de ubicaciones
local locationScroll = 0

-- Función para renderizar el menú principal
function GPS_UI.renderMainMenu()
    local bgW, bgH = scaleSize(550), scaleSize(720)
    local btnW, btnH = scaleSize(240), scaleSize(120)
    local headerH = scaleSize(55)
    
    -- Fondo exterior
    dxDrawImage(sx/2 - bgW/2, sy/2 - bgH/2, bgW, bgH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BGEXTERIOR.png')
    
    -- Botones de categorías (posiciones ajustadas)
    local leftX = sx/2 - bgW/2 + scaleSize(30)
    local rightX = sx/2 - bgW/2 + scaleSize(280)
    local topY = sy/2 - scaleSize(270)
    local spacing = scaleSize(135)
    
    dxDrawImage(leftX, topY, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonTrabajos.png')
    dxDrawImage(leftX, topY + spacing, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonTiendas.png')
    dxDrawImage(leftX, topY + spacing * 2, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonIlegales.png')
    dxDrawImage(leftX, topY + spacing * 3, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonRopa.png')
    
    dxDrawImage(rightX, topY + spacing, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonConcesionario.png')
    dxDrawImage(rightX, topY + spacing * 2, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonLegales.png')
    dxDrawImage(rightX, topY + spacing * 3, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonOtros.png')
    dxDrawImage(rightX, topY, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/BotonLugares.png')
    
    -- Header
    dxDrawImage(sx/2 - bgW/2, sy/2 - bgH/2, bgW, headerH, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/Header.png')
    
    -- Textos (tamaños escalados)
    local titleSize = scaleSize(22)
    local btnSize = scaleSize(20)
    
    dxDrawText('Sistema de GPS - La Capital RP', sx/2 - scaleSize(180), sy/2 - bgH/2 + scaleSize(15), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', titleSize), 'left', 'top')
    
    -- Textos de botones
    dxDrawText('TRABAJOS', leftX + scaleSize(80), topY + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    dxDrawText('TIENDAS', leftX + scaleSize(80), topY + spacing + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    dxDrawText('ILEGALES', leftX + scaleSize(80), topY + spacing * 2 + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    dxDrawText('ROPA', leftX + scaleSize(80), topY + spacing * 3 + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    
    dxDrawText('LUGARES', rightX + scaleSize(80), topY + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    dxDrawText('CONCESIONARIO', rightX + scaleSize(80), topY + spacing + scaleSize(35), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', scaleSize(16)), 'center', 'top')
    dxDrawText('LEGALES', rightX + scaleSize(80), topY + spacing * 2 + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    dxDrawText('OTROS', rightX + scaleSize(80), topY + spacing * 3 + scaleSize(45), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnSize), 'center', 'top')
    
    -- Botón cerrar
    local closeSize = scaleSize(36)
    dxDrawImage(sx/2 + bgW/2 - closeSize - scaleSize(10), sy/2 - bgH/2 + scaleSize(10), closeSize, closeSize, ':' .. thisResourceName .. '/InterfazNuevaGPS/PrimerMenuLugaresGPS/data/IconoCerrar.png')
end

-- Función para renderizar el menú de ubicaciones
function GPS_UI.renderLocationsMenu()
    local bgW, bgH = scaleSize(550), scaleSize(720)
    local headerH = scaleSize(55)
    local listPanelW, listPanelH = scaleSize(480), scaleSize(280)
    local infoPanelW, infoPanelH = scaleSize(480), scaleSize(160)
    
    -- Fondo exterior
    dxDrawImage(sx/2 - bgW/2, sy/2 - bgH/2, bgW, bgH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/BGEXTERIOR2.png')
    
    -- Header
    dxDrawImage(sx/2 - bgW/2, sy/2 - bgH/2, bgW, headerH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/Header2.png')
    
    -- Botón cerrar
    local closeSize = scaleSize(36)
    dxDrawImage(sx/2 + bgW/2 - closeSize - scaleSize(10), sy/2 - bgH/2 + scaleSize(10), closeSize, closeSize, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/IconoCerrar.png')
    
    -- Paneles internos
    local listPanelY = sy/2 - scaleSize(220)
    local infoPanelY = sy/2 + scaleSize(100)
    
    dxDrawImage(sx/2 - listPanelW/2, listPanelY, listPanelW, listPanelH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/BGINTERNO-LUGARES.png')
    dxDrawImage(sx/2 - infoPanelW/2, infoPanelY, infoPanelW, infoPanelH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/BGINTERNO-INFORMACION.png')
    
    -- Textos principales
    local titleSize = scaleSize(22)
    local infoTitleSize = scaleSize(18)
    local selectTitleSize = scaleSize(18)
    
    dxDrawText('Sistema de GPS - La Capital RP', sx/2 - scaleSize(180), sy/2 - bgH/2 + scaleSize(15), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', titleSize), 'left', 'top')
    dxDrawText('Selecciona un lugar:', sx/2 - scaleSize(110), listPanelY - scaleSize(25), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', selectTitleSize), 'left', 'top')
    dxDrawText('Informacion del lugar:', sx/2 - scaleSize(120), infoPanelY - scaleSize(25), nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', infoTitleSize), 'left', 'top')
    
    -- Lista de ubicaciones
    if GPS_UI.selectedCategory and locations[GPS_UI.selectedCategory] then
        local categoryLocations = locations[GPS_UI.selectedCategory]
        local listStartX = sx/2 - listPanelW/2 + scaleSize(15)
        local listStartY = listPanelY + scaleSize(15)
        local listWidth = listPanelW - scaleSize(30)
        local listHeight = listPanelH - scaleSize(30)
        local scaledItemHeight = scaleSize(35)
        local scaledScrollbarWidth = scaleSize(15)
        local totalItems = #categoryLocations
        local scaledMaxVisible = math.floor(listHeight / scaledItemHeight)
        local visibleItems = math.min(scaledMaxVisible, totalItems)
        local maxScroll = math.max(0, totalItems - scaledMaxVisible)
        
        -- Limitar el scroll
        if locationScroll > maxScroll then
            locationScroll = maxScroll
        elseif locationScroll < 0 then
            locationScroll = 0
        end
        
        for i = 1, visibleItems do
            local locationIndex = i + locationScroll
            if categoryLocations[locationIndex] then
                local location = categoryLocations[locationIndex]
                local itemY = listStartY + (i - 1) * scaledItemHeight
                local isSelected = (GPS_UI.selectedLocation == location[1])
                
                -- Verificar que el item esté dentro del área visible
                if itemY >= listStartY and itemY + scaledItemHeight <= listStartY + listHeight then
                    -- Imagen de fondo del item (CampoTituloLugar.png)
                    local itemBgX = listStartX
                    local itemBgY = itemY
                    local itemBgWidth = listWidth - (totalItems > scaledMaxVisible and scaledScrollbarWidth or 0)
                    local itemBgHeight = scaledItemHeight - scaleSize(2)
                    
                    -- ✅ ARREGLADO: Color overlay más claro para mostrar colores de Colombia
                    local overlayColor = isSelected and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 255)
                    
                    -- Dibujar fondo del item sin overlay oscuro
                    dxDrawImage(itemBgX, itemBgY, itemBgWidth, itemBgHeight, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/CampoTituloLugar.png', 0, 0, 0, overlayColor)
                    
                    -- Highlight para selección con borde
                    if isSelected then
                        dxDrawRectangle(itemBgX - 2, itemBgY - 2, itemBgWidth + 4, itemBgHeight + 4, tocolor(255, 255, 0, 100))
                    end
                    
                    -- ✅ ARREGLADO: Texto en blanco y más visible
                    local textColor = tocolor(255, 255, 255, 255)
                    local fontSize = scaleSize(14)
                    dxDrawText(location[1], itemBgX + scaleSize(10), itemBgY + scaleSize(5), itemBgX + itemBgWidth - scaleSize(10), itemBgY + itemBgHeight - scaleSize(5), textColor, 1, getFontWithFallback('Poppins-SemiBold', fontSize), 'left', 'center', true)
                end
            end
        end
        
        -- Scrollbar si es necesario
        if totalItems > scaledMaxVisible then
            local scrollbarX = listStartX + listWidth - scaledScrollbarWidth
            local scrollbarY = listStartY
            local scrollbarHeight = listHeight
            
            -- Fondo del scrollbar
            dxDrawRectangle(scrollbarX, scrollbarY, scaledScrollbarWidth, scrollbarHeight, tocolor(0, 0, 0, 100))
            
            -- Thumb del scrollbar
            local thumbHeight = math.max(scaleSize(15), (scaledMaxVisible / totalItems) * scrollbarHeight)
            local thumbY = scrollbarY + (locationScroll / maxScroll) * (scrollbarHeight - thumbHeight)
            dxDrawRectangle(scrollbarX + scaleSize(2), thumbY, scaledScrollbarWidth - scaleSize(4), thumbHeight, tocolor(255, 255, 255, 150))
        end
    end
    
    -- Información del lugar seleccionado
    if GPS_UI.selectedLocationData then
        local infoText = GPS_UI.selectedLocationData[5] or "No hay información disponible"
        local infoTextSize = scaleSize(14)
        dxDrawText(infoText, sx/2 - infoPanelW/2 + scaleSize(15), infoPanelY + scaleSize(25), sx/2 + infoPanelW/2 - scaleSize(15), infoPanelY + infoPanelH - scaleSize(15), tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', infoTextSize), 'left', 'top', false, true)
    end
    
    -- Botones de acción
    local btnW, btnH = scaleSize(200), scaleSize(55)
    local btnY = sy/2 + bgH/2 - btnH - scaleSize(15)
    local btnMarcarX = sx/2 - btnW - scaleSize(10)
    local btnVolverX = sx/2 + scaleSize(10)
    local btnTextSize = scaleSize(18)
    
    dxDrawImage(btnMarcarX, btnY, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/BotorMarcarGPS.png')
    dxDrawImage(btnVolverX, btnY, btnW, btnH, ':' .. thisResourceName .. '/InterfazNuevaGPS/SegundoMenuLugaresInformacionGPS/data/BotonVolver.png')
    dxDrawText('MARCAR GPS', btnMarcarX + btnW/2, btnY + btnH/2, nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnTextSize), 'center', 'center')
    dxDrawText('VOLVER', btnVolverX + btnW/2, btnY + btnH/2, nil, nil, tocolor(255, 255, 255, 255), 1, getFontWithFallback('Poppins-SemiBold', btnTextSize), 'center', 'center')
end

-- Función principal de renderizado
function GPS_UI.render()
    if not GPS_UI.isVisible then return end
    
    if GPS_UI.currentMenu == MENU_STATES.MAIN then
        GPS_UI.renderMainMenu()
    elseif GPS_UI.currentMenu == MENU_STATES.LOCATIONS then
        GPS_UI.renderLocationsMenu()
    end
end

-- Función para mostrar/ocultar la interfaz
function GPS_UI.toggle()
    GPS_UI.isVisible = not GPS_UI.isVisible
    
    if GPS_UI.isVisible then
        GPS_UI.currentMenu = MENU_STATES.MAIN
        GPS_UI.selectedCategory = nil
        GPS_UI.selectedLocation = nil
        GPS_UI.selectedLocationData = nil
        addEventHandler("onClientRender", root, GPS_UI.render)
        addEventHandler("onClientClick", root, GPS_UI.onClick)
        addEventHandler("onClientKey", root, GPS_UI.onScroll)
        showCursor(true)
    else
        removeEventHandler("onClientRender", root, GPS_UI.render)
        removeEventHandler("onClientClick", root, GPS_UI.onClick)
        removeEventHandler("onClientKey", root, GPS_UI.onScroll)
        showCursor(false)
    end
end

-- Función para manejar clicks
function GPS_UI.onClick(button, state, absoluteX, absoluteY)
    if button ~= "left" or state ~= "down" then return end
    
    if GPS_UI.currentMenu == MENU_STATES.MAIN then
        GPS_UI.handleMainMenuClick(absoluteX, absoluteY)
    elseif GPS_UI.currentMenu == MENU_STATES.LOCATIONS then
        GPS_UI.handleLocationsMenuClick(absoluteX, absoluteY)
    end
end

-- Función para manejar clicks en el menú principal
function GPS_UI.handleMainMenuClick(x, y)
    local bgW, bgH = scaleSize(550), scaleSize(720)
    local btnW, btnH = scaleSize(240), scaleSize(120)
    local closeSize = scaleSize(36)
    
    -- Botón cerrar
    local closeX = sx/2 + bgW/2 - closeSize - scaleSize(10)
    local closeY = sy/2 - bgH/2 + scaleSize(10)
    if x >= closeX and x <= closeX + closeSize and y >= closeY and y <= closeY + closeSize then
        GPS_UI.toggle()
        return
    end
    
    -- Botones de categorías
    local leftX = sx/2 - bgW/2 + scaleSize(30)
    local rightX = sx/2 - bgW/2 + scaleSize(280)
    local topY = sy/2 - scaleSize(270)
    local spacing = scaleSize(135)
    
    local buttons = {
        {leftX, topY, btnW, btnH, "TRABAJOS"},
        {leftX, topY + spacing, btnW, btnH, "TIENDAS"},
        {leftX, topY + spacing * 2, btnW, btnH, "ILEGALES"},
        {leftX, topY + spacing * 3, btnW, btnH, "ROPA"},
        {rightX, topY, btnW, btnH, "LUGARES"},
        {rightX, topY + spacing, btnW, btnH, "CONCESIONARIO"},
        {rightX, topY + spacing * 2, btnW, btnH, "LEGALES"},
        {rightX, topY + spacing * 3, btnW, btnH, "OTROS"}
    }
    
    for i, btn in ipairs(buttons) do
        if x >= btn[1] and x <= btn[1] + btn[3] and y >= btn[2] and y <= btn[2] + btn[4] then
            GPS_UI.selectedCategory = btn[5]
            GPS_UI.currentMenu = MENU_STATES.LOCATIONS
            GPS_UI.selectedLocation = nil
            GPS_UI.selectedLocationData = nil
            locationScroll = 0
            break
        end
    end
end

-- Función para manejar clicks en el menú de ubicaciones
function GPS_UI.handleLocationsMenuClick(x, y)
    local bgW, bgH = scaleSize(550), scaleSize(720)
    local listPanelW, listPanelH = scaleSize(480), scaleSize(280)
    local listPanelY = sy/2 - scaleSize(220)
    local closeSize = scaleSize(36)
    local btnW, btnH = scaleSize(200), scaleSize(55)
    
    -- Botón cerrar
    local closeX = sx/2 + bgW/2 - closeSize - scaleSize(10)
    local closeY = sy/2 - bgH/2 + scaleSize(10)
    if x >= closeX and x <= closeX + closeSize and y >= closeY and y <= closeY + closeSize then
        GPS_UI.toggle()
        return
    end
    
    -- Botones de acción
    local btnY = sy/2 + bgH/2 - btnH - scaleSize(15)
    local btnMarcarX = sx/2 - btnW - scaleSize(10)
    local btnVolverX = sx/2 + scaleSize(10)
    
    -- Botón volver
    if x >= btnVolverX and x <= btnVolverX + btnW and y >= btnY and y <= btnY + btnH then
        GPS_UI.currentMenu = MENU_STATES.MAIN
        GPS_UI.selectedCategory = nil
        GPS_UI.selectedLocation = nil
        GPS_UI.selectedLocationData = nil
        return
    end
    
    -- Botón marcar GPS
    if x >= btnMarcarX and x <= btnMarcarX + btnW and y >= btnY and y <= btnY + btnH then
        if GPS_UI.selectedLocationData then
            local locData = GPS_UI.selectedLocationData
            setWaypoint(locData[2], locData[3], locData[4])
            outputChatBox("#1E90FF[GPS] #FFFFFFEl destino se marcó en el GPS. Destino: #00FF00" .. locData[1] .. ".", 255, 255, 255, true)
            GPS_UI.toggle()
        else
            outputChatBox("#1E90FF[GPS] #FFFFFFSelecciona un destino primero.", 255, 255, 255, true)
        end
        return
    end
    
    -- Lista de ubicaciones
    if GPS_UI.selectedCategory and locations[GPS_UI.selectedCategory] then
        local categoryLocations = locations[GPS_UI.selectedCategory]
        local listStartX = sx/2 - listPanelW/2 + scaleSize(15)
        local listStartY = listPanelY + scaleSize(15)
        local listWidth = listPanelW - scaleSize(30)
        local listHeight = listPanelH - scaleSize(30)
        local scaledItemHeight = scaleSize(35)
        local scaledScrollbarWidth = scaleSize(15)
        local totalItems = #categoryLocations
        local scaledMaxVisible = math.floor(listHeight / scaledItemHeight)
        local visibleItems = math.min(scaledMaxVisible, totalItems)
        
        for i = 1, visibleItems do
            local locationIndex = i + locationScroll
            if categoryLocations[locationIndex] then
                local itemY = listStartY + (i - 1) * scaledItemHeight
                local itemBgWidth = listWidth - (totalItems > scaledMaxVisible and scaledScrollbarWidth or 0)
                local itemBgHeight = scaledItemHeight - scaleSize(2)
                
                -- Verificar si el click está dentro del área del item
                if x >= listStartX and x <= listStartX + itemBgWidth and y >= itemY and y <= itemY + itemBgHeight then
                    local location = categoryLocations[locationIndex]
                    GPS_UI.selectedLocation = location[1]
                    GPS_UI.selectedLocationData = location
                    break
                end
            end
        end
    end
end

-- Función para manejar scroll
function GPS_UI.onScroll(key, press)
    if not press or GPS_UI.currentMenu ~= MENU_STATES.LOCATIONS then return end
    
    if GPS_UI.selectedCategory and locations[GPS_UI.selectedCategory] then
        local categoryLocations = locations[GPS_UI.selectedCategory]
        local listPanelH = scaleSize(280)
        local scaledItemHeight = scaleSize(35)
        local scaledMaxVisible = math.floor((listPanelH - scaleSize(30)) / scaledItemHeight)
        local totalItems = #categoryLocations
        local maxScroll = math.max(0, totalItems - scaledMaxVisible)
        
        if key == "mouse_wheel_up" then
            locationScroll = math.max(0, locationScroll - 1)
        elseif key == "mouse_wheel_down" then
            locationScroll = math.min(maxScroll, locationScroll + 1)
        end
    end
end

-- Comando para abrir el GPS
addCommandHandler("gps", GPS_UI.toggle)

-- Tecla F9 para abrir el GPS
bindKey("F9", "down", GPS_UI.toggle)

-- Limpiar eventos al cerrar el resource
addEventHandler("onClientResourceStop", resourceRoot, function()
    if GPS_UI.isVisible then
        GPS_UI.toggle()
    end
end)
