
function joinHandler(player)
    if not player then
       player = source
    end
    outputChatBox('#00D4FF╓────────────● #D1FF00IMPORTANTE LEER #00D4FF●────────────╖', player, 0, 255, 0, true)
    outputChatBox('#FFFFFF╟ Recuerda que en nuestro servidor hay reglas, las debes cumplir', player, 0, 255, 0, true)
    outputChatBox('#FFFFFF╟ No te desconectes a proposito, no seas #00D4FFcobarde', player, 0, 255, 0, true)
    outputChatBox('#FFFFFF╟ LEE CONCEPTOS DE ROL en el panel #00D4FF-F1-', player, 0, 255, 0, true)
	outputChatBox('#FFFFFF╟ Rolea bien tu personaje para evitar malas experiencias', player, 0, 255, 0, true)
	outputChatBox('#FFFFFF╟ Roleplay se basa en crear una vida con tu personaje', player, 0, 255, 0, true)		
	outputChatBox('#FFFFFF╟ WEB: #00D4FFhttps://beacons.ai/mta.versorp', player, 0, 255, 0, true)
    outputChatBox('#00D4FF╙────────────● Verso Roleplay ●────────────╜', player, 0, 255, 0, true)           
end
addEventHandler('onPlayerJoin', root, joinHandler)