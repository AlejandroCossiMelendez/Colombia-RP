local count = {}

addEventHandler( "onResourceStart", resourceRoot,
	function()
		DB = Connection('sqlite','shops.db')
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


addCommandHandler("creartiendaropa",
	function(player, _, skin)
		if isObjectInACLGroup('user.'..player.account.name, aclGetGroup( 'Desarrollador' ) ) then
			if tonumber(skin) then

				local qh = DB:query('select * from shops')
				local p = dbPoll(qh, -1)

				local id = (((p[math.max(#p, 1)].id) or 0)+1)
				local x,y,z = getElementPosition(player)
				local _,_,rz = getElementRotation(player)
				local int,dim = player.interior, player.dimension
				local skin = tonumber(skin)

				dbFree(DB:query('insert into shops values(?,?,?)', id, toJSON({x,y,z,rz,int,dim}), skin ))
				print('Tienda de ropa creada ', 'id='..id..', x='..x..', y='..y..', z='..z..', rz='..rz..', int='..int..', dim='..dim..', skin='..skin)

				createShop(id, x, y, z, rz, int, dim, skin)
				dbFree( qh )
			end
		end
	end
)

addCommandHandler("borrartiendaropa",
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

				print('Tienda de ropa borrada ', 'id='..id)
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
								local sql, err = exports.sql:query_assoc_single("SELECT color, genero FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(hitElement)))
								local color = tonumber(sql.color)
								local genero = tonumber(sql.genero)
								triggerClientEvent(hitElement,"showDemClothGui", hitElement, genero, color)
								exports.objetivos:addObjetivo(10, exports.players:getCharacterID(hitElement), hitElement)
							end
						end
					end
    			end
    		end
    	end
	end
)

addEvent("ropa:comprarSkin",true)
addEventHandler("ropa:comprarSkin",getRootElement(),
	function(id)
		source:setModel(id)
		exports.players:takeMoney(source, 300)
		source:outputChat('Compraste la skin '..getSkinNameFromID(id)..'('..id..')', 0, 255, 0)
	end
)

addEvent("displayclothes",true)
addEventHandler("displayclothes",getRootElement(),
function(style)
	if client and source and client == source then
		local sql, err = exports.sql:query_assoc_single("SELECT color, genero FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(source)))
		local color = tonumber(sql.color)
		local genero = tonumber(sql.genero)
		triggerClientEvent(client,"displayClothOn",client,clothes[style], style, tonumber(genero), tonumber(color))
	end
end)

addEvent("aplicarRopaServidor",true)
addEventHandler("aplicarRopaServidor",getRootElement(),
function(idUnico)
	if idUnico then
		local sql = exports.sql:query_assoc_single("SELECT color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(source)))
		local color = tonumber(sql.color)
		local cost = getPrecioRopa(idUnico)
		if idUnico <= 0 then
			if getElementModel(source) > 0 then
				setElementModel(source, 0)
			end
			removePedClothes(source, -idUnico)
			if color == 1 then -- Blanco
				triggerClientEvent("onSolicitarRopaBlanco", source)
			end
		else
			if idUnico >= 341 then -- Skin de las antiguas.
				if idUnico == 99999 then
					setElementModel(source, 0)
					if color == 1 then -- Blanco
						triggerClientEvent("onSolicitarRopaBlanco", source)
					end
				else
					local _, skin = getInfoRopa(tonumber(idUnico))
					--outputDebugString("IDUnico: "..tonumber(idUnico))
					--outputDebugString("IDSkin: "..tonumber(skin))
					setElementModel(source, tonumber(skin))
				end
			else
				if getElementModel(source) > 0 then
					setElementModel(source, 0)
				end
				local textura, modelo, tipo, name = getInfoRopa(tonumber(idUnico))
				addPedClothes(source,textura,modelo,tipo)
				if color == 1 then -- Blanco
					triggerClientEvent("onSolicitarRopaBlanco", source)
				end
				exports.items:give( source, 5551555, toJSON({textura, modelo, tipo}), name )
				source:outputChat('Compraste '..name..'.', 0,255,0)
			end
		end
		if tonumber(cost) then
			exports.players:takeMoney(source, cost)
		end
		exports.ropas:saveClothes(source)
	end 
end)


addCommandHandler('quitarcamisa',
	function(source)
		source:addClothes("player_torso", "torso", 0)
		local sql = exports.sql:query_assoc_single("SELECT color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(source)))
		local color = tonumber(sql.color)
		if color == 1 then -- Blanco
			triggerClientEvent("onSolicitarRopaBlanco", source)
		end
		exports.ropas:saveClothes(source)
		exports.chat:me(source, 'se quita su camisa y la guarda')
	end
)