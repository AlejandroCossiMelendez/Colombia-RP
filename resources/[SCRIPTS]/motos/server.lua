function evitarCaidaEnMoto(theVehicle, thePlayer)
    if isElement(thePlayer) and isPedInVehicle(thePlayer) then
        if getVehicleType(theVehicle) == "Bike" then
            setPedCanBeKnockedOffBike(thePlayer, false) -- Evita que el jugador se caiga
        end
    end
end
addEventHandler("onPlayerVehicleEnter", root, evitarCaidaEnMoto)
