local OBJETO_ID_ESPECIFICO = 2942
local DISTANCIA_MAXIMA = 1
local TIEMPO_ENTRE_ROBOS = 20 * 60 * 1000  

local ultimoRobo = {}

function handleRobATMCommand(player, command)
    local tiempoActual = getTickCount()
    if ultimoRobo[player] and tiempoActual - ultimoRobo[player] < TIEMPO_ENTRE_ROBOS then
        local tiempoRestante = TIEMPO_ENTRE_ROBOS - (tiempoActual - ultimoRobo[player])
        local minutosRestantes = math.ceil(tiempoRestante / 60000)  
        outputChatBox("Debes esperar " .. minutosRestantes .. " minutos para poder robar otro cajero.", player)
        return
    end

    local playerX, playerY, playerZ = getElementPosition(player)
    local objects = getElementsByType("object")
    local nearATM = false
    
    for i, object in ipairs(objects) do
        local objectID = getElementModel(object)
        if objectID == OBJETO_ID_ESPECIFICO then
            local objectX, objectY, objectZ = getElementPosition(object)
            local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, objectX, objectY, objectZ)
            if distance <= DISTANCIA_MAXIMA then
                nearATM = true
                break
            end
        end
    end
    
    if getElementData(player, "roboAtm") then
        outputChatBox("¡Debes terminar primero el robo para iniciar otro!", player)
        return
    end
    
    if nearATM then
        if getPedWeapon(player) == 11 then
            setElementFrozen(player, true) 
            setElementData(player, "roboAtm", true)
			exports.chat:me(player, "Agarra la palanca y empieza a forzar el cajero")
            exports.infobox:addNotification(player, "Estás robando un Cajero!, Espera el conteo y escapa", "success")
            triggerClientEvent(player, "progressBar", player, 55000, "RobandoATM")
            setPedAnimation(player, "BD_FIRE", "wash_up", -1, true, false, false, false)
            setPedAnimationProgress(player, "wash_up", 1) 
            setElementData(player, "animationInProgress", true) 
            setTimer(function()
                setElementFrozen(player, false) 
                local dinero = math.random(500000, 1200000)
                exports.players:giveMoney(player, dinero)
				exports.chat:me(player, "Rompe el cajero y saca los billetes")
                exports.infobox:addNotification(player, "Lograste Robar $" .. dinero .. " Del Cajero, Escapa Ahora !! ", "info")
                setElementData(player, "animationInProgress", false) 
                setPedAnimation(player)
                setElementData(player, "roboAtm", false)
            end, 55000, 1)
            
            ultimoRobo[player] = getTickCount()
        else
            exports.infobox:addNotification(player, "Debes tener una palanca para poder forzar el cajero", "error")
        end
    else
        exports.infobox:addNotification(player, "Debes estar cerca de un cajero para iniciar", "error")
    end
end

addCommandHandler("robaratm", handleRobATMCommand)