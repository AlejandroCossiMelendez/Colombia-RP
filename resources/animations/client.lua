-- Sistema de Animaciones y Efectos para Colombia RP
local isAnimating = false
local currentAnimation = nil
local smokeObject = nil
local smokeEffect = nil

-- Función para detener animación actual
function stopCurrentAnimation()
    if isAnimating then
        if currentAnimation then
            setPedAnimation(localPlayer, false)
            currentAnimation = nil
        end
        isAnimating = false
    end
    
    -- Limpiar efectos
    if isElement(smokeObject) then
        destroyElement(smokeObject)
        smokeObject = nil
    end
    
    if isElement(smokeEffect) then
        destroyElement(smokeEffect)
        smokeEffect = nil
    end
end

-- Función para fumar
function startSmoking()
    if isAnimating then
        outputChatBox("Ya estás realizando una animación. Presiona X para detenerla.", 255, 255, 0)
        return
    end
    
    if isPedInVehicle(localPlayer) then
        outputChatBox("No puedes fumar dentro de un vehículo.", 255, 0, 0)
        return
    end
    
    isAnimating = true
    
    -- Animación de fumar
    setPedAnimation(localPlayer, "SMOKING", "M_smklean_loop", -1, true, false, false, false)
    currentAnimation = "smoking"
    
    -- Crear objeto de cigarrillo
    local x, y, z = getElementPosition(localPlayer)
    smokeObject = createObject(3027, x, y, z) -- ID 3027 es un cigarrillo
    setObjectScale(smokeObject, 0.8)
    
    -- Adjuntar cigarrillo a la mano del jugador
    attachElements(smokeObject, localPlayer, 0.05, 0.05, 0.55, 0, 0, 0)
    
    -- Crear efecto de humo usando partículas
    smokeEffect = createEffect("smoke30lit", x, y, z)
    if smokeEffect then
        attachElements(smokeEffect, localPlayer, 0.05, 0.05, 0.55, 0, 0, 0)
    end
    
    outputChatBox("Presiona X para dejar de fumar.", 0, 255, 0)
    
    -- Detener automáticamente después de 30 segundos
    setTimer(function()
        if isAnimating and currentAnimation == "smoking" then
            stopCurrentAnimation()
            outputChatBox("Terminaste de fumar.", 255, 255, 255)
        end
    end, 30000, 1)
end

-- Función para fumar 2 (variante)
function startSmoking2()
    if isAnimating then
        outputChatBox("Ya estás realizando una animación. Presiona X para detenerla.", 255, 255, 0)
        return
    end
    
    if isPedInVehicle(localPlayer) then
        outputChatBox("No puedes fumar dentro de un vehículo.", 255, 0, 0)
        return
    end
    
    isAnimating = true
    
    -- Animación alternativa de fumar
    setPedAnimation(localPlayer, "SMOKING", "M_smk_in", -1, false, false, false, false)
    currentAnimation = "smoking2"
    
    -- Crear objeto de cigarrillo
    local x, y, z = getElementPosition(localPlayer)
    smokeObject = createObject(3027, x, y, z)
    setObjectScale(smokeObject, 0.8)
    
    -- Adjuntar cigarrillo a la mano del jugador (posición diferente)
    attachElements(smokeObject, localPlayer, 0.08, 0.03, 0.5, 0, 0, 0)
    
    -- Crear efecto de humo usando partículas
    smokeEffect = createEffect("smoke30lit", x, y, z)
    if smokeEffect then
        attachElements(smokeEffect, localPlayer, 0.08, 0.03, 0.5, 0, 0, 0)
    end
    
    outputChatBox("Presiona X para dejar de fumar.", 0, 255, 0)
    
    -- Detener automáticamente después de 30 segundos
    setTimer(function()
        if isAnimating and currentAnimation == "smoking2" then
            stopCurrentAnimation()
            outputChatBox("Terminaste de fumar.", 255, 255, 255)
        end
    end, 30000, 1)
end

-- Comando para fumar
addCommandHandler("fumar", function()
    startSmoking()
end)

-- Comando para fumar 2
addCommandHandler("fumar2", function()
    startSmoking2()
end)

-- Detener animación con X
bindKey("x", "down", function()
    if isAnimating then
        stopCurrentAnimation()
        outputChatBox("Animación detenida.", 255, 255, 255)
    end
end)

-- Limpiar al desconectarse
addEventHandler("onClientResourceStop", resourceRoot, function()
    stopCurrentAnimation()
end)

-- Limpiar al morir
addEventHandler("onClientPlayerWasted", localPlayer, function()
    stopCurrentAnimation()
end)

-- El efecto de humo se actualiza automáticamente cuando está adjunto al jugador

