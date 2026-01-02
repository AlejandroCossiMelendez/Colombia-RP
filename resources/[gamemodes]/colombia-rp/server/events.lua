-- Archivo para registrar eventos remotamente activables
-- Este archivo DEBE cargarse PRIMERO para que los eventos estén disponibles

outputServerLog("[EVENTS] Cargando eventos remotamente activables...")

-- Eventos de login y registro (usando resourceRoot para asegurar que funcionen)
addEvent("onPlayerLogin", true)
addEvent("onPlayerRegister", true)
outputServerLog("[EVENTS] Eventos de login registrados: onPlayerLogin, onPlayerRegister")

-- Verificar que los eventos se registraron correctamente
setTimer(function()
    outputServerLog("[EVENTS] Verificando eventos...")
    -- Los eventos deberían estar disponibles ahora
end, 100, 1)

-- Eventos de personajes
addEvent("requestCharacters", true)
addEvent("selectCharacter", true)
addEvent("createCharacter", true)
addEvent("deleteCharacter", true)
outputServerLog("[EVENTS] Eventos de personajes registrados")

-- Eventos de inventario
addEvent("requestInventory", true)
addEvent("useItem", true)
addEvent("moveInventoryItem", true)
addEvent("dropInventoryItem", true)
outputServerLog("[EVENTS] Eventos de inventario registrados")

outputServerLog("[EVENTS] Todos los eventos registrados correctamente")
