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
    local Stamina = math.floor(tonumber(getElementData(localPlayer, "stamina") or 100)) -- Redondear a número entero
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
    dxDrawImage(x*1225, y*255, x*101, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- HAMBRE
    dxDrawImage(x*1225, y*289, x*101, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 80), false) -- SED
    dxDrawImage(x*1002, y*703, x*285, y*41, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 0, 0, 108), false) -- VOICE
    
    --<!-- BARRINHA (usando el mismo método del código original para mantener bordes redondeados) --!>--
    -- Usar dxDrawImage directamente como en el código original para mantener los bordes redondeados perfectos
    -- La imagen 0.png tiene bordes redondeados en todas las esquinas, al estirarla proporcionalmente los mantiene
    dxDrawImage(x*1225, y*154, x*101/100*Vida, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(237, 0, 5, 200), false) -- VIDA
    dxDrawImage(x*1225, y*187, x*101/100*Colete, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(7, 239, 247, 180), false) -- COLETE
    dxDrawImage(x*1225, y*221, x*101/100*Stamina, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(253, 221, 0, 180), false) -- STAMINA
    dxDrawImage(x*1225, y*255, x*101/100*Hambre, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(255, 165, 0, 200), false) -- HAMBRE
    dxDrawImage(x*1225, y*289, x*101/100*Sed, y*28, "hud-rp/Hype_Hud/imgs/0.png", 0, 0, 0, tocolor(0, 100, 255, 200), false) -- SED
    
    --<!-- CIRCULO (dibujado después de las barras para que esté encima) --!>--
    dxDrawImage(x*1295, y*153, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(255, 0, 0, 255), false) -- VIDA
    dxDrawImage(x*1295, y*186, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(7, 239, 247, 255), false) -- COLETE
    dxDrawImage(x*1295, y*220, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(237, 218, 16, 255), false) -- STAMINA
    dxDrawImage(x*1295, y*254, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(255, 165, 0, 255), false) -- HAMBRE
    dxDrawImage(x*1295, y*288, x*38, y*29, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(0, 100, 255, 255), false) -- SED
    dxDrawImage(x*1284, y*703, x*52, y*42, "hud-rp/Hype_Hud/imgs/circulo.png", 0, 0, 0, tocolor(33, 141, 8, 254), false) -- VOICE
    
    --<!-- ICONES --!>--
    dxDrawImage(x*1303, y*160, x*22, y*16, "hud-rp/Hype_Hud/imgs/health.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- VIDA
    dxDrawImage(x*1303, y*191, x*24, y*19, "hud-rp/Hype_Hud/imgs/armor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- COLETE
    dxDrawImage(x*1303, y*225, x*22, y*19, "hud-rp/Hype_Hud/imgs/stamina.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- STAMINA
    dxDrawImage(x*1303, y*259, x*22, y*19, "hud-rp/Hype_Hud/imgs/comida.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- HAMBRE
    dxDrawImage(x*1303, y*293, x*22, y*19, "hud-rp/Hype_Hud/imgs/agua.png", 0, 0, 0, tocolor(255, 255, 255, 255), false) -- SED
    
    --<!-- DX --!>--
    dxDrawText(Emprego, x*1120, y*87, x*1328, y*119, tocolor(255, 255, 255, 255), 1.00, FontHypeBrivie, "center", "center", false, false, false, false, false)
    
    --<!-- DX2 --!>--
    dxDrawText(Vida, x*1245, y*161, x*1279, y*174, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(Colete, x*1245, y*194, x*1279, y*207, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(math.floor(Stamina), x*1245, y*228, x*1279, y*241, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(math.floor(Hambre), x*1245, y*262, x*1279, y*275, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    dxDrawText(math.floor(Sed), x*1245, y*296, x*1279, y*309, tocolor(255, 255, 255, 255), 1.00, FontHype, "center", "center", false, false, false, false, false)
    
    --<!-- DINERO Y BANCO (reposicionado a la derecha) --!>--
    -- Fondo semi-transparente para el dinero (a la derecha)
    local moneyBoxX = screenW - x*220 -- Posición desde la derecha
    dxDrawRectangle(moneyBoxX, y*20, x*200, y*50, tocolor(0, 0, 0, 150), false)
    
    -- Icono y texto de dinero en billetera (alineado a la derecha)
    dxDrawImage(moneyBoxX + x*5, y*25, x*20, y*20, "hud-rp/Hype_Hud/imgs/wallet.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("$" .. Dinheiro, moneyBoxX + x*30, y*25, moneyBoxX + x*195, y*45, tocolor(255, 255, 0, 255), 1.00, FontHype, "left", "center", false, false, false, false, false)
    
    -- Icono y texto de dinero en banco (alineado a la derecha)
    dxDrawImage(moneyBoxX + x*5, y*45, x*20, y*20, "hud-rp/Hype_Hud/imgs/bank.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("$" .. Banco, moneyBoxX + x*30, y*45, moneyBoxX + x*195, y*65, tocolor(0, 255, 0, 255), 1.00, FontHype, "left", "center", false, false, false, false, false)
    
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

-- El sistema de voz ahora se maneja automáticamente con onClientPlayerVoiceStart/Stop
-- No necesitamos el bindKey manual, el icono se actualiza automáticamente cuando hablas
-- bindKey("z", "both", CorMicroFoneHype) -- Desactivado, se maneja en voice.lua

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
            setPlayerHudComponentVisible(hudComponents, false)
        end
    end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        for id, hudComponents in ipairs(hudTable) do
            setPlayerHudComponentVisible(hudComponents, true)
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

-- Detectar click en el icono de defensa/chaleco
local vestClickArea = {
    x = 0, -- Se calculará dinámicamente
    y = 0,
    width = 0,
    height = 0
}

addEventHandler("onClientClick", root, function(button, state, absX, absY)
    if button == "left" and state == "down" and hudEnabled and getElementData(localPlayer, "character:selected") then
        -- Verificar si el jugador tiene chaleco equipado
        local hasVest = getElementData(localPlayer, "has:vest")
        local currentArmor = math.floor(getPedArmor(localPlayer))
        
        if not hasVest or currentArmor <= 0 then
            return
        end
        
        -- Calcular área clickeable del icono de defensa
        local screenW, screenH = guiGetScreenSize()
        local x, y = (screenW/1366), (screenH/768)
        
        -- Área del icono de defensa (armor.png) - Área más grande para facilitar el click
        local iconX = x * 1303
        local iconY = y * 191
        local iconW = x * 24
        local iconH = y * 19
        
        -- También incluir el área de la barra de defensa para facilitar el click
        local barX = x * 1225
        local barY = y * 187
        local barW = x * 101
        local barH = y * 28
        
        -- Verificar si el click está dentro del área del icono o de la barra
        local clickedOnIcon = (absX >= iconX and absX <= iconX + iconW and absY >= iconY and absY <= iconY + iconH)
        local clickedOnBar = (absX >= barX and absX <= barX + barW and absY >= barY and absY <= barY + barH)
        
        if clickedOnIcon or clickedOnBar then
            -- Enviar evento al servidor para quitarse el chaleco
            outputChatBox("Quitando chaleco...", 0, 150, 255)
            triggerServerEvent("unequipVest", localPlayer)
        end
    end
end)

