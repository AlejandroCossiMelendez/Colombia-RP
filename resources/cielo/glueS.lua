addEvent("gluePlayerCapitalRP", true)
addEventHandler("gluePlayerCapitalRP", getRootElement(), function(slot, vehicle, x, y, z, rotX, rotY, rotZ)
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, eventName, {
        checkEventData = {
            {eventData = source, equalTo = client},
            {eventData = slot, allowedDataTypes = {["number"] = true}},
            {eventData = vehicle, allowedDataTypes = {["userdata"] = true}},
            {eventData = x, allowedDataTypes = {["number"] = true}},
            {eventData = y, allowedDataTypes = {["number"] = true}},
            {eventData = z, allowedDataTypes = {["number"] = true}},
            {eventData = rotX, allowedDataTypes = {["number"] = true}},
            {eventData = rotY, allowedDataTypes = {["number"] = true}},
            {eventData = rotZ, allowedDataTypes = {["number"] = true}}
        }
    })

    if not shouldProcessServerCode then return false end
    attachElements(client, vehicle, x, y, z, rotX, rotY, rotZ)
    setPedWeaponSlot(client, slot)
end)

addEvent("ungluePlayerCapitalRP", true)
addEventHandler("ungluePlayerCapitalRP", getRootElement(), function()
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, eventName, {
        checkEventData = {
            {eventData = source, equalTo = client}
        }
    })

    if not shouldProcessServerCode then return false end
    detachElements(client)
end)

addEvent("glueVehicleCapitalRP", true)
addEventHandler("glueVehicleCapitalRP", getRootElement(), function(attachedTo, x, y, z, rotX, rotY, rotZ)
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, eventName, {
        checkEventData = {
            {eventData = source, equalTo = client},
            {eventData = attachedTo, allowedDataTypes = {["userdata"] = true}},
            {eventData = x, allowedDataTypes = {["number"] = true}},
            {eventData = y, allowedDataTypes = {["number"] = true}},
            {eventData = z, allowedDataTypes = {["number"] = true}},
            {eventData = rotX, allowedDataTypes = {["number"] = true}},
            {eventData = rotY, allowedDataTypes = {["number"] = true}},
            {eventData = rotZ, allowedDataTypes = {["number"] = true}}
        }
    })

    if not shouldProcessServerCode then return false end
    attachElements(client, attachedTo, x, y, z, rotX, rotY, rotZ)
end)

addEvent("unglueVehicleCapitalRP", true)
addEventHandler("unglueVehicleCapitalRP", getRootElement(), function()
    local shouldProcessServerCode = exports["Help"]:processServerEventData(client, source, eventName, {
        checkEventData = {
            {eventData = source, equalTo = client}
        }
    })

    if not shouldProcessServerCode then return false end
    detachElements(client)
end)
