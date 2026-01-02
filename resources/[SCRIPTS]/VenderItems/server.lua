local MarkerVender4 = createMarker ( 632.21484375, 1251.2744140625, 11.691181182861 -1, "cylinder", 1.1,  255, 0, 0, 155, true )
local MarkerVender3 = createMarker ( 640.6064453125, 1237.7236328125, 11.687688827515 -1, "cylinder", 1.1,  255, 0, 0, 155, true )
local MarkerVender2 = createMarker ( 577.5888671875, 1222.9091796875, 11.711267471313 -1, "cylinder", 1.1,  255, 0, 0, 155, true )
local MarkerVender1 = createMarker ( 570.64453125, 1219.005859375, 11.711267471313 -1, "cylinder", 1.1,  255, 0, 0, 155, true )


addCommandHandler("vender",
function(source, command, num)
	if isElementWithinMarker (source, MarkerVender1 ) or isElementWithinMarker (source, MarkerVender2 ) or isElementWithinMarker (source, MarkerVender3 ) 
	or isElementWithinMarker (source, MarkerVender4 ) then 
    
-----------------------------------------------------------------
  if not num then
    triggerClientEvent("add:notification", source, "4:Bolsa De Tussi 5:Documento Robado 6:Celular", "info", true )
	triggerClientEvent("add:notification", source, "1:Bareto 2:Seta 3:Bolsa De Meta", "info", true )
    triggerClientEvent("add:notification", source, "Elige el item a vender con /vender 1-6", "info", true )
   return
  end 
-----------------------------------------------------------------

if num == "1" then
  if quitaPorro(source, 1) then
  exports.players:giveMoney(source, 200000) 
  exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 Porro ")
  outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
  exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 1)")
  else
  triggerClientEvent("add:notification", source, "No Tienes Ningun Porro", "warn", true )  
end


 elseif num == "2" then
 if quitaMarihuana(source, 1) then
  exports.players:giveMoney(source, 230000) 
  exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 seta ")
  outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
  exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 2)")
  else
 triggerClientEvent("add:notification", source, "No Tienes setas", "warn", true )  
 end

 elseif num == "3" then
  if quitarMeta(source, 1) then
    exports.players:giveMoney(source, 600000)  
    exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 Raya de meta")
    outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
    exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 3)")
    else
    triggerClientEvent("add:notification", source, "No Tienes Ninguna bolsa de Meta", "warn", true )  
  end
elseif num == "4" then
  if quitarExtasis(source, 1) then
    exports.players:giveMoney(source, 500000)  
    exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 bolsa de tussi")
    outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
    exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 4)")
    else
    triggerClientEvent("add:notification", source, "No Tienes Ninguna bolsa de tussi", "warn", true )  
  end
elseif num == "5" then
  if quitarBolsaMeta(source, 1) then
    exports.players:giveMoney(source, 300000) 
    exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 documento robado")
    outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
    exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 5)")
    else
    triggerClientEvent("add:notification", source, "No Tienes Ningun documento", "warn", true )  
  end
elseif num == "6" then
  if quitarCel(source, 1) then
    exports.players:giveMoney(source, 650000) 
    exports.logs:addLogMessage("ventadrogas", getPlayerName(source):gsub("_", " ") .. " A vendido 1 celular")
    outputChatBox("Ya Tienes el dinero listo y se encuentra en tus manos!", source, 0, 255, 0, true)
    exports.chat:me(source, "Agarra el dinero de la mesa.", "(/vender 6)")
    else
    triggerClientEvent("add:notification", source, "No Tienes Ningun celular", "warn", true )  
  end
else
  triggerClientEvent("add:notification", source, "Numero Invalido", "warn", true )  
 end
   else
  outputChatBox("[Alerta] No estas en un punto", source, 255, 0, 0, true)
end
end)
----------------- Quitar  Cosas ----------------

function quitaSemillas(player, numHierro)
	if player and numHierro then
		local Hierro, slot, v = exports.items:has(player, 47)
		if Hierro then
			if numHierro > v.value then 
				return false
			elseif numHierro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numHierro < v.value then
				local value2 = v.value-numHierro
				exports.items:take(player, slot)
			--	exports.items:give(player, 47, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

function quitaPorro(player, numPorro)
	if player and numPorro then
		local Hierro, slot, v = exports.items:has(player, 18)
		if Hierro then
			if numPorro > v.value then 
				return false
			elseif numPorro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPorro < v.value then
				local value2 = v.value-numPorro
				exports.items:take(player, slot)
			--	exports.items:give(player, 18, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

function quitaMarihuana(player, numPorro)
	if player and numPorro then
		local Hierro, slot, v = exports.items:has(player, 19)
		if Hierro then
			if numPorro > v.value then 
				return false
			elseif numPorro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPorro < v.value then
				local value2 = v.value-numPorro
				exports.items:take(player, slot)
			--	exports.items:give(player, 22, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

function quitarMeta(player, numPorro)
	if player and numPorro then
		local Hierro, slot, v = exports.items:has(player, 21)
		if Hierro then
			if numPorro > v.value then 
				return false
			elseif numPorro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPorro < v.value then
				local value2 = v.value-numPorro
				exports.items:take(player, slot)
			--	exports.items:give(player, 21, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end


function quitarExtasis(player, numPorro)
	if player and numPorro then
		local Hierro, slot, v = exports.items:has(player, 20)
		if Hierro then
			if numPorro > v.value then 
				return false
			elseif numPorro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPorro < v.value then
				local value2 = v.value-numPorro
				exports.items:take(player, slot)
				--exports.items:give(player, 20, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

function quitarBolsaMeta(player, numPorro)
	if player and numPorro then
		local Hierro, slot, v = exports.items:has(player, 16)
		if Hierro then
			if numPorro > v.value then 
				return false
			elseif numPorro == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPorro < v.value then
				local value2 = v.value-numPorro
				exports.items:take(player, slot)
			--	exports.items:give(player, 23, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

function quitarCel(player)
    if player then
        local Hierro, slot, v = exports.items:has(player, 7)
        if Hierro then
            exports.items:take(player, slot)
            return true
        else 
            return false
        end
    else
        return false
    end
end