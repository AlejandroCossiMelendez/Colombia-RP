-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy


local IFP1 = engineLoadIFP( "1.ifp", "1" )
local IFP2 = engineLoadIFP( "2.ifp", "2" )
local IFP3 = engineLoadIFP( "3.ifp", "3" )
local IFP4 = engineLoadIFP( "4.ifp", "4" )
local IFP5 = engineLoadIFP( "5.ifp", "5" )
local IFP6 = engineLoadIFP( "6.ifp", "6" )
local IFP7 = engineLoadIFP( "7.ifp", "7" )
local IFP8 = engineLoadIFP( "8.ifp", "8" )
local IFP9 = engineLoadIFP( "9.ifp", "9" )
function bind1 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "1", "Stunt1", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt1', 0.3 )
      end,20,1)
end
end
end
end

bindKey("1", "down", bind1)

function bind2 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "2", "Stunt2", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt2', 0.3 )
      end,20,1)
end
end
end
end

bindKey("2", "down", bind2)

function bind3 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "3", "Stunt3", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt3', 0.3 )
      end,20,1)
end
end
end
end

bindKey("3", "down", bind3)

function bind4 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "4", "Stunt4", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt4', 0.3 )
      end,20,1)
end
end
end
end

bindKey("4", "down", bind4)

function bind5 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "5", "Stunt9", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt9', 0.3 )
      end,20,1)
end
end
end
end

bindKey("5", "down", bind5)

function bind6 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "6", "Stunt6", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt6', 0.3 )
      end,20,1)
end
end
end
end

bindKey("6", "down", bind6)

function bind7 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "7", "Stunt7", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt7', 0.3 )
      end,20,1)
end
end
end
end

bindKey("7", "down", bind7)

function bind8 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
		setPedAnimation(localPlayer, "8", "Stunt8", -1, false, false, true, true)
		setElementData(localPlayer, "vehAnim", true)
		setTimer(function() 
         setPedAnimationSpeed( localPlayer, 'Stunt8', 0.3 )
      end,20,1)
end
end
end
end

bindKey("8", "down", bind8)

function bind9 ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if veh then
	if getVehicleController( veh ) == localPlayer then
		if getVehicleType( veh ) == "Bike" then
setPedAnimation(localPlayer, "9", "Stunt5", -1, false, false, true, true)
setElementData(localPlayer, "vehAnim", true)
setTimer(function()
		setPedAnimationSpeed( localPlayer, 'Stunt5', 0.2 )
end, 3200, 0 )
end
end
end
end

bindKey("9", "down", bind9)
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() then
        		if getElementData(thePlayer, "vehAnim") == true then
        			setElementData(thePlayer, "vehAnim", nil)
        			setPedAnimation(thePlayer, false)
        end
    end
    end
)


-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
