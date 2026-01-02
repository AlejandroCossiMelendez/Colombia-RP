-- Sistema de gestión de contactos del teléfono

-- Evento para guardar contactos
addEvent("saveContacts", true)
addEventHandler("saveContacts", root, function(contactsJson)
    local player = source
    local characterId = getElementData(player, "character:id")
    
    outputServerLog("[PHONE] Recibido evento saveContacts de " .. getPlayerName(player))
    outputServerLog("[PHONE] character_id: " .. tostring(characterId))
    outputServerLog("[PHONE] contactsJson length: " .. tostring(contactsJson and string.len(contactsJson) or 0))
    
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
            return fromJSON(contactsJson)
        else
            return loadstring("return " .. contactsJson)()
        end
    end)
    
    if not success or not result or type(result) ~= "table" then
        outputServerLog("[PHONE] ERROR: No se pudo parsear el JSON de contactos. JSON recibido: " .. tostring(contactsJson))
        return
    end
    
    contacts = result
    
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
        if contact.name and contact.number and type(contact.name) == "string" and type(contact.number) == "string" then
            local insertQuery = "INSERT INTO phone_contacts (character_id, contact_name, contact_number) VALUES (?, ?, ?)"
            local insertSuccess = executeDatabase(insertQuery, characterId, contact.name, contact.number)
            if insertSuccess then
                insertCount = insertCount + 1
                outputServerLog("[PHONE] Contacto " .. i .. " guardado: " .. contact.name .. " - " .. contact.number)
            else
                errorCount = errorCount + 1
                outputServerLog("[PHONE] ERROR al guardar contacto " .. i .. ": " .. contact.name .. " - " .. contact.number)
            end
        else
            outputServerLog("[PHONE] Contacto " .. i .. " inválido (name: " .. tostring(contact.name) .. ", number: " .. tostring(contact.number) .. ")")
            errorCount = errorCount + 1
        end
    end
    
    outputServerLog("[PHONE] Contactos guardados para personaje ID " .. characterId .. ": " .. insertCount .. " exitosos, " .. errorCount .. " errores")
    if insertCount > 0 then
        outputChatBox("✓ " .. insertCount .. " contacto(s) guardado(s) correctamente.", player, 0, 255, 0)
    end
    if errorCount > 0 then
        outputChatBox("⚠ Error al guardar " .. errorCount .. " contacto(s).", player, 255, 165, 0)
    end
end)

-- Evento para cargar contactos
addEvent("loadContacts", true)
addEventHandler("loadContacts", root, function()
    local player = source
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
