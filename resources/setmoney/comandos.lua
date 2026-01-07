function giveMoney(player, command, otherP, cantidad)
    if hasObjectPermissionTo(player, "command.modchat", false) then
        if otherP and cantidad then
            local other, name = exports.players:getFromName(player, otherP)
            local cantidad = tonumber(cantidad)

            if other and cantidad then
                local set = exports.players:giveMoney(other, cantidad)

                if set then
                    outputChatBox("Le has dado $" .. cantidad .. " a " .. string.gsub(getPlayerName(other), "_", " ") .. ".", player, 0, 255, 0)
                    outputChatBox("El administrador " .. string.gsub(getPlayerName(player), "_", " ") .. " te ha dado $" .. cantidad .. ".", other, 0, 170, 0)

                    -- Log en Discord
                    local logMessage = {
                        title = "Entrega de Dinero",
                        description = 
                            "> **Administrador:** " .. getPlayerName(player):gsub("_", " ") .. "\n" ..
                            "> **Jugador:** " .. name .. "\n" ..
                            "> **Cantidad:** $" .. cantidad,
                        color = 3066993,
                        footer = {
                            text = "Registro de dinero entregado",
                            icon_url = "https://imgur.com/Fbx9o6X"
                        },
                        timestamp = "now"
                    }

                    exports.discord_webhooks:sendToURL(
                        "https://discord.com/api/webhooks/1407955813414211675/KbjJ2HlRs791SlS3S_oCoCteSdgtnf3MGVbIUQoKZCybfrMTGvG3Qq7znaL0Vptm5P86",
                        logMessage
                    )
                else
                    outputChatBox("Error, recuerda no usar símbolos en la cantidad!", player, 255, 0, 0)
                end
            end
        else
            outputChatBox("SYNTAX: /" .. command .. " [Jugador] [Cantidad]", player, 255, 255, 255)
        end
    end
end
addCommandHandler("capitalgivemoney", giveMoney)

function setMoney(player, command, otherP, cantidad)
    if hasObjectPermissionTo(player, "command.modchat", false) then
        if otherP and cantidad then
            local other, name = exports.players:getFromName(player, otherP)
            local cantidad = tonumber(cantidad)

            if other and cantidad then
                local set = exports.players:setMoney(other, cantidad)

                if set then
                    outputChatBox("Le has seteado $" .. cantidad .. " a " .. string.gsub(getPlayerName(other), "_", " ") .. ".", player, 0, 255, 0)
                    outputChatBox("El administrador " .. string.gsub(getPlayerName(player), "_", " ") .. " te ha seteado $" .. cantidad .. ".", other, 0, 170, 0)

                    -- Log en Discord
                    local logMessage = {
                        title = "Modificación de Dinero",
                        description = 
                            "> **Administrador:** " .. getPlayerName(player):gsub("_", " ") .. "\n" ..
                            "> **Jugador:** " .. name .. "\n" ..
                            "> **Nueva Cantidad:** $" .. cantidad,
                        color = 15158332,
                        footer = {
                            text = "Registro de cambio de dinero",
                            icon_url = "https://imgur.com/Fbx9o6X"
                        },
                        timestamp = "now"
                    }

                    exports.discord_webhooks:sendToURL(
                        "https://discord.com/api/webhooks/1348665827746119680/ZGWzzHMQp_QFLOWXyr19rQv6L3-lD2FlIbbXXAdOedDzpXtMOePTOQeT5ji0rFNwHB0l",
                        logMessage
                    )
                else
                    outputChatBox("Error, recuerda no usar símbolos en la cantidad!", player, 255, 0, 0)
                end
            end
        else
            outputChatBox("SYNTAX: /" .. command .. " [Jugador] [Cantidad]", player, 255, 255, 255)
        end
    end
end
addCommandHandler("capitalsetmoney", setMoney)
