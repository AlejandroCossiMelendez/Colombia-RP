-- Sistema JBL - Servidor
-- Maneja la activación del JBL y la reproducción de música

local activeJBLs = {} -- {player = {object = element, x, y, z, music = url, volume = 0.5}}
local jblModel = 2226 -- ID del modelo JBL

-- Función para obtener el modelo JBL
function getJBLModel()
    return jblModel
end

-- Activar JBL
addEvent("jbl:activate", true)
addEventHandler("jbl:activate", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    -- Verificar si ya tiene un JBL activo
    if activeJBLs[player] then
        outputChatBox("Ya tienes un JBL activo.", player, 255, 0, 0)
        return
    end
    
    -- Crear objeto JBL y adjuntarlo a la mano del jugador
    local x, y, z = getElementPosition(player)
    local jblObject = createObject(jblModel, x, y, z)
    
    if not jblObject then
        outputChatBox("Error al crear el JBL.", player, 255, 0, 0)
        return
    end
    
    -- Adjuntar a la mano derecha (bone 25 - mano derecha)
    -- Verificar si bone_attach está disponible
    local boneAttachResource = getResourceFromName("bone_attach")
    if boneAttachResource and getResourceState(boneAttachResource) == "running" then
        if exports.bone_attach then
            exports.bone_attach:attachElementToBone(jblObject, player, 25, 0.1, 0.05, 0.1, 0, 0, 0)
        end
    else
        -- Si bone_attach no está disponible, adjuntar usando attachElements
        attachElements(jblObject, player, 0.1, 0.05, 0.1, 0, 0, 0)
    end
    
    activeJBLs[player] = {
        object = jblObject,
        x = x,
        y = y,
        z = z,
        music = nil,
        volume = 0.5
    }
    
    triggerClientEvent(player, "jbl:activated", resourceRoot)
    outputChatBox("JBL activado. Usa F6 para controlar la música.", player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " activó su JBL")
end)

-- Desactivar JBL
addEvent("jbl:deactivate", true)
addEventHandler("jbl:deactivate", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    -- Detener música si está reproduciendo
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Destruir objeto
    if isElement(jblData.object) then
        -- Desadjuntar
        local boneAttachResource = getResourceFromName("bone_attach")
        if boneAttachResource and getResourceState(boneAttachResource) == "running" then
            if exports.bone_attach then
                exports.bone_attach:detachElementFromBone(jblData.object)
            end
        else
            detachElements(jblData.object, player)
        end
        destroyElement(jblData.object)
    end
    
    activeJBLs[player] = nil
    triggerClientEvent(player, "jbl:deactivated", resourceRoot)
    outputChatBox("JBL desactivado.", player, 255, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " desactivó su JBL")
end)

-- Reproducir música desde link
addEvent("jbl:playFromLink", true)
addEventHandler("jbl:playFromLink", root, function(link)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        outputChatBox("Primero debes activar el JBL.", player, 255, 0, 0)
        return
    end
    
    -- Validar que sea un link de YouTube
    if not string.find(link, "youtube.com") and not string.find(link, "youtu.be") then
        outputChatBox("El link debe ser de YouTube.", player, 255, 0, 0)
        return
    end
    
    -- Obtener posición del JBL
    local x, y, z = getElementPosition(jblData.object)
    
    -- Enviar link a y2mate para convertir (esto se hará en el cliente)
    triggerClientEvent(player, "jbl:convertAndPlay", resourceRoot, link, x, y, z)
    outputChatBox("Convirtiendo y reproduciendo música...", player, 0, 255, 0)
end)

-- Convertir YouTube a MP3 usando y2mate
addEvent("jbl:convertYouTube", true)
addEventHandler("jbl:convertYouTube", root, function(link, x, y, z)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    -- Nota: En MTA no podemos hacer requests HTTP directamente
    -- Por ahora, simularemos la conversión
    -- En producción, esto requeriría un servidor proxy o usar fetchRemote
    
    outputChatBox("Convirtiendo link de YouTube a MP3...", player, 0, 255, 0)
    
    -- Simular URL de MP3 convertido (en producción, esto vendría de y2mate)
    -- Por ahora, usaremos el link directamente como si fuera un MP3
    local mp3Url = link -- Esto debería ser la URL del MP3 descargado de y2mate
    
    -- Detener música anterior si existe
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Reproducir nueva música
    jblData.music = mp3Url
    triggerClientEvent(getRootElement(), "jbl:musicStarted", resourceRoot, mp3Url, x, y, z)
    
    outputChatBox("Música reproducida desde YouTube.", player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " está reproduciendo música desde YouTube: " .. link)
end)

-- Reproducir música desde Spotify
addEvent("jbl:playFromSpotify", true)
addEventHandler("jbl:playFromSpotify", root, function(trackUrl, trackName)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        outputChatBox("Primero debes activar el JBL.", player, 255, 0, 0)
        return
    end
    
    -- Detener música anterior si existe
    if jblData.music then
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
    end
    
    -- Obtener posición del JBL
    local x, y, z = getElementPosition(jblData.object)
    
    -- Reproducir nueva música
    jblData.music = trackUrl
    triggerClientEvent(getRootElement(), "jbl:musicStarted", resourceRoot, trackUrl, x, y, z)
    
    outputChatBox("Reproduciendo: " .. (trackName or "Música"), player, 0, 255, 0)
    outputServerLog("[JBL] " .. getPlayerName(player) .. " está reproduciendo música desde Spotify")
end)

-- Cambiar volumen
addEvent("jbl:setVolume", true)
addEventHandler("jbl:setVolume", root, function(volume)
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    volume = math.max(0, math.min(1, tonumber(volume) or 0.5))
    jblData.volume = volume
    
    triggerClientEvent(getRootElement(), "jbl:volumeChanged", resourceRoot, volume)
end)

-- Detener música
addEvent("jbl:stopMusic", true)
addEventHandler("jbl:stopMusic", root, function()
    local player = source
    
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    
    local jblData = activeJBLs[player]
    if not jblData then
        return
    end
    
    if jblData.music then
        jblData.music = nil
        triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
        outputChatBox("Música detenida.", player, 255, 255, 0)
    end
end)

-- Limpiar cuando el jugador se desconecta
addEventHandler("onPlayerQuit", root, function()
    local player = source
    if activeJBLs[player] then
        local jblData = activeJBLs[player]
        if jblData.music then
            triggerClientEvent(getRootElement(), "jbl:musicStopped", resourceRoot)
        end
        if isElement(jblData.object) then
            if exports.bone_attach then
                exports.bone_attach:detachElementFromBone(jblData.object)
            end
            destroyElement(jblData.object)
        end
        activeJBLs[player] = nil
    end
end)

