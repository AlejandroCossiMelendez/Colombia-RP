
---@diagnostic disable: undefined-global
 
-- Utilidades de bienvenida profesionales
local function sanitizePlayerName(name)
    return (name or ""):gsub("#%x%x%x%x%x%x", "")
end

local function sendWelcomeMessage(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return
    end
    local name = sanitizePlayerName(getPlayerName(player))
    local lines = {
        "#FF3B3B╓──────────────● La Capital Roleplay ●──────────────╖",
        "#FFFFFF╟ Bienvenido, #FFD54F" .. name .. " #AAAAAA| #FFFFFFdisfruta tu estadía",
        "#FFFFFF╟ Servidor de rol serio y realista",
        "#FFFFFF╟ Servidor #FFD54F100%#FFFFFF Colombiano",
        "#FFFFFF╟ Rol en Los Santos y sus alrededores",
        "#FFFFFF╟ Usa F1 y lee las reglas antes de comenzar",
        "#FF3B3B╙──────────────●  ¡Éxitos en tu rol! ●──────────────╜"
    }
    for i, text in ipairs(lines) do
        setTimer(function(p, t)
            if isElement(p) then
                outputChatBox(t, p, 255, 255, 255, true)
            end
        end, (i - 1) * 250, 1, player, text)
    end
end

function joinHandler(player)
    if not player then
       player = source
    end
    sendWelcomeMessage(player)
end
addEventHandler('onPlayerJoin', root, joinHandler)