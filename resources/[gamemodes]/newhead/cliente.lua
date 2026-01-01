local heads = {
	{954, 0.01, -0.02, -0.67, 0, -90, 0},
	{1220, 0.01, -0.02, -0.67, 0, -90, 0},
	{926, 0.01, -0.02, -0.67, 0, -90, 0},
	{928, 0.01, -0.01, -0.67, 0, -90, 0}, -- negra
	{1230, 0.01, -0.026, -0.685, 0, -90, 0}, -- negra
	{1329, 0.01, -0.01, -0.67, 0, -90, 0}, -- negra
	{1328, 0.01, -0.01, -0.67, 0, -90, 0},--negra
	{1327, 0.01, -0.015, -0.67, 0, -90, 0},--negra
	{902, 0.01, -0.015, -0.645, 0, -90, 0},--negra
	{903, 0.01, -0.015, -0.645, 0, -90, 0},
	{953, 0.01, -0.01, -0.57, 0, -90, 0},
	{1599, 0.01, -0.01, -0.67, 0, -90, 0},
	{1600, 0.01, -0.01, -0.67, 0, -90, 0},
	{1601, 0.01, -0.03, -0.69, -4, -90, 0},
	{1602, 0.01, -0.02, -0.67, -2, -90, 0},
	{1603, 0.01, -0.02, -0.67, -2, -90, 0},
	{1604, 0.01, -0.02, -0.67, -2, -90, 0},
	{1605, 0.01, -0.02, -0.67, -1, -90, 0},
	{1606, 0.01, -0.02, -0.67, -2.5, -90, 0},
	{1610, 0.01, -0.02, -0.67, -0.05, -90, 0},
	{1611, 0.01, -0.02, -0.67, -0.2, -90, -4}, --negra
	{2709, 0.01, -0.02, -0.65, -0.2, -90, -4},--negra
	{2710, 0.01, -0.0, -0.65, 0, -90, 0}, --negra
	{2037, 0.01, -0.02, -0.69, 0, -90, 0},--negra
	{1644, 0.01, -0.02, -0.66, 0, -90, 0},
	{1221, 0.01, -0.0, -0.695, 0, -90, 0},
	{1654, -0.005, -0.04, -0.61, 0, -90, 0},
	{2672, -0.01, -0.125, -0.63, 0, -90, 0},
	{2671, -0.005, -0.045, -0.68, -0.05, -90, 0}, --negra
	{2670, -0.0, 0.01, -0.68, 0, -90, 0},
	{2747, 0.01, 0.01, -0.66, 0, -90, 0},--negra
	{2683, 0, -0.02, -0.69, 0, -90, 0}, -- negra
	{2663, 0.0, 0.01, -0.68, 0, -90, 0},
	{7361, -0.0, 0.00, -0.73, 0, -90, 0},
	{9568, 0.0, -0.02, -0.68, -0.5, -90, 0},
}



_cabezas = {
	blanco = {
		{954, 0.01, -0.02, -0.67, 0, -90, 0},
		{1220, 0.01, -0.02, -0.67, 0, -90, 0},
		{926, 0.01, -0.02, -0.67, 0, -90, 0},
		{903, 0.01, -0.015, -0.645, 0, -90, 0},
		{953, 0.01, -0.01, -0.57, 0, -90, 0},
		{1599, 0.01, -0.01, -0.67, 0, -90, 0},
		{1600, 0.01, -0.01, -0.67, 0, -90, 0},
		{1601, 0.01, -0.03, -0.69, -4, -90, 0},
		{1602, 0.01, -0.02, -0.67, -2, -90, 0},
		{1603, 0.01, -0.02, -0.67, -2, -90, 0},
		{1604, 0.01, -0.02, -0.67, -2, -90, 0},
		{1605, 0.01, -0.02, -0.67, -1, -90, 0},
		{1606, 0.01, -0.02, -0.67, -2.5, -90, 0},
		{1610, 0.01, -0.02, -0.67, -0.05, -90, 0},
		{1644, 0.01, -0.02, -0.66, 0, -90, 0},
		{1221, 0.01, -0.0, -0.695, 0, -90, 0},
		{1654, -0.005, -0.04, -0.61, 0, -90, 0},
		{2672, -0.01, -0.125, -0.63, 0, -90, 0},
		{2670, -0.0, 0.01, -0.68, 0, -90, 0},
		{2663, 0.0, 0.01, -0.68, 0, -90, 0},
		{7361, 0.0, 0.01, -0.68, 0, -90, 0},
		{9568, 0.0, 0.01, -0.90, -0.5, -90, 0},
	},
	negro = {
		{928, 0.01, -0.01, -0.67, 0, -90, 0}, -- negra
		{1230, 0.01, -0.026, -0.685, 0, -90, 0}, -- negra
		{1329, 0.01, -0.01, -0.67, 0, -90, 0}, -- negra
		{1328, 0.01, -0.01, -0.67, 0, -90, 0},--negra
		{1327, 0.01, -0.015, -0.67, 0, -90, 0},--negra
		{902, 0.01, -0.015, -0.645, 0, -90, 0},--negra
		{1611, 0.01, -0.02, -0.67, -0.2, -90, -4}, --negra
		{2709, 0.01, -0.02, -0.65, -0.2, -90, -4},--negra
		{2710, 0.01, -0.0, -0.65, 0, -90, 0}, --negra
		{2037, 0.01, -0.02, -0.69, 0, -90, 0},--negra
		{2671, -0.005, -0.045, -0.68, -0.05, -90, 0}, --negra
		{2747, 0.01, 0.01, -0.66, 0, -90, 0},--negra
		{2683, 0, -0.02, -0.69, 0, -90, 0}, -- negra
	}
}

if dxDrawText then

local tecni = [[texture gTexture;
technique hello
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]
shaderRopa1 = {}
texturaRopa1 = {}

addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		for i, v in ipairs(heads) do
			i = i + 1
			engineImportTXD(engineLoadTXD('files/'..i..'.txd'),v[1])
			engineReplaceModel(engineLoadDFF('files/'..i..'.dff'),v[1])
		end

		--for i, v in ipairs(getElementsByType('player')) do
		--	setPedHeadless( v, true )
		--end

		local shaBlood = dxCreateShader(tecni)
		local textBlur = dxCreateTexture( "blur.png")
		dxSetShaderValue(shaBlood,"gTexture",textBlur)			
		engineApplyShaderToWorldTexture(shaBlood,"bloodpool_64")
		engineApplyShaderToWorldTexture(shaBlood,"sphere")

	end
)


end

if getResources then

obHead = {}


addEventHandler( "onResourceStart", resourceRoot,
	function()
		DB = dbConnect( "sqlite", "test.db" )
		for i, v in ipairs(getElementsByType('player')) do
			if exports.players:isLoggedIn(v) then
				eventPonerC(v)
			end
		end
	end
)

addEvent('GuardarCabeza', true)
addEventHandler('GuardarCabeza', root,
	function(charID, id, genero)
		--iprint(charID, 'char')
		if genero == 1 then
			local qh = DB:query('select * from cabezas where char=?', charID)
			local resp = qh:poll(-1)
			if resp and #resp == 1 then
				dbFree( DB:query('update cabezas set id=?, genero=? where char=?', charID, '1', charID) )
			else
				dbFree( DB:query('insert into cabezas values(?,?,?)', charID, id, ''..genero) )
			end
		end
	end
)


function eventPonerC(player)
		local source = player or source
		local charID = exports.players:getCharacterID(source)
		local userID = exports.players:getUserID(source)
		if charID and userID then
			local char = exports.sql:query_assoc_single( "SELECT * FROM characters WHERE userID = " .. tonumber( userID ) .. " AND characterID = " .. tonumber( charID ) )
			if char then
				if char.genero == 1 then
				--	source:setHeadless(true)
					local qh = DB:query('select * from cabezas where char=?', charID)
					local resp = qh:poll(-1)
					if resp and #resp == 1 then
						if resp[1].genero == '1' then
							addPlayerHead(source, tonumber(resp[1].id))
						end
					end
				else
					source:setHeadless(false)
				end
			end
		end
	end
addEventHandler( "onCharacterLogin", getRootElement(), eventPonerC)

function addPlayerHead(player, id)
	setPedHeadless(player, true)

	local id,x,y,z,rx,ry,rz = getArrayFromID(id)
	obHead[player] = Object(id, player.position)
	obHead[player]:setCollisionsEnabled(false)

	Timer(function(player,x,y,z,rx,ry,rz)
		exports.bone_attach:attachElementToBone(obHead[player], player, 1, x,y,z,rx,ry,rz)--52
	end, 150, 1, player,x,y,z,rx,ry,rz)
end

function changeHead(player, id)
	removeHeadPlayer(player)
	addPlayerHead(player, id)
end

function removeHeadPlayer(player)
	if isElement(obHead[player]) then
		exports.bone_attach:detachElementFromBone(obHead[player])
		obHead[player]:destroy()
	end
end

addCommandHandler('head',
	function(player,_, id)
		changeHead(player, 9568)
	end
)

addEventHandler( "onPlayerSpawn", getRootElement(),
	function()
		local charID = exports.players:getCharacterID(source)
		local userID = exports.players:getUserID(source)
		if charID and userID then
			local char = exports.sql:query_assoc_single( "SELECT * FROM characters WHERE userID = " .. tonumber( userID ) .. " AND characterID = " .. tonumber( charID ) )
			if char then
				if char.genero == 1 then
					source:setHeadless(true)
				else
					source:setHeadless(false)
				end
			end
		end
	end
)

addEventHandler( "onCharacterLogout", getRootElement(),
	function()
		removeHeadPlayer(source)
	end
)

local check = {
	int={},
	dim={},
}

Timer(
	function()

		for i,v in ipairs(Element.getAllByType('player')) do

			if isElement(obHead[v]) then

				check.int[v] = check.int[v] or 0
				check.dim[v] = check.dim[v] or 0

				local cdim = getElementDimension( v )
				local cint = getElementInterior( v )

				if cdim ~= check.dim[v] or cint ~= check.int[v] then

					check.int[v] = cint
					check.dim[v] = cdim

					setElementInterior(obHead[v], cint)
					setElementDimension(obHead[v], cdim)

				end

			end

			local charID = exports.players:getCharacterID(v)
			local userID = exports.players:getUserID(v)
			if charID and userID then
				local char = exports.sql:query_assoc_single( "SELECT * FROM characters WHERE userID = " .. tonumber( userID ) .. " AND characterID = " .. tonumber( charID ) )
				if char then
					if char.genero == 1 then
						v:setHeadless(true)
					else
						v:setHeadless(false)
					end
				end
			end

		end

	end
,100,0)




end

function getArrayFromID(id)
	if tonumber(id) then
		for i,v in ipairs(heads) do
			if v[1] == id then
				return unpack(v)
			end
		end
	end
	return nil, false
end

--[[
local function tryCreate( key )
	local name = destroy["g:createcharacter:name"] and guiGetText( destroy["g:createcharacter:name"] )
	local edad = destroy["g:createcharacter:edad"] and math.floor(tonumber(guiGetText( destroy["g:createcharacter:edad"] )))
	local genero = destroy["g:createcharacter:genero"] and string.lower(guiGetText( destroy["g:createcharacter:genero"] ))
	local color = destroy["g:createcharacter:color"] and string.lower(guiGetText( destroy["g:createcharacter:color"] ))
	if tostring(genero) ~= "hombre" and tostring(genero) ~= "mujer" then setMessage ( "Género no válido. Pon Mujer o Hombre." ) return end
	if tostring(color) ~= "blanco" and tostring(color) ~= "negro" then setMessage ( "Color no válido. Pon Blanco o Negro." ) return end
	if not tonumber(edad) or tonumber(edad) <= 9 or tonumber(edad) >= 101 then setMessage ( "La edad debe de estar entre 10 y 100." ) return end
	local error = verifyCharacterName( name )
	if not error then
		if tostring(genero) == "hombre" then gen = 1 else gen = 2 end
		if tostring(color) == "negro" then col = 0 else col = 1 end
		triggerServerEvent( "gui:createCharacter", getLocalPlayer( ), name, edad, gen, col )
	else
		setMessage( error )
	end
end  ]]