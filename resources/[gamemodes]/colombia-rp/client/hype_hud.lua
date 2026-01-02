--[[
Hype HUD adaptado para Colombia RP
Integrado con el sistema de personajes
--]]

local screenW, screenH = guiGetScreenSize()
local x, y = (screenW/1366), (screenH/768)

local FontHype = dxCreateFont("hud-rp/Hype_Hud/font/fontHype.ttf", y*10)
local FontHypeBrivie = dxCreateFont("hud-rp/Hype_Hud/font/fontHype.ttf", y*16)

HypeHudVisible = false
local hudEnabled = false

-- Función para mostrar/ocultar HUD
function showHypeHUD()
    hudEnabled = true
end

function hideHypeHUD()
    hudEnabled = false
end

-- Evento desde el servidor
addEvent("showHUD", true)
addEventHandler("showHUD", resourceRoot, function()
    showHypeHUD()
end)

-- Verificar automáticamente si el jugador tiene un personaje seleccionado
setTimer(function()
    if not hudEnabled and getElementData(localPlayer, "character:selected") then
        showHypeHUD()
    end
end, 1000, 0)

-- Mostrar HUD cuando el jugador spawnea con un personaje seleccionado
addEventHandler("onClientPlayerSpawn", localPlayer, function()
    if getElementData(localPlayer, "character:selected") then
        showHypeHUD()
    end
end)

-- Verificar al iniciar el recurso si ya hay un personaje seleccionado
addEventHandler("onClientResourceStart", resourceRoot, function()
    setTimer(function()
        if getElementData(localPlayer, "character:selected") then
            showHypeHUD()
        end
    end, 500, 1)
end)

function HudHype()
    -- Solo mostrar si está habilitado y hay personaje seleccionado
    if not hudEnabled or not getElementData(localPlayer, "character:selected") then
        return
    end
    
    --<!-- FUNCIÓN PLAYER --!>--
    local Dinheiro = convertNumber(getElementData(localPlayer, "character:money") or 0)
    local Banco = convertNumber(getElementData(localPlayer, "character:bank") or 0)
    local Emprego = getElementData(localPlayer, "character:job") or "Desempleado"
    local Vida = math.floor(getElementHealth(localPlayer))
    local Colete = math.floor(getPedArmor(localPlayer))
    local Stamina = tonumber(getElementData(localPlayer, "stamina") or 100)
    local Hambre = tonumber(getElementData(localPlayer, "character:hunger") or 100)
    local Sed = tonumber(getElementData(localPlayer, "character:thirst") or 100)
    
    --<!-- NOME DAS CITYS --!>--
    local playerX, playerY, playerZ = getElementPosition(localPlayer) 
    local ZonaNome = getZoneName(playerX, playerY, playerZ)
    
    --<!-- REAL TIME --!>--
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    local meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}
    local dias = {"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"}
    local dia = dias[time.weekday + 1]
    local ano = ("%02d"):format(time.year + 1900)
    local mes = meses[time.month + 1]

    local seconds = getTickCount() / 1600
    local angle = math.sin(seconds) * 10

    --<!-- BARRAS FONDO --!>--
    dxDrawImage(x*1225, y*154, x*101, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- VIDA
    dxDrawImage(x*1225, y*187, x*101, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- COLETE
    dxDrawImage(x*1225, y*221, x*101, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- STAMINA
    dxDrawImage(x*1002, y*703, x*285, y*41, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 108), false) -- VOICE
    
    --<!-- BARRINHA (ajustada para respetar la curva del círculo y mantener forma) --!>--
    -- Calcular el ancho máximo disponible (antes del círculo)
    local maxBarWidth = x*101 - x*10 -- Ancho total menos espacio para el círculo
    local minBarWidth = x*10 -- Ancho mínimo para mantener la forma de la barra
    
    -- Función auxiliar para dibujar barra con forma mantenida usando la imagen original
    local function drawBar(barX, barY, value, color, minWidth)
        if value <= 0 then
            return
        end
        
        local percent = math.max(0, math.min(100, value)) / 100
        local calculatedWidth = maxBarWidth * percent
        
        -- Si el valor es muy bajo (menos del 20%), usar ancho mínimo fijo para mantener la forma
        local finalWidth
        if value < 20 then
            finalWidth = minWidth
        else
            finalWidth = math.max(minWidth, calculatedWidth)
        end
        
        -- Usar la imagen original para mantener la forma, pero con el ancho calculado
        -- Si el ancho es menor que el mínimo, usar el mínimo pero mantener la proporción visual
        dxDrawImage(barX, barY, finalWidth, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, color, false)
    end
    
    -- Dibujar barras
    drawBar(x*1225, y*154, Vida, tocolor(237, 0, 5, 200), minBarWidth) -- VIDA
    drawBar(x*1225, y*187, Colete, tocolor(7, 239, 247, 150), minBarWidth) -- COLETE
    drawBar(x*1225, y*221, Stamina, tocolor(253, 221, 0, 150), minBarWidth) -- STAMINA
    
    --<!-- CIRCULO (dibujado después de las barras para que esté encima) --!>--
    dxDrawImage(x*1295, y*153, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(255, 0, 0, 255), false) -- VIDA
    dxDrawImage(x*1295, y*186, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(7, 239, 247, 255), false) -- COLETE
    dxDrawImage(x*1295, y*220, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(237, 218, 16, 255), false) -- STAMINA
    dxDrawImage(x*1284, y*703, x*52, y*42, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(33, 141, 8, 254), false) -- VOICE
    
    --<!-- ICONES --!>--
    dxDrawImage(x*1303, y*160, x*22, y*16, "hud-rp/Hype_Hud/imgs/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- VIDA
    dxDrawImage(x*1303, y*191, x*24, y*19, "hud-rp/Hype_Hud/imgs/armor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- COLETE
    dxDrawImage(x*1303, y*225, x*22, y*19, "hud-rp/Hype_Hud/imgs/stamina.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- STAMINA
    
    --<!-- DX --!>--
    dxDrawText(Emprego, x*1120, y*87, x*1328, y*119, tocolor(255, 255, 255, 255), 1.00, FontHypeBrivie, "center", "center", false, false, false, false, false)
    
    --<!-- DX2 --!>--
    dxDrawText(Vida, x*1245, y*161, x*1279, y*174, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(Colete, x*1245, y*194, x*1279, y*207, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(Stamina, x*1245, y*228, x*1279, y*241, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    
    --<!-- DINERO Y BANCO (mejorado y reposicionado) --!>--
    -- Fondo semi-transparente para el dinero
    dxDrawRectangle(x*20, y*20, x*200, y*50, tocolor(0, 0, 0, 150), false)
    
    -- Icono y texto de dinero en billetera
    dxDrawImage(x*25, y*25, x*20, y*20, "hud-rp/Hype_Hud/imgs/wallet.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("$" .. Dinheiro, x*50, y*25, x*200, y*45, tocolor(255, 255, 0, 255), 1.00, FontHype, "left", "center", false, false, false, false, false)
    
    -- Icono y texto de dinero en banco
    dxDrawImage(x*25, y*45, x*20, y*20, "hud-rp/Hype_Hud/imgs/bank.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("$" .. Banco, x*50, y*45, x*200, y*65, tocolor(0, 255, 0, 255), 1.00, FontHype, "left", "center", false, false, false, false, false)
    
    --<!-- HAMBRE Y SED (opcional, puedes agregar barras si quieres) --!>--
    --<!-- VOICE LADO --!>--
    dxDrawText("Hoy es "..dia.." de "..mes.." de "..ano.."", x*1084, y*709, x*1268, y*724, tocolor(255, 255, 255, 255), 1.00, FontHype, "right", "center", false, false, false, false, false)
    dxDrawText("Estás en "..ZonaNome, x*1084, y*724, x*1268, y*740, tocolor(255, 255, 255, 255), 1.00, FontHype, "right", "center", false, false, false, false, false)
    
    --<!-- IMG VOICE ON + OFF --!>--
    if getElementData(localPlayer, "Hype>Voice", true) then
        dxDrawImage(x*1296, y*712, x*28, y*24, "hud-rp/Hype_Hud/imgs/voiceOn.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawImage(x*1296, y*712, x*28, y*24, "hud-rp/Hype_Hud/imgs/voiceOff.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
    end
    
    --<!-- LOGO --!>--
    dxDrawImage(x*648, y*10, x*64, y*73, "hud-rp/Hype_Hud/imgs/logo.png", angle, 0, -40, tocolor(255, 255, 255, 255), false)
end
addEventHandler("onClientRender", getRootElement(), HudHype)

function CorMicroFoneHype()
    if getElementData(localPlayer, "Hype>Voice", true) then
        setElementData(localPlayer, "Hype>Voice", false)
    else
        setElementData(localPlayer, "Hype>Voice", true)
    end
end
bindKey("z", "both", CorMicroFoneHype)

function VisibleHudHype(state)
    if HypeHudVisible == false then
        HypeHudVisible = true
        removeEventHandler("onClientRender", root, HudHype)
    else
        addEventHandler("onClientRender", root, HudHype)
        HypeHudVisible = false
    end
end
bindKey("F11", "down", VisibleHudHype)

function OnStop()
    setPlayerHudComponentVisible("armour", true)
    setPlayerHudComponentVisible("wanted", true)
    setPlayerHudComponentVisible("weapon", true)
    setPlayerHudComponentVisible("money", true)
    setPlayerHudComponentVisible("health", true)
    setPlayerHudComponentVisible("clock", true)
    setPlayerHudComponentVisible("breath", true)
    setPlayerHudComponentVisible("ammo", true)
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), OnStop)

function OnStart()
    setPlayerHudComponentVisible("armour", false)
    setPlayerHudComponentVisible("wanted", false)
    setPlayerHudComponentVisible("weapon", false)
    setPlayerHudComponentVisible("money", false)
    setPlayerHudComponentVisible("health", false)
    setPlayerHudComponentVisible("clock", false)
    setPlayerHudComponentVisible("breath", false)
    setPlayerHudComponentVisible("ammo", false)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), OnStart)

local hudTable = 
{
    "ammo",
    "armour",
    "clock",
    "health",
    "money",
    "weapon",
    "wanted",
    "area_name",
    "vehicle_name",
    "breath",
    "clock"
}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        for id, hudComponents in ipairs(hudTable) do
            showPlayerHudComponent(hudComponents, false)
        end
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        for id, hudComponents in ipairs(hudTable) do
            showPlayerHudComponent(hudComponents, true)
        end
    end
)

function convertNumber(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if (k == 0) then       
            break   
        end   
    end   
    return formatted 
end

