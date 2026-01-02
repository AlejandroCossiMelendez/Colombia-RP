local playerCooldowns = {}

-- Facebook
function FaceBook(thePlayer, command, ...)
    if (...) then 
        if not exports.items:hasPhone(thePlayer, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", thePlayer, 255, 0, 0)
            return
        end

        if playerCooldowns[thePlayer] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", thePlayer, 255, 0, 0)
        else
            local texto = table.concat({ ... }, " ")
            outputChatBox('#005DFFFacebook #FFFFFF @'..getPlayerName(thePlayer)..': '..texto..'', root, 255, 255, 255, true)
            playerCooldowns[thePlayer] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, thePlayer)
        end
    else
        outputChatBox('Syntax: /'..command..' [Mensaje]', thePlayer, 255, 100, 100)
    end
end

addCommandHandler('fb', FaceBook)


-- Anonimo
function deepweb(source, cmd, ...)
    if (...) then
        if not exports.items:hasPhone(source, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", source, 255, 0, 0)
            return
        end

        if playerCooldowns[source] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", source, 255, 0, 0)
        else
            local mensaje = table.concat({ ... }, " ")
            local nombre = getPlayerName(source)
            for _, v in ipairs(getElementsByType("player")) do
                if hasObjectPermissionTo(v, "command.goto", false) then
                    outputChatBox("#FFFFFF[#0A0A0A VISTA STAFF ANONIMO#FFFFFF] [" .. nombre .. "]: " .. mensaje, v, 255, 255, 255, true)
                else
                    outputChatBox("#FFFFFF[#0A0A0A ANONIMO#FFFFFF]: " .. mensaje .. ".", v, 255, 255, 255, true)
                end
            end
            playerCooldowns[source] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, source)
        end
    else
        outputChatBox('Syntax: /' .. cmd .. ' [Mensaje]', source, 255, 100, 100)
    end
end

addCommandHandler("an", deepweb)

-- Instagram
function Instagram(thePlayer, command, ...)
    if (...) then

        if not exports.items:hasPhone(thePlayer, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", thePlayer, 255, 0, 0)
            return
        end

        if playerCooldowns[thePlayer] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", thePlayer, 255, 0, 0)
        else
            local texto = table.concat({ ... }, " ")
            outputChatBox('#FFFFFF#FF0074Insta#FF7400gram #FFFFFF @' .. getPlayerName(thePlayer) .. ': ' .. texto, root, 255, 255, 255, true)
            playerCooldowns[thePlayer] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, thePlayer)
        end
    else
        outputChatBox('Syntax: /' .. command .. ' [Mensaje]', thePlayer, 255, 100, 100)
    end
end

addCommandHandler('ig', Instagram)

-- MercadoLibre
function MercadoLibre(thePlayer, command, ...)
    if (...) then

        if not exports.items:hasPhone(thePlayer, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", thePlayer, 255, 0, 0)
            return
        end

        if playerCooldowns[thePlayer] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", thePlayer, 255, 0, 0)
        else
            local texto = table.concat({ ... }, " ")
            outputChatBox('#FFDC00MercadoLibre #FFFFFF @' .. getPlayerName(thePlayer) .. ': ' .. texto, root, 255, 255, 255, true)
            playerCooldowns[thePlayer] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, thePlayer)
        end
    else
        outputChatBox('Syntax: /' .. command .. ' [Mensaje]', thePlayer, 255, 100, 100)
    end
end

addCommandHandler('ml', MercadoLibre)

-- Computrabajo
function Computrabajo(thePlayer, command, ...)
    if (...) then
        if not exports.items:hasPhone(thePlayer, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", thePlayer, 255, 0, 0)
            return
        end

        if playerCooldowns[thePlayer] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", thePlayer, 255, 0, 0)
        else
            local texto = table.concat({ ... }, " ")
            outputChatBox('#FFD23BCompuTrabajo #FFFFFF @'..getPlayerName(thePlayer)..': '..texto..'', root, 255, 255, 255, true)
            playerCooldowns[thePlayer] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, thePlayer)
        end
    else
        outputChatBox('Syntax: /' .. command .. ' [Mensaje]', thePlayer, 255, 100, 100)
    end
end
addCommandHandler('ct', Computrabajo)

-- Entorno
function Entorno(source, cmd, ...)
    if (...) then  

        if not exports.items:hasPhone(source, 7) then
            outputChatBox("Necesitas un teléfono para usar este comando.", source, 255, 0, 0)
            return
        end

        if playerCooldowns[source] then
            outputChatBox("Sólo se permite un mensaje cada 3 segundos.", source, 255, 0, 0)
        else
            local mensaje = table.concat({ ... }, " ")
            for _, v in ipairs(getElementsByType("player")) do
                local nombre = getPlayerName(source)
                if hasObjectPermissionTo(v, "command.goto", false) then
                    outputChatBox("#0BFFEC[ENTORNOS STAFF]: [" .. nombre .. "]: " .. mensaje, v, 255, 255, 255, true)
                else
                    outputChatBox("#0BFFEC[Vieja Chismosa]: " .. mensaje .. ".", v, 255, 255, 255, true)
                end
            end
            playerCooldowns[source] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, source)
        end
    else
        outputChatBox('Syntax: /' .. cmd .. ' [Mensaje]', source, 255, 100, 100)
    end
end

addCommandHandler("entorno", Entorno)

function setTimeToNoon(player)
    setTime(12, 0)
    outputChatBox("Hecho.", player, 0, 255, 0)
end
addCommandHandler("abuelodia", setTimeToNoon)
