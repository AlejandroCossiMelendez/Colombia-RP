-- restricciones_items.lua
-- Este script maneja las restricciones para los ítems especiales

-- Lista de ítems restringidos que no pueden ser guardados en mochilas ni vehículos
local itemsRestringidos = {
	[113] = true, -- Bomba Improvisada (IED) no se guarda en mochilas/maleteros
}

-- Función para verificar si un ítem está restringido para mochilas y vehículos
local function esItemRestringido(item, value, nombre)
    -- Verificar por ID
    if itemsRestringidos[item] then
        return true
    end
    
    -- Verificar por nombre especial (contiene [RESTRINGIDO])
    if nombre and string.find(nombre, "[RESTRINGIDO]") then
        return true
    end
    
    return false
end

-- Interceptamos el evento de guardar en maletero
addEventHandler("items:giveToMaletero", root, function(slot)
    -- Este evento se activa antes de que se procese el original
    if source == client and slot then
        if exports.players:isLoggedIn(source) then
            local item = exports.items:get(source)[slot]
            if item then
                -- Verificar si el ítem está restringido
                if esItemRestringido(item.item, item.value, item.name) then
                    -- Cancelar el evento original
                    cancelEvent()
                    -- Informar al jugador
                    exports.InfoSirilo:addBoxSiri(source, "Este objeto no puede guardarse en vehículos.", "error")
                    return
                end
            end
        end
    end
end, true) -- El true aquí hace que se procese antes que el manejador original

-- Interceptamos el evento de guardar en mochila
addEvent("items:giveToMochila", true)
addEventHandler("items:giveToMochila", root, function(slot)
    if source == client and slot then
        if exports.players:isLoggedIn(source) then
            local item = exports.items:get(source)[slot]
            if item then
                -- Verificar si el ítem está restringido
                if esItemRestringido(item.item, item.value, item.name) then
                    -- Cancelar el evento original
                    cancelEvent()
                    -- Informar al jugador
                    exports.InfoSirilo:addBoxSiri(source, "Este objeto no puede guardarse en mochilas.", "error")
                    return
                end
            end
        end
    end
end, true) -- El true aquí hace que se procese antes que el manejador original

-- Exportar funciones útiles
function esItemRestringidoExport(item, value, nombre)
    return esItemRestringido(item, value, nombre)
end 