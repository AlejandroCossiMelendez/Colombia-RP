-- Definir los vehículos permitidos (puedes añadir más IDs si es necesario)
local vehiculos_permitidos = {
    [596] = true, -- LSPD
    [597] = true, -- SFPD
    [598] = true, -- LVPD
    [599] = true, -- Ranger
    [601] = true  -- FBI Rancher
}

local sonidoClaxon = nil -- Variable para almacenar el sonido

-- Función para tocar el claxon al presionar el click derecho
function activarClaxon()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and vehiculos_permitidos[getElementModel(veh)] then
        -- Verificar si el jugador local es el conductor
        if getVehicleOccupant(veh, 0) == localPlayer then
            if not sonidoClaxon then -- Evitar múltiples sonidos al mismo tiempo
                triggerServerEvent("sincronizarClaxon", resourceRoot, veh) -- Notificar al servidor
            end
        else
            outputChatBox("Solo el conductor puede activar la sirena.", 255, 0, 0)
        end
    end
end

-- Función para detener el claxon al soltar el click derecho
function desactivarClaxon()
    if sonidoClaxon then
        destroyElement(sonidoClaxon)
        sonidoClaxon = nil
        triggerServerEvent("detenerClaxon", resourceRoot) -- Notificar al servidor
    end
end

-- Función para reproducir el sonido sincronizado
function reproducirClaxon(veh)
    if not sonidoClaxon then
        local x, y, z = getElementPosition(veh)
        sonidoClaxon = playSound3D("sounds/policia.mp3", x, y, z, true) -- Sonido en loop
        attachElements(sonidoClaxon, veh) -- Fijar sonido al vehículo
    end
end
addEvent("reproducirClaxon", true)
addEventHandler("reproducirClaxon", root, reproducirClaxon)

-- Función para detener el sonido sincronizado
function detenerClaxon()
    if sonidoClaxon then
        destroyElement(sonidoClaxon)
        sonidoClaxon = nil
    end
end
addEvent("detenerClaxon", true)
addEventHandler("detenerClaxon", root, detenerClaxon)

-- Asignar el botón del **click derecho** para activar y desactivar el claxon
bindKey("mouse2", "down", activarClaxon) -- Presionar click derecho para sonar
bindKey("mouse2", "up", desactivarClaxon) -- Soltar click derecho para detener
