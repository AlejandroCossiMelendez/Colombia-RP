function gobierno ( source, cmd, ... )
local mensaje = table.concat ( { ... }, " " )
local nombre = getPlayerName(source); 
    if exports.factions:isPlayerInFaction(source, 11) then
           outputChatBox( "#FF0000[ ILEGAL ] #FFFFFF[#FD2F03 The Bloods #FD2F03]: #FFFFFF" .. mensaje .. ".", v, 255, 0, 228, true )
       end 
          end               
addCommandHandler("hb", gobierno) 