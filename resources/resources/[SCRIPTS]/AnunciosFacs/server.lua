function addNotification(playerSource, msg, type)
	if getElementType(playerSource) == "player" then
		triggerClientEvent(playerSource, "renderNotification", resourceRoot, msg, type)
	end
end
local playerCooldowns = {}

function Anuncio(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 1) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "admin")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end

addCommandHandler("pd", Anuncio)

function Anuncio2(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 2) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "sura")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end

addCommandHandler("sura", Anuncio2)

function Anuncio3(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 3) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "meca")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end
addCommandHandler("meca", Anuncio3)

function Anuncio4(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 33) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "error")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end
addCommandHandler("tst", Anuncio4)

function Anuncio5(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 22) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "exp")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end
addCommandHandler("ejnc", Anuncio5)

function Anuncio6(playerSource, commandName, ...)
    if exports.factions:isPlayerInFaction(playerSource, 36) then
        if playerCooldowns[playerSource] then
            outputChatBox("Sólo se permite un anuncio cada 3 segundos.", playerSource, 255, 0, 0)
        else
            local msg = table.concat({ ... }, " ")
            local id = getElementData(playerSource, "playerid") or "N/A"
            msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
            msg = getPlayerName(playerSource) .. "#FFFFFF (" .. id .. "): " .. msg
            for i, v in pairs(getElementsByType("player")) do
                triggerClientEvent(v, "renderNotification", resourceRoot, msg, "warning")
            end
            playerCooldowns[playerSource] = true
            setTimer(function(player) playerCooldowns[player] = nil end, 3000, 1, playerSource)
        end
    else
        outputChatBox("¡No tienes permiso para ejecutar este comando!", playerSource, 255, 0, 0)
    end
end
addCommandHandler("tmo", Anuncio6)
