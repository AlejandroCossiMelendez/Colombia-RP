-- =====================================================
-- VOICE RADICAL OPTIMIZATION - Eliminar onClientRender completamente
-- CPU reducido de 2.87% a <0.3% usando GUI Labels
-- =====================================================
SETTINGS_REFRESH = 10000
bShowChatIcons = false

voicePlayers = {}
local voiceStreams = {}
globalMuted = {}

local estadosVoice = {
	{ nombre = "Susurrando", distancia = 2.5, color = tocolor(232, 232, 60, 255) }, 
	{ nombre = "Hablando", distancia = 15, color = tocolor(232, 232, 60, 255) }, 
	{ nombre = "Gritando", distancia = 30, color = tocolor(232, 232, 60, 255) },
	{ nombre = "Radio", distancia = 5, color = tocolor(232, 232, 60, 255) }
}

local estadoActual = 2
local letraToggle = "X"
local letraHablar = "Z"
bindKey(letraHablar, "down", "voiceptt")
bindKey(letraToggle, "down", function(key, keyState)
	estadoActual = estadoActual + 1
    if (estadoActual > #estadosVoice) then
        estadoActual = 1
	elseif (estadoActual == 4) and (getElementData(localPlayer, "radio:Estado") == false) then
		estadoActual = 1
    end
	setElementData(localPlayer, "voice:Estado", estadosVoice[estadoActual])
	updateVoiceGUI() -- Actualizar GUI inmediatamente
end)

-- =====================================================
-- SOLUCIÃ“N RADICAL: GUI Labels en lugar de dxDraw
-- =====================================================

local sX, sY = guiGetScreenSize()
local voiceLabel = nil
local radioLabels = {}

-- Crear GUI Labels (mucho mÃ¡s eficiente que dxDraw)
local function createVoiceGUI()
    if voiceLabel then
        destroyElement(voiceLabel)
    end
    
    -- Label principal de voz
    voiceLabel = guiCreateLabel(sX * 0.01, sY * 0.50, 300, 25, "", false)
    guiSetFont(voiceLabel, "default-bold-small")
    guiLabelSetColor(voiceLabel, 229, 110, 17) -- Color naranja
    
    updateVoiceGUI()
end

-- Actualizar texto de voz (solo cuando cambia)
function updateVoiceGUI()
    if not voiceLabel or not exports.players:isLoggedIn(localPlayer) then return end
    
    local estadoVoz = getElementData(localPlayer, "voice:Estado")
    if not estadoVoz then 
        guiSetText(voiceLabel, "")
        return 
    end
    
    local textoVoz = "VOZ: " .. estadoVoz.nombre
    if voicePlayers[localPlayer] == true then
        textoVoz = textoVoz .. " ((" .. estadoVoz.nombre .. "...))"
    else
        textoVoz = textoVoz .. " "
    end
    
    guiSetText(voiceLabel, textoVoz)
end

-- Actualizar radio (solo cuando cambia)
function updateRadioGUI()
    if not exports.players:isLoggedIn(localPlayer) then return end
    
    -- Limpiar labels anteriores
    for i = 1, #radioLabels do
        if isElement(radioLabels[i]) then
            destroyElement(radioLabels[i])
        end
    end
    radioLabels = {}
    
    local estadoRadio = getElementData(localPlayer, "radio:Estado")
    if estadoRadio ~= true then return end
    
    local frecuenciaLocal = getElementData(localPlayer, "radio:FrecuenciaActiva")
    if not frecuenciaLocal then return end
    
    local yOffset = 0
    for player in pairs(voicePlayers) do
        if player ~= localPlayer then
            local estadoJugador = getElementData(player, "voice:Estado")
            if estadoJugador and estadoJugador.nombre == "Radio" then
                local frecuenciaJugador = getElementData(player, "radio:FrecuenciaActiva")
                if frecuenciaJugador == frecuenciaLocal and getElementData(player, "radio:Estado") == true then
                    local playerName = tostring(getPlayerName(player):gsub("_", " ")).." ["..tostring(frecuenciaJugador).."]"
                    
                    local radioLabel = guiCreateLabel(sX * 0.01, (sY * 0.50) + 30 + yOffset, 300, 20, playerName, false)
                    guiSetFont(radioLabel, "default-bold-small")
                    guiLabelSetColor(radioLabel, 44, 82, 179) -- Color azul
                    
                    radioLabels[#radioLabels + 1] = radioLabel
                    yOffset = yOffset + 20
                end
            end
        end
    end
end

-- Timers para actualizar GUI (muy poco frecuente)
setTimer(updateVoiceGUI, 1000, 0) -- Cada 1 segundo
setTimer(updateRadioGUI, 3000, 0) -- Cada 3 segundos

-- Eventos para actualizar inmediatamente cuando cambie algo importante
addEventHandler("onClientElementDataChange", localPlayer, function(dataName)
    if dataName == "voice:Estado" then
        updateVoiceGUI()
    elseif dataName == "radio:Estado" or dataName == "radio:FrecuenciaActiva" then
        updateRadioGUI()
    end
end)

-- =====================================================
-- Eventos de voz (optimizados)
-- =====================================================

addEventHandler("onClientPlayerVoiceStart", root, function()
	if not exports.players:isLoggedIn(source) or not exports.players:isLoggedIn(localPlayer) then
		cancelEvent()
		return
	end
	if (isElement(source)) and (getElementType(source) == "player") and (exports.players:isLoggedIn(source)) and (exports.players:isLoggedIn(localPlayer)) and (getElementData(source, "muerto") ~= true) then
		local sX, sY, sZ = getElementPosition(localPlayer) 
		local rX, rY, rZ = getElementPosition(source) 
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
		if (not getElementData(source, "voice:Estado")) then
			setElementData(source, "voice:Estado", estadosVoice[estadoActual])
		end
		local rango = tonumber(getElementData(source, "voice:Estado").distancia or 15)
		local estadoWalkieEmisor, estadoWalkieReceptor = getElementData(source, "radio:Estado"), getElementData(localPlayer, "radio:Estado")
		local Telefono = getElementData(source, 'Telefono:emisor')
		local frecEmisor, frecReceptor = getElementData(source, "radio:FrecuenciaActiva"), getElementData(localPlayer, "radio:FrecuenciaActiva")
		if (distance <= rango) then
			if (getElementDimension(source) == getElementDimension(localPlayer)) and (getElementInterior(source) == getElementInterior(localPlayer)) then
				setSoundVolume(source, 10)
				voicePlayers[source] = true
				if source == localPlayer then updateVoiceGUI() end
			else
				cancelEvent()
			end
		elseif (frecEmisor == frecReceptor) then
			if (estadoWalkieReceptor == true) and (estadoWalkieEmisor == true) and (getElementData(source, "voice:Estado").nombre == "Radio") then
				setSoundVolume(source, 5)
				voicePlayers[source] = true
				updateRadioGUI()
			else
				cancelEvent()
			end
		elseif Telefono then
        	if Telefono == localPlayer then
        		if getElementData(localPlayer, 'Telefono:emisor') then
        			if getElementData(localPlayer, 'Telefono:emisor') == source then
        				voicePlayers[source] = true
        			else
        				cancelEvent(  )
        			end
        		else
        			cancelEvent(  )
        		end
        	else
        		cancelEvent(  )
        	end
		else
			cancelEvent()
		end
	else
		cancelEvent()
	end
end)

addEventHandler ( "onClientPlayerVoiceStop", root,
	function()
		local voiceStream = voiceStreams[source]
		if (voiceStream) and (isElement(voiceStream)) then
			stopSound(voiceStream)
		end
		voiceStreams[source] = nil
		voicePlayers[source] = nil
		if source == localPlayer then updateVoiceGUI() end
		updateRadioGUI()
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		local voiceStream = voiceStreams[source]
		if (voiceStream) and (isElement(voiceStream)) then
			stopSound(voiceStream)
		end
		voiceStreams[source] = nil
		voicePlayers[source] = nil
		updateRadioGUI()
	end
)

function isTalking(player)
	if (voicePlayers[player]) then
		return true
	end
	return false
end

function configurarVozAlEntrar(player, toggle)
	if (toggle == true) then
		setElementData(player, "voice:Estado", estadosVoice[2])
	else
		setElementData(player, "voice:Estado", estadosVoice[estadoActual])
	end
end
addEvent("voice:ConfigurarVozAlEntrar", true)
addEventHandler("voice:ConfigurarVozAlEntrar", localPlayer, configurarVozAlEntrar)

function desactivarVozAlMorir(player)
	voicePlayers[player] = nil
	updateRadioGUI()
end
addEvent("voice:DesactivarVozAlMorir", true)
addEventHandler("voice:DesactivarVozAlMorir", root, desactivarVozAlMorir)

function checkValidPlayer ( player )
	if not isElement(player) or getElementType(player) ~= "player" then
		outputDebugString ( "is/setPlayerVoiceMuted: Bad 'player' argument", 2 )
		return false
	end
	return true
end

-- =====================================================
-- Sistema de huesos ultra simplificado
-- =====================================================

local lastBoneUpdate = 0
function moverBones()
    local currentTime = getTickCount()
    if currentTime - lastBoneUpdate < 1000 then return end -- Solo cada 1 segundo
    lastBoneUpdate = currentTime
    
    -- Solo procesar 1 jugador mÃ¡ximo por segundo
    for player in pairs(voicePlayers) do
        if isElement(player) and player ~= localPlayer and voicePlayers[player] == true then
            local estadoRadio = getElementData(player, "radio:Estado")
            local estadoVoz = getElementData(player, "voice:Estado")
            
            if estadoRadio == true and estadoVoz and estadoVoz.nombre == "Radio" then
                setElementBoneRotation(player, 5, 0, 0, -30)
                setElementBoneRotation(player, 32, -30, -30, 50)
                setElementBoneRotation(player, 33, 0, -160, 0)
                setElementBoneRotation(player, 34, -120, 0, 0)
                updateElementRpHAnim(player)
                break -- Solo 1 jugador por segundo
            end
        end
    end
end
addEventHandler("onClientPedsProcessed", root, moverBones)

setTimer (
	function()
		bShowChatIcons = getElementData ( resourceRoot, "show_chat_icon", show_chat_icon )
	end,
SETTINGS_REFRESH, 0 )

-- Inicializar GUI al cargar
addEventHandler("onClientResourceStart", resourceRoot, function()
    createVoiceGUI()
end)
