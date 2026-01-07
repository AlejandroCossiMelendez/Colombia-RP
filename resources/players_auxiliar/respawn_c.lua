--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

-- Variables para efectos visuales de headshot
local headshots = 0
local bloodEffects = {}
local playerIsDead = false -- Renombrada para evitar conflicto con la función nativa

-- Función para crear charcos de sangre con efecto visual
function createBloodPool(x, y, z)
    -- Crear un marcador para el charco de sangre
    local bloodPool = createMarker(x, y, z-0.9, "corona", 1.2, 255, 0, 0, 150)
    
    -- Eliminar el charco después de un tiempo
    setTimer(function()
        if isElement(bloodPool) then
            destroyElement(bloodPool)
        end
    end, 30000, 1)
end

-- addEventHandler( "onClientPlayerWasted", localPlayer,
	-- function(atacante, weapon, parte)
		-- cancelEvent()
		-- if getPedOccupiedVehicle(source) and getElementHealth(getPedOccupiedVehicle(source)) == 0 then
			-- return
		-- else
			-- triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, true)
		-- end
	-- end
-- )
                                           
addEventHandler( "onClientPlayerDamage", localPlayer,
	function(atacante, weapon, parte, loss)
		-- Procesamiento especial para headshots (parte 9)
		if parte == 9 and weapon and (weapon >= 22 and weapon <= 38) then
			cancelEvent()
			
			-- Efecto visual de sangre para el headshot
			if headshots == 0 then
				headshots = 1
				local screenW, screenH = guiGetScreenSize()
				blood1 = guiCreateStaticImage(10, (screenW - 386) / 5, 196, 386, "blood_2.png", false)
				blood2 = guiCreateStaticImage(screenW - 631 - 10, (screenH - 425) / 2, 631, 425, "blood_1.png", false)
				
				-- Animar los efectos visuales
				setTimer(fadeBloodIn, 50, 15, blood1)
				setTimer(fadeBloodIn, 50, 15, blood2)
				setTimer(fadeBloodOutStart, 5000, 1, blood1)
				setTimer(fadeBloodOutStart, 5000, 1, blood2)
				setTimer(destroyBlood, 6000, 1, blood1)
				setTimer(destroyBlood, 6000, 1, blood2)
				
				-- Crear charco de sangre en la posición del disparo
				local x, y, z = getPedBonePosition(source, 6) -- 6 es el hueso de la cabeza
				createBloodPool(x, y, z)
				
				-- Limpiar después de un tiempo
				setTimer(function() blood1 = nil; blood2 = nil; headshots = 0; end, 6000, 1)
			end
			
			-- Enviar el daño al servidor para procesarlo como headshot
			triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, true)
			return
		end
	
		if weapon and tonumber(weapon) == 37 then 
			if tonumber(getElementHealth(source)) > 3 then
				return
			else
				cancelEvent()
				if not getElementData(getLocalPlayer(), "muertoQuemado") == true then
					setElementData(getLocalPlayer(), "muertoQuemado", true)
					triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, true)
					setTimer(setElementData, 5000, 1, getLocalPlayer(), "muertoQuemado", false)
				end
			end                             
		else
			if weapon and tonumber(weapon) == 54 then
				if tostring(loss) == "100" and getElementDimension(getLocalPlayer()) > 0 then
					cancelEvent()
					triggerServerEvent("onDesbugAlCaerINT", source)
					return
				elseif tonumber(loss) > tonumber(getElementHealth(getLocalPlayer())) then
					cancelEvent()
					triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, true)
				else
					triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, false)
				end
			else
				cancelEvent()
				if weapon and tonumber(weapon) == 53 then 
					-- Muerto por agua.
					if getElementModel(source) ~= 279 and not getElementData(source, "muertoPorAhogamiento") == true then
						setElementData(source, "muertoPorAhogamiento", true)
						triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, true)
						setTimer(setElementData, 3000, 1, source, "muertoPorAhogamiento", false)
					end
					return
				end
				triggerServerEvent("onSufrirDamageCapitalRP", source, atacante, weapon, parte, false)
			end
		end
	end
)

-- Funciones auxiliares para efectos de sangre
function fadeBloodIn(window)
    if isElement(window) then
        local alpha = guiGetAlpha(window)
        local newalpha = alpha + 0.035
        guiSetAlpha(window, newalpha)
        guiMoveToBack(window)
    end
end

function fadeBloodOutStart(window)
    setTimer(fadeBloodOut, 50, 15, window)
end

function fadeBloodOut(window)
    if isElement(window) then
        local alpha = guiGetAlpha(window)
        local newalpha = alpha - 0.035
        guiSetAlpha(window, newalpha)
    end
end

function destroyBlood(window)
    if isElement(window) then
        destroyElement(window)
    end
end
 
addEventHandler("onClientVehicleExplode", getRootElement(), function()
	cancelEvent()
	for seat, player in pairs(getVehicleOccupants(source)) do
		triggerServerEvent("onSolicitarGuardarArmas", player, player)
		removePedFromVehicle(player)
		setTimer(triggerServerEvent, 1500, 1, "onSufrirDamageCapitalRP", player, player, 51, 3, true)
	end
	triggerServerEvent("onDesvolcarVehiculo", source, getLocalPlayer())
end)

function abortAllStealthKills()
    cancelEvent()
end
addEventHandler("onClientPlayerStealthKill", getLocalPlayer(), abortAllStealthKills)

local respawnKeys = { 'e' }
local respawnWait = false
local localPlayer = getLocalPlayer()
local screenX, screenY = guiGetScreenSize()

function drawRespawnText()
	local text = "Pulsa '" .. respawnKeys[1] .. "' para reaparecer"
	
	if respawnWait then
		local diff = respawnWait - getTickCount()
		if diff >= 0 then
			text = ( "Espera %.1f segundos para reaparecer o avisa y espera a los médicos (/avisarsura)" ):format( diff / 1000 )
		else
			for _, key in ipairs(respawnKeys) do
				if getKeyState(key) then
					requestRespawn()
					break
				end
			end
		end

		-- Dibujar la sombra del texto para mejorar la visibilidad
		local fontSize = 1.2  -- Reducido para evitar que el texto sea demasiado grande
		dxDrawText(text, 2, 2, screenX, screenY, tocolor(0, 0, 0, 255), fontSize, "pricedown", "center", "center") -- Sombra suave
		dxDrawText(text, -2, -2, screenX, screenY, tocolor(0, 0, 0, 255), fontSize, "pricedown", "center", "center") -- Sombra opuesta
		dxDrawText(text, 0, 0, screenX, screenY, tocolor(255, 255, 255, 255), fontSize, "pricedown", "center", "center") -- Texto principal
	end
end

addEvent("onClientMuertoCapitalRP", true)
addEventHandler("onClientMuertoCapitalRP", localPlayer, function()
	setCameraTarget(localPlayer)
	respawnWait = getTickCount() + 240000
	triggerEvent("onResetAFKTime", getLocalPlayer(), -900)
	addEventHandler("onClientRender", root, drawRespawnText)
	playerIsDead = true
	
	-- Asegurarse de que el jugador pueda chatear cuando está muerto
	toggleControl("chatbox", true)  -- Permitir uso del chat
	toggleControl("chat", true)     -- Permitir comandos
	
	-- Mensaje actualizado para reflejar que pueden usar el chat normalmente
	outputChatBox("Estás muerto. Puedes usar el chat OOC (/b) normalmente.", 255, 0, 0)
end)


addEvent("onClientNoMuerto", true)
addEventHandler("onClientNoMuerto", localPlayer, function()
    -- Restablecer la cámara
    setCameraTarget(localPlayer, localPlayer)
    respawnWait = false
    removeEventHandler("onClientRender", root, drawRespawnText)
    setPedHeadless(localPlayer, false)
    
    -- Marcar al jugador como vivo para el sistema de chat
    playerIsDead = false
    
    -- IMPORTANTE: Asegurarse de que todos los controles estén habilitados
    setTimer(function()
        toggleAllControls(true)
        setPedAnimation(localPlayer, false) -- Detener cualquier animación
    end, 100, 1)
    
    -- Segunda verificación para asegurar que los controles estén habilitados
    setTimer(function()
        toggleAllControls(true)
        setPedAnimation(localPlayer, false)
    end, 1000, 1)
    
    -- Tercera verificación final
    setTimer(function()
        toggleAllControls(true)
        setPedAnimation(localPlayer, false)
        outputChatBox("Si todavía no puedes moverte, escribe /liberarme", 255, 255, 0)
    end, 3000, 1)
end)

-- Evento específico para reanimación médica
addEvent("onClientMedicRevive", true)
addEventHandler("onClientMedicRevive", localPlayer, function()
    -- Resetear estado de muerte
    playerIsDead = false
    respawnWait = false
    removeEventHandler("onClientRender", root, drawRespawnText)
    setCameraTarget(localPlayer, localPlayer)
    setPedHeadless(localPlayer, false)
    
    -- MÉTODO DE DESBLOQUEO AGRESIVO
    -- Reset inmediato de controles
    toggleAllControls(true)
    setPedAnimation(localPlayer, false)
    
    -- Desactivar cualquier congelamiento
    setElementFrozen(localPlayer, false)
    
    -- Secuencia de desbloqueos espaciados
    for i = 1, 20 do
        setTimer(function()
            -- Verificar que el jugador exista y siga en el juego
            if isElement(localPlayer) then
                -- Desbloquear controles
                toggleAllControls(true)
                
                -- Detener cualquier animación
                setPedAnimation(localPlayer, false)
                
                -- Descongelar al jugador
                setElementFrozen(localPlayer, false)
                
                -- En los últimos intentos, mover ligeramente al jugador para forzar el desbloqueo físico
                if i > 15 then
                    local x, y, z = getElementPosition(localPlayer)
                    -- Mover ligeramente al jugador en diferentes direcciones
                    if i % 2 == 0 then
                        setElementPosition(localPlayer, x + 0.02, y, z)
                    else
                        setElementPosition(localPlayer, x, y + 0.02, z)
                    end
                end
            end
        end, i * 250, 1) -- Incrementar el intervalo gradualmente
    end
    
    -- Crear un indicador visual para feedback al jugador
    outputChatBox("Has sido reanimado por un médico.", 0, 255, 0)
    outputChatBox("Si no puedes moverte, pulsa la tecla F para entrar/salir de vehículos varias veces.", 255, 255, 0)
    outputChatBox("También puedes intentar usar /liberarme", 255, 255, 0)
    
    -- Establecer un timer final para verificar que todo está bien
    setTimer(function()
        if isElement(localPlayer) then
            local health = getElementHealth(localPlayer)
            if health > 0 and health <= 20 then
                -- El jugador ha sido reanimado pero sigue con poca vida
                outputChatBox("Sigues vivo pero gravemente herido. Busca atención médica.", 255, 165, 0)
            end
            
            -- Asegurar una última vez que los controles están habilitados
            toggleAllControls(true)
            setPedAnimation(localPlayer, false)
        end
    end, 10000, 1)
end)

function requestRespawn()
	removeEventHandler("onClientRender", root, drawRespawnText)
	triggerServerEvent("onPlayerRespawn", localPlayer)
	playerIsDead = false -- Asegurarse de que el jugador ya no está marcado como muerto
end


function handleVehicleDamage(attacker, weapon, loss, x, y, z, tire)
    if attacker and not tire and source and getElementModel(source) ~= 471 then
        cancelEvent()
		local actualHP = getElementHealth(source)
		setElementHealth(source, actualHP-20)
    end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)
addEventHandler("onClientRender", root, function()
    if respawnWait then
        local diff = respawnWait - getTickCount()
        if getElementHealth(localPlayer) > 1 then
            -- Si el jugador es revivido antes del tiempo, eliminar la espera
            removeEventHandler("onClientRender", root, drawRespawnText)
            setCameraTarget(localPlayer, localPlayer)
            respawnWait = false
            playerIsDead = false
        end
    end
    
    -- Asegurar que los controles de chat siempre estén disponibles si el jugador está muerto
    if playerIsDead or getElementData(localPlayer, "muerto") then
        toggleControl("chatbox", true)
        toggleControl("chat", true)
    end
end)

-- Función auxiliar para rehabilitar controles de chat
function rehabilitarChat()
    -- MODIFICACIÓN IMPORTANTE: No desactivamos controles de movimiento cuando el jugador está reanimado
    if playerIsDead or getElementData(localPlayer, "muerto") then
        -- Verificar si el jugador realmente debería seguir considerándose muerto
        if getElementHealth(localPlayer) > 10 then
            -- Si el jugador tiene más de 10 de salud, probablemente ya no está muerto
            playerIsDead = false
            setElementData(localPlayer, "muerto", nil)
            toggleAllControls(true)
            return
        end
        
        -- CAMBIO IMPORTANTE: Ya no bloqueamos controles de movimiento, solo habilitamos chat
        toggleControl("chatbox", true)
        toggleControl("chat", true)
    end
end

-- Intentar rehabilitar constantemente los controles de chat para jugadores muertos
setTimer(rehabilitarChat, 500, 0)

-- Tecla de emergencia para desbloquear controles (F8)
function emergencyUnlock()
    outputChatBox("¡DESBLOQUEO DE EMERGENCIA ACTIVADO!", 255, 0, 0)
    
    -- Limpiar estados
    playerIsDead = false
    setElementData(localPlayer, "muerto", nil)
    setElementData(localPlayer, "recogido", nil)
    setElementData(localPlayer, "accidente", nil)
    
    -- Restaurar controles y movimiento
    toggleAllControls(true)
    setPedAnimation(localPlayer, false)
    setElementFrozen(localPlayer, false)
    
    -- Mover ligeramente al jugador para resetear física
    local x, y, z = getElementPosition(localPlayer)
    setElementPosition(localPlayer, x + 0.05, y + 0.05, z)
    
    -- Notificar al servidor
    triggerServerEvent("onEmergencyUnlock", localPlayer)
    
    outputChatBox("Controles restablecidos. Si esto arregló tu problema, por favor notifica a un administrador.", 0, 255, 0)
end
bindKey("F8", "down", emergencyUnlock)

-- Evento para asegurar compatibilidad con sistemas externos
addEvent("onClientRestoreControls", true)
addEventHandler("onClientRestoreControls", localPlayer, function()
    -- Asegurar que el jugador está completamente desbloqueado
    playerIsDead = false
    toggleAllControls(true)
    setPedAnimation(localPlayer, false)
    setCameraTarget(localPlayer, localPlayer)
    
    -- Descongelar jugador y restaurar controles
    setElementFrozen(localPlayer, false)
    toggleAllControls(true)
    
    -- Segundo intento con delay
    setTimer(function()
        toggleAllControls(true)
        setPedAnimation(localPlayer, false)
    end, 500, 1)
end)

-- Hacer la variable playerIsDead accesible a través de eventos
addEvent("onClientCheckDeadStatus", true)
addEventHandler("onClientCheckDeadStatus", localPlayer, function()
    triggerServerEvent("onServerReceiveDeadStatus", localPlayer, playerIsDead)
end)

-- Evento para forzar la restauración de cámara
addEvent("onClientRestoreCamera", true)
addEventHandler("onClientRestoreCamera", localPlayer, function()
    setCameraTarget(localPlayer, localPlayer)
end)

-- Evento para servir como punto de diagnóstico
addEvent("onClientPerformDiagnostic", true)
addEventHandler("onClientPerformDiagnostic", localPlayer, function()
    local playerHealth = getElementHealth(localPlayer)
    local playerState = {
        health = playerHealth,
        isDead = playerIsDead,
        isDying = playerHealth <= 20,
        isMuertoState = getElementData(localPlayer, "muerto"),
        hasCamera = getCameraTarget() == localPlayer,
        position = {getElementPosition(localPlayer)},
        animations = isPedDucked(localPlayer) or isPedInVehicle(localPlayer)
    }
    
    triggerServerEvent("onServerReceiveDiagnostic", localPlayer, playerState)
end)

-- Comprobador periódico para asegurar sincronización del estado de muerte
setTimer(function()
    if isElement(localPlayer) then
        -- Verificar si hay discrepancia entre nuestra variable y el estado real
        local reallyDead = isPedDead(localPlayer)
        local muertoState = getElementData(localPlayer, "muerto")
        
        -- Si el jugador está realmente muerto pero no lo tenemos marcado
        if reallyDead and not playerIsDead and not muertoState then
            outputDebugString("[SISTEMA] Sincronizando estado: jugador realmente muerto pero no marcado")
            playerIsDead = true
            setElementData(localPlayer, "muerto", true)
            -- Activar la interfaz de muerte
            triggerEvent("onClientMuertoCapitalRP", localPlayer)
        end
        
        -- Si el jugador no está realmente muerto pero lo tenemos marcado
        if not reallyDead and playerIsDead and getElementHealth(localPlayer) > 20 then
            outputDebugString("[SISTEMA] Sincronizando estado: jugador vivo pero marcado como muerto")
            playerIsDead = false
            setElementData(localPlayer, "muerto", nil)
            -- Restaurar controles
            toggleAllControls(true)
            setPedAnimation(localPlayer, false)
        end
    end
end, 2000, 0)  -- Comprobar cada 2 segundos