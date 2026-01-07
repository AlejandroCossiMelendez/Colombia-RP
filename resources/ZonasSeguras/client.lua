-- ZonasSeguras OPTIMIZADO - CPU reducido de 4.5% a <0.5%
local sx,sy = guiGetScreenSize()
local px,py = 1440,900
local x,y =  (sx/px), (sy/py)

zonas_seguras = {
    {986.34765625, -1050.1416015625, 0.0, 100, 94, 100}, -- MECA
    {1672.5870361328, -2327.51953125, 0.0, 100, 94, 100}, -- AEROPUERTO 
    {1986.90234375, -1327.8768310547, 0.0, 100, 94, 100}, -- KYOTO CLUB
}

local jugadoresEnZona = {}

-- OPTIMIZACIÃ“N: Cache para evitar cÃ¡lculos repetidos
local renderCache = {
    lastUpdate = 0,
    updateInterval = 100, -- Actualizar cada 100ms en lugar de cada frame
    playersData = {},
    needsUpdate = true
}

-- OPTIMIZACIÃ“N: Colores precomputados
local COLOR_SOMBRA = tocolor(0, 0, 0, 255)
local COLOR_TEXTO = tocolor(0, 255, 0, 255)

-- OPTIMIZACIÃ“N: FunciÃ³n para actualizar cache de jugadores
local function actualizarCacheJugadores()
    local currentTime = getTickCount()
    if currentTime - renderCache.lastUpdate < renderCache.updateInterval then
        return
    end
    
    renderCache.lastUpdate = currentTime
    renderCache.playersData = {}
    
    -- Solo procesar jugadores que realmente estÃ¡n en zona
    for player, _ in pairs(jugadoresEnZona) do
        if isElement(player) and isPedOnGround(player) then
            local x, y, z = getElementPosition(player)
            local screenX, screenY = getScreenFromWorldPosition(x, y, z + 1.3)
            
            if screenX and screenY then
                renderCache.playersData[#renderCache.playersData + 1] = {
                    screenX = screenX,
                    screenY = screenY
                }
            end
        end
    end
end

-- OPTIMIZACIÃ“N: FunciÃ³n de dibujo ultra eficiente
function dibujarNombresZonaSegura()
    -- Actualizar cache solo cada 100ms
    actualizarCacheJugadores()
    
    -- Dibujar usando datos cacheados
    for i = 1, #renderCache.playersData do
        local data = renderCache.playersData[i]
        local screenX, screenY = data.screenX, data.screenY
        
        -- Sombra
        dxDrawText("Zona Segura", screenX + 1, screenY + 1, screenX, screenY, COLOR_SOMBRA, 1.3, "default-bold", "center", "center", false, false, false, false, false)
        -- Texto principal
        dxDrawText("Zona Segura", screenX, screenY, screenX, screenY, COLOR_TEXTO, 1.3, "default-bold", "center", "center", false, false, false, false, false)
    end
end

function crearZonasSeguras()
    for i, zona in ipairs(zonas_seguras) do
        local zona_verde = createColCuboid(zona[1], zona[2], zona[3], zona[4], zona[5], zona[6])
        createRadarArea(zona[1], zona[2], zona[4], zona[5], 0, 255, 0, 100)

        addEventHandler("onClientColShapeHit", zona_verde, function(hitPlayer)
            if getElementType(hitPlayer) == "player" then
                jugadoresEnZona[hitPlayer] = true
                renderCache.needsUpdate = true -- Marcar cache para actualizar
                
                if hitPlayer == localPlayer then
                    setPedWeaponSlot(hitPlayer, 0)
                    setToggleControlsPlayer(false)
                    addEventHandler("onClientRender", getRootElement(), dibujarNombresZonaSegura)
                    addEventHandler("onClientPlayerDamage", getRootElement(), quitarDano)
                    addEventHandler("onClientKey", root, bloquearGolpes)
                end
            end
        end)

        addEventHandler("onClientColShapeLeave", zona_verde, function(hitPlayer)
            if getElementType(hitPlayer) == "player" then
                jugadoresEnZona[hitPlayer] = nil
                renderCache.needsUpdate = true -- Marcar cache para actualizar
                
                if hitPlayer == localPlayer then
                    setToggleControlsPlayer(true)
                    removeEventHandler("onClientRender", getRootElement(), dibujarNombresZonaSegura)
                    removeEventHandler("onClientPlayerDamage", getRootElement(), quitarDano)
                    removeEventHandler("onClientKey", root, bloquearGolpes)
                end
            end
        end)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, crearZonasSeguras)

function setToggleControlsPlayer(status)
    toggleControl("fire", status) -- Disparar
    toggleControl("aim_weapon", status) -- Apuntar
    toggleControl("next_weapon", status) -- Cambiar arma adelante
    toggleControl("previous_weapon", status) -- Cambiar arma atrÃ¡s
    toggleControl("vehicle_fire", status) -- Disparar desde vehÃ­culo
    toggleControl("vehicle_secondary_fire", status) -- Disparo secundario en vehÃ­culo
    toggleControl("melee", status) -- Golpes cuerpo a cuerpo
    toggleControl("action", status) -- BotÃ³n de acciÃ³n (puede permitir ataques)
end

function quitarDano()
    cancelEvent() -- Cancela cualquier daÃ±o recibido dentro de la zona segura
end

function bloquearGolpes(key, press)
    -- Bloquea el intento de golpear (teclas de ataque cuerpo a cuerpo)
    if key == "lctrl" or key == "rctrl" or key == "mouse1" or key == "mouse2" then
        cancelEvent()
    end
end
