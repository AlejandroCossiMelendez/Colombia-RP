local validFactions = {}

validFactions[1] = "Policia"
validFactions[2] = "Médico"
validFactions[3] = "Mecánico"
validFactions[4] = false
validFactions[5] = false
validFactions[6] = false
validFactions[7] = false
validFactions[8] = false
validFactions[9] = false
validFactions[10] = "Taxi"

addCommandHandler("facturar", function(thePlayer, cmd, id, idfaction, quanty)
    local parts = {}
    parts[1] = id 
    parts[2] = idfaction
    parts[3] = quanty
        if parts[1] and parts[2] and parts[3] then 
            local factionID = tonumber(parts[2])
            if (exports.factions:isPlayerInFaction(thePlayer, factionID)) and (validFactions[factionID]) then 
                local id = tonumber(parts[1])
                local otherPlayer = nil
                for i, v in ipairs (getElementsByType('player')) do 
                    if (getElementData( v, "playerid" ) == id) then 
                        otherPlayer = v
                        break
                    end
                end
                if isElement(otherPlayer) then 
                    local x, y, z = getElementPosition(thePlayer)
                    local px, py, pz = getElementPosition(otherPlayer)
                    if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 8 then 
                        outputChatBox("Estás demasiado lejos de "..getPlayerName(otherPlayer)..".", thePlayer, 255, 0, 0)
                        return
                    end
                    local cantidad = tonumber(parts[3])
                    if cantidad > 299 then 
                        if cantidad < 12001 then 
                            setElementData(otherPlayer, "lastFacturaCantidad", cantidad)
                            setElementData(otherPlayer, "lastFacturaTipo", validFactions[factionID])
                            setElementData(otherPlayer, "lastFacturaFactionToPay", factionID)
                            setElementData(otherPlayer, "lastFacturador", thePlayer)
                            setElementData(otherPlayer, "ableToPagarFactura", true)
                            setTimer(setElementData, 60000, 1, otherPlayer, "ableToPagarFactura", false)
                            chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " utiliza su datáfono para generar una factura y se la entrega a "..string.gsub(getPlayerName(otherPlayer), "_", " ")..".", 255, 0, 128)
                            outputChatBox("¡Te ha llegado una factura! El valor es de $"..cantidad.." por los servicios de "..validFactions[factionID].." prestados por "..string.gsub(getPlayerName(thePlayer), "_"," ")..".", otherPlayer, 0, 255, 0)
                            outputChatBox("Utiliza /aceptarfactura o /rechazarfactura para aceptar o rechazar este pago respectivamente. Tienes 1 minuto para aceptarla o se rechazará automáticamente.", otherPlayer, 0, 255, 0)
                        else
                            outputChatBox("No puedes facturar más de $12000.", thePlayer, 255, 0, 0)
                        end
                    else
                        outputChatBox("No puedes facturar menos de $300.", thePlayer, 255, 0, 0)
                    end
                else
                    outputChatBox("No se ha encontrado un jugador con la ID: "..id, thePlayer, 255, 255, 255)
                end
            else
                outputChatBox("No perteneces a esa facción o esa facción no está habilitada para facturar.", thePlayer, 255, 0, 0)
            end
        else
            outputChatBox("Sintáxis: /facturar [id] [idfaccion] [cantidad]", thePlayer, 255, 255, 255)
            outputChatBox("ID Facciones posibles: 1: Policia, 2: Médico, 3: Mecánico, 10: Taxista", thePlayer, 255, 255, 255)
        end
end)

function chatLocal(thePlayer, msg, r, g, b)
    local px, py, pz = getElementPosition(thePlayer)
    local chat_range = 20
    local nick = getPlayerName(thePlayer)
    for _,v in ipairs(getElementsByType("player")) do 
        if isPlayerInRangeOfPoint(v,px,py,pz,chat_range) then 
          outputChatBox(msg,v,r,g,b,true) 
        end
    end
end

function isPlayerInRangeOfPoint(player,x,y,z,range)
    local px,py,pz=getElementPosition(player) 
    return ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5<=range 
 end 


addCommandHandler("aceptarfactura", function(thePlayer, cmd, msg)
    if getElementData(thePlayer, "ableToPagarFactura") then 
    if (msg) and ((msg == "1") or (msg == "2")) then 
        if msg == "1" then 
            local theCantidad = getElementData(thePlayer, "lastFacturaCantidad")
            local theType = getElementData(thePlayer, "lastFacturaTipo")
            local theFactionToPay = getElementData(thePlayer, "lastFacturaFactionToPay")
            local theFacturador = getElementData(thePlayer, "lastFacturador")

                if (getPlayerMoney(thePlayer) >= theCantidad) then 

                    setPlayerMoney(thePlayer, (getPlayerMoney(thePlayer)-theCantidad))

                    setPlayerMoney(theFacturador, (getPlayerMoney(theFacturador)+(theCantidad*0.15)))
                    setElementData(thePlayer, "ableToPagarFactura", false)
                    exports.factions:giveFactionPresupuesto(theFactionToPay, (theCantidad*0.85))
                    
                    outputChatBox("Tu cliente ha pagado la factura con éxito. Obtuviste el 15% de este pago ($"..(theCantidad*0.15)..").", theFacturador, 0, 255, 0)
                    outputChatBox("Has pagado esta factura con éxito.", thePlayer, 0, 255, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " toma unos billetes de su cartera y paga la factura con estos.", 255, 0, 128)
                else
                    outputChatBox("No tienes suficiente dinero en tu billetera para pagar esta factura.", thePlayer, 255, 0, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " ha intentado pagar la factura pero no tiene suficiente dinero en la billetera para esto.", 255, 0, 128)
                end

        elseif msg == "2" then
            if getElementData(thePlayer, "moneyInBank") then 
                local theCantidad = getElementData(thePlayer, "lastFacturaCantidad")
                local theType = getElementData(thePlayer, "lastFacturaTipo")
                local theFactionToPay = getElementData(thePlayer, "lastFacturaFactionToPay")
                local theFacturador = getElementData(thePlayer, "lastFacturador")
    
                if (getElementData(thePlayer, "moneyInBank") >= theCantidad) then 
                    setElementData(thePlayer, "moneyInBank", getElementData(thePlayer, "moneyInBank")-theCantidad)
                    setPlayerMoney(theFacturador, getPlayerMoney(theFacturador)+(theCantidad*0.15))
                    exports.factions:giveFactionPresupuesto(theFactionToPay, (theCantidad*0.85))
                    outputChatBox("Tu cliente ha pagado la factura con éxito. Obtuviste el 15% de este pago ($"..(theCantidad*0.15)..").", theFacturador, 0, 255, 0)
                    outputChatBox("Has pagado esta factura con éxito. Tu dinero fue retirado de tu cuenta bancaria.", thePlayer, 0, 255, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " utiliza su teléfono para pagar la factura con su cuenta bancaria.", 255, 0, 128)
                    setElementData(thePlayer, "ableToPagarFactura", false)
                else
                    outputChatBox("No tienes suficiente dinero en tu banco para pagar esta factura.", thePlayer, 255, 0, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " utiliza su teléfono para pagar la factura con su cuenta bancaria, pero no tiene suficiente dinero para pagarla.", 255, 0, 128)
                
                end
            else
                outputChatBox("No tienes una cuenta bancaria para pagar esta factura.", thePlayer, 255, 0, 0)
            end
        end
    else
        outputChatBox("Sintáxis: /aceptarfactura [tipo de pago]", thePlayer, 255, 255, 255)
        outputChatBox("Tipos de pago: 1- Billetera, 2- Banco", thePlayer, 255, 255, 255)
    end
    else
        outputChatBox("No tienes facturas para pagar en este momento.", thePlayer, 255, 0, 0)
    end
end)

addCommandHandler("rechazarfactura", function(thePlayer)
    if getElementData(thePlayer, "ableToPagarFactura") then 
        local theFacturador = getElementData(thePlayer, "lastFacturador")
        setElementData(thePlayer, "ableToPagarFactura", false)
        outputChatBox("Tu cliente ha rechazado la factura entregada.", theFacturador, 255, 0, 0)
        outputChatBox("Rechazaste esta factura con éxito.", thePlayer, 0, 255, 0)
        chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " rechaza la factura entregada.", 255, 0, 128)
    else
        outputChatBox("No tienes facturas para rechazar en este momento.", thePlayer, 255, 0, 0)
    end
end)

addCommandHandler("pagar", function(thePlayer, cmd, id, cantidad)
    if id and cantidad then 
        theID = tonumber(id)
        local otherPlayer = nil 

        for i, v in ipairs (getElementsByType('player')) do 
            if (getElementData( v, "playerid" ) == theID) then 
                otherPlayer = v
                break
            end
        end
        if isElement(otherPlayer) then 
            local x, y, z = getElementPosition(thePlayer)
            local px, py, pz = getElementPosition(otherPlayer)
                if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 8 then 
                    cantidad = tonumber(cantidad)
                    --if cantidad > 0 then 
                        --if cantidad < 150001 then 
                            if getPlayerMoney(thePlayer) >= cantidad then 
                                setElementData(otherPlayer, "lastPagoCantidad", cantidad)
                                setElementData(otherPlayer, "lastPagador", thePlayer)
                                setElementData(otherPlayer, "ableToPagarPago", true)
                                setTimer(setElementData, 60000, 1, otherPlayer, "ableToPagarPago", false)
                                chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " intenta pagarle a "..string.gsub(getPlayerName(otherPlayer), "_", " "), 255, 0, 128)
                                outputChatBox("¡Te ha llegado un pago! El valor es de $"..cantidad..".", otherPlayer, 0, 255, 0)
                                outputChatBox("Utiliza /aceptarpago o /rechazarpago para aceptar o rechazar este pago respectivamente. Tienes 1 minuto para aceptarla o se rechazará automáticamente.", otherPlayer, 0, 255, 0)
                            
                            else
                                outputChatBox("No tienes tanto dinero para pagar.", thePlayer, 255, 0, 0)
                            end
                        --else
                          --  outputChatBox("No puedes pagar más de $2500.", thePlayer, 255, 0, 0)
                        --end
                    --else
                        --outputChatBox("No puedes pagar menos de $500.", thePlayer, 255, 0, 0)
                    --end
                else
                    outputChatBox("Estás demasiado lejos de "..getPlayerName(otherPlayer)..".", thePlayer, 255, 0, 0)
                end
        else
            outputChatBox("No se encontró a ningún jugador con la ID "..theID, thePlayer, 255, 0, 0)
        end
    else
        outputChatBox("Sintáxis: /pagar [ID] [Cantidad]", thePlayer, 255, 255, 255)
    end
end)

addCommandHandler("aceptarpago", function(thePlayer, cmd, msg)
    if getElementData(thePlayer, "ableToPagarPago") then 
    if (msg) and ((msg == "1") or (msg == "2")) then 
        if msg == "1" then 
            local theCantidad = getElementData(thePlayer, "lastPagoCantidad")
            local theFacturador = getElementData(thePlayer, "lastPagador")

                if (getPlayerMoney(theFacturador) >= theCantidad) then 

                    setPlayerMoney(thePlayer, (getPlayerMoney(thePlayer)+theCantidad))

                    setPlayerMoney(theFacturador, (getPlayerMoney(theFacturador)-theCantidad))
                    setElementData(thePlayer, "ableToPagarPago", false)
                    outputChatBox("La otra persona ha recibido el pago con éxito.", theFacturador, 0, 255, 0)
                    outputChatBox("Has recibido este pago con éxito.", thePlayer, 0, 255, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(theFacturador), "_", " ").. " toma unos billetes de su cartera y se los entrega a "..string.gsub(getPlayerName(thePlayer), "_", " ")..".", 255, 0, 128)
                else
                    outputChatBox("No tienes suficiente dinero en tu billetera para pagar esta factura.", thePlayer, 255, 0, 0)
                    chatLocal(thePlayer, string.gsub(getPlayerName(theFacturador), "_", " ").. " ha intentado pagar pero no tiene suficiente dinero en la billetera para esto.", 255, 0, 128)
                end

        elseif msg == "2" then
            if getElementData(thePlayer, "moneyInBank") ~= false and getElementData(thePlayer, "moneyInBank") ~= nil then 
                local theCantidad = getElementData(thePlayer, "lastPagoCantidad")
                local theFacturador = getElementData(thePlayer, "lastPagador")
                    setElementData(thePlayer, "moneyInBank", (getElementData(thePlayer, "moneyInBank"))+theCantidad)
                    setPlayerMoney(theFacturador, getPlayerMoney(theFacturador)-theCantidad)
                    outputChatBox("La otra persona ha recibido el pago con éxito.", theFacturador, 0, 255, 0)
                    outputChatBox("Has recibido este pago con éxito en tu cuenta bancaria.", thePlayer, 0, 255, 0)
                    setElementData(thePlayer, "ableToPagarPago", false)
                    chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " utiliza su teléfono para recibir un pago con su cuenta bancaria.", 255, 0, 128)
            else
                outputChatBox("No tienes una cuenta bancaria para recibir este pago.", thePlayer, 255, 0, 0)
            end
        end
    else
        outputChatBox("Sintáxis: /aceptarpago [tipo de pago]", thePlayer, 255, 255, 255)
        outputChatBox("Tipos de pago: 1- Billetera, 2- Banco", thePlayer, 255, 255, 255)
    end
    else
        outputChatBox("No tienes pagos para recibir en este momento..", thePlayer, 255, 0, 0)
    end
end)

addCommandHandler("rechazarpago", function(thePlayer)
    if getElementData(thePlayer, "ableToPagarPago") then 
        local theFacturador = getElementData(thePlayer, "lastPagador")
        setElementData(thePlayer, "ableToPagarPago", false)
        outputChatBox("El otro jugador ha rechazado tu pago.", theFacturador, 255, 0, 0)
        outputChatBox("Rechazaste este pago con éxito.", thePlayer, 0, 255, 0)
        chatLocal(thePlayer, string.gsub(getPlayerName(thePlayer), "_", " ").. " rechaza el pago.", 255, 0, 128)
    else
        outputChatBox("No tienes pagos para recibir en este momento.", thePlayer, 255, 0, 0)
    end
end)