-- Tabla para llevar registro de advertencias
local warnedPlayers = {}

function checkPlayerWeapons()
    for _, player in ipairs(getElementsByType("player")) do
        if isElement(player) then
            local other, name, id = exports.players:getFromName(nil, getPlayerName(player), true)
            
            if other then
                for slot = 0, 12 do
                    local weapon = getPedWeapon(other, slot)
                    local ammo = getPedTotalAmmo(other, slot)

                    if weapon > 0 and ammo > 100 then
                        if warnedPlayers[other] then
                            -- Segunda vez → KICK y Log
                            outputChatBox(name .. " ha sido expulsado por reincidir con exceso de munición.", root, 255, 0, 0)
                            kickPlayer(other, "Detectado con más de 100 balas en un arma (2da vez).")
                            
                            -- Log de Discord para kick
                            local discordMessage = {
                                title = "AntiCheat: Jugador Expulsado",
                                description = 
                                    "> [ + ] Nombre: **" .. name .. "**\n" ..
                                    "> [ + ] UserID: **" .. tostring(id) .. "**\n" ..
                                    "> [ + ] Arma: **" .. tostring(weapon) .. "**\n" ..
                                    "> [ + ] Munición: **" .. tostring(ammo) .. "**\n" ..
                                    "> [ + ] Razón: Exceso de munición (2da vez)",
                                color = 15158332, -- Rojo
                                footer = {
                                    text = "AntiCheat System",
                                    icon_url = "https://imgur.com/n3378F1"
                                },
                                timestamp = "now"
                            }

                            exports.discord_webhooks:sendToURL(
                                "https://discord.com/api/webhooks/1407616186837110865/ehNcvanbeQeOr_cfjaGvzOkrtBdYBucPJOPR7eG12_95NMvzqsnNYyQ5GXcpg0sbQAIp",
                                discordMessage
                            )
                        else
                            -- Primera vez → Quitar arma, advertir y Log
                            takeWeapon(other, weapon)
                            outputChatBox(name .. ", tenías más de 100 balas en un arma. Se te ha eliminado.", other, 255, 255, 0)
                            warnedPlayers[other] = true

                            -- Log de Discord para advertencia
                            local discordMessage = {
                                title = "AntiCheat: Advertencia de Munición",
                                description = 
                                    "> [ + ] Nombre: **" .. name .. "**\n" ..
                                    "> [ + ] UserID: **" .. tostring(id) .. "**\n" ..
                                    "> [ + ] Arma: **" .. tostring(weapon) .. "**\n" ..
                                    "> [ + ] Munición: **" .. tostring(ammo) .. "**\n" ..
                                    "> [ + ] Acción: Arma eliminada",
                                color = 16776960, -- Amarillo
                                footer = {
                                    text = "AntiCheat System",
                                    icon_url = "https://imgur.com/n3378F1"
                                },
                                timestamp = "now"
                            }

                            exports.discord_webhooks:sendToURL(
                                "https://discord.com/api/webhooks/1407616186837110865/ehNcvanbeQeOr_cfjaGvzOkrtBdYBucPJOPR7eG12_95NMvzqsnNYyQ5GXcpg0sbQAIp",
                                discordMessage
                            )
                        end
                        break
                    end
                end
            end
        end
    end
end

-- Ejecuta la función cada 1 segundo
setTimer(checkPlayerWeapons, 1000, 0)
