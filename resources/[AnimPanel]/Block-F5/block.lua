-- Funcin para bloquear la tecla F5 si el jugador est muerto
function bloquearF5SiMuerto(button, pressOrRelease)
    if button == "F5" and pressOrRelease then
        local player = source
        if getElementData(player, "muerto") then
            outputChatBox("No puedes usar la tecla F5 ahora. Estás muerto.", player, 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onPlayerKey", root, bloquearF5SiMuerto)

-- Marcar tecla F5 como permitida
local teclaPermitida = "F5"
