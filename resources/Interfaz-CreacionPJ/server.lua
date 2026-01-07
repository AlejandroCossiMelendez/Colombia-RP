-- Sistema de Creación de Personajes - Server Side
-- Integrado con sistema existente de players/gui

-- Función de verificación de nombres (copiada del sistema existente)
function verifyCharacterName( name )
    if not name then
        return "No name given."
    elseif #name < 5 then
        return "El nombre debe de tener 5 carácteres."
    elseif #name >= 22 then
        return "El nombre no puede superar los 22 carácteres."
    else
        local foundSpace = false
        
        local lastChar = ' '
        local currentPart = ''
        
        for i = 1, #name do
            local currentChar = name:sub( i, i )
            if currentChar == ' ' then
                if i == 1 then
                    return "El nombre no puede empezar con un espacio"
                elseif i == #name then
                    return "El nombre no puede acabar con un espacio."
                elseif lastChar == ' ' then
                    return "El nombre no puede tener dos espacios consecutivos."
                else
                    foundSpace = true
                    
                    if #currentPart < 2 then
                        return "Todas las partes del nombre deben tener como mínimo dos caracteres."
                    else
                        currentPart = ""
                    end
                end
            elseif lastChar == ' ' then -- need a capital letter at the start
                if currentChar < 'A' or currentChar > 'Z' then
                    return "Nombre invalido - Formato: Nombre Apellido."
                end
                currentPart = currentPart .. currentChar
            elseif ( currentChar >= 'a' and currentChar <= 'z' ) or ( currentChar >= 'A' and currentChar <= 'Z' ) then
                currentPart = currentPart .. currentChar
            else
                return "Tu nombre contiene caracteres invalidos."
            end
            lastChar = currentChar
        end
        
        if not foundSpace then
            return "El nombre debe tener mínimo dos partes."
        elseif #currentPart < 2 then
            return "Todas las partes del nombre deben tener como mínimo dos caracteres."
        end
    end
end

-- Event handler para crear personajes
addEvent( "gui:createCharacter", true )
addEventHandler( "gui:createCharacter", root,
    function( name, edad, genero, color )
        if source == client and type( edad ) == 'number' and type( genero ) == 'number' and type( color ) == 'number' then
            local error = verifyCharacterName( name )
            if not error then
                -- Usar la función del sistema existente de players
                if exports.players then
                    local success = exports.players:createCharacter( source, name, edad, genero, color )
                    if success then
                        outputDebugString( "Personaje creado exitosamente: " .. name .. " por " .. getPlayerName(source), 3 )
                    end
                else
                    outputDebugString( "Error: No se pudo acceder al sistema de players", 1 )
                    triggerClientEvent( source, "players:characterCreationResult", source, 1 )
                end
            else
                -- Error en validación del nombre - enviar notificación
                local infoBox = getResourceFromName("a_infoBox")
                if infoBox and getResourceState(infoBox) == "running" then
                    pcall(function()
                        exports.a_infoBox:addBox( source, error, "error" )
                    end)
                end
                outputChatBox( "Error en nombre: " .. error, source, 255, 0, 0 )
                -- NO enviar characterCreationResult para que la interfaz no se cierre
            end
        end
    end
)

-- Función exportada para verificar nombres (para compatibilidad)
function getVerifyCharacterName()
    return verifyCharacterName
end
