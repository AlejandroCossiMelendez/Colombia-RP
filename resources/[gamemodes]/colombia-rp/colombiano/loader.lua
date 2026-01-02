
-- Esperar a que el recurso esté completamente cargado y pDecrypt esté disponible
addEventHandler("onClientResourceStart", root, function(resource)
    -- Solo ejecutar si es el gamemode colombia-rp
    if getResourceName(resource) ~= "colombia-rp" then
        return
    end
    -- Esperar un momento para que key.pcrypt se cargue completamente
    setTimer(function()
        if not pDecrypt then
            outputChatBox("Error: pDecrypt no está disponible. Verifica que key.pcrypt se haya cargado.", 255, 0, 0)
            return
        end
        
        local files = {
            { "pcrypted/[COLOMBIANO].txd.pcrypt", 30 },
            { "pcrypted/[COLOMBIANO].dff.pcrypt", 30 },
        }
        
        local currentIndex = 1
        
        function loadModel(file, data, model)
            local ext = file:match("^.+(%..+)%..+$")
            
            if ext == ".dff" then
                local dff = engineLoadDFF(data)
                if dff then
                    engineReplaceModel(dff, model)
                    outputChatBox("✓ Skin colombiana cargada (DFF) para modelo " .. model, 0, 255, 0)
                else
                    outputChatBox("Error al cargar DFF: " .. file, 255, 0, 0)
                end
            elseif ext == ".txd" then
                local txd = engineLoadTXD(data)
                if txd then
                    engineImportTXD(txd, model)
                    outputChatBox("✓ Skin colombiana cargada (TXD) para modelo " .. model, 0, 255, 0)
                else
                    outputChatBox("Error al cargar TXD: " .. file, 255, 0, 0)
                end
            elseif ext == ".col" then
                local col = engineLoadCOL(data)
                if col then
                    engineReplaceCOL(col, model)
                end
            end
            
            -- Cargar el siguiente archivo
            currentIndex = currentIndex + 1
            if currentIndex <= #files then
                local nextFile = files[currentIndex][1]
                local nextModel = files[currentIndex][2]
                pDecrypt(nextFile, function(data)
                    if data then
                        loadModel(nextFile, data, nextModel)
                    else
                        outputChatBox("Error al descifrar: " .. nextFile, 255, 0, 0)
                    end
                end)
            else
                files = nil
                collectgarbage()
            end
        end
        
        -- Cargar el primer archivo
        local firstFile = files[currentIndex][1]
        local firstModel = files[currentIndex][2]
        pDecrypt(firstFile, function(data)
            if data then
                loadModel(firstFile, data, firstModel)
            else
                outputChatBox("Error al descifrar: " .. firstFile, 255, 0, 0)
            end
        end)
    end, 1500, 1) -- Esperar 1.5 segundos para que key.pcrypt se cargue
end)
