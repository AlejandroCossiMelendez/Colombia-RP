--[[
addEventHandler("onResourceStart", resourceRoot,
function()
    if not string.find(getServerName(), "[BR] Rio de Janeiro - Roleplay v1.0 @ HeavyHost.com.br") then
       cancelEvent(true)
    end
end)
]]