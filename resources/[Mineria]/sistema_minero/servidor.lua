addEvent('minero:picarMateriales', true)
addEventHandler('minero:picarMateriales', getRootElement (),
    function(material, cantidad)
    local shouldProcessServerCode = exports["AzkeAC"]:processServerEventData(client, source, eventName, {
        checkEventData = {
        }
    })

    if (not shouldProcessServerCode) then 
        return false
    end
        exports.items:give(client, tonumber(material), tonumber(cantidad))
    end
)

addEvent('minero:quitarMateriales', true)
addEventHandler('minero:quitarMateriales', getRootElement (),
    function(material, cantidad)
    local shouldProcessServerCode = exports["AzkeAC"]:processServerEventData(client, source, eventName, {
        checkEventData = {
        }
    })
    if (not shouldProcessServerCode) then 
        return false
    end

        exports.items:take(client, tonumber(material), tonumber(cantidad))
    end
)

addEvent('minero:giveDinero', true)
addEventHandler('minero:giveDinero', getRootElement (),
    function()
    	local shouldProcessServerCode = exports["AzkeAC"]:processServerEventData(client, source, eventName, {
        checkEventData = {
        }
    })

    if (not shouldProcessServerCode) then 
        return false
    end
        local dineroAleatorio = math.random(5001, 15720)
        exports.players:giveMoney(client, dineroAleatorio)
    end
)

addEvent('minero:animPicar', true)
addEventHandler('minero:animPicar', getRootElement (),
	function()
		setPedAnimation(client, 'sword', 'sword_4', -1, true, false, false)
	end
)

local Alarma = false
addEvent('minero:Alarma', true)
addEventHandler('minero:Alarma', getRootElement (),
	function()
		if not Alarma or getTickCount() - Alarma > 60000*30 then
			outputChatBox('*** Suena la alarma de la Fabrica abandonada ***', root, 0, 255, 153)
			Alarma = getTickCount()
		end
	end
)

addEvent("solicitarPermisoPicar", true)
addEventHandler("solicitarPermisoPicar", getRootElement (), function()
    if exports.players:takeMoney(client, 10000) then
        setElementData(client, "permiso:picar", true) 
        outputChatBox("¡Has obtenido permiso para picar y has pagado $10,000!", player, 0, 255, 0) 
    else
        outputChatBox("No tienes suficiente dinero para pagar el permiso.", player, 255, 0, 0) 
    end
end)