--[[
Creado por : Edvis20 

Servidor : ExoticRP

2020
]]

local download = exports.pobieranie_start

addEventHandler('onClientResourceStart', resourceRoot, function()
	download:stopDownloading()
end)