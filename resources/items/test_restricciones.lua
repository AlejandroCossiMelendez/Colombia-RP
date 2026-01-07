-- test_restricciones.lua
-- Este archivo solo se usa para verificar si las restricciones funcionan correctamente

addCommandHandler("probaritems", function(player, cmd)
    if getElementType(player) == "player" and exports.players:isLoggedIn(player) then
        -- Verificar si el jugador tiene un ítem restringido
        local playerItems = exports.items:get(player)
        if playerItems then
            local tieneRestringido = false
            for slot, item in pairs(playerItems) do
                if esItemRestringidoExport(item.item, item.value, item.name) then
                    tieneRestringido = true
                    outputChatBox("Tienes un ítem restringido en el slot " .. slot .. ": " .. (item.name or "Sin nombre"), player, 255, 255, 0)
                end
            end
            
            if not tieneRestringido then
                outputChatBox("No tienes ningún ítem restringido en tu inventario.", player, 0, 255, 0)
            end
        else
            outputChatBox("No se pudo cargar tu inventario.", player, 255, 0, 0)
        end
    end
end) 