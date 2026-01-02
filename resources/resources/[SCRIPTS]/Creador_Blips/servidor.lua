addEvent('onServerRemoveBlip', true)
addEvent('onServerCreateBlip', true)

local Blips = {}
local dbC = dbConnect( "sqlite", "blips.db" )


addEventHandler('onServerRemoveBlip',root,
	function(name)
		if Blips[name] then
			if isElement(Blips[name].blip) then
				Blips[name].blip:destroy()
				Blips[name] = nil
				dbExec( dbC, 'DELETE FROM `Blips` WHERE `Nombre`=?', name)
			end
		end
	end
)

addEventHandler('onServerCreateBlip',root,
	function(name,x,y,z,id)
		if not Blips[name] then
			Blips[name] = {x=x,y=y,z=z,id=id}
			Blips[name].blip = createBlip(x,y,z,id)
			dbExec( dbC, "INSERT INTO Blips VALUES (?,?,?,?,?)",name,x,y,z,id)
		end
	end
)


function resourceStart(none)
	local player = source
	Timer(function(event,player)
		local qh = dbPoll( dbQuery( dbC, "SELECT * FROM Blips"), -1 )
		if #qh ~= 0 then
			
			if event == "onResourceStart" then
				triggerClientEvent(root,'AgregarBlips', root, qh)
			elseif event == 'onPlayerJoin' then
				player:triggerEvent('AgregarBlips', player, qh)
			end
			
			for _,v in ipairs(qh) do
				if not Blips[v.Nombre] then
	        		Blips[v.Nombre] = {x=v.PosX,y=v.PosY,z=v.PosZ,id=v.ID}
					Blips[v.Nombre].blip = createBlip(v.PosX,v.PosY,v.PosZ,v.ID)
				end
	    	end
		end
	end,2000,1,eventName,player)
end
addEventHandler( "onResourceStart", getResourceRootElement(), resourceStart)
addEventHandler( "onPlayerJoin", root, resourceStart)

