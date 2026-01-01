local npc = Ped(27, 584.802734375, 870.1337890625, -42.497318267822, 274.75854492188)
npc:setFrozen(true)
npc:setID('npc:minero')


addEvent('Minero:functionCallBack', true)
addEventHandler('Minero:functionCallBack', root,
	function(f, ...)
		_G[f](...)
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function()
		db = dbConnect( "sqlite", "minero.db" )
	end
)


addEvent('minero:giveDinero', true)
addEventHandler('minero:giveDinero', root,
	function(money)
		exports['players']:giveMoney(source, tonumber(money))
	end
)

local Alarma = false
addEvent('Minero:Alarma', true)
addEventHandler('Minero:Alarma', root,
	function()
		if not Alarma or getTickCount(  ) - Alarma > 60000*20 then
			outputChatBox('*** Suena la Fabrica de Herramientas ***', root, 0, 255, 153)
			Alarma = getTickCount(  )
		end
	end
)

function loadMinero(player)

	local player = player or source
	local name = player:getName()
	local cache = {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}

	local qh = db:query('select * from minero where user=?', name)
	local resp = qh:poll(-1)

	if resp and #resp > 1 then
		cache = fromJSON(resp[1].dato)
	end

	dbFree( qh )
	player:setData('minero:minerales', cache)

end

function saveMinero(player)

	local player = player or source
	local name = player:getName()
	local cache = toJSON(player:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0})

	local qh = db:query('select * from minero where user=?', name)
	local resp = qh:poll(-1)

	if resp and #resp > 1 then
		dbFree( db:query('update minero set dato=? where user=?', cache, name) )
	else
		dbFree( db:query('insert into minero values(?,?)', name, cache) )
	end

	dbFree( qh )

end

addEventHandler( "onCharacterLogin", root, loadMinero)
addEventHandler( "onCharacterLogout", root, saveMinero)

addEventHandler( "onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(Element.getAllByType('player')) do
			if v.account and not v.account:isGuest() then
				saveMinero(v)
			end
		end
	end
)

local valores = {
	hierro = true,
	carbon = true,
	bauxita= true,
}


addCommandHandler('darmineral',
	function(player, _, id, mineral, cantidad)
		if tonumber(id) then

			local who = getPlayerFromID(id)
			if isElement(who) then

				if valores[mineral] then
					if tonumber(cantidad) then

						if getDistanceBetweenPoints3D( who.position, player.position ) < 2 then

							local cantidad = math.floor(math.abs(cantidad))
							local matWho = who:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}
							local matPla = player:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}

							if matPla[mineral] >= cantidad then

								who:outputChat('* '..player.name:gsub('_',' ')..' te dio '..cantidad..' de '..mineral, 0,255,0)
								player:outputChat('* le diste '..cantidad..' de '..mineral..' a '..who.name:gsub('_',' '), 0,255,0)

								matPla[mineral] = matPla[mineral] - cantidad
								matWho[mineral] = matWho[mineral] + cantidad

								who:setData('minero:minerales', matWho)
								player:setData('minero:minerales', matPla)

							end

						end
					end
				end
			end
		end
	end
)

addCommandHandler('givemineral',
	function(player, _, id, mineral, cantidad)
		if tonumber(id) then
			if isObjectInACLGroup('user.'..player.account.name, aclGetGroup( 'Desarrollador' ) ) then
				local who = getPlayerFromID(id)
				if isElement(who) then

					if valores[mineral] then

						if tonumber(cantidad) then

							local cantidad = math.floor(math.abs(cantidad))
							local matWho = who:getData('minero:minerales') or {hierro=0, carbon=0, bauxita=0, acero=0, polvora=0, aluminio=0}

							who:outputChat('* '..player.name:gsub('_',' ')..' te dio '..cantidad..' de '..mineral, 0,255,0)
							player:outputChat('* le diste '..cantidad..' de '..mineral..' a '..who.name:gsub('_',' '), 0,255,0)

							matWho[mineral] = matWho[mineral] + cantidad

							who:setData('minero:minerales', matWho)

						end
					end
				end
			end
		end
	end
)

addEventHandler( "onPlayerCommand", getRootElement(),
	function(c)
		if c == 'guardararma' then
			if source:getWeapon() == 6 then
				cancelEvent(  )
			end
		end
	end
)

function getPlayerFromID(id)
	for _, player in ipairs(Element.getAllByType('player')) do
		if exports['players']:getID(player) == tonumber(id) then
			return player
		end
	end
	return false;
end