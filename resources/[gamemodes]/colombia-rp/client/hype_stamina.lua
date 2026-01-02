--[[
Hype Stamina adaptado para Colombia RP
Sistema de stamina que se reduce al correr y se recupera al descansar
--]]

function isElementMoving(theElement)
    if isElement(theElement) then                    
        local x, y, z = getElementVelocity(theElement) 
        return x ~= 0 or y ~= 0 or z ~= 0      
    end
 
    return false
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

-- Inicializar stamina al spawnear
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    if getElementData(localPlayer, "character:selected") then
        if not getElementData(localPlayer, "stamina") then
            setElementData(localPlayer, "stamina", 100)
        end
    end
end)

-- Evento desde el servidor para inicializar stamina
addEvent("initializeStamina", true)
addEventHandler("initializeStamina", resourceRoot, function()
    if getElementData(localPlayer, "character:selected") then
        if not getElementData(localPlayer, "stamina") then
            setElementData(localPlayer, "stamina", 100)
        end
    end
end)

function checkMoving()
    -- Solo funcionar si hay un personaje seleccionado
    if not getElementData(localPlayer, "character:selected") then
        return
    end
    
    if not getPedOccupiedVehicle(localPlayer) then
        local speed = getElementSpeed(localPlayer)
        local staminalevel = tonumber(getElementData(localPlayer, "stamina") or 100)
        
        -- Diferencia entre trotar y correr basado en la velocidad
        -- Caminar: < 5.1 (no consume stamina)
        -- Trotar: 5.1 - 8.5 (consume poco)
        -- Correr: > 8.5 (consume más)
        
        if isElementMoving(localPlayer) and speed > 5.1 then
            if speed > 8.5 then
                -- Corriendo (sprint) - consume más stamina
                if staminalevel >= 0.2 then
                    local newStamina = math.max(0, math.floor((staminalevel - 0.06) * 10) / 10) -- Redondear a 1 decimal
                    setElementData(localPlayer, "stamina", newStamina)
                    if getElementData(localPlayer, "stamina->animRequested") then
                        toggleAllControls(true, true, true)
                        setElementData(localPlayer, "stamina->animRequested", false)
                        setPedAnimation(localPlayer, "", "")
                    end
                else
                    if not getElementData(localPlayer, "stamina->animRequested") then
                        toggleAllControls(false, true, false)
                        setPedAnimation(localPlayer, "FAT", "idle_tired", 8000, true, false, true, false)
                        setElementData(localPlayer, "stamina->animRequested", true)
                    end
                end
            else
                -- Trotando - consume menos stamina
                if staminalevel >= 0.2 then
                    local newStamina = math.max(0, math.floor((staminalevel - 0.025) * 10) / 10) -- Redondear a 1 decimal
                    setElementData(localPlayer, "stamina", newStamina)
                    if getElementData(localPlayer, "stamina->animRequested") then
                        toggleAllControls(true, true, true)
                        setElementData(localPlayer, "stamina->animRequested", false)
                        setPedAnimation(localPlayer, "", "")
                    end
                else
                    if not getElementData(localPlayer, "stamina->animRequested") then
                        toggleAllControls(false, true, false)
                        setPedAnimation(localPlayer, "FAT", "idle_tired", 8000, true, false, true, false)
                        setElementData(localPlayer, "stamina->animRequested", true)
                    end
                end
            end
        else
            -- No se está moviendo o está caminando - recuperar stamina
            if staminalevel < 25 then
                if not getElementData(localPlayer, "stamina->animRequested") then
                    toggleAllControls(false, true, false)
                    setPedAnimation(localPlayer, "FAT", "idle_tired", 8000, true, false, true, false)
                    setElementData(localPlayer, "stamina->animRequested", true)
                end
                local newStamina = math.min(100, math.floor((staminalevel + 0.08) * 10) / 10) -- Redondear a 1 decimal
                setElementData(localPlayer, "stamina", newStamina)
            else
                if staminalevel < 100 then
                    local newStamina = math.min(100, math.floor((staminalevel + 0.08) * 10) / 10) -- Redondear a 1 decimal
                    setElementData(localPlayer, "stamina", newStamina)
                    if getElementData(localPlayer, "stamina->animRequested") then
                        setElementData(localPlayer, "stamina->animRequested", false)
                        toggleAllControls(true, true, true)
                        setPedAnimation(localPlayer, "", "")
                    end
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, checkMoving, true, "low")

