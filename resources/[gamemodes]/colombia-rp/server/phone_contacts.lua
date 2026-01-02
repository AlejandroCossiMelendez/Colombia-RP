-- Sistema de gestión de contactos del teléfono

-- Evento para guardar contactos
addEvent("saveContacts", true)
addEventHandler("saveContacts", root, function(contactsJson)
    local player = source
    local characterId = getElementData(player, "character:id")
    
    if not characterId then
        outputServerLog("[PHONE] ERROR: No se pudo obtener character_id para guardar contactos")
        return
    end
    
    if not contactsJson or contactsJson == "" then
        outputServerLog("[PHONE] No hay contactos para guardar")
        return
    end
    
    -- Parsear JSON de contactos (fromJSON es una función nativa de MTA)
    local contacts = nil
    local success, result = pcall(function()
        if type(fromJSON) == "function" then
            return fromJSON(contactsJson)
        else
            -- Intentar usar loadstring como fallback (menos seguro)
            return loadstring("return " .. contactsJson)()
        end
    end)
    
    if success and result and type(result) == "table" then
        contacts = result
    else
        outputServerLog("[PHONE] ERROR: No se pudo parsear el JSON de contactos. JSON recibido: " .. tostring(contactsJson))
        outputServerLog("[PHONE] Error: " .. tostring(result))
        return
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
    for _, contact in ipairs(contacts) do
        if contact.name and contact.number then
            local insertQuery = "INSERT INTO phone_contacts (character_id, contact_name, contact_number) VALUES (?, ?, ?)"
            local insertSuccess = executeDatabase(insertQuery, characterId, contact.name, contact.number)
            if insertSuccess then
                insertCount = insertCount + 1
            end
        end
    end
    
    outputServerLog("[PHONE] Contactos guardados para personaje ID " .. characterId .. ": " .. insertCount .. " contactos")
end)

-- Evento para cargar contactos
addEvent("loadContacts", true)
addEventHandler("loadContacts", root, function()
    local player = source
    local characterSelected = getElementData(player, "character:selected")
    local characterId = getElementData(player, "character:id")
    
    -- Verificar que el personaje esté completamente seleccionado
    if not characterSelected or not characterId then
        outputServerLog("[PHONE] WARNING: Personaje no completamente seleccionado (selected: " .. tostring(characterSelected) .. ", id: " .. tostring(characterId) .. "). Reintentando en 2 segundos...")
        -- Reintentar después de 2 segundos en caso de que el character:id aún no esté establecido
        setTimer(function()
            if isElement(player) then
                local retrySelected = getElementData(player, "character:selected")
                local retryCharacterId = getElementData(player, "character:id")
                if retrySelected and retryCharacterId then
                    -- Cargar contactos desde la base de datos
                    local query = "SELECT contact_name, contact_number FROM phone_contacts WHERE character_id = ? ORDER BY id ASC"
                    local result = queryDatabase(query, retryCharacterId)
                    
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
                    outputServerLog("[PHONE] Contactos cargados después del reintento para personaje ID: " .. retryCharacterId)
                else
                    outputServerLog("[PHONE] ERROR: No se pudo obtener character_id después del reintento (selected: " .. tostring(retrySelected) .. ", id: " .. tostring(retryCharacterId) .. ")")
                    -- Enviar lista vacía
                    triggerClientEvent(player, "receiveContacts", resourceRoot, {})
                end
            end
        end, 2000, 1)
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

