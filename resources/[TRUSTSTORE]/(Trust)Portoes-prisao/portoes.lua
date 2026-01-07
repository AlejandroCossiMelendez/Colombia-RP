for _, valor in ipairs(portoes['celas']) do 
    local portao = createObject(2930, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 2.7, 'cylinder', 2, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end

for _, valor in ipairs(portoes['dupla portas']) do 
    local portao = createObject(3089, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 2.7, 'cylinder', 4, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end 

for _, valor in ipairs(portoes['portão entrada penitenciaria']) do 
    local portao = createObject(971, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 4, 'cylinder', 14, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 3000, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 3000, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end

for _, valor in ipairs(portoes['portas guaritas']) do 
    local portao = createObject(3089, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 2.7, 'cylinder', 3, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end 

for _, valor in ipairs(portoes['portão portaria penitenciaria']) do 
    local portao = createObject(2909, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 2.7, 'cylinder', 9, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 3000, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 3000, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end

for _, valor in ipairs(portoes['almoxarifado']) do 
    local portao = createObject(2930, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 2.7, 'cylinder', 2, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end

for _, valor in ipairs(portoes['porta area solitaria']) do 
    local portao = createObject(3089, valor.fechado[1], valor.fechado[2], valor.fechado[3], 0, 0, valor.fechado[4]) 
    local marker = createMarker(valor.fechado[1], valor.fechado[2], valor.fechado[3] - 1.5, 'cylinder', 3.5, 0, 0, 0, 0) 
    addEventHandler('onMarkerHit', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.aberto[1], valor.aberto[2], valor.aberto[3])
                end
            end
        end 
    end)
    addEventHandler('onMarkerLeave', marker, 
    function (player, dim)
        if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dim then 
            local c = getPlayerAccount(player)
            if c and not isGuestAccount(c) then 
                local conta = getAccountName(c)
                if getPermissionPortao(conta, valor.acls) then 
                    moveObject(portao, 1500, valor.fechado[1], valor.fechado[2], valor.fechado[3])
                end
            end
        end 
    end)
end

getPermissionPortao = function ( conta, tabela )
    for _, acl in ipairs(tabela) do 
        if acl and aclGetGroup(acl) and isObjectInACLGroup('user.'..conta, aclGetGroup(acl)) then 
            return true
        end
    end
    return false 
end