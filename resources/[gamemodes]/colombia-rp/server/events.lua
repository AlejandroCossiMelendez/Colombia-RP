-- Archivo para registrar eventos remotamente activables
-- Este archivo DEBE cargarse PRIMERO para que los eventos estén disponibles
-- CRÍTICO: Este archivo debe estar ANTES de cualquier otro script en meta.xml

outputServerLog("[EVENTS] ========================================")
outputServerLog("[EVENTS] REGISTRANDO EVENTOS REMOTAMENTE ACTIVABLES")
outputServerLog("[EVENTS] ========================================")

-- Eventos de login y registro
-- El segundo parámetro 'true' marca el evento como remotamente activable desde el cliente
-- IMPORTANTE: addEvent debe ejecutarse inmediatamente, sin delays
-- Usamos nombres únicos para evitar conflictos con eventos nativos
addEvent("colombiaRP:playerLogin", true)
addEvent("colombiaRP:playerRegister", true)
outputServerLog("[EVENTS] ✓ Eventos de login registrados: colombiaRP:playerLogin, colombiaRP:playerRegister")
outputServerLog("[EVENTS] ✓ colombiaRP:playerLogin remotamente activable: true")
outputServerLog("[EVENTS] ✓ colombiaRP:playerRegister remotamente activable: true")

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

-- Eventos de muerte (para el HUD del cliente)
addEvent("onClientPlayerDeath", true)
addEvent("updateDeathTime", true)
addEvent("onClientPlayerRevived", true)
outputServerLog("[EVENTS] Eventos de muerte registrados: onClientPlayerDeath, updateDeathTime, onClientPlayerRevived")

-- Eventos del HUD
addEvent("initializeStamina", true)
outputServerLog("[EVENTS] Eventos del HUD registrados: initializeStamina")

-- Eventos de voz
addEvent("onConectarAFrecuencia", true)
addEvent("onAbrirMisFrecuencias", true)
addEvent("onCerrarMisFrecuencias", true)
addEvent("onCharacterSelected", false) -- Evento interno del servidor
outputServerLog("[EVENTS] Eventos de voz registrados: onConectarAFrecuencia, onAbrirMisFrecuencias, onCerrarMisFrecuencias, onCharacterSelected")

outputServerLog("[EVENTS] Todos los eventos registrados correctamente")
