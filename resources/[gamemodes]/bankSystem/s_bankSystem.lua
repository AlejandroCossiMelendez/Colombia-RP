local ATMTable = {}
function cargarATM()
    local ATM = executeSQLQuery("SELECT * FROM bankPos")
    if ATM then 
        for i, v in ipairs (ATM) do 
            local x, y, z, rz = ATM[i].x, ATM[i].y, ATM[i].z, ATM[i].rz 
            local theATM = createObject(2942, x, y, z, 0, 0, rz)
            setElementData(theATM, "ID", ATM[i].ID)
            table.insert(ATMTable, theATM)
        end
        triggerClientEvent("returnATM", root, ATMTable, true)
    else
        outputDebugString("No se pudo cargar los ATM", 3, 255, 0, 0)
    end
end
addEventHandler("onResourceStart", resourceRoot, function()
    for i, v in ipairs (getElementsByType('player')) do 
        local accName = getElementData(v, "characterID")
       if accName then 
        local moneyinAcc = executeSQLQuery("SELECT * FROM bankStat WHERE account = ?", accName)
        if #moneyinAcc > 0 then 
            setElementData(v, "moneyInBank", tonumber(moneyinAcc[1].money))
        else
            setElementData(v, "moneyInBank", false)
        end
       end
    end
    cargarATM()
end)



addEvent("requestATM", true)
addEventHandler("requestATM", root, function()
    triggerClientEvent(source, "returnATM", source, ATMTable)
end)
addCommandHandler("showCharID", function(thePlayer)
    outputChatBox(getElementData(thePlayer, "characterID"), thePlayer)
end)

addCommandHandler("showM", function(thePlayer)
    outputChatBox(tostring(getElementData(thePlayer, "moneyInBank")), thePlayer)
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

--[[addEventHandler("onResourceStop", resourceRoot, function()
    for i, v in ipairs (getElementsByType('player')) do 
        local accName = getElementData(v, "characterID")
        local moneyInAcc = getElementData(v, "moneyInBank")
        if moneyInAcc then 
            executeSQLQuery("UPDATE bankStat SET money = ? WHERE account = ?", moneyInAcc, accName)
        end
    end
end)]]

addEvent("onCharacterLoginBank", true)
addEventHandler("onCharacterLoginBank", root, function()
    local accName = getElementData(source, "characterID")
    local moneyinAcc = executeSQLQuery("SELECT * FROM bankStat WHERE account = ?", accName)
        if accName then 
            if #moneyinAcc > 0 then 
                setElementData(source, "moneyInBank", tonumber(moneyinAcc[1].money))
            else
                setElementData(source, "moneyInBank", false)
            end
        end
end)
addEvent("onCharacterLogoutBank", true)
addEventHandler("onCharacterLogoutBank", root, function()
    local moneyInAcc = getElementData(source, "moneyInBank")
    if moneyInAcc then
        local accName = getElementData(source, "characterID")
        executeSQLQuery("UPDATE bankStat SET money = ? WHERE account = ?", moneyInAcc, accName)
    end
    setElementData(source, "moneyInBank", false)
end)

addEvent("retirarDinero", true)
addEventHandler("retirarDinero", root, function(money)
    setPlayerMoney(source, (getPlayerMoney(source)+money))
    setElementData(source, "moneyInBank", (getElementData(source, "moneyInBank")-money))
    chatLocal(source, string.gsub(getPlayerName(source), "_", " ").. " retira dinero del cajero.", 255, 0, 128)
end)

addEvent("comprarTarjeta", true)
addEventHandler("comprarTarjeta", root, function()
local money = getPlayerMoney(source)
    if (money == 200) or (money > 200) then 
        local createAcc = executeSQLQuery("INSERT INTO bankStat(account, money) VALUES(?,?)", getElementData(source, "characterID"), 0)
        setPlayerMoney(source, getPlayerMoney(source)-200)
        setElementData(source, "moneyInBank", 0)
        outputChatBox("[CAJERO] Has comprado una tarjeta para el banco. Ahora puedes acceder al sistema.", source, 0, 255, 0)
        chatLocal(source, string.gsub(getPlayerName(source), "_", " ").. " compró una tarjeta para el banco.", 255, 0, 128)
    end
end)

addEvent("ingresarDinero", true)
addEventHandler("ingresarDinero", root, function(money)
    setPlayerMoney(source, (getPlayerMoney(source)-money))
    setElementData(source, "moneyInBank", (getElementData(source, "moneyInBank")+money))
    chatLocal(source, string.gsub(getPlayerName(source), "_", " ").. " ingresa dinero a su cuenta bancaria..", 255, 0, 128)
end)

addCommandHandler("crearatm", function(thePlayer)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Desarrollador")) then 
        local x, y, z = getElementPosition(thePlayer)
        local rx, ry, rz = getElementRotation(thePlayer)
        local insert = executeSQLQuery("INSERT INTO bankPos(x, y, z, rz) VALUES(?,?,?,?)", x, y, z-0.2, rz)
        if insert then 
            outputChatBox("ATM creado con éxito. Utiliza /refreshatm para actualizar.", thePlayer, 0, 255, 0)
        else
            outputChatBox("Hubo un error al crear este ATM.", thePlayer, 255, 0, 0)
        end
    end
end)

addCommandHandler("borraratm", function (thePlayer, msg, id)
    local check = executeSQLQuery("SELECT * FROM bankPos WHERE ID = ?", tonumber(id))
    if #check > 0 then 
        local delete = executeSQLQuery("DELETE FROM bankPos WHERE ID = ?", tonumber(id))
        if delete then 
            outputChatBox("Se ha eliminado el ATM especificado. Utiliza /refresh para actualizar.", thePlayer, 0, 255, 0)
        else
            outputChatBox("Ha ocurrido un error al eliminar el ATM especificado", thePlayer, 255, 0, 0)
        end
    else
        outputChatBox("Este ATM no existe.", thePlayer, 255, 0, 0)
    end
end)

addCommandHandler("refreshatm", function(thePlayer)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Desarrollador")) then 
        for i, v in ipairs (ATMTable) do 
            table.remove(ATMTable, i)
            destroyElement(v)
        end
        cargarATM()
        outputChatBox("Se han refrescado los ATM", thePlayer, 0, 255, 0)
    end
end)

addCommandHandler("veratms", function(thePlayer)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Desarrollador")) then 
        triggerClientEvent(thePlayer, "verATM", thePlayer)
    end
end)