local screenW, screenH = guiGetScreenSize()
local x, y = (screenW / 1366), (screenH / 768)
local font = dxCreateFont("Fontes/AbFont.ttf", x * 8)  
local font1 = dxCreateFont("Fontes/AbFont.ttf", x * 10)
local hudTable = {"ammo", "armour", "clock", "health", "money", "weapon", "wanted", "area_name", "vehicle_name", "breath", "clock", "radar"}

local asd = 0
local asd1 = 0
local asd2 = 0

addEventHandler("onClientRender", root,
    function()
        if not exports.players:isLoggedIn() then return end

        if getElementData( localPlayer, "player:FactionD" ) ~= false then 
            dxDrawText(tostring( getElementData( localPlayer, "player:FactionD" ).name ) .. ":", x*1096, y*232, x*1356, y*284, tocolor(255, 255, 255, 255), 1.00, font1, "right", "center", false, true, false, false, false)
            dxDrawText(tostring( getElementData( localPlayer, "player:1212121" ) ), x*1188, y*364, x*1356, y*216, tocolor(200, 200, 200, 255), 1.00, font1, "right", "center", false, true, false, false, false)
        else
            dxDrawText("Desempleado", x*1066, y*352, x*1356, y*184, tocolor(255, 255, 255, 255), 1.00, font1, "right", "center", false, true, false, false, false)
        end

        dxDrawImage(x * 1324, y * 66, x * 32, x * 32, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 0, 0, 120));
        dxDrawImage(x * 1282, y * 66, x * 32, x * 32, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 0, 0, 120));
        dxDrawImage(x * 1240, y * 66, x * 32, x * 32, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 0, 0, 120));
        dxDrawImage(x * 1196, y * 66, x * 32, x * 32, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 0, 0, 120));

        local hungry = getElementData(getLocalPlayer(), "hambre") or 0
        local thrist = getElementData(getLocalPlayer(), "sed") or 0
        local armor = getPedArmor(localPlayer)
        local health = getElementHealth(localPlayer)

        local municionEnArma = getPedAmmoInClip(localPlayer)
        local municionTotal = getPedTotalAmmo(localPlayer) - municionEnArma
        local arma = getPedWeapon(localPlayer)

        dxDrawImageSection(x * 1324, y * 66 + y * 32, x * 32, x * 32 / -100 * thrist, 0, 0, 35, 35 / -100 * thrist, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 178, 209));
        dxDrawImageSection(x * 1282, y * 66 + y * 32, x * 32, x * 32 / -100 * hungry, 0, 0, 35, 35 / -100 * hungry, "Imagens/Fundo.png", 0, 0, 0, tocolor(255, 138, 22))
        dxDrawImageSection(x * 1240, y * 66 + y * 32, x * 32, x * 32 / -100 * armor, 0, 0, 35, 35 / -100 * armor, "Imagens/Fundo.png", 0, 0, 0, tocolor(0, 116, 202));
        dxDrawImageSection(x * 1196, y * 66 + y * 32, x * 32, x * 32 / -100 * health, 0, 0, 35, 35 / -100 * health, "Imagens/Fundo.png", 0, 0, 0, tocolor(255, 0, 0));

        dxDrawRoundedRectangle(x * 1240, y * 118, x * 116, y * 32, tocolor(0, 0, 0, 120), 12)
        dxDrawImage(x * 1215, y * 115, x * 38, x * 38, "Imagens/Fundo.png", 0, 0, 0, tocolor(57, 212, 16))

        dxDrawImage(x * 1324 + x * 8, y * 69 + y * 6, x * 16, x * 16, "Imagens/Sede.png");
        dxDrawImage(x * 1282 + x * 8, y * 69 + y * 6, x * 16, x * 16, "Imagens/Fome.png");
        dxDrawImage(x * 1240 + x * 8, y * 69 + y * 6, x * 16, x * 16, "Imagens/Colete.png");
        dxDrawImage(x * 1196 + x * 8, y * 69 + y * 6, x * 16, x * 16, "Imagens/Vida.png");

        dxDrawImage(x * 1215 + x * 7, y * 117 + y * 5, x * 25, x * 25, "Imagens/Money.png");

        dxDrawText(formatNumber(getPlayerMoney(localPlayer), ",") .. " #00FF46$", x * 1253, y * 70, x * 1356, y * 200 + y * 2, tocolor(255, 255, 255, 255), 1.25, font, "center", "center", false, false, false, true, false)

        if arma >= 0 then
            dxDrawImage(x * 1030, y * 195, x * 220, x * 70, "armas/" .. arma .. ".png")
            dxDrawText(municionEnArma .. "/" .. municionTotal, x * 1210, y * 10, x * 1178, y * 477, tocolor(255, 255, 255), 1, font1, "center", "center")
        end

        dxDrawRoundedRectangle(x * 1292, y * 168, x * 60, y * 24, tocolor(0, 0, 0, 120), 12)
        dxDrawText("ID: " .. getElementData(localPlayer, "playerid"), x * 1292, y * 5, x * 1353, y * 355, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)

        -- Indicador de Hablar
        local Jogador_Falando = getElementData(localPlayer, "Falando_") or false
        dxDrawRoundedRectangle(x * 1262, y * 210, x * 90, y * 24, tocolor(0, 0, 0, 120), 12)
        if Jogador_Falando == true then
            dxDrawText("[Voz]: #00FF46ON", x * 1277, y * 216, x * 460, y * 677, tocolor(255, 255, 255, 255), 1.0, font, "left", "top", false, false, false, true, false)
        else
            dxDrawText("[Voz]: #FFFFFFOFF", x * 1277, y * 216, x * 460, y * 677, tocolor(255, 255, 255, 255), 1.0, font, "left", "top", false, false, false, true, false)
        end
    end
)

function formatNumber(number, sep)
    assert(type(tonumber(number)) == "number", "Bad argument @'formatNumber' [Expected number at argument 1 got " .. type(number) .. "]")
    assert(not sep or type(sep) == "string", "Bad argument @'formatNumber' [Expected string at argument 2 got " .. type(sep) .. "]")
    local money = number
    for i = 1, tostring(money):len() / 3 do
        money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1" .. sep .. "%2")
    end
    return money
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        for id, hudComponents in ipairs(hudTable) do
            setPlayerHudComponentVisible(hudComponents, false)
        end
    end
)

addEvent("onCllientShowUIX", true)
addEventHandler("onCllientShowUIX", root,
    function(v, v1, v2)
        asd = v
        asd1 = v1
        asd = v2
    end
)

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

-- Funciones para mostrar cuando un jugador empieza o termina de hablar
addEventHandler("onClientPlayerVoiceStart", root,
    function()
        if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
            setElementData(source, "Falando_", true)
        end
    end
)

addEventHandler("onClientPlayerVoiceStop", root,
    function()
        if (source and isElement(source) and getElementType(source) == "player") and localPlayer == source then
            setElementData(source, "Falando_", false)
        end
    end
)