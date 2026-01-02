-- Sistema de Voz - Cliente
-- Integrado con el HUD de Colombia RP

local frecuenciasPolicia = {
    [100] = "Frecuencia General", 
    [101] = "Frecuencia 1", 
    [102] = "Frecuencia 2", 
    [103] = "Frecuencia 3", 
    [104] = "Frecuencia SWAT", 
    [105] = "Frecuencia DIC"
}

local frecuenciasMedicos = {
    [200] = "Frecuencia General", 
    [201] = "Entrevistas / Exámenes", 
    [202] = "Médicos de servicio", 
    [203] = "Médicos fuera de servicio"
}

local frecuenciasTaller = {
    [300] = "Frecuencia General", 
    [301] = "Frecuencia 1", 
    [302] = "Frecuencia 2", 
    [303] = "Frecuencia 3"
}

local frecuenciasNoticias = {
    [400] = "Frecuencia General", 
    [401] = "Frecuencia 1", 
    [402] = "Frecuencia 2"
}

local frecuenciasGobierno = {
    [500] = "Frecuencia General", 
    [501] = "Frecuencia 1", 
    [502] = "Frecuencia 2"
}

local frecuenciasJusticia = {
    [600] = "Frecuencia General", 
    [601] = "Frecuencia 1", 
    [602] = "Frecuencia 2"
}

local frecuenciasTTL = {
    [700] = "Frecuencia General", 
    [701] = "Camión 1", 
    [702] = "Camión 2"
}

local frecuenciasAutobuses = {
    [800] = "Frecuencia General", 
    [801] = "Frecuencia Ruta 1", 
    [802] = "Frecuencia Ruta 2"
}

local screenW, screenH = guiGetScreenSize()
local px, py = screenW, screenH

-- Variables para el GUI de frecuencias
local vMisFrecuencias = nil
local gridlistFrecuencias = nil
local bConectarFrecuencias = nil
local bCerrarFrecuencias = nil

-- Función para abrir el menú de frecuencias
function abrirMisFrecuencias(datosF)
    if vMisFrecuencias and isElement(vMisFrecuencias) then
        cerrarMisFrecuencias()
        return
    end
    
    showCursor(true)
    vMisFrecuencias = guiCreateWindow((px/2)-(386/2), (py/2)-(457/2), 386, 457, "Mis frecuencias disponibles", false)
    guiWindowSetSizable(vMisFrecuencias, false)
    bConectarFrecuencias = guiCreateButton(223, 396, 153, 51, "Conectar a frecuencia", false, vMisFrecuencias)
    bCerrarFrecuencias = guiCreateButton(10, 399, 153, 48, "Cerrar", false, vMisFrecuencias)
    addEventHandler("onClientGUIClick", bConectarFrecuencias, botonPulsadoMisFrecuencias)
    addEventHandler("onClientGUIClick", bCerrarFrecuencias, botonPulsadoMisFrecuencias)
    gridlistFrecuencias = guiCreateGridList(10, 36, 366, 340, false, vMisFrecuencias)
    guiGridListAddColumn(gridlistFrecuencias, "ID frecuencia", 0.2)
    guiGridListAddColumn(gridlistFrecuencias, "Nombre frecuencia", 0.75)
    
    local filaID = 0
    guiGridListAddRow(gridlistFrecuencias)
    guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-1", false, false)
    guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Apagar canal de voz", false, false)
    filaID = filaID + 1
    
    -- Agregar frecuencias según las facciones del jugador
    for key, fID in ipairs(datosF) do
        if fID == 1 then -- Policía
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Policía", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasPolicia) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 2 then -- Médicos
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Médicos", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasMedicos) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 3 then -- Taller
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Taller", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasTaller) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 4 then -- Noticias
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Noticias", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasNoticias) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 5 then -- Gobierno
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Gobierno", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasGobierno) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 6 then -- Justicia
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Justicia", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasJusticia) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 7 then -- Transporte
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Transporte", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasTTL) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        elseif fID == 8 then -- Autobuses
            guiGridListAddRow(gridlistFrecuencias)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
            guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Autobuses", false, false)
            filaID = filaID + 1
            for k, v in pairs(frecuenciasAutobuses) do
                guiGridListAddRow(gridlistFrecuencias)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
                guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
                filaID = filaID + 1
            end
        end
    end
end
addEvent("onAbrirMisFrecuencias", true)
addEventHandler("onAbrirMisFrecuencias", resourceRoot, abrirMisFrecuencias)

function cerrarMisFrecuencias()
    if vMisFrecuencias and isElement(vMisFrecuencias) then
        destroyElement(vMisFrecuencias)
        vMisFrecuencias = nil
        showCursor(false)
    end
end
addEvent("onCerrarMisFrecuencias", true)
addEventHandler("onCerrarMisFrecuencias", resourceRoot, cerrarMisFrecuencias)

function botonPulsadoMisFrecuencias()
    if source == bCerrarFrecuencias then
        cerrarMisFrecuencias()
    elseif source == bConectarFrecuencias then
        local row = guiGridListGetSelectedItem(gridlistFrecuencias)
        if row and row >= 0 then
            local frecuenciaID = guiGridListGetItemText(gridlistFrecuencias, row, 1)
            local frecuenciaName = guiGridListGetItemText(gridlistFrecuencias, row, 2)
            if tonumber(frecuenciaID) and tostring(frecuenciaName) then
                showCursor(false)
                triggerServerEvent("onConectarAFrecuencia", localPlayer, tonumber(frecuenciaID), tostring(frecuenciaName))
                cerrarMisFrecuencias()
            else
                outputChatBox("Selecciona una frecuencia válida.", 255, 0, 0)
            end
        else
            outputChatBox("Selecciona una frecuencia de la lista.", 255, 0, 0)
        end
    end
end

-- Sistema de detección de voz para actualizar el icono en el HUD
local voicePlayers = {}
local isVoiceActive = false

-- Inicializar estado de voz
setElementData(localPlayer, "Hype>Voice", false)

-- Actualizar estado de voz cuando el jugador habla
addEventHandler("onClientPlayerVoiceStart", root, function()
    if source and isElement(source) and getElementType(source) == "player" then
        if source == localPlayer then
            -- Actualizar estado de voz para el HUD
            isVoiceActive = true
            setElementData(localPlayer, "Hype>Voice", true)
        end
        voicePlayers[source] = true
    end
end)

addEventHandler("onClientPlayerVoiceStop", root, function()
    if source and isElement(source) and getElementType(source) == "player" then
        if source == localPlayer then
            -- Actualizar estado de voz para el HUD
            isVoiceActive = false
            setElementData(localPlayer, "Hype>Voice", false)
        end
        voicePlayers[source] = nil
    end
end)

-- La voz por proximidad funciona por defecto, no necesitamos cancelar el evento
-- Solo actualizamos el icono del HUD cuando hablas

-- Actualizar el icono de voz cuando cambia la frecuencia
addEventHandler("onClientElementDataChange", root, function(dataName)
    if source == localPlayer and dataName == "frecuencia.voz" then
        local frecuencia = getElementData(localPlayer, "frecuencia.voz")
        if not frecuencia or tonumber(frecuencia) == -1 then
            -- Si no hay frecuencia, asegurar que el icono esté apagado
            if isVoiceActive then
                setElementData(localPlayer, "Hype>Voice", false)
            end
        end
    end
end)

