myShader = dxCreateShader( "texture.fx" )
local limpiaVeh_1 = createMarker ( 1317.8674316406, 250.81658935547, 19.36874961853, "cylinder", 4, 255, 0, 0, 0 )

function limpiarCoche (hitPlayer, matchingDimension)
	if not getPedOccupiedVehicle ( hitPlayer ) then return end
    local theVehicle = getPedOccupiedVehicle ( hitPlayer )
	local conductor = getVehicleController( theVehicle )
    if theVehicle and conductor then
		if getLocalPlayer() == conductor and hitPlayer == conductor then
			outputChatBox("", 0, 255, 0)
		end
		if theVehicle and getElementModel(theVehicle) ~= 416 then
			engineApplyShaderToWorldTexture( myShader, "vehiclegrunge256", theVehicle )
			engineApplyShaderToWorldTexture( myShader, "?emap*", theVehicle )     
		end
    end
end
addEventHandler("onClientMarkerHit", limpiaVeh_1, limpiarCoche)
addEventHandler("onClientMarkerHit", limpiaVeh_2, limpiarCoche)