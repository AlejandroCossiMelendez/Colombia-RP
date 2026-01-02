addEvent("TS:setActive",true)
addEventHandler("TS:setActive", root, function(bool)
    setElementData(source, "TS:radioActive", bool)
end)


addEvent("TS:setAnimationServer",true)
addEventHandler("TS:setAnimationServer", root, function()
    triggerClientEvent(root, "TS:setAnimationClient", root, source)
end)


addEvent("TS:cancelAnimationServer",true)
addEventHandler("TS:cancelAnimationServer", root, function()
    triggerClientEvent(root, "TS:cancelAnimationClient", root, source)
end)

addEventHandler("onResourceStart",resourceRoot,function()
    for i,v in ipairs(getElementsByType("player")) do
        setElementData(v, "TS:RadioActive", false)
        setElementData(v, "TS:Frequencia", false)
    end
end)