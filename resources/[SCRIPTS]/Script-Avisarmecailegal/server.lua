local _getPlayerName = getPlayerName
local getPlayerName = function(x)
    return _getPlayerName(x):gsub("_", " ")
end

function entornoMecaIlegal(player, ...)
    if getElementDimension(player) == 0 then
        local x, y, z = getElementPosition(player)
        exports.factions:createFactionBlip2(x, y, z, 13)
    else
        local x, y, z = exports.interiors:getPos(getElementDimension(player))
        exports.factions:createFactionBlip2(x, y, z, 13)
    end

    local message = table.concat({...}, " ")
    if #message > 0 and not getElementData(player, "nogui") == true then
        for k, v in ipairs(getElementsByType("player")) do
            if exports.factions:isPlayerInFaction(v, 13) then -- Solo mecánicos ilegales
                local pletra = string.upper(string.sub(message, 1, 1))
                local resto = string.sub(message, 2)
                local mensaje = tostring(pletra .. resto)

                outputChatBox("((/avisarmecailegal "..getPlayerName(player)..")) Zona caliente - Un cliente solicita asistencia.", v, 200, 150, 0)
                triggerClientEvent(player, "callNotification", player, "info", "Mecánicos ilegales - Solicitud enviada.", true)
            end
        end

        outputChatBox("Aviso enviado. Esperá en la zona y mantenete bajo perfil.", player, 200, 100, 0)
        exports.chat:sendLocalOOC(player, "((/avisarmecailegal)) Se ha pedido apoyo mecánico ilegal en esta zona.\n(( "..getPlayerName(player).." ))", 255, 255, 255, false, 255, 255, 255)
    else
        outputChatBox("Usá: /avisarmecailegal [Entorno en tercera persona]", player, 255, 255, 255)
    end
end
addCommandHandler("avisarmecailegal", entornoMecaIlegal)
