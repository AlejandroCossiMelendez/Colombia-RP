function twittear(thePlayer, command, ...)
    if exports.players:isLoggedIn(thePlayer) then
    if (...) then 
        local texto = table.concat ( { ... }, " " )
        outputChatBox('#FFD23BCompuTrabajo #FFFFFF @'..getPlayerName(thePlayer)..': '..texto..'', root, 255, 255, 255, true)
    else
        outputChatBox('Syntax: /'..command..' [Mensaje]', thePlayer, 255, 100, 100)
        end
    else
    outputChatBox("Debes iniciar sesión para poder enviar un mensaje.", source, 255, 0, 0, true)
    end
end
addCommandHandler('ct', twittear)
