addCommandHandler("setskin",
    function(player, commandName, otherPlayer, skin)
        skin = tonumber(skin)
        if otherPlayer and skin then
            local other, name = exports.players:getFromName(player, otherPlayer)
            if other then
                local oldSkin = getElementModel(other)
                local characterID = exports.players:getCharacterID(other)
                if oldSkin == skin then
                    outputChatBox(name .. " ya usa esta skin.", player, 255, 255, 0)
                elseif characterID and setElementModel(other, skin) then
                    if exports.sql:query_free("UPDATE characters SET skin = " .. skin .. " WHERE characterID = " .. characterID) then
                        outputChatBox("Cambiada la skin de " .. name .. " a " .. skin, player, 0, 255, 153)
                        exports.players:updateCharacters(other)

                        -- Log en Discord
                        local logMessage = {
                            title = "Cambio de Skin",
                            description = 
                                "> **Administrador:** " .. getPlayerName(player):gsub("_", " ") .. "\n" ..
                                "> **Jugador:** " .. name .. "\n" ..
                                "> **Nueva Skin:** " .. skin,
                            color = 3447003,
                            footer = {
                                text = "Registro de cambio de skin",
                                icon_url = "https://imgur.com/Fbx9o6X"
                            },
                            timestamp = "now"
                        }

                        exports.discord_webhooks:sendToURL(
                            "https://discord.com/api/webhooks/1348664497136603136/XktqfS8LwlaoOvYpI9jxlwJCp-g_q50s7mvFqwkbmxGZ2hMW_-wrd7YBIH1BKgenKNc0",
                            logMessage
                        )
                    else
                        outputChatBox("Fallo al guardar la skin en la base de datos.", player, 255, 0, 0)
                        setElementModel(other, oldSkin)
                    end
                else
                    outputChatBox("La skin " .. skin .. " es inválida.", player, 255, 0, 0)
                end
            end
        else
            outputChatBox("Syntax: /" .. commandName .. " [player] [skin]", player, 255, 255, 255)
        end
    end,
    true
)

addCommandHandler("cabeweaponnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn",
    function(thePlayer, commandName, otro, weaponID, ammo)
        if hasObjectPermissionTo(thePlayer, "command.adminchat", false) then
            local other, name = exports.players:getFromName(thePlayer, otro)
            local weaponID, ammo = tonumber(weaponID), tonumber(ammo)

            if other and weaponID and ammo then
                local status = giveWeapon(other, weaponID, ammo, true)
                if not status then
                    outputConsole("Fallo en dar el arma.", thePlayer, 255, 0, 0)
                    return
                end

                outputChatBox("Has dado un arma a " .. name .. ". ID: " .. weaponID .. ", Munición: " .. ammo, thePlayer, 0, 255, 0)
                outputChatBox("El staff " .. getPlayerName(thePlayer):gsub("_", " ") .. " te ha dado un arma. ID: " .. weaponID .. ", Munición: " .. ammo, other, 255, 255, 0)

                -- Log en Discord
                local logMessage = {
                    title = "Entrega de Arma",
                    description = 
                        "> **Administrador:** " .. getPlayerName(thePlayer):gsub("_", " ") .. "\n" ..
                        "> **Receptor:** " .. name .. "\n" ..
                        "> **ID de Arma:** " .. weaponID .. "\n" ..
                        "> **Munición:** " .. ammo,
                    color = 15158332,
                    footer = {
                        text = "Registro de entrega de armas",
                        icon_url = "https://imgur.com/Fbx9o6X"
                    },
                    timestamp = "now"
                }

                exports.discord_webhooks:sendToURL(
                    "https://discord.com/api/webhooks/1348757740469616801/RJ1pT00vDkL5MyjJEV_QyGlnmQDiDqchJ7EJH3ozM7fnjAkK0EYN13S-DuJ-_HSRKf0W",
                    logMessage
                )
            else
                outputChatBox("Error: jugador o valores inválidos.", thePlayer, 255, 0, 0)
                outputChatBox("Uso: /" .. commandName .. " [Jugador] [ID Arma] [Balas]", thePlayer, 255, 255, 255)
            end
        end
    end
)
