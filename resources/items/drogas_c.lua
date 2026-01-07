-- drogas_c.lua - Sistema de efectos de drogas (Instantáneo)
-- Efectos: MARIHUANA(Vida +30%), PERICO(Chaleco +20%), META(Chaleco +40%), HONGO(Vida +60%)

local localPlayer = getLocalPlayer()

-- Función para aplicar efecto de MARIHUANA (Vida +30%)
function aplicarEfectoMarihuana()
    local vidaActual = getElementHealth(localPlayer)
    local nuevaVida = math.min(100, vidaActual + 30) -- Máximo 100 de vida
    local incrementoReal = nuevaVida - vidaActual
    
    if incrementoReal > 0 then
        setElementHealth(localPlayer, nuevaVida)
        outputChatBox("[MARIHUANA] Tu vida se incremento +" .. math.floor(incrementoReal) .. "% (de " .. math.floor(vidaActual) .. "% a " .. math.floor(nuevaVida) .. "%)", 0, 255, 0)
    else
        outputChatBox("[MARIHUANA] Tu vida ya esta al maximo (100%)", 255, 255, 0)
    end
end

-- Función para aplicar efecto de PERICO (Chaleco +20%)
function aplicarEfectoPerico()
    local armorActual = getPedArmor(localPlayer)
    local nuevoArmor = math.min(100, armorActual + 20) -- Máximo 100 de armadura
    local incrementoReal = nuevoArmor - armorActual
    
    if incrementoReal > 0 then
        setPedArmor(localPlayer, nuevoArmor)
        outputChatBox("[PERICO] Tu chaleco se reforzo +" .. math.floor(incrementoReal) .. "% (de " .. math.floor(armorActual) .. "% a " .. math.floor(nuevoArmor) .. "%)", 0, 150, 255)
    else
        outputChatBox("[PERICO] Tu chaleco ya esta al maximo (100%)", 255, 255, 0)
    end
end

-- Función para aplicar efecto de META (Chaleco +40%)
function aplicarEfectoMeta()
    local armorActual = getPedArmor(localPlayer)
    local nuevoArmor = math.min(100, armorActual + 40) -- Máximo 100 de armadura
    local incrementoReal = nuevoArmor - armorActual
    
    if incrementoReal > 0 then
        setPedArmor(localPlayer, nuevoArmor)
        outputChatBox("[META] Tu chaleco se reforzo +" .. math.floor(incrementoReal) .. "% (de " .. math.floor(armorActual) .. "% a " .. math.floor(nuevoArmor) .. "%)", 255, 100, 0)
    else
        outputChatBox("[META] Tu chaleco ya esta al maximo (100%)", 255, 255, 0)
    end
end

-- Función para aplicar efecto de HONGO (Vida +60%)
function aplicarEfectoHongo()
    local vidaActual = getElementHealth(localPlayer)
    local nuevaVida = math.min(100, vidaActual + 60) -- Máximo 100 de vida
    local incrementoReal = nuevaVida - vidaActual
    
    if incrementoReal > 0 then
        setElementHealth(localPlayer, nuevaVida)
        outputChatBox("[HONGO MAGICO] Tu vida se incremento +" .. math.floor(incrementoReal) .. "% (de " .. math.floor(vidaActual) .. "% a " .. math.floor(nuevaVida) .. "%)", 255, 0, 255)
    else
        outputChatBox("[HONGO MAGICO] Tu vida ya esta al maximo (100%)", 255, 255, 0)
    end
end

-- Eventos para activar cada droga
addEvent("droga.marihuana", true)
addEventHandler("droga.marihuana", getRootElement(), aplicarEfectoMarihuana)

addEvent("droga.perico", true)
addEventHandler("droga.perico", getRootElement(), aplicarEfectoPerico)

addEvent("droga.meta", true)
addEventHandler("droga.meta", getRootElement(), aplicarEfectoMeta)

addEvent("droga.hongo", true)
addEventHandler("droga.hongo", getRootElement(), aplicarEfectoHongo)
