local count = {}

addEventHandler( "onResourceStart", resourceRoot,
	function()
		DB = Connection('sqlite','sql.db')
		if DB then
			local qh = DB:query('select * from shops')
			local poll = qh:poll(-1)
			if poll and #poll > 0 then

				for i,v in ipairs(poll) do
					
					local p = fromJSON(v.pos)
					createShop(tonumber(v.id), p[1], p[2], p[3], p[4], p[5], p[6], tonumber(v.skin))

				end

			end
			dbFree( qh )
		end
	end
)


addCommandHandler("creartiendatoys",
	function(player, _, skin)
		if isObjectInACLGroup('user.'..player.account.name, aclGetGroup( 'Desarrollador' ) ) then
			if tonumber(skin) then

				local qh = DB:query('select * from shops')
				local p, row = dbPoll(qh, -1)
				local id = 0

				if #p == 0 then
					id = 1
				else
					id = (p[#p] and tonumber(p[#p].id) + 1) or 1
				end
				local x,y,z = getElementPosition(player)
				local _,_,rz = getElementRotation(player)
				local int,dim = player.interior, player.dimension
				local skin = tonumber(skin)

				dbFree(DB:query('insert into shops values(?,?,?)', id, toJSON({x,y,z,rz,int,dim}), skin ))
				print('Tienda de toys creada ', 'id='..id..', x='..x..', y='..y..', z='..z..', rz='..rz..', int='..int..', dim='..dim..', skin='..skin)

				createShop(id, x, y, z, rz, int, dim, skin)
				dbFree( qh )
			end
		end
	end
)

addCommandHandler("borrartiendatoys",
	function(player, _, id)
		if isObjectInACLGroup('user.'..player.account.name, aclGetGroup( 'Desarrollador' ) ) then
			if tonumber(id) then
				local qh = DB:query('select * from shops where id=?', id)
				local p= qh:poll(-1)

				if not p or #p == 0 then
					return
				end

				DB:exec('delete from shops where id=?', tonumber(id))

				if isElement(count[tonumber(id)]) then
					count[tonumber(id)]:destroy()
				end

				print('Tienda de toys borrada ', 'id='..id)
			end
		end
	end
)

check = {}
function createShop(id, x, y, z, rz, int, dim, skin)

	local ped = Ped(skin, x,y,z,rz)
	ped.interior = int
	ped.dimension = dim
	--
	ped:setID('custom:npc_'..id)

	count[id] = ped
	check[ped] = true

end


addEventHandler( "onElementClicked", root,
	function( theButton, theState, hitElement )
    	if theButton == "left" and theState == "down" then
    		if source.type == 'ped' then
    			if tostring(source:getID()):find('custom:npc') then
    				if getElementType(hitElement) == "player" and not isPedInVehicle(hitElement) then
						if getElementDimension(hitElement) == getElementDimension(source) then
							if check[source] then
								hitElement:triggerEvent('showShopToys', resourceRoot)
							end
						end
					end
    			end
    		end
    	end
	end
)

addEvent('Buy:Toys', true)
addEventHandler('Buy:Toys', root,
	function(_id, _type, offsets, name, price)
		local x,y,z,rx,ry,rz, size = unpack(offsets)
		exports.players:takeMoney(source, price)
		exports.items:give( source, 5552555, toJSON({_id, _type, x, y, z, rx, ry, rz, size}), name )
		source:outputChat('Compraste '..name..'.', 0, 220, 0)
	end
)

--print(id, _type, inspect(offsets), name, price)
