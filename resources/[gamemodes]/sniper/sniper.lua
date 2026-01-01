--------------------------
------ Target Info -------
------  by alex17  -------
--------------------------
local x1, y1 = guiGetScreenSize ()
local x = x1/1000 -- para compatibilidad con todas las resoluciones
local y = y1/1000 --

local x1, y1 = guiGetScreenSize(  )
local x = x1/1000
local y = y1/1000

local targetID = ""
local Effect = "Visión normal"

function GoggleEffect( )
	local weapon = getPedWeapon(getLocalPlayer())
    if  weapon == 34 then
		if(getCameraGoggleEffect() == "normal")then
			setCameraGoggleEffect("nightvision")
			Effect = "#00ff00Vision #Ffffffnocturna"
		elseif(getCameraGoggleEffect() == "nightvision")then
			setCameraGoggleEffect("thermalvision")
			Effect = "#B40486Vision #Fffffftérmica"
		elseif(getCameraGoggleEffect() == "thermalvision")then
			setCameraGoggleEffect("normal")
			Effect = "Visión normal"
		end
	end	
end
bindKey("F", "down", GoggleEffect)

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		local weapon = getPedWeapon( getLocalPlayer( ) )
		local target = getPedTarget( getLocalPlayer( ) )
		if getControlState( "aim_weapon" ) then
			if weapon == 34 then
				if target then
					local posx, posy = getElementPosition( target )
					local posx2, posy2 = getElementPosition( getLocalPlayer( ) )
					if getElementType ( target ) =="vehicle" then 
						targetID = getVehicleName ( target )	
					elseif getElementType( target ) == "object" then
						targetID = getElementModel( target )
					elseif getElementType( target ) == "player" then
						targetID = getPlayerName ( target )
					elseif getElementType( target ) == "ped" then
						targetID = "Model ["..getElementModel(target).."]"
					end
					dxDrawText(Effect.." - [F]\n#00ff00Objetivo #ffffff@"..math.ceil(getDistanceBetweenPoints2D ( posx, posy, posx2, posy2 )).."m\n"..getElementType ( target ).."\n"..targetID.."\n#ffffffHealth "..math.ceil(getElementHealth ( target )), x*10, y*530, 0, 0, tocolor(255, 255, 255, 255), y*2, "clear", "left", "top", false, false, true, true, false)
				else
					dxDrawText( Effect.." - [F]\n#ff0000No hay objetivo", x*10, y*500, 0, 0, tocolor(255, 255, 255, 255), y*2, "clear", "left", "top", false, false, true, true, false)					
				end
			else
				setCameraGoggleEffect( "normal" )
				Effect = "Visión normal"
			end
		end
	end
)
