-- CLIENT.LUA - Sistema de Pólvora y Pirotecnia con Efectos
local screenW, screenH = guiGetScreenSize()
local panelAbierto = false
local animacionPanel = 0
local efectosActivos = {}

-- Detectar click en NPC
addEventHandler("onClientClick", root, function(button, state, _, _, _, _, _, element)
    if button == "right" and state == "down" then
        if element and getElementType(element) == "ped" then
            if getElementData(element, "esVendedorPolvora") then
                local x, y, z = getElementPosition(element)
                local px, py, pz = getElementPosition(localPlayer)
                local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
                
                if distancia < 3 then
                    triggerServerEvent("polvora:clickNPC", localPlayer)
                end
            end
        end
    end
end)

-- Abrir panel
addEvent("polvora:abrirPanel", true)
addEventHandler("polvora:abrirPanel", root, function(items)
    if panelAbierto then return end
    
    itemsPolvora = items
    panelAbierto = true
    animacionPanel = 0
    showCursor(true)
    
    addEventHandler("onClientRender", root, renderPanelPolvora)
    addEventHandler("onClientClick", root, clickPanelPolvora)
    addEventHandler("onClientKey", root, teclasPanelPolvora)
end)

-- Cerrar panel
function cerrarPanelPolvora()
    if panelAbierto then
        showCursor(false)
        panelAbierto = false
        removeEventHandler("onClientRender", root, renderPanelPolvora)
        removeEventHandler("onClientClick", root, clickPanelPolvora)
        removeEventHandler("onClientKey", root, teclasPanelPolvora)
    end
end

-- Render del panel
function renderPanelPolvora()
    if animacionPanel < 1 then
        animacionPanel = animacionPanel + 0.05
    end
    
    local ancho, alto = 900, 600
    local x = (screenW - ancho) / 2
    local y = (screenH - alto) / 2
    
    local offsetY = (1 - animacionPanel) * -100
    y = y + offsetY
    local alpha = animacionPanel * 255
    
    -- Fondo
    dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 0, 0, 200 * animacionPanel))
    
    -- Panel principal (naranja/rojo fuego)
    dxDrawRectangle(x, y, ancho, alto, tocolor(20, 20, 20, alpha), false)
    dxDrawRectangle(x, y, ancho, 4, tocolor(255, 100, 0, alpha), false)
    
    -- Header con gradiente de fuego
    dxDrawRectangle(x, y, ancho, 80, tocolor(40, 20, 10, alpha), false)
    dxDrawRectangle(x, y, ancho, 80, tocolor(255, 100, 0, alpha * 0.3), false)
    
    -- Título con efecto de fuego
    local brillo = math.abs(math.sin(getTickCount() / 400)) * 80 + 175
    dxDrawText("💥 PIROTECNIA", x, y + 10, x + ancho, y + 50, tocolor(255, 255, 255, alpha), 2, "pricedown", "center", "top")
    dxDrawText("EXPLOSIVOS Y EFECTOS", x, y + 50, x + ancho, y + 75, tocolor(brillo, 100, 0, alpha), 1.2, "default-bold", "center", "top")
    
    -- Botón cerrar
    local btnCerrarX = x + ancho - 60
    dibujarBotonRedondeado(btnCerrarX, y + 15, 50, 50, tocolor(255, 50, 0, alpha), "✕", alpha, 2)
    
    -- Contenido (solo tienda)
    renderTienda(x, y, ancho, alto, alpha)
    
    -- Saldo (usar el sistema de dinero del gamemode)
    local saldo = getElementData(localPlayer, "character:money") or 0
    dxDrawRectangle(x + 30, y + alto - 60, 250, 40, tocolor(20, 20, 20, alpha * 0.9), false)
    dxDrawText("💰 Saldo: $" .. tostring(saldo), x + 30, y + alto - 60, x + 280, y + alto - 20, tocolor(100, 255, 100, alpha), 1.2, "default-bold", "center", "center")
end

-- Render tienda
function renderTienda(x, y, ancho, alto, alpha)
    local listaY = y + 170
    local itemAlto = 80
    
    for i, item in ipairs(itemsPolvora) do
        local itemY = listaY + ((i - 1) * (itemAlto + 10))
        
        if itemY > y + 160 and itemY < y + alto - 80 then
            -- Fondo
            dxDrawRectangle(x + 30, itemY, ancho - 60, itemAlto, tocolor(30, 30, 30, alpha * 0.9), false)
            dxDrawRectangle(x + 30, itemY, 5, itemAlto, tocolor(255, 100, 0, alpha), false)
            
            -- Nombre
            dxDrawText(item.nombre, x + 50, itemY + 10, x + 400, itemY + 35, tocolor(255, 255, 255, alpha), 1.2, "default-bold")
            
            -- Precio
            dxDrawText("$" .. item.precio, x + 50, itemY + 40, x + 200, itemY + 65, tocolor(255, 200, 50, alpha), 1.3, "pricedown")
            
            -- Descripción
            dxDrawText(item.desc, x + 220, itemY + 45, x + ancho - 220, itemY + 70, tocolor(200, 200, 200, alpha), 0.9, "default")
            
            -- Botón COMPRAR
            local brilloBtn = math.abs(math.sin(getTickCount() / 300 + i)) * 50 + 200
            dibujarBotonRedondeado(x + ancho - 210, itemY + 15, 160, 50, tocolor(brilloBtn, 100, 0, alpha), "💥 COMPRAR", alpha, 1.1)
        end
    end
end


-- Botón redondeado
function dibujarBotonRedondeado(x, y, ancho, alto, color, texto, alpha, escalaTexto)
    escalaTexto = escalaTexto or 1
    dxDrawRectangle(x + 3, y + 3, ancho, alto, tocolor(0, 0, 0, alpha * 0.5), false)
    dxDrawRectangle(x, y, ancho, alto, color, false)
    dxDrawText(texto, x, y, x + ancho, y + alto, tocolor(255, 255, 255, alpha), escalaTexto, "default-bold", "center", "center")
end

-- Clicks
function clickPanelPolvora(button, state)
    if not panelAbierto or button ~= "left" or state ~= "down" then return end
    if animacionPanel < 1 then return end
    
    local ancho, alto = 900, 600
    local x = (screenW - ancho) / 2
    local y = (screenH - alto) / 2
    local mx, my = getCursorPosition()
    mx, my = mx * screenW, my * screenH
    
    -- Botón cerrar
    if mx >= x + ancho - 60 and mx <= x + ancho - 10 and my >= y + 15 and my <= y + 65 then
        cerrarPanelPolvora()
        return
    end
    
    -- Solo manejar clicks en la tienda
    clickTienda(x, y, ancho, alto, mx, my)
end

-- Clicks tienda
function clickTienda(x, y, ancho, alto, mx, my)
    local listaY = y + 170
    local itemAlto = 80
    
    for i, item in ipairs(itemsPolvora) do
        local itemY = listaY + ((i - 1) * (itemAlto + 10))
        
        if my >= itemY and my <= itemY + itemAlto then
            if mx >= x + ancho - 210 and mx <= x + ancho - 50 then
                triggerServerEvent("polvora:comprarItem", localPlayer, item.id, item.precio, item.nombre)
                return
            end
        end
    end
end


-- Teclas
function teclasPanelPolvora(key, press)
    if not panelAbierto or not press then return end
    if key == "escape" or key == "backspace" then
        cerrarPanelPolvora()
        cancelEvent()
    end
end

-- ==============================
-- SISTEMA DE EFECTOS VISUALES
-- ==============================

-- Activar efecto
addEvent("polvora:activarEfecto", true)
addEventHandler("polvora:activarEfecto", root, function(efecto, x, y, z)
    if efecto == "petardo" then
        efectoPetardo(x, y, z)
    elseif efecto == "bengala" then
        efectoBengala(x, y, z)
    elseif efecto == "cohete" then
        efectoCohete(x, y, z)
    elseif efecto == "trueno" then
        efectoTrueno(x, y, z)
    elseif efecto == "fuente" then
        efectoFuente(x, y, z)
    elseif efecto == "humo" then
        efectoHumo(x, y, z)
    elseif efecto == "profesional" then
        efectoProfesional(x, y, z)
    elseif efecto == "destello" then
        efectoDestello(x, y, z)
    end
end)

-- Efecto: Petardo
function efectoPetardo(x, y, z)
    createExplosion(x, y, z, 1, false, 0.5, false)
    
    -- Partículas de chispas
    for i = 1, 10 do
        fxAddSparks(x, y, z + 0.5, 0, 0, 0, 3, 1, 0, 0, 0, false, 1, 1)
    end
    
    -- Sonido del juego
    playSoundFrontEnd(1)
end

-- Efecto: Bengala
function efectoBengala(x, y, z)
    setTimer(function()
        fxAddSparks(x + math.random(-1, 1), y + math.random(-1, 1), z + 1, 0, 0, 1, 5, 0.5, 0, 0, 0, false, 0.5, 1)
    end, 100, 30)
end

-- Efecto: Cohete
function efectoCohete(x, y, z)
    -- Sonido de lanzamiento
    playSoundFrontEnd(1)
    
    -- Subir cohete
    local alturaFinal = z + 30
    local pasos = 15
    local intervalo = 100
    
    for i = 1, pasos do
        setTimer(function()
            local alturaActual = z + ((alturaFinal - z) / pasos) * i
            fxAddSparks(x, y, alturaActual, 0, 0, 1, 3, 1, 255, 100, 0, false, 0.5, 1)
        end, intervalo * i, 1)
    end
    
    -- Explosión final
    setTimer(function()
        createExplosion(x, y, alturaFinal, 1, false, 1, false)
        
        -- Chispas de colores
        for i = 1, 20 do
            local angle = (math.pi * 2 / 20) * i
            local fx = x + math.cos(angle) * 5
            local fy = y + math.sin(angle) * 5
            
            fxAddSparks(fx, fy, alturaFinal, 0, 0, -1, 5, 1, math.random(0, 255), math.random(0, 255), math.random(100, 255), false, 1, 1)
        end
    end, intervalo * pasos, 1)
end

-- Efecto: Trueno
function efectoTrueno(x, y, z)
    createExplosion(x, y, z + 1, 6, true, 1, false)
    playSoundFrontEnd(1)
    
    -- Humo
    fxAddGunshot(x, y, z + 1, 0, 0, 0, false)
end

-- Efecto: Fuente
function efectoFuente(x, y, z)
    playSoundFrontEnd(1)
    
    for i = 1, 50 do
        setTimer(function()
            for j = 1, 3 do
                local offsetX = math.random(-1, 1) * 0.5
                local offsetY = math.random(-1, 1) * 0.5
                fxAddSparks(x + offsetX, y + offsetY, z + 0.5, 0, 0, 2, 5, 0.8, 255, 200, 50, false, 1, 1)
            end
        end, 100 * i, 1)
    end
end

-- Efecto: Humo
function efectoHumo(x, y, z)
    for i = 1, 30 do
        setTimer(function()
            fxAddGunshot(x + math.random(-2, 2), y + math.random(-2, 2), z + 0.5, 0, 0, 1, false)
        end, 200 * i, 1)
    end
end

-- Efecto: Profesional (show completo)
function efectoProfesional(x, y, z)
    for i = 1, 10 do
        setTimer(function()
            local offsetX = math.random(-10, 10)
            local offsetY = math.random(-10, 10)
            efectoCohete(x + offsetX, y + offsetY, z)
        end, 500 * i, 1)
    end
end

-- Efecto: Destello
function efectoDestello(x, y, z)
    createExplosion(x, y, z + 2, 1, false, 2, false)
    
    -- Flash brillante
    for i = 1, 50 do
        fxAddSparks(x + math.random(-5, 5), y + math.random(-5, 5), z + math.random(0, 5), 0, 0, 0, 10, 0.5, 255, 255, 255, false, 0.3, 1)
    end
    
    playSoundFrontEnd(1)
end