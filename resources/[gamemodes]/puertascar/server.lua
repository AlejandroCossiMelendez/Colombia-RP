function porta1()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 0 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 0, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 0, 0, 2500)
    end
end
addEvent("porta1", true)
addEventHandler("porta1", root, porta1)

function porta6()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 1 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 1, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 1, 0, 2500)
    end
end
addEvent("porta6", true)
addEventHandler("porta6", root, porta6)

function porta2()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 2 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 2, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 2, 0, 2500)
    end
end
addEvent("porta2", true)
addEventHandler("porta2", root, porta2)

function porta3()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 3 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 3, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 3, 0, 2500)
    end
end
addEvent("porta3", true)
addEventHandler("porta3", root, porta3)

function porta4()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 5 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 5, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 5, 0, 2500)
    end
end
addEvent("porta4", true)
addEventHandler("porta4", root, porta4)

function porta5()
local vehicle = getPedOccupiedVehicle(source)
if not vehicle then return end
    if getVehicleDoorOpenRatio ( vehicle, 4 ) == 0 then
        setVehicleDoorOpenRatio(vehicle, 4, 1, 2500)
    else
        setVehicleDoorOpenRatio(vehicle, 4, 0, 2500)
    end
end
addEvent("porta5", true)
addEventHandler("porta5", root, porta5)