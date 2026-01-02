-- Archivo para registrar eventos remotamente activables
-- Este archivo DEBE cargarse PRIMERO para que los eventos estén disponibles

-- Eventos de login y registro
addEvent("onPlayerLogin", true)
addEvent("onPlayerRegister", true)

-- Eventos de personajes
addEvent("requestCharacters", true)
addEvent("selectCharacter", true)
addEvent("createCharacter", true)
addEvent("deleteCharacter", true)

-- Eventos de inventario
addEvent("requestInventory", true)
addEvent("useItem", true)
addEvent("moveInventoryItem", true)
addEvent("dropInventoryItem", true)

