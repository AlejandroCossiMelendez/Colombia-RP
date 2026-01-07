local GPS = {}
GPS.Functions = {}
GPS.Events = {}
GPS.Indicator = nil
GPS.WaypointInfo = { 
    Blip = nil,
    Marker = nil,
    Target = nil,
}

GPS.Functions.CreateWaypoint = function(x, y, z)
    GPS.Functions.DestroyWaypoint()
    GPS.WaypointInfo.Marker = createMarker(x, y, z, 'checkpoint', 2, 255, 185, 100, 200)
    if ( GPS.WaypointInfo.Marker ) then
    
        GPS.WaypointInfo.Blip = createBlipAttachedTo(GPS.WaypointInfo.Marker, 41, 2)
        if ( GPS.WaypointInfo.Blip ) then
            setElementParent(GPS.WaypointInfo.Blip, GPS.WaypointInfo.Marker)
        end
        
        if ( not GPS.Indicator ) then
            local x, y, z = getElementPosition(localPlayer)
            GPS.Indicator = createObject(1318, x, y, z)
            if ( GPS.Indicator ) then
                setObjectScale(GPS.Indicator, 0.5)
                setElementCollisionsEnabled(GPS.Indicator, false)
                setElementInterior(GPS.Indicator, getElementInterior(localPlayer))
                setElementDimension(GPS.Indicator, getElementDimension(localPlayer))
            end
            addEventHandler('onClientPreRender', root, GPS.Functions.RenderIndicator)
        end
        
        addEventHandler('onClientMarkerHit', GPS.WaypointInfo.Marker, GPS.Events.OnWaypointHit)
    end
end

GPS.Functions.DestroyWaypoint = function()
    if ( GPS.WaypointInfo.Marker ) then
  
        if isElement( GPS.WaypointInfo.Marker ) then
            destroyElement( GPS.WaypointInfo.Marker )
        end
        
        if ( GPS.WaypointInfo.Blip ) then
        
            if isElement( GPS.WaypointInfo.Blip ) then
                destroyElement(GPS.WaypointInfo.Blip)
            end
            
            GPS.WaypointInfo.Blip = nil
        end
        
        if ( GPS.Indicator ) then
        
            if ( isElement(GPS.Indicator) ) then
                destroyElement(GPS.Indicator)
            end
            
            removeEventHandler('onClientPreRender', root, GPS.Functions.RenderIndicator)
            GPS.Indicator = nil
        end
        
        GPS.WaypointInfo.Marker = nil
        GPS.WaypointInfo = {}
        
        return true
    end
    return false
end

GPS.Functions.RenderIndicator = function()
    if ( GPS.WaypointInfo.Marker ) and ( GPS.Indicator ) then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        local element = ( vehicle  ) or localPlayer
        local x1, y1, z1 = getElementPosition(element)
        local x2, y2, z2 = getElementPosition(GPS.WaypointInfo.Marker)
        if ( x1 ) and ( x2 ) then
            local x, y, z =  getPositionFromElementOffset(localPlayer,0,0,( vehicle and 1.2 ) or 1) 
            local vehicleX, vehicleY, vehicleZ = ( vehicle and getVehicleComponentPosition(element, 'ug_roof', 'world') ) or false
            setElementPosition(GPS.Indicator, ( vehicle and x1 ) or x, ( vehicle and y1 ) or y, ( vehicleZ and vehicleZ + 1 ) or z)
            
            local rot = findRotation( x1, y1, x2, y2 )
            if ( rot ) then
                setElementRotation(GPS.Indicator, 0, 270, ( rot + 90 ))
            end 
        end
    end
end

GPS.Events.OnWaypointHit = function(player, matchingDimension)
    if ( player == localPlayer ) and ( matchingDimension ) then
        outputChatBox("Has alcanzado tu destino.",255,255,255,true)
        GPS.Functions.DestroyWaypoint()
    end
end

function getWaypoint()
    if ( GPS.WaypointInfo.Marker ) then
        return GPS.WaypointInfo
    end
    return false
end

function setWaypoint(x, y, z)
    if ( x and isElement(x) ) then
        local elementX, elementY, elementZ = getElementPosition(x)
        if ( elementX ) then
            local element = GPS.Functions.CreateWaypoint(elementX, elementY, elementZ)
            if ( element ) then
                attachElements(element, x)
                return element
            end
        end
    elseif ( type(x) == 'number' and type(y) == 'number' and type(z) == 'number' ) then
        return GPS.Functions.CreateWaypoint(x, y, z) or false
    end
    return false
end
addEvent(thisResourceName..".SetWaypoint", true)
addEventHandler(thisResourceName..".SetWaypoint", root, setWaypoint)

function removeWaypoint()
    return GPS.Functions.DestroyWaypoint()
end
addEvent(thisResourceName..".RemoveWaypoint", true)
addEventHandler(thisResourceName..".RemoveWaypoint", root, setWaypoint)


addCommandHandler('waypoint',
    function()
        setWaypoint(0,0,0)
    end
)