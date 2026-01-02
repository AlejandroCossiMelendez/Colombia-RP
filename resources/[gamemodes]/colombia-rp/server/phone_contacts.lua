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
    
    outputServerLog("[PHONE] Recibido evento saveContacts de " .. getPlayerName(player))
    
    local characterId = getElementData(player, "character:id")
    
    if not characterId then
        outputServerLog("[PHONE] ERROR: No se pudo obtener character_id para guardar contactos")
        outputChatBox("Error: No se pudo guardar los contactos. Intenta de nuevo.", player, 255, 0, 0)
        return
    end
    
    outputServerLog("[PHONE] character_id: " .. tostring(characterId))
    outputServerLog("[PHONE] contactsJson recibido: " .. tostring(contactsJson) .. " (longitud: " .. tostring(contactsJson and string.len(contactsJson) or 0) .. ")")
    
    if not contactsJson or contactsJson == "" then
        -- Si no hay contactos, simplemente eliminar todos los existentes
        local deleteQuery = "DELETE FROM phone_contacts WHERE character_id = ?"
        executeDatabase(deleteQuery, characterId)
        return
    end
    
    -- Parsear JSON de contactos
    local contacts = nil
    local success, result = pcall(function()
        if type(fromJSON) == "function" then
            return fromJSON(contactsJson)
        else
            -- Fallback: usar loadstring
            local func = loadstring("return " .. contactsJson)
            if func then
                return func()
            end
            return nil
        end
    end)
    
    if not success then
        outputServerLog("[PHONE] ERROR: Error al parsear JSON de contactos")
        return
    end
    
    -- Si result es nil o no es una tabla, verificar si es un array vacío
    if not result then
        -- Array vacío es válido, simplemente no hay contactos
        contacts = {}
    elseif type(result) ~= "table" then
        outputServerLog("[PHONE] ERROR: JSON parseado no es una tabla")
        return
    else
        contacts = result
    end
    
    -- Verificar estructura y convertir si es necesario
    local arrayLength = #contacts
    local pairCount = 0
    local hasName = false
    local hasNumber = false
    for k, v in pairs(contacts) do
        pairCount = pairCount + 1
        if k == "name" then hasName = true end
        if k == "number" then hasNumber = true end
    end
    
    -- Si el array está vacío pero tiene las propiedades name y number directamente, 
    -- significa que fromJSON devolvió el objeto del array en lugar del array
    if arrayLength == 0 and hasName and hasNumber then
        -- Convertir el objeto único a un array con un elemento
        contacts = {contacts}
    elseif arrayLength == 0 and pairCount > 0 then
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
        end
    end
    
    -- Si después de todo el procesamiento el array está vacío, está bien (no hay contactos)
    -- No necesitamos hacer nada especial, simplemente continuar con el proceso de eliminación e inserción
    
    -- Eliminar contactos antiguos del personaje
    local deleteQuery = "DELETE FROM phone_contacts WHERE character_id = ?"
    local deleteSuccess = executeDatabase(deleteQuery, characterId)
    
    if not deleteSuccess then
        outputServerLog("[PHONE] ERROR: No se pudieron eliminar los contactos antiguos")
        outputChatBox("Error: No se pudieron eliminar contactos antiguos. Intenta de nuevo.", player, 255, 0, 0)
        return
    end
    
    -- Si el array está vacío, solo eliminar y terminar
    if #contacts == 0 then
        return
    end
    
    -- Insertar nuevos contactos
    local insertCount = 0
    local errorCount = 0
    outputServerLog("[PHONE] Total de contactos a insertar: " .. tostring(#contacts))
    
    for i, contact in ipairs(contacts) do
        -- Validar que el contacto tenga los campos necesarios
        local name = contact.name
        local number = contact.number
        
        outputServerLog("[PHONE] Procesando contacto " .. tostring(i) .. ": name=" .. tostring(name) .. ", number=" .. tostring(number))
        
        if name and number and type(name) == "string" and type(number) == "string" and name ~= "" and number ~= "" then
            local insertQuery = "INSERT INTO phone_contacts (character_id, contact_name, contact_number) VALUES (?, ?, ?)"
            local insertSuccess = executeDatabase(insertQuery, characterId, name, number)
            if insertSuccess then
                insertCount = insertCount + 1
                outputServerLog("[PHONE] Contacto insertado correctamente: " .. name .. " - " .. number)
            else
                errorCount = errorCount + 1
                outputServerLog("[PHONE] ERROR al insertar contacto: " .. name .. " - " .. number)
            end
        else
            errorCount = errorCount + 1
            outputServerLog("[PHONE] Contacto inválido (índice " .. tostring(i) .. "): name=" .. tostring(name) .. ", number=" .. tostring(number))
        end
    end
    
    outputServerLog("[PHONE] Contactos guardados: " .. tostring(insertCount) .. " exitosos, " .. tostring(errorCount) .. " errores")
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
end)
