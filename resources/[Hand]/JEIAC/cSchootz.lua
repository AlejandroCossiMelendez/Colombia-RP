-- JEICORDERO AC - Cliente Limpio
-- Solo Anti-Spoofer y Anti-Executor

outputDebugString("🔥🔥🔥 [JEICORDERO AC] SCRIPT CLIENTE CARGADO! 🔥🔥🔥", 3)
-- outputChatBox("🔥 JEICORDERO AC - Cliente cargado!", 255, 255, 0)  -- Comentado para no molestar

local antiCheatActive = false
local playerSerial = nil
local executorDetections = 0

-- Test inmediato de configuración
if config then
    outputDebugString("✅ [JEICORDERO AC] Config encontrado al cargar script", 3)
else
    outputDebugString("❌ [JEICORDERO AC] Config NO encontrado al cargar script", 1)
end

-- ===== ANTI-SPOOFER =====
function initializeAntiSpoofer()
    -- Verificar si el módulo está habilitado
    if config and config.modules and config.modules.antispoofer and not config.modules.antispoofer.enabled then
        outputDebugString("[JEICORDERO AC] ⚠️ Anti-Spoofer deshabilitado en configuración", 2)
        return
    end
    
    outputDebugString("[JEICORDERO AC] 🔍 Iniciando Anti-Spoofer...", 3)
    playerSerial = getPlayerSerial(localPlayer)
    outputDebugString("[JEICORDERO AC] 📋 Serial del jugador: " .. playerSerial, 3)
    
    -- Obtener nombre del archivo de configuración
    local fileName = "@pegasus_serial.json"
    if config and config.modules and config.modules.antispoofer and config.modules.antispoofer.file_name then
        fileName = config.modules.antispoofer.file_name
    end
    
    -- Crear archivo de serial si no existe
    if not fileExists(fileName) then
        outputDebugString("[JEICORDERO AC] 🔨 Intentando crear archivo: " .. fileName, 3)
        local serialFile = fileCreate(fileName)
        if serialFile then
            local serialData = {
                serial = playerSerial,
                created = getRealTime().timestamp,
                version = "2.0"
            }
            local jsonData = toJSON(serialData)
            fileWrite(serialFile, jsonData)
            fileClose(serialFile)
            outputDebugString("[JEICORDERO AC] ✅ Archivo de serial creado exitosamente: " .. fileName, 3)
            outputDebugString("[JEICORDERO AC] 📄 Contenido: " .. jsonData, 3)
            
            -- Mostrar información del sistema para encontrar el archivo
            outputDebugString("[JEICORDERO AC] 💻 Usuario: " .. (os.getenv("USERNAME") or "Desconocido"), 3)
            outputDebugString("[JEICORDERO AC] 🏠 LOCALAPPDATA: " .. (os.getenv("LOCALAPPDATA") or "No encontrado"), 3)
            outputDebugString("[JEICORDERO AC] 🏠 APPDATA: " .. (os.getenv("APPDATA") or "No encontrado"), 3)
            outputDebugString("[JEICORDERO AC] 💿 PROGRAMFILES: " .. (os.getenv("PROGRAMFILES") or "No encontrado"), 3)
            outputDebugString("[JEICORDERO AC] 💿 PROGRAMFILES(X86): " .. (os.getenv("PROGRAMFILES(X86)") or "No encontrado"), 3)
            
            -- Instrucciones para encontrar el archivo
            outputChatBox("🔍 ARCHIVO CREADO: " .. fileName, 255, 255, 0)
            outputChatBox("📂 BUSCAR EN:", 255, 255, 0) 
            outputChatBox("1. Carpeta de MTA/resources/JEIAC/", 255, 255, 0)
            outputChatBox("2. AppData/Local/MTA*/server-cache/*/JEIAC/", 255, 255, 0)
            outputChatBox("3. Usar 'Buscar archivos' en Windows: @pegasus_serial.json", 255, 255, 0)
        else
            outputDebugString("[JEICORDERO AC] ❌ Error: No se pudo crear el archivo " .. fileName, 1)
        end
    else
        -- Archivo existe, verificar serial guardado vs serial actual
        outputDebugString("[JEICORDERO AC] 📂 Archivo de serial encontrado: " .. fileName, 3)
        local serialFile = fileOpen(fileName)
        if serialFile then
            local fileSize = fileGetSize(serialFile)
            local fileContent = fileRead(serialFile, fileSize)
            fileClose(serialFile)
            
            outputDebugString("[JEICORDERO AC] 📖 Leyendo archivo, tamaño: " .. fileSize .. " bytes", 3)
            
            local savedData = fromJSON(fileContent)
            if savedData and savedData.serial then
                outputDebugString("[JEICORDERO AC] 🔍 Serial guardado: " .. savedData.serial, 3)
                outputDebugString("[JEICORDERO AC] 🔍 Serial actual: " .. playerSerial, 3)
                
                if savedData.serial ~= playerSerial then
                    -- Serial diferente detectado - posible spoofer
                    outputDebugString("[JEICORDERO AC] 🚨 SPOOFER DETECTADO!", 1)
                    outputDebugString("[JEICORDERO AC] 📊 Serial anterior: " .. savedData.serial, 1)
                    outputDebugString("[JEICORDERO AC] 📊 Serial actual: " .. playerSerial, 1)
                    triggerServerEvent("Pegasus.DetectSpoofer", resourceRoot, savedData.serial, playerSerial)
                else
                    -- Serial correcto, actualizar última verificación
                    outputDebugString("[JEICORDERO AC] ✅ Serial verificado correctamente", 3)
                    savedData.last_check = getRealTime().timestamp
                    local updateFile = fileCreate(fileName)
                    if updateFile then
                        fileWrite(updateFile, toJSON(savedData))
                        fileClose(updateFile)
                    end
                end
            else
                outputDebugString("[JEICORDERO AC] ⚠️ Error: Archivo JSON corrupto o sin serial", 2)
            end
        else
            outputDebugString("[JEICORDERO AC] ❌ Error: No se pudo abrir el archivo " .. fileName, 1)
        end
    end
end

-- ===== ANTI-EXECUTOR =====
local blockedFunctions = {
    "loadstring",
    "setElementData",
    "triggerServerEvent",
    "executeCommandHandler",
    "addCommandHandler"
}

-- Usar patrones de configuración centralizada
function getSuspiciousPatterns()
    if config and config.modules and config.modules.antiexecutor then
        return config.modules.antiexecutor.suspicious_patterns
    end
    
    -- Fallback si no hay configuración
    return {
        "triggerServerEvent.*roadblockCreateWorldObject",
        "createObject.*252[15]",
        "setElementData.*ID",
        "setElementData.*Level", 
        "setElementData.*Money",
        "setElementData.*Cash",
        "givePlayerMoney",
        "setPlayerMoney",
        "createObject",
        "createVehicle",
        "giveWeapon",
        "setPedStat"
    }
end

function checkSuspiciousCode(code)
    if not code or type(code) ~= "string" then
        return false
    end
    
    -- Verificar si el módulo está habilitado
    if config and config.modules and config.modules.antiexecutor and not config.modules.antiexecutor.enabled then
        return false
    end
    
    -- Obtener patrones de configuración
    local patterns = getSuspiciousPatterns()
    
    -- Verificar patrones sospechosos usando regex de Lua
    for _, pattern in ipairs(patterns) do
        if string.find(code, pattern) then
            return true, pattern
        end
    end
    
    return false
end

-- Hook para detectar loadstring malicioso
addDebugHook("preFunction", function(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    if functionName == "loadstring" then
        local args = {...}
        local code = args[1]
        
        if code and code ~= "return" then -- Permitir "return" para verificaciones normales
            local isSuspicious, pattern = checkSuspiciousCode(code)
            if isSuspicious then
                executorDetections = executorDetections + 1
                
                triggerServerEvent("Pegasus.detectCheaters", resourceRoot, {
                    type = "Anti-Executor",
                    code = code,
                    pattern = pattern,
                    resourceName = sourceResource and getResourceName(sourceResource) or "unknown",
                    line = luaLineNumber or 0,
                    detections = executorDetections
                })
                
                -- Bloquear ejecución
                return "return false"
            end
        end
    end
end, {"loadstring"})

-- Detectar paste de código sospechoso
addEventHandler("onClientPaste", root, function(clipboardText)
    if clipboardText then
        local isSuspicious, pattern = checkSuspiciousCode(clipboardText)
        if isSuspicious then
            triggerServerEvent("Pegasus.detectCheaters", resourceRoot, {
                type = "Anti-Executor",
                code = clipboardText,
                pattern = pattern,
                source = "clipboard",
                detections = executorDetections
            })
        end
    end
end)

-- ===== INICIALIZACIÓN =====
function startAntiCheat()
    outputDebugString("[JEICORDERO AC] 🚀 INICIANDO CLIENTE...", 3)
    
    -- Marcar como inicializado
    antiCheatActive = true
    setElementData(localPlayer, "Pegasus.AntiCheat", true)
    
    -- Verificar si config existe
    if not config then
        outputDebugString("[JEICORDERO AC] ❌ ERROR: Configuración no encontrada!", 1)
        return
    end
    
    outputDebugString("[JEICORDERO AC] ✅ Configuración encontrada", 3)
    
    -- Inicializar anti-spoofer
    initializeAntiSpoofer()
    
    outputDebugString("[JEICORDERO AC] ✅ Cliente iniciado - Anti-Spoofer y Anti-Executor activos", 3)
end

-- ===== EVENTOS =====
outputDebugString("📋 [JEICORDERO AC] Registrando evento onClientResourceStart", 3)
addEventHandler("onClientResourceStart", resourceRoot, startAntiCheat)

-- Verificación periódica de integridad
setTimer(function()
    if antiCheatActive then
        -- Verificar que el anticheat sigue activo
        if not getElementData(localPlayer, "Pegasus.AntiCheat") then
            triggerServerEvent("Pegasus.detectCheaters", resourceRoot, {
                type = "Anti-Block",
                reason = "ElementData removed"
            })
        end
        
        -- Re-verificar serial usando intervalo de configuración
        local checkInterval = 300000 -- Default 5 minutos
        if config and config.modules and config.modules.antispoofer and config.modules.antispoofer.check_interval then
            checkInterval = config.modules.antispoofer.check_interval
        end
        
        initializeAntiSpoofer()
    end
end, config and config.modules and config.modules.antispoofer and config.modules.antispoofer.check_interval or 300000, 0)

-- Función de utilidad para verificar si un event handler existe
function isEventHandlerAdded(eventName, attachedTo, handlerFunction)
    if type(eventName) == "string" and isElement(attachedTo) and type(handlerFunction) == "function" then
        local handlers = getEventHandlers(eventName, attachedTo)
        if type(handlers) == "table" and #handlers > 0 then
            for _, handler in ipairs(handlers) do
                if handler == handlerFunction then
                    return true
                end
            end
        end
    end
    return false
end

-- Comando para mostrar contenido del archivo serial (para pruebas)
addCommandHandler("verserial", function()
    local fileName = "@pegasus_serial.json"
    if fileExists(fileName) then
        local file = fileOpen(fileName)
        if file then
            local content = fileRead(file, fileGetSize(file))
            fileClose(file)
            outputChatBox("📄 Contenido del archivo serial:", 0, 255, 255)
            outputChatBox(content, 255, 255, 255)
        else
            outputChatBox("❌ No se pudo abrir el archivo", 255, 0, 0)
        end
    else
        outputChatBox("❌ Archivo no encontrado", 255, 0, 0)
    end
end)
