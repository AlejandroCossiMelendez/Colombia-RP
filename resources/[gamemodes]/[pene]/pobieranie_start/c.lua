--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]
local load = exports.ladowanie

addEventHandler('onClientResourceStart', resourceRoot, function()
	load:createLoadingScreen('Espere porfavor.')
	showChat(false)
end)

function stopDownloading()
	load:destroyLoadingScreen()
end