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
addEvent("requestSkinPreview", true)
addEvent("receiveSkinPreview", true)
outputServerLog("[EVENTS] Eventos de personajes registrados")

-- Eventos de inventario
addEvent("requestInventory", true)
addEvent("useItem", true)
addEvent("moveInventoryItem", true)
addEvent("dropInventoryItem", true)
addEvent("unequipVest", true)
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

-- Eventos del panel de administración
addEvent("admin:revivePlayer", true)
addEvent("admin:teleportToPlayer", true)
addEvent("admin:bringPlayer", true)
addEvent("admin:toggleInvisibility", true)
addEvent("admin:healPlayer", true)
addEvent("admin:giveMoney", true)
addEvent("admin:getCoords", true)
addEvent("admin:freecamTeleport", true)
addEvent("admin:getItemsList", true)
addEvent("admin:receiveItemsList", true)
addEvent("admin:giveItems", true)
addEvent("admin:giveItemsResponse", true)
addEvent("admin:createVehicle", true)
addEvent("admin:reviveResponse", true)
addEvent("admin:teleportResponse", true)
addEvent("admin:healResponse", true)
addEvent("admin:giveMoneyResponse", true)
addEvent("admin:invisibilityUpdate", true)
outputServerLog("[EVENTS] Eventos del panel de administración registrados: admin:revivePlayer, admin:teleportToPlayer, admin:bringPlayer, admin:toggleInvisibility, admin:healPlayer, admin:giveMoney, admin:getCoords, admin:getItemsList, admin:giveItems, admin:reviveResponse, admin:teleportResponse, admin:healResponse, admin:giveMoneyResponse, admin:giveItemsResponse, admin:invisibilityUpdate")

-- Eventos del teléfono
addEvent("saveContacts", true)
addEvent("loadContacts", true)
addEvent("receiveContacts", true)
addEvent("closePhoneFromBrowser", true)
outputServerLog("[EVENTS] Eventos del teléfono registrados: saveContacts, loadContacts, receiveContacts, closePhoneFromBrowser")
-- Eventos de llamadas
addEvent("phone:makeCall", true)
addEvent("phone:answerCall", true)
addEvent("phone:hangup", true)
addEvent("phone:toggleSpeaker", true)
addEvent("phone:incomingCall", true)
addEvent("phone:callAnswered", true)
addEvent("phone:callEnded", true)
addEvent("phone:callRinging", true)
addEvent("phone:callFailed", true)
addEvent("phone:callStarted", true)
addEvent("phone:requestCallStatus", true)
outputServerLog("[EVENTS] Eventos de llamadas registrados: phone:makeCall, phone:answerCall, phone:hangup, phone:toggleSpeaker, phone:incomingCall, phone:callAnswered, phone:callEnded, phone:callRinging, phone:callFailed, phone:callStarted, phone:requestCallStatus")
-- Eventos de JBL
addEvent("jbl:activate", true)
addEvent("jbl:deactivate", true)
addEvent("jbl:playFromLink", true)
addEvent("jbl:playFromSpotify", true)
addEvent("jbl:setVolume", true)
addEvent("jbl:stopMusic", true)
addEvent("jbl:convertYouTube", true)
outputServerLog("[EVENTS] Eventos de JBL registrados: jbl:activate, jbl:deactivate, jbl:playFromLink, jbl:playFromSpotify, jbl:setVolume, jbl:stopMusic, jbl:convertYouTube")
-- Eventos de pólvora/C4
addEvent("polvora:clickNPC", true)
addEvent("polvora:comprarItem", true)
addEvent("polvora:usarItem", true)
addEvent("polvora:colocarC4", true)
addEvent("polvora:crearC4", true)
addEvent("polvora:c4Colocado", true)
addEvent("polvora:notificarExplosion", true)
addEvent("polvora:abrirPanel", true)
addEvent("polvora:activarEfecto", true)
outputServerLog("[EVENTS] Eventos de pólvora/C4 registrados: polvora:clickNPC, polvora:comprarItem, polvora:usarItem, polvora:colocarC4, polvora:crearC4, polvora:c4Colocado, polvora:notificarExplosion, polvora:abrirPanel, polvora:activarEfecto")

outputServerLog("[EVENTS] Todos los eventos registrados correctamente")
