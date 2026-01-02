-- Sistema de gestión de contactos del teléfono

-- Evento para guardar contactos
addEvent("saveContacts", true)
addEventHandler("saveContacts", root, function(contactsJson)
    local player = source
    
    -- Verificar que source sea un jugador
    if not isElement(player) or getElementType(player) ~= "player" then
        outputServerLog("[PHONE] ERROR: saveContacts recibido de elemento inválido (tipo: " .. tostring(getElementType(player)) .. ")")
        return
    end
    
    local characterId = getElementData(player, "character:id")
    local playerName = getPlayerName(player) or "Unknown"
    
    outputServerLog("[PHONE] Recibido evento saveContacts de " .. playerName)
    outputServerLog("[PHONE] character_id: " .. tostring(characterId))
    outputServerLog("[PHONE] contactsJson length: " .. tostring(contactsJson and string.len(contactsJson) or 0))
    outputServerLog("[PHONE] contactsJson contenido: " .. tostring(contactsJson))
    
    if not characterId then
        outputServerLog("[PHONE] ERROR: No se pudo obtener character_id para guardar contactos")
        outputChatBox("Error: No se pudo guardar los contactos. Intenta de nuevo.", player, 255, 0, 0)
        return
    end
    
    if not contactsJson or contactsJson == "" then
        -- Si no hay contactos, simplemente eliminar todos los existentes
        local deleteQuery = "DELETE FROM phone_contacts WHERE character_id = ?"
        local deleteSuccess = executeDatabase(deleteQuery, characterId)
        if deleteSuccess then
            outputServerLog("[PHONE] Todos los contactos eliminados para personaje ID " .. characterId)
        else
            outputServerLog("[PHONE] ERROR: No se pudieron eliminar los contactos")
        end
        return
    end
    
    -- Parsear JSON de contactos
    local contacts = nil
    local success, result = pcall(function()
        if type(fromJSON) == "function" then
            local parsed = fromJSON(contactsJson)
            outputServerLog("[PHONE] fromJSON devolvió tipo: " .. type(parsed))
            if type(parsed) == "table" then
                outputServerLog("[PHONE] fromJSON #result: " .. #parsed)
                local pairCount = 0
                for k, v in pairs(parsed) do
                    pairCount = pairCount + 1
                    outputServerLog("[PHONE] fromJSON pair[" .. tostring(k) .. "] = " .. type(v))
                end
                outputServerLog("[PHONE] fromJSON total pairs: " .. pairCount)
            end
            return parsed
        else
            -- Fallback: usar loadstring
            local func = loadstring("return " .. contactsJson)
            if func then
                return func()
            end
            return nil
        end
    end)
    
    if not success or not result or type(result) ~= "table" then
        outputServerLog("[PHONE] ERROR: No se pudo parsear el JSON de contactos. JSON recibido: " .. tostring(contactsJson))
        outputServerLog("[PHONE] success: " .. tostring(success) .. ", result type: " .. type(result))
        return
    end
    
    contacts = result
    
    -- Verificar estructura y convertir si es necesario
    local arrayLength = #contacts
    local pairCount = 0
    for k, v in pairs(contacts) do
        pairCount = pairCount + 1
    end
    
    outputServerLog("[PHONE] Array length (#): " .. arrayLength)
    outputServerLog("[PHONE] Pairs count: " .. pairCount)
    
    -- Si el array está vacío pero hay pairs, podría ser un objeto en lugar de array
    if arrayLength == 0 and pairCount > 0 then
        outputServerLog("[PHONE] WARNING: Array vacío pero hay " .. pairCount .. " pares. Intentando convertir...")
        -- Intentar convertir objeto a array
        local tempArray = {}
        for k, v in pairs(contacts) do
            if type(k) == "number" and type(v) == "table" then
                table.insert(tempArray, v)
            elseif type(v) == "table" then
                -- Podría ser un objeto con propiedades name y number
                if v.name and v.number then
                    table.insert(tempArray, v)
                end
            end
        end
        if #tempArray > 0 then
            contacts = tempArray
            outputServerLog("[PHONE] Convertido a array con " .. #contacts .. " elementos")
        end
    end
    
    outputServerLog("[PHONE] Total contactos finales: " .. #contacts)
    
    -- Debug: mostrar cada contacto antes de validar
    if #contacts > 0 then
        for i, contact in ipairs(contacts) do
            outputServerLog("[PHONE] Contacto " .. i .. " - name: " .. tostring(contact.name) .. " (" .. type(contact.name) .. "), number: " .. tostring(contact.number) .. " (" .. type(contact.number) .. ")")
        end
    else
        outputServerLog("[PHONE] WARNING: Array de contactos está vacío después del parseo")
    end
    
    -- Eliminar contactos antiguos del personaje
    local deleteQuery = "DELETE FROM phone_contacts WHERE character_id = ?"
    local deleteSuccess = executeDatabase(deleteQuery, characterId)
    
    if not deleteSuccess then
        outputServerLog("[PHONE] ERROR: No se pudieron eliminar los contactos antiguos")
        return
    end
    
    -- Insertar nuevos contactos
    local insertCount = 0
    local errorCount = 0
    for i, contact in ipairs(contacts) do
        -- Validar que el contacto tenga los campos necesarios
        local name = contact.name
        local number = contact.number
        
        -- Debug detallado
        outputServerLog("[PHONE] Procesando contacto " .. i .. ":")
        outputServerLog("[PHONE]   - name existe: " .. tostring(name ~= nil))
        outputServerLog("[PHONE]   - number existe: " .. tostring(number ~= nil))
        outputServerLog("[PHONE]   - name type: " .. type(name))
        outputServerLog("[PHONE]   - number type: " .. type(number))
        if name then outputServerLog("[PHONE]   - name value: " .. tostring(name)) end
        if number then outputServerLog("[PHONE]   - number value: " .. tostring(number)) end
        
        if name and number and type(name) == "string" and type(number) == "string" and name ~= "" and number ~= "" then
            local insertQuery = "INSERT INTO phone_contacts (character_id, contact_name, contact_number) VALUES (?, ?, ?)"
            local insertSuccess = executeDatabase(insertQuery, characterId, name, number)
            if insertSuccess then
                insertCount = insertCount + 1
                outputServerLog("[PHONE] ✓ Contacto " .. i .. " guardado exitosamente: " .. name .. " - " .. number)
            else
                errorCount = errorCount + 1
                outputServerLog("[PHONE] ✗ ERROR al guardar contacto " .. i .. " en BD: " .. name .. " - " .. number)
            end
        else
            outputServerLog("[PHONE] ✗ Contacto " .. i .. " NO pasó validación:")
            if not name or name == "" then
                outputServerLog("[PHONE]   - name está vacío o no existe")
            end
            if not number or number == "" then
                outputServerLog("[PHONE]   - number está vacío o no existe")
            end
            if name and type(name) ~= "string" then
                outputServerLog("[PHONE]   - name no es string, es: " .. type(name))
            end
            if number and type(number) ~= "string" then
                outputServerLog("[PHONE]   - number no es string, es: " .. type(number))
            end
            errorCount = errorCount + 1
        end
    end
    
    outputServerLog("[PHONE] Contactos guardados para personaje ID " .. characterId .. ": " .. insertCount .. " exitosos, " .. errorCount .. " errores")
    if isElement(player) and getElementType(player) == "player" then
        if insertCount > 0 then
            outputChatBox("✓ " .. insertCount .. " contacto(s) guardado(s) correctamente.", player, 0, 255, 0)
        end
        if errorCount > 0 then
            outputChatBox("⚠ Error al guardar " .. errorCount .. " contacto(s).", player, 255, 165, 0)
        end
    end
end)

-- Evento para cargar contactos
addEvent("loadContacts", true)
addEventHandler("loadContacts", root, function()
    local player = source
    
    -- Verificar que source sea un jugador
    if not isElement(player) or getElementType(player) ~= "player" then
        outputServerLog("[PHONE] ERROR: loadContacts recibido de elemento inválido (tipo: " .. tostring(getElementType(player)) .. ")")
        return
    end
    
    local characterId = getElementData(player, "character:id")
    
    if not characterId then
        outputServerLog("[PHONE] ERROR: No se pudo obtener character_id para cargar contactos")
        triggerClientEvent(player, "receiveContacts", resourceRoot, {})
        return
    end
    
    -- Cargar contactos desde la base de datos
    local query = "SELECT contact_name, contact_number FROM phone_contacts WHERE character_id = ? ORDER BY id ASC"
    local result = queryDatabase(query, characterId)
    
    local contactsList = {}
    if result and #result > 0 then
        for _, contact in ipairs(result) do
            table.insert(contactsList, {
                name = contact.contact_name,
                number = contact.contact_number
            })
        end
    end
    
    -- Enviar contactos al cliente
    triggerClientEvent(player, "receiveContacts", resourceRoot, contactsList)
    outputServerLog("[PHONE] Contactos cargados para personaje ID: " .. characterId .. " (" .. #contactsList .. " contactos)")
end)
