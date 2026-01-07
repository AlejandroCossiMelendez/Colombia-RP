function twittear(thePlayer, command, ...)
    if exports.players:isLoggedIn(thePlayer) then
        if (...) then 
            local texto = table.concat ( { ... }, " " )
            outputChatBox('#005DFFFacebook #FFFFFF @'..getPlayerName(thePlayer)..': '..texto..'', root, 255, 255, 255, true)
        else
            outputChatBox('Syntax: /'..command..' [Mensaje]', thePlayer, 255, 100, 100)
        end
    else
        outputChatBox('Debes iniciar sesión para poder usar el chat.', thePlayer, 255, 100, 100)
    end
end
addCommandHandler('fb', twittear)