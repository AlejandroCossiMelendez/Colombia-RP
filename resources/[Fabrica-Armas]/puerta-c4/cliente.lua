-- Variables para el temporizador y efectos
local temporizadorC4 = nil
local efectoExplosion = nil
local sonidoReproduciendo = nil
local efectosHumo = {}
local temporizadorRespawn = nil
local tiempoRespawnTotal = 1800000 -- 30 minutos en milisegundos (debe coincidir con el servidor)
local efectosLuz = {}

function reproducirSonidoExplosion(x, y, z, sonido, dimension, interior)
    if not fileExists(sonido) then
        outputChatBox("Error: No se encontro el archivo de sonido '" .. sonido .. "'", 255, 0, 0)
        return
    end

    sonidoReproduciendo = playSound3D(sonido, x, y, z, false)
    if isElement(sonidoReproduciendo) then
        setSoundMaxDistance(sonidoReproduciendo, 50) -- Radio de audicion amplio
        setSoundVolume(sonidoReproduciendo, 2.5) -- Volumen aumentado
        setElementDimension(sonidoReproduciendo, tonumber(dimension) or 0)
        setElementInterior(sonidoReproduciendo, tonumber(interior) or 0)
    else
        outputChatBox("Error al reproducir sonido de explosion.", 255, 0, 0)
    end
end
addEvent("reproducirSonidoExplosion", true)
addEventHandler("reproducirSonidoExplosion", root, reproducirSonidoExplosion)

-- Funcion para crear el temporizador visual
function crearTemporizadorC4(x, y, z, tiempoTotal, dimension, interior)
    if isElement(temporizadorC4) then destroyElement(temporizadorC4) end
    
    local tiempoRestante = tiempoTotal
    
    -- Crear el temporizador visual
    temporizadorC4 = {}
    temporizadorC4.x, temporizadorC4.y, temporizadorC4.z = x, y, z -- Posicion en el centro de la puerta
    temporizadorC4.dimension = dimension
    temporizadorC4.interior = interior
    temporizadorC4.tiempoTotal = tiempoTotal
    temporizadorC4.tiempoRestante = tiempoRestante
    temporizadorC4.activo = true
    temporizadorC4.inicioTiempo = getTickCount()
    temporizadorC4.finTiempo = getTickCount() + tiempoTotal
    
    -- Actualizar el temporizador cada 100ms para animacion fluida
    temporizadorC4.timer = setTimer(function()
        if not temporizadorC4.activo then return end
        
        temporizadorC4.tiempoRestante = temporizadorC4.tiempoRestante - 100
        
        if temporizadorC4.tiempoRestante <= 0 then
            temporizadorC4.activo = false
            if isTimer(temporizadorC4.timer) then killTimer(temporizadorC4.timer) end
        end
    end, 100, 0)
    
    -- Anadir el renderizado del temporizador
    addEventHandler("onClientRender", root, renderizarTemporizador)
    
    -- Crear luz roja parpadeante para el C4 (si está disponible)
    if createLight then
        local luzC4 = createLight(0, x, y, z, 5, 255, 0, 0, 0, 0, 0)
        if isElement(luzC4) then
            setElementDimension(luzC4, dimension)
            setElementInterior(luzC4, interior)
            table.insert(efectosLuz, luzC4)
            
            -- Hacer que la luz parpadee
            temporizadorC4.luzTimer = setTimer(function()
                if isElement(luzC4) then
                    local intensidad = math.random(3, 8)
                    setLightRadius(luzC4, intensidad)
                end
            end, 100, 0)
        end
    end
    
    -- Notificar al jugador con un mensaje mas impactante
    outputChatBox("¡ALERTA! C4 ACTIVADO - Detonacion en " .. math.ceil(tiempoTotal/1000) .. " segundos.", 255, 0, 0)
    
    -- Sonido de tictac para aumentar la tension
    local sonidoTictac = playSound3D("tictac.mp3", x, y, z, true)
    if isElement(sonidoTictac) then
        setSoundMaxDistance(sonidoTictac, 15)
        setElementDimension(sonidoTictac, dimension)
        setElementInterior(sonidoTictac, interior)
        
        -- Aumentar la velocidad gradualmente
        local velocidadInicial = 1.0
        local velocidadFinal = 1.8
        
        -- Crear un timer que aumente la velocidad cada segundo
        local tiempoTotalSeg = tiempoTotal / 1000 -- convertir a segundos
        local incrementoVelocidad = (velocidadFinal - velocidadInicial) / tiempoTotalSeg
        
        for i = 1, tiempoTotalSeg do
            setTimer(function()
                if isElement(sonidoTictac) then
                    local nuevaVelocidad = velocidadInicial + (incrementoVelocidad * i)
                    setSoundSpeed(sonidoTictac, nuevaVelocidad)
                    
                    -- Tambien aumentar el volumen
                    local volumen = 0.8 + (i / tiempoTotalSeg) * 0.7
                    setSoundVolume(sonidoTictac, volumen)
                end
            end, i * 1000, 1)
        end
        
        -- Detener el sonido cuando termine el temporizador
        setTimer(function()
            if isElement(sonidoTictac) then
                destroyElement(sonidoTictac)
            end
        end, tiempoTotal, 1)
    end
end
addEvent("crearTemporizadorC4", true)
addEventHandler("crearTemporizadorC4", root, crearTemporizadorC4)

-- Funcion para renderizar el temporizador
function renderizarTemporizador()
    if not temporizadorC4 or not temporizadorC4.activo then 
        removeEventHandler("onClientRender", root, renderizarTemporizador)
        return 
    end
    
    -- Verificar que el jugador este en el mismo interior y dimension
    local playerDimension = getElementDimension(localPlayer)
    local playerInterior = getElementInterior(localPlayer)
    
    if playerDimension ~= temporizadorC4.dimension or playerInterior ~= temporizadorC4.interior then
        return -- No renderizar si el jugador esta en otra dimension o interior
    end
    
    local x, y, z = temporizadorC4.x, temporizadorC4.y, temporizadorC4.z
    local px, py, pz = getElementPosition(localPlayer)
    local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
    
    if distancia > 30 then return end -- No renderizar si esta muy lejos
    
    local sx, sy = getScreenFromWorldPosition(x, y, z)
    if not sx or not sy then return end
    
    local tiempoActual = getTickCount()
    local tiempoRestante = temporizadorC4.finTiempo - tiempoActual
    local segundosRestantes = math.ceil(tiempoRestante / 1000)
    local porcentaje = tiempoRestante / temporizadorC4.tiempoTotal
    
    if porcentaje < 0 then porcentaje = 0 end
    if segundosRestantes < 0 then segundosRestantes = 0 end
    
    -- Colores dinamicos basados en el tiempo restante
    local r, g, b = 255, 0, 0
    if porcentaje > 0.6 then
        r, g, b = 0, 255, 0 -- Verde
    elseif porcentaje > 0.3 then
        r, g, b = 255, 255, 0 -- Amarillo
    end
    
    -- Efecto de parpadeo cuando queda poco tiempo
    local alpha = 255
    if segundosRestantes <= 3 then
        alpha = math.abs(math.sin(getTickCount() * 0.01)) * 255
    end
    
    -- Tamano del temporizador basado en la distancia pero con un minimo mas grande
    local escala = 1.5 - (distancia / 30)
    if escala < 0.8 then escala = 0.8 end
    
    local anchoBase = 180 * escala
    local altoBase = 100 * escala
    
    -- Dibujar fondo del temporizador con efecto de transparencia y degradado
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, anchoBase, altoBase, tocolor(0, 0, 0, 200))
    
    -- Dibujar barra de progreso con efecto de degradado
    local anchoBarra = anchoBase - 20
    local altoBarra = 12 * escala
    dxDrawRectangle(sx - anchoBarra/2, sy + 20, anchoBarra, altoBarra, tocolor(50, 50, 50, 200))
    
    -- Barra de progreso con degradado
    local colorInicio = tocolor(r, g, b, alpha)
    local colorFin = tocolor(r*0.7, g*0.7, b*0.7, alpha)
    dxDrawRectangle(sx - anchoBarra/2, sy + 20, anchoBarra * porcentaje, altoBarra, colorInicio)
    
    -- Dibujar borde del temporizador con efecto de brillo
    local grosorBorde = 3 * escala
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, anchoBase, grosorBorde, tocolor(r, g, b, alpha)) -- Arriba
    dxDrawRectangle(sx - anchoBase/2, sy + altoBase/2 - grosorBorde, anchoBase, grosorBorde, tocolor(r, g, b, alpha)) -- Abajo
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, grosorBorde, altoBase, tocolor(r, g, b, alpha)) -- Izquierda
    dxDrawRectangle(sx + anchoBase/2 - grosorBorde, sy - altoBase/2, grosorBorde, altoBase, tocolor(r, g, b, alpha)) -- Derecha
    
    -- Dibujar texto del temporizador con estilo futurista
    local tamanoTexto = 3.0 * escala
    local tamanoTextoC4 = 1.8 * escala
    
    -- Anadir sombra al texto para mejor visibilidad
    dxDrawText(segundosRestantes, sx+2, sy-5+2, sx+2, sy-5+2, tocolor(0, 0, 0, alpha), tamanoTexto, "default-bold", "center", "center")
    dxDrawText(segundosRestantes, sx, sy-5, sx, sy-5, tocolor(r, g, b, alpha), tamanoTexto, "default-bold", "center", "center")
    
    -- Texto "C4" con efecto de brillo
    local brilloC4 = math.abs(math.sin(getTickCount() * 0.002)) * 50 + 200
    dxDrawText("C4 EXPLOSIVO", sx+2, sy-35+2, sx+2, sy-35+2, tocolor(0, 0, 0, alpha), tamanoTextoC4, "default-bold", "center", "center")
    dxDrawText("C4 EXPLOSIVO", sx, sy-35, sx, sy-35, tocolor(255, brilloC4, 0, alpha), tamanoTextoC4, "default-bold", "center", "center")
    
    -- Dibujar texto de "DETONANDO" en la parte inferior con efecto parpadeante
    local tamanoTextoDetona = 1.2 * escala
    local alphaDetona = math.abs(math.sin(getTickCount() * 0.005)) * 255
    dxDrawText("¡DETONANDO!", sx, sy+40, sx, sy+40, tocolor(255, 0, 0, alphaDetona), tamanoTextoDetona, "default-bold", "center", "center")
    
    -- Dibujar lineas decorativas con efecto de movimiento
    local tiempo = getTickCount()
    local movimiento = math.sin(tiempo * 0.001) * 5
    local lineaLongitud = 25 * escala
    local lineaGrosor = 2 * escala
    
    -- Esquinas superiores
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, lineaLongitud + movimiento, lineaGrosor, tocolor(r, g, b, alpha))
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, lineaGrosor, lineaLongitud + movimiento, tocolor(r, g, b, alpha))
    
    dxDrawRectangle(sx + anchoBase/2 - lineaLongitud - movimiento, sy - altoBase/2, lineaLongitud + movimiento, lineaGrosor, tocolor(r, g, b, alpha))
    dxDrawRectangle(sx + anchoBase/2 - lineaGrosor, sy - altoBase/2, lineaGrosor, lineaLongitud + movimiento, tocolor(r, g, b, alpha))
    
    -- Esquinas inferiores
    dxDrawRectangle(sx - anchoBase/2, sy + altoBase/2 - lineaGrosor, lineaLongitud + movimiento, lineaGrosor, tocolor(r, g, b, alpha))
    dxDrawRectangle(sx - anchoBase/2, sy + altoBase/2 - lineaLongitud - movimiento, lineaGrosor, lineaLongitud + movimiento, tocolor(r, g, b, alpha))
    
    dxDrawRectangle(sx + anchoBase/2 - lineaLongitud - movimiento, sy + altoBase/2 - lineaGrosor, lineaLongitud + movimiento, lineaGrosor, tocolor(r, g, b, alpha))
    dxDrawRectangle(sx + anchoBase/2 - lineaGrosor, sy + altoBase/2 - lineaLongitud - movimiento, lineaGrosor, lineaLongitud + movimiento, tocolor(r, g, b, alpha))
end

-- Funcion para crear efectos de explosion
function crearEfectoExplosion(x, y, z, dimension, interior)
    -- Verificar que el jugador este en el mismo interior y dimension
    local playerDimension = getElementDimension(localPlayer)
    local playerInterior = getElementInterior(localPlayer)
    
    if playerDimension ~= dimension or playerInterior ~= interior then
        return -- No crear efectos si el jugador esta en otra dimension o interior
    end
    
    -- Crear explosion visual principal (sin dano)
    createExplosion(x, y, z, 7, false, 0.5, false)
    
    -- Efectos adicionales de explosiones secundarias
    for i = 1, 12 do
        local offsetX = math.random(-4, 4) * 0.5
        local offsetY = math.random(-4, 4) * 0.5
        local offsetZ = math.random(-3, 3) * 0.5
        
        setTimer(function()
            createExplosion(x + offsetX, y + offsetY, z + offsetZ, 12, false, 0.3, false)
        end, i * 80, 1)
    end
    
    -- Efecto de humo persistente mejorado
    for i = 1, 5 do
        local offsetX = math.random(-3, 3)
        local offsetY = math.random(-3, 3)
        local offsetZ = math.random(-1, 2)
        local humo = createEffect("smoke", x + offsetX, y + offsetY, z + offsetZ, 0, 0, 0, 6)
        if isElement(humo) then
            setElementDimension(humo, dimension)
            setElementInterior(humo, interior)
            table.insert(efectosHumo, {elemento = humo, tiempoCreacion = getTickCount()})
        end
    end
    
    -- Efecto de fuego temporal mejorado
    for i = 1, 3 do
        local offsetX = math.random(-2, 2)
        local offsetY = math.random(-2, 2)
        local fuego = createEffect("fire", x + offsetX, y + offsetY, z - 1, 0, 0, 0, 3)
        if isElement(fuego) then
            setElementDimension(fuego, dimension)
            setElementInterior(fuego, interior)
            setTimer(destroyElement, 10000, 1, fuego)
        end
    end
    
    -- Efecto de escombros mejorado
    for i = 1, 30 do
        local px = x + math.random(-40, 40) / 10
        local py = y + math.random(-40, 40) / 10
        local pz = z + math.random(0, 30) / 10
        
        local tipoEfecto = {"gunshot", "blood", "spraycan", "tear_gas"}
        local particula = createEffect(tipoEfecto[math.random(1, #tipoEfecto)], px, py, pz)
        if isElement(particula) then
            setElementDimension(particula, dimension)
            setElementInterior(particula, interior)
            setTimer(destroyElement, math.random(1000, 4000), 1, particula)
        end
    end
    
    -- Luz brillante de explosion (si está disponible)
    if createLight then
        local luzExplosion = createLight(0, x, y, z, 15, 255, 150, 0, 0, 0, 0)
        if isElement(luzExplosion) then
            setElementDimension(luzExplosion, dimension)
            setElementInterior(luzExplosion, interior)
            table.insert(efectosLuz, luzExplosion)
            
            -- Hacer que la luz se desvanezca
            local intensidadInicial = 15
            for i = 1, 10 do
                setTimer(function()
                    if isElement(luzExplosion) then
                        setLightRadius(luzExplosion, intensidadInicial * (1 - i/10))
                    end
                end, i * 300, 1)
            end
            
            setTimer(destroyElement, 3000, 1, luzExplosion)
        end
    end
    
    -- Sacudir la camara para los jugadores cercanos
    triggerEvent("sacudirCamara", localPlayer)
    
    -- Gestionar la duracion de los efectos de humo
    setTimer(function()
        local tiempoActual = getTickCount()
        for i, efecto in ipairs(efectosHumo) do
            if isElement(efecto.elemento) and tiempoActual - efecto.tiempoCreacion > 20000 then
                destroyElement(efecto.elemento)
                efectosHumo[i] = nil
            end
        end
        
        -- Limpiar la tabla
        local nuevaTabla = {}
        for _, efecto in pairs(efectosHumo) do
            if efecto then
                table.insert(nuevaTabla, efecto)
            end
        end
        efectosHumo = nuevaTabla
    end, 21000, 1)
end
addEvent("crearEfectoExplosion", true)
addEventHandler("crearEfectoExplosion", root, crearEfectoExplosion)

-- Funcion para sacudir la camara
function sacudirCamara()
    local intensidad = 0.2
    local duracion = 4000
    local tiempoInicio = getTickCount()
    
    local sacudidaTimer = setTimer(function() end, duracion, 1)
    
    addEventHandler("onClientRender", root, function()
        local ahora = getTickCount()
        local tiempoTranscurrido = ahora - tiempoInicio
        
        if tiempoTranscurrido > duracion then
            removeEventHandler("onClientRender", root, sacudirCamara)
            return
        end
        
        local factor = 1 - (tiempoTranscurrido / duracion)
        local sacudidaX = (math.random(-15, 15) / 100) * intensidad * factor
        local sacudidaY = (math.random(-15, 15) / 100) * intensidad * factor
        
        setCameraShakeLevel(intensidad * factor * 12)
    end)
    
    setTimer(function()
        setCameraShakeLevel(0)
    end, duracion, 1)
end
addEvent("sacudirCamara", true)
addEventHandler("sacudirCamara", root, sacudirCamara)

-- Funcion para crear el temporizador de respawn
function crearTemporizadorRespawn(x, y, z, tiempoTotal, dimension, interior)
    -- Limpiar temporizador anterior si existe
    if temporizadorRespawn and temporizadorRespawn.activo then
        if isTimer(temporizadorRespawn.timer) then killTimer(temporizadorRespawn.timer) end
        if isElement(temporizadorRespawn.hologramaEfecto) then destroyElement(temporizadorRespawn.hologramaEfecto) end
        if isElement(temporizadorRespawn.luzHolograma) then destroyElement(temporizadorRespawn.luzHolograma) end
        removeEventHandler("onClientRender", root, renderizarTemporizadorRespawn)
    end
    
    -- Si el tiempo es muy corto, no crear el temporizador
    if tiempoTotal < 5000 then return end
    
    -- Crear el temporizador visual
    temporizadorRespawn = {}
    temporizadorRespawn.x, temporizadorRespawn.y, temporizadorRespawn.z = x, y, z + 2.5 -- Posicion mas arriba de la puerta
    temporizadorRespawn.dimension = dimension
    temporizadorRespawn.interior = interior
    temporizadorRespawn.tiempoTotal = tiempoTotal
    temporizadorRespawn.tiempoRestante = tiempoTotal
    temporizadorRespawn.activo = true
    temporizadorRespawn.inicioTiempo = getTickCount()
    temporizadorRespawn.finTiempo = getTickCount() + tiempoTotal
    
    -- Actualizar el temporizador cada segundo
    temporizadorRespawn.timer = setTimer(function()
        if not temporizadorRespawn.activo then return end
        
        temporizadorRespawn.tiempoRestante = temporizadorRespawn.tiempoRestante - 1000
        
        if temporizadorRespawn.tiempoRestante <= 0 then
            temporizadorRespawn.activo = false
            if isTimer(temporizadorRespawn.timer) then killTimer(temporizadorRespawn.timer) end
            removeEventHandler("onClientRender", root, renderizarTemporizadorRespawn)
            
            -- Limpiar efectos
            if isElement(temporizadorRespawn.hologramaEfecto) then destroyElement(temporizadorRespawn.hologramaEfecto) end
            if isElement(temporizadorRespawn.luzHolograma) then destroyElement(temporizadorRespawn.luzHolograma) end
        end
    end, 1000, 0)
    
    -- Anadir el renderizado del temporizador
    addEventHandler("onClientRender", root, renderizarTemporizadorRespawn)
    
    -- Crear efecto holografico en la posicion de la puerta
    local hologramaEfecto = createEffect("water_splash", x, y, z, 0, 0, 0, 2.0)
    if isElement(hologramaEfecto) then
        setElementDimension(hologramaEfecto, dimension)
        setElementInterior(hologramaEfecto, interior)
        setEffectDensity(hologramaEfecto, 3)
        setEffectSpeed(hologramaEfecto, 0.4)
        
        -- Guardar referencia al efecto
        temporizadorRespawn.hologramaEfecto = hologramaEfecto
    end
    
    -- Crear luz para el holograma (si está disponible)
    if createLight then
        local luzHolograma = createLight(0, x, y, z, 8, 0, 150, 255, 0, 0, 0)
        if isElement(luzHolograma) then
            setElementDimension(luzHolograma, dimension)
            setElementInterior(luzHolograma, interior)
            temporizadorRespawn.luzHolograma = luzHolograma
            table.insert(efectosLuz, luzHolograma)
        end
    end
    
    -- Notificar al jugador con mensaje mejorado
    local minutos = math.floor(tiempoTotal / 60000)
    local segundos = math.floor((tiempoTotal % 60000) / 1000)
    outputChatBox("SISTEMA: La puerta se regenerara en " .. minutos .. " minutos y " .. segundos .. " segundos.", 0, 200, 255)
end
addEvent("crearTemporizadorRespawn", true)
addEventHandler("crearTemporizadorRespawn", root, crearTemporizadorRespawn)

-- Funcion para renderizar el temporizador de respawn
function renderizarTemporizadorRespawn()
    if not temporizadorRespawn or not temporizadorRespawn.activo then 
        removeEventHandler("onClientRender", root, renderizarTemporizadorRespawn)
        return 
    end
    
    -- Verificar que el jugador este en el mismo interior y dimension
    local playerDimension = getElementDimension(localPlayer)
    local playerInterior = getElementInterior(localPlayer)
    
    if playerDimension ~= temporizadorRespawn.dimension or playerInterior ~= temporizadorRespawn.interior then
        return -- No renderizar si el jugador esta en otra dimension o interior
    end
    
    local x, y, z = temporizadorRespawn.x, temporizadorRespawn.y, temporizadorRespawn.z
    local px, py, pz = getElementPosition(localPlayer)
    local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
    
    if distancia > 40 then return end -- No renderizar si esta muy lejos
    
    local sx, sy = getScreenFromWorldPosition(x, y, z)
    if not sx or not sy then return end
    
    local tiempoActual = getTickCount()
    local tiempoRestante = temporizadorRespawn.finTiempo - tiempoActual
    
    -- Calcular porcentaje de regeneracion (0% al inicio, 100% al final)
    local porcentajeTranscurrido = 1 - (tiempoRestante / temporizadorRespawn.tiempoTotal)
    if porcentajeTranscurrido < 0 then porcentajeTranscurrido = 0 end
    if porcentajeTranscurrido > 1 then porcentajeTranscurrido = 1 end
    
    -- Calcular tiempo en formato horas:minutos:segundos
    local segundosTotales = math.ceil(tiempoRestante / 1000)
    local horas = math.floor(segundosTotales / 3600)
    local minutos = math.floor((segundosTotales % 3600) / 60)
    local segundos = segundosTotales % 60
    
    local tiempoFormateado = ""
    if horas > 0 then
        tiempoFormateado = string.format("%02d:%02d:%02d", horas, minutos, segundos)
    else
        tiempoFormateado = string.format("%02d:%02d", minutos, segundos)
    end
    
    -- Tamano del temporizador basado en la distancia pero con un minimo mas grande
    local escala = 1.4 - (distancia / 40)
    if escala < 0.8 then escala = 0.8 end
    
    local anchoBase = 280 * escala
    local altoBase = 120 * escala
    
    -- Colores dinamicos basados en el porcentaje de regeneracion
    local r, g, b = interpolateColor(50, 100, 255, 0, 200, 100, porcentajeTranscurrido)
    
    -- Efecto de transparencia pulsante
    local pulso = math.abs(math.sin(getTickCount() * 0.001)) * 50 + 200
    
    -- Dibujar fondo del temporizador con efecto de cristal y degradado
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, anchoBase, altoBase, tocolor(10, 20, 40, 220))
    
    -- Dibujar bordes con efecto de neon
    local grosorBorde = 3 * escala
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, anchoBase, grosorBorde, tocolor(r, g, b, pulso)) -- Arriba
    dxDrawRectangle(sx - anchoBase/2, sy + altoBase/2 - grosorBorde, anchoBase, grosorBorde, tocolor(r, g, b, pulso)) -- Abajo
    dxDrawRectangle(sx - anchoBase/2, sy - altoBase/2, grosorBorde, altoBase, tocolor(r, g, b, pulso)) -- Izquierda
    dxDrawRectangle(sx + anchoBase/2 - grosorBorde, sy - altoBase/2, grosorBorde, altoBase, tocolor(r, g, b, pulso)) -- Derecha
    
    -- Dibujar barra de progreso circular
    local radio = 35 * escala
    local grosorCirculo = 5 * escala
    local startAngle = -90 -- Comenzar desde arriba
    local endAngle = startAngle + (360 * porcentajeTranscurrido)
    
    -- Dibujar circulo de fondo
    dxDrawCircle(sx, sy - 15, radio, startAngle, startAngle + 360, tocolor(50, 50, 70, 200), tocolor(30, 30, 50, 200))
    
    -- Dibujar progreso
    dxDrawCircle(sx, sy - 15, radio, startAngle, endAngle, tocolor(r, g, b, pulso), tocolor(r, g, b, pulso * 0.7), grosorCirculo)
    
    -- Dibujar texto del temporizador
    local tamanoTextoTiempo = 1.4 * escala
    local tamanoTextoTitulo = 1.2 * escala
    
    -- Titulo con efecto de brillo
    dxDrawText("REGENERACION DE PUERTA", sx, sy - 50, sx, sy - 50, tocolor(255, 255, 255, pulso), tamanoTextoTitulo, "default-bold", "center", "center")
    
    -- Tiempo con sombra
    dxDrawText(tiempoFormateado, sx+2, sy+25+2, sx+2, sy+25+2, tocolor(0, 0, 0, 200), tamanoTextoTiempo, "default-bold", "center", "center")
    dxDrawText(tiempoFormateado, sx, sy+25, sx, sy+25, tocolor(255, 255, 255, 255), tamanoTextoTiempo, "default-bold", "center", "center")
    
    -- Porcentaje dentro del circulo (0% al inicio, 100% al final)
    local porcentajeTexto = math.floor(porcentajeTranscurrido * 100) .. "%"
    dxDrawText(porcentajeTexto, sx, sy-15, sx, sy-15, tocolor(255, 255, 255, 255), tamanoTextoTiempo * 0.9, "default-bold", "center", "center")
    
    -- Dibujar lineas decorativas
    local lineaLongitud = 40 * escala
    local lineaGrosor = 2 * escala
    local lineaOffset = 60 * escala
    
    -- Lineas horizontales
    dxDrawRectangle(sx - anchoBase/2 - lineaLongitud, sy - lineaOffset, lineaLongitud, lineaGrosor, tocolor(r, g, b, pulso * 0.7))
    dxDrawRectangle(sx + anchoBase/2, sy - lineaOffset, lineaLongitud, lineaGrosor, tocolor(r, g, b, pulso * 0.7))
    
    dxDrawRectangle(sx - anchoBase/2 - lineaLongitud, sy + lineaOffset, lineaLongitud, lineaGrosor, tocolor(r, g, b, pulso * 0.7))
    dxDrawRectangle(sx + anchoBase/2, sy + lineaOffset, lineaLongitud, lineaGrosor, tocolor(r, g, b, pulso * 0.7))
    
    -- Efecto de particulas alrededor del temporizador (solo si esta cerca)
    if distancia < 15 then
        local tiempo = getTickCount()
        for i = 1, 12 do
            local angulo = (tiempo / 1000 + i * 30) % 360
            local radioParticula = radio * 2.5
            local px = sx + math.cos(math.rad(angulo)) * radioParticula
            local py = sy + math.sin(math.rad(angulo)) * radioParticula
            
            local tamanoParticula = 4 * escala
            dxDrawRectangle(px - tamanoParticula/2, py - tamanoParticula/2, tamanoParticula, tamanoParticula, tocolor(r, g, b, pulso * 0.7))
        end
    end
    
    -- Texto adicional para mayor claridad
    local tamanoTextoInfo = 1.0 * escala
    dxDrawText("TIEMPO RESTANTE", sx, sy+45, sx, sy+45, tocolor(200, 200, 200, 255), tamanoTextoInfo, "default-bold", "center", "center")
end

-- Funcion para interpolar colores
function interpolateColor(r1, g1, b1, r2, g2, b2, progress)
    local r = r1 + (r2 - r1) * progress
    local g = g1 + (g2 - g1) * progress
    local b = b1 + (b2 - b1) * progress
    return r, g, b
end

-- Funcion para dibujar un circulo
function dxDrawCircle(x, y, radius, startAngle, endAngle, color, colorCenter, thickness)
    thickness = thickness or 1
    colorCenter = colorCenter or color
    
    local segments = 40
    local angleStep = (endAngle - startAngle) / segments
    
    for i = 0, segments do
        local angle1 = math.rad(startAngle + i * angleStep)
        local angle2 = math.rad(startAngle + (i + 1) * angleStep)
        
        local x1 = x + math.cos(angle1) * radius
        local y1 = y + math.sin(angle1) * radius
        local x2 = x + math.cos(angle2) * radius
        local y2 = y + math.sin(angle2) * radius
        
        -- Dibujar linea gruesa
        for t = 0, thickness - 1 do
            local offset = t - thickness / 2
            dxDrawLine(x1 + offset, y1, x2 + offset, y2, color)
            dxDrawLine(x1, y1 + offset, x2, y2 + offset, color)
        end
    end
end

-- Funcion para sincronizar el temporizador con jugadores que entran al interior
function sincronizarTemporizadorNuevosJugadores()
    if temporizadorC4 and temporizadorC4.activo then
        local playerDimension = getElementDimension(localPlayer)
        local playerInterior = getElementInterior(localPlayer)
        
        -- Si el jugador acaba de entrar al interior/dimension donde esta el temporizador
        if playerDimension == temporizadorC4.dimension and playerInterior == temporizadorC4.interior then
            -- Notificar al jugador
            local tiempoRestante = math.ceil((temporizadorC4.finTiempo - getTickCount()) / 1000)
            if tiempoRestante > 0 then
                outputChatBox("⚠️ ¡Cuidado! Hay un C4 activo que explotará en " .. tiempoRestante .. " segundos.", 255, 0, 0)
            end
        end
    end
end

-- Detectar cuando el jugador cambia de dimension o interior
addEventHandler("onClientElementDimensionChange", localPlayer, sincronizarTemporizadorNuevosJugadores)
addEventHandler("onClientElementInteriorChange", localPlayer, sincronizarTemporizadorNuevosJugadores)

-- Modificar la funcion limpiarRecursos para incluir el temporizador de respawn
function limpiarRecursos()
    if isElement(sonidoReproduciendo) then destroyElement(sonidoReproduciendo) end
    
    for _, efecto in ipairs(efectosHumo) do
        if isElement(efecto.elemento) then destroyElement(efecto.elemento) end
    end
    efectosHumo = {}
    
    if temporizadorC4 and temporizadorC4.timer and isTimer(temporizadorC4.timer) then
        killTimer(temporizadorC4.timer)
    end
    temporizadorC4 = nil
    
    if temporizadorRespawn then
        if temporizadorRespawn.timer and isTimer(temporizadorRespawn.timer) then
            killTimer(temporizadorRespawn.timer)
        end
        if temporizadorRespawn.colorTimer and isTimer(temporizadorRespawn.colorTimer) then
            killTimer(temporizadorRespawn.colorTimer)
        end
        if isElement(temporizadorRespawn.hologramaEfecto) then
            destroyElement(temporizadorRespawn.hologramaEfecto)
        end
    end
    temporizadorRespawn = nil
    
    removeEventHandler("onClientRender", root, renderizarTemporizador)
    removeEventHandler("onClientRender", root, renderizarTemporizadorRespawn)
end
addEventHandler("onClientResourceStop", resourceRoot, limpiarRecursos)

-- Añadir esta función al final del archivo para recibir información del servidor cuando el jugador se conecta
function sincronizarTemporizadorAlConectar()
    -- Enviar evento al servidor para solicitar el estado actual de la puerta
    triggerServerEvent("solicitarEstadoPuerta", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, sincronizarTemporizadorAlConectar)
