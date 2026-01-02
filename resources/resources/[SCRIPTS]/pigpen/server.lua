ped1 = createPed( 87, -2671.115234375, 1409.5947265625, 907.5703125 )
setElementInterior(ped1, 3)
setElementDimension(ped1, 2126)

ped2 = createPed ( 178, -2674.576171875, 1427.552734375, 906.4609375 )
setElementInterior(ped2, 3)
setElementDimension(ped2, 2126)

ped3 = createPed ( 246, -2666.4931640625, 1428.5361328125, 906.4609375 )
setElementInterior(ped3, 3)
setElementDimension(ped3, 2126)

function strip(thePlayer)
    if isElementInRange(thePlayer, -2671.115234375, 1409.5947265625, 907.5703125, 2) then
        setPedAnimation(ped1, "strip", "STR_C2")
        setElementFrozen(ped1, false)
        exports.players:takeMoney(thePlayer, 50000)
        setPedAnimation(thePlayer, "strip", "PLY_CASH")
        outputChatBox("Has pagado $500 por un baile strip.", thePlayer, 0, 255, 0)
        setTimer(function(thePlayer)
            setPedAnimation(ped1)
        end, 15000, 1, thePlayer)
    elseif isElementInRange(thePlayer, -2674.576171875, 1427.552734375, 906.4609375, 2) then
        setPedAnimation(ped2, "sex", "sex_1_cum_w")
        setPedAnimation(thePlayer, "sex", "sex_1_cum_p")
        setElementFrozen(ped2, false)
        exports.players:takeMoney(thePlayer, 50000)
        outputChatBox("Has pagado $50K por un una culiada strip.", thePlayer, 0, 255, 0)
        outputChatBox("Maria Tragaleche dice: Acomodate bien mi amor", thePlayer, 255, 69, 173)
        setTimer(function(thePlayer)
            setPedAnimation(ped2)
        end, 35000, 1, thePlayer)
    elseif isElementInRange(thePlayer, -2666.4931640625, 1428.5361328125, 906.4609375, 2) then
        setPedAnimation(ped3, "strip", "STR_C1")
        setPedAnimation(thePlayer, "strip", "PLY_CASH")
        setElementFrozen(ped3, false)
        exports.players:takeMoney(thePlayer, 50000)
        outputChatBox("Has pagado $500 por un baile strip.", thePlayer, 0, 255, 0)
        setTimer(function(thePlayer)
            setPedAnimation(ped3)
        end, 35000, 1, thePlayer)
    end 
end
addCommandHandler("puta", strip)

function isElementInRange(ele, x, y, z, range)
    if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
       return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
    end
    return false
end