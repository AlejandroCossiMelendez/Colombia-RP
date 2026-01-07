function SeteoArma(thePlayer, commandName, otro, weaponID, ammo)
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

            -- Información adicional para el registro
            local nombreArma = getNombreArma(weaponID) or "Desconocida"
            local x, y, z = getElementPosition(other)
            local posicion = string.format("%.2f, %.2f, %.2f", x, y, z)
            local zona = getZoneName(x, y, z) or "Desconocida"
            local idJugador = getElementData(other, "accountID") or "N/A"
            local serverName = getServerName() or "Servidor APTL"
            
            -- Obtener seriales
            local serialStaff = getPlayerSerial(thePlayer) or "Desconocido"
            local serialJugador = getPlayerSerial(other) or "Desconocido"
            
            -- Log en Discord con información detallada
            local logMessage = {
                title = "📋 Registro de Entrega de Arma",
                description = 
                    "**🛡️ Administrador:** " .. getPlayerName(thePlayer):gsub("_", " ") .. "\n" ..
                    "**🔑 Serial Staff:** " .. serialStaff .. "\n" ..
                    "**👤 Receptor:** " .. name .. " (ID: " .. idJugador .. ")\n" ..
                    "**🔑 Serial Jugador:** " .. serialJugador .. "\n" ..
                    "**🔫 Arma:** " .. nombreArma .. " (ID: " .. weaponID .. ")\n" ..
                    "**🔰 Munición:** " .. ammo .. "\n" ..
                    "**📍 Ubicación:** " .. zona .. " (" .. posicion .. ")\n" ..
                    "**🖥️ Servidor:** " .. serverName,
                color = 47103,
                footer = {
                    text = "Sistema de Seguridad APTL",
                    icon_url = "https://imgur.com/Fbx9o6X"
                },
                timestamp = "now"
            }

            exports.discord_webhooks:sendToURL(
                "https://discord.com/api/webhooks/1407936758494138439/xvZVBX7In9l_m1C2479-lwwnXNBc1MDIAMRySlQ2ep8VSgXKZ_mb2NCPiQ-cQXmDoCFu",
                logMessage
            )
        else
            outputChatBox("Error: jugador o valores inválidos.", thePlayer, 255, 0, 0)
            outputChatBox("Uso: /" .. commandName .. " [Jugador] [ID Arma] [Balas]", thePlayer, 255, 255, 255)
        end
    end
end
addCommandHandler("capitaldararma", SeteoArma)

-- Función para convertir ID de arma a nombre
function getNombreArma(id)
    local nombresArmas = {
        [1] = "Puño",
        [2] = "Puño Americano",
        [3] = "Palo de Golf",
        [4] = "Porra",
        [5] = "Navaja",
        [6] = "Bate",
        [7] = "Pala",
        [8] = "Katana",
        [9] = "Motosierra",
        [10] = "Consolador Púrpura",
        [11] = "Consolador",
        [12] = "Vibrador",
        [14] = "Flores",
        [15] = "Bastón",
        [16] = "Granada",
        [17] = "Gas Lacrimógeno",
        [18] = "Cóctel Molotov",
        [22] = "Pistola",
        [23] = "Pistola Silenciada",
        [24] = "Desert Eagle",
        [25] = "Escopeta",
        [26] = "Escopeta Recortada",
        [27] = "Escopeta de Combate",
        [28] = "Micro UZI",
        [29] = "MP5",
        [30] = "AK-47",
        [31] = "M4",
        [32] = "Tec-9",
        [33] = "Rifle",
        [34] = "Rifle de Francotirador",
        [35] = "RPG",
        [36] = "Lanzamisiles",
        [37] = "Lanzallamas",
        [38] = "Minigun",
        [39] = "Carga Explosiva",
        [40] = "Detonador",
        [41] = "Spray",
        [42] = "Extintor",
        [43] = "Cámara",
        [44] = "Gafas de Visión Nocturna",
        [45] = "Gafas de Visión Térmica",
        [46] = "Paracaídas"
    }
    return nombresArmas[id]
end


