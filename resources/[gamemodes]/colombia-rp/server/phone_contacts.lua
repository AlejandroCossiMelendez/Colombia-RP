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
    -- CRÍTICO: fromJSON en MTA puede tener problemas con arrays JSON
    -- Usar parseo manual robusto usando patrones de string
    local contacts = nil
    local success, result = pcall(function()
        -- Parseo manual usando patrones de string para extraer contactos
        -- Formato esperado: [{"name":"...","number":"..."},{"name":"...","number":"..."}]
        local contactArray = {}
        local pattern = '%{"name":"([^"]+)","number":"([^"]+)"}'
        
        for name, number in contactsJson:gmatch(pattern) do
            if name and number and name ~= "" and number ~= "" then
                table.insert(contactArray, {name = name, number = number})
            end
        end
        
        if #contactArray > 0 then
            outputServerLog("[PHONE] Parseo manual exitoso usando patrones: " .. #contactArray .. " contactos encontrados")
            return contactArray
        end
        
        -- Si el parseo manual falla, intentar con fromJSON como fallback
        if type(fromJSON) == "function" then
            outputServerLog("[PHONE] Parseo manual falló, intentando con fromJSON...")
            return fromJSON(contactsJson)
        end
        
        return nil
    end)
    
    if not success then
        outputServerLog("[PHONE] ERROR: Error al parsear JSON de contactos: " .. tostring(result))
        return
    end
    
    outputServerLog("[PHONE] JSON parseado exitosamente. Tipo: " .. type(result))
    
    -- Si result es nil o no es una tabla, verificar si es un array vacío
    if not result then
        -- Array vacío es válido, simplemente no hay contactos
        contacts = {}
        outputServerLog("[PHONE] Result es nil, usando array vacío")
    elseif type(result) ~= "table" then
        outputServerLog("[PHONE] ERROR: JSON parseado no es una tabla, es: " .. type(result))
        return
    else
        contacts = result
    end
    
    -- Verificar estructura y convertir si es necesario
    local arrayLength = #contacts
    local pairCount = 0
    local hasName = false
    local hasNumber = false
    local numericKeys = {}
    local nonNumericKeys = {}
    
    for k, v in pairs(contacts) do
        pairCount = pairCount + 1
        if k == "name" then hasName = true end
        if k == "number" then hasNumber = true end
        
        -- Clasificar las claves
        if type(k) == "number" then
            table.insert(numericKeys, k)
        else
            table.insert(nonNumericKeys, k)
        end
    end
    
    outputServerLog("[PHONE] Estructura del JSON: arrayLength=" .. tostring(arrayLength) .. ", pairCount=" .. tostring(pairCount) .. ", hasName=" .. tostring(hasName) .. ", hasNumber=" .. tostring(hasNumber))
    outputServerLog("[PHONE] Claves numéricas: " .. #numericKeys .. ", Claves no numéricas: " .. #nonNumericKeys)
    
    -- CRÍTICO: fromJSON puede devolver el JSON de diferentes maneras
    -- Necesitamos reconstruir el array correctamente desde el objeto parseado
    
    -- Si arrayLength es 0 pero hay claves numéricas, significa que fromJSON devolvió un objeto con índices numéricos
    -- pero el operador # no los cuenta correctamente
    if arrayLength == 0 and #numericKeys > 0 then
        -- Reconstruir el array desde las claves numéricas
        local tempArray = {}
        table.sort(numericKeys)
        for _, key in ipairs(numericKeys) do
            if type(contacts[key]) == "table" then
                table.insert(tempArray, contacts[key])
            end
        end
        if #tempArray > 0 then
            contacts = tempArray
            outputServerLog("[PHONE] Reconstruido array desde claves numéricas: " .. #contacts .. " contactos")
        end
    -- Si arrayLength es 0 pero tiene name y number, fromJSON devolvió solo el primer objeto del array
    elseif arrayLength == 0 and hasName and hasNumber then
        -- fromJSON devolvió solo el primer objeto, necesitamos parsear el JSON manualmente
        outputServerLog("[PHONE] fromJSON devolvió solo el primer objeto, parseando manualmente...")
        
        -- Intentar parsear el JSON manualmente usando loadstring
        local success2, result2 = pcall(function()
            -- Reemplazar corchetes y llaves para que Lua pueda parsearlo
            local luaCode = contactsJson:gsub("%[", "{"):gsub("%]", "}")
            local func = loadstring("return " .. luaCode)
            if func then
                return func()
            end
            return nil
        end)
        
        if success2 and result2 and type(result2) == "table" then
            -- Verificar si ahora tenemos un array válido
            local newArrayLength = #result2
            if newArrayLength > 0 then
                contacts = result2
                outputServerLog("[PHONE] Parseado manual exitoso: " .. newArrayLength .. " contactos")
            else
                -- Intentar extraer contactos desde el objeto parseado
                local tempArray = {}
                for k, v in pairs(result2) do
                    if type(k) == "number" and type(v) == "table" and v.name and v.number then
                        table.insert(tempArray, v)
                    end
                end
                if #tempArray > 0 then
                    contacts = tempArray
                    outputServerLog("[PHONE] Extraídos " .. #tempArray .. " contactos del parseo manual")
                end
            end
        else
            -- Si el parseo manual falla, convertir el objeto único a array
            contacts = {contacts}
            outputServerLog("[PHONE] Convertido objeto único a array (fallback)")
        end
    elseif arrayLength == 0 and pairCount > 0 then
        -- Intentar convertir objeto a array
        local tempArray = {}
        for k, v in pairs(contacts) do
            if type(k) == "number" and type(v) == "table" then
                table.insert(tempArray, v)
            elseif type(v) == "table" and v.name and v.number then
                table.insert(tempArray, v)
            end
        end
        if #tempArray > 0 then
            contacts = tempArray
            outputServerLog("[PHONE] Convertido objeto a array con " .. #tempArray .. " elementos")
        end
    end
    
    -- Verificar que contacts sea un array válido
    if type(contacts) ~= "table" then
        outputServerLog("[PHONE] ERROR: contacts no es una tabla después del procesamiento")
        return
    end
    
    -- CRÍTICO: Extraer todos los contactos usando pairs para asegurar que no se pierda ninguno
    local allContacts = {}
    for k, v in pairs(contacts) do
        if type(k) == "number" and type(v) == "table" and v.name and v.number then
            -- Es un elemento del array con índice numérico y tiene name/number
            table.insert(allContacts, v)
        elseif type(v) == "table" and v.name and v.number and type(k) ~= "string" then
            -- Es un objeto con propiedades name y number (no es una propiedad del objeto)
            table.insert(allContacts, v)
        end
    end
    
    -- Si encontramos contactos con pairs, usar esos
    if #allContacts > 0 then
        if #allContacts ~= #contacts then
            outputServerLog("[PHONE] Encontrados " .. #allContacts .. " contactos con pairs vs " .. #contacts .. " con ipairs, usando pairs")
        end
        contacts = allContacts
    end
    
    outputServerLog("[PHONE] Contactos finales después del procesamiento completo: " .. #contacts)
    
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
        outputServerLog("[PHONE] No hay contactos para insertar, solo se eliminaron los antiguos")
        return
    end
    
    -- Insertar nuevos contactos
    local insertCount = 0
    local errorCount = 0
    outputServerLog("[PHONE] Total de contactos a insertar: " .. tostring(#contacts))
    
    -- Usar ipairs para procesar en orden
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
    
    -- Mostrar mensaje de confirmación al jugador
    if insertCount > 0 then
        outputChatBox("✓ " .. tostring(insertCount) .. " contacto(s) guardado(s) correctamente.", player, 0, 255, 0)
    elseif errorCount > 0 then
        outputChatBox("Error: No se pudieron guardar algunos contactos. Intenta de nuevo.", player, 255, 0, 0)
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
end)

