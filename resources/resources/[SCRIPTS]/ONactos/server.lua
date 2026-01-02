local Actos

addCommandHandler("actoson", 
function( player )
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 22) then
        triggerClientEvent("ActosOnByPuma", player, Actos ) 
    else
    outputChatBox("Intento de alterar actos, reportado", player, 255, 0, 0)
    end
end)

addCommandHandler("actosoff", 
function( player )
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 22) then
        triggerClientEvent("ActosOffByPuma", player ) 
    else
    outputChatBox("Intento de alterar actos, reportado", player, 255, 0, 0)
    end
end)

local Actos2

addCommandHandler("akon", 
function( player )
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 22) then
        triggerClientEvent("ActosOnPuma", player, Actos2 )  
    else
    outputChatBox("Intento de alterar actos, reportado", player, 255, 0, 0)
    end
end)

addCommandHandler("akoff", 
function( player )
    if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 22) then
        triggerClientEvent("ActosOffPuma", player )
    else
    outputChatBox("Intento de alterar actos, reportado", player, 255, 0, 0)
    end
end)