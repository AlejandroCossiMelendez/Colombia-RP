addEventHandler("onVehicleStartEnter", root, function(enteringPed, seat, jacked, door)
    if (enteringPed) and (seat == 0) and (jacked) then
        cancelEvent()
    end
end)
