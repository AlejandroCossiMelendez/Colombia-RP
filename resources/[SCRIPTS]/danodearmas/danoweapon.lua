addEventHandler("onPlayerDamage", getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if bodypart == 9 then
			local result = triggerEvent("", source, attacker, weapon, loss)
			if result == true then
				killPed(source, attacker, weapon, bodypart)
			end
		end
	end
)

local weapons = {20, 40, 31, 30, 29, 24, 22, 27}

function onClientPedDamage(_, weapon)
    if(getElementType(source) == "player") then
       if(weapons[weapon]) then
           return killPed(source)
       end
    end
end
addEventHandler("onClientPedDamage", getRootElement(), onClientPedDamage)

for _, v in ipairs ( { "pro", "std", "poor" } ) do
    setWeaponProperty ( "m4", v, "damage", 65 )
    setWeaponProperty ( "ak47", v, "damage", 65 )
    setWeaponProperty ( "mp5", v, "damage", 40 )
    setWeaponProperty ( "deagle", v, "damage", 80 )
    setWeaponProperty ( "colt45", v, "damage", 50 )
    setWeaponProperty ( "uzi", v, "damage", 50 )
    setWeaponProperty ( "tec-9", v, "damage", 15 )
    setWeaponProperty ( "Combat Shotgun", v, "damage", 20 )
end