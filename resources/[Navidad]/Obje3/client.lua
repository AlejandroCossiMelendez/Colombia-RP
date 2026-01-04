--[[
SparroW MTA : https://sparrow-mta.blogspot.com/
Facebook : https://www.facebook.com/sparrowgta/
İnstagram : https://www.instagram.com/sparrowmta/
Discord : https://discord.gg/DzgEcvy
]]--

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1871)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1871)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1871)
engineSetModelLODDistance(1871, 999999)
end)

























































-- İçeriklerimi sitesinde paylaşan dal yaraklarak sesleniyorum, ananızı sikiyim.