function addBox(sourceElement, msg, type)
    if isElement(sourceElement) and tostring(msg) and tostring(type) then 
        triggerClientEvent(sourceElement, "addBox", sourceElement, msg, type)
    end 
end
addEvent("addBox", true)
addEventHandler("addBox", root, addBox)