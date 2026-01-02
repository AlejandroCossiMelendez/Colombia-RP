--[[
⠄⠄⠄⠄⠄⠄⠄⢠⣶⡆⠄⣶⣶⣶⡆⢰⣶⣶⡄⣶⡆⣶⡆⠄⣶⣶⠄⠄⢰⣶⡆⢰⣶⡆⣶⣶⣶⠄⣶⣆⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄ 
⠄⠄⠄⠄⠄⠄⠄⢸⣿⣇⠄⣿⡇⢸⡇⢸⣿⠄⠄⣿⣷⣿⡇⠄⣿⣿⠄⠄⢸⣿⣧⣼⣿⡇⢸⣿⠄⢰⣿⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄ 
⠄⠄⠄⠄⠄⠄⠄⣾⡿⣿⠄⣿⣧⣼⡇⢸⣿⣿⠄⣿⣿⣿⡇⢸⡿⣿⡇⠄⢸⣿⣿⣿⣿⡇⢸⣿⠄⢸⡏⣿⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄ 
⠄⠄⠄⠄⠄⠄⢀⣿⣥⣿⡄⣿⡟⣿⡁⢸⣿⣀⠄⣿⢹⣿⡇⣼⣧⣼⣇⠄⢸⣿⠸⠇⣿⡇⢸⣿⠄⣿⣧⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄ 
⠄⠄⠄⠄⠄⠄⠸⠿⠉⠿⠇⠿⠇⠻⠧⠸⠿⠿⠄⠿⠄⠿⠇⠿⠏⠹⠿⠄⠸⠿⠄⠄⠿⠇⠸⠿⠄⠿⠉⠹⠧⠄⠄⠄⠄⠄⠄⠄⠄⠄
--]]

--[[ 

    Caso utilize inventário, use esse evento para ativar/desativar o rádio

    Para server = triggerEvent("TS:ativeRadio", source, source, state ( true ou false ))
    Para client = triggerServerEvent("TS:ativeRadio", localPlayer, localPlayer, state ( true ou false ))

--]]

config = {
    ["Configuração Geral"] = {
        inventory = false,
        commandRadio = "radio", -- Comando para ativar/desativar rádio ( Só funciona se estiver sem inventário )
        commandRadioFrequencia = "radiof", -- Comando para alterar a frequência
        modelID = 2710,
        posModel = { 32, -0.04, -0.05, -0.05, -90, 0 ,-180 },
        distanceSound = 2,
    },
    ["Frequências"] = {
        [190] = "Policia", --- [ Freq ] = ACL
    },
    ["Shop"] = {
        ["Products"] = { -- Maximo 5
            {productName = "Rádio", price = 1000, itemID = "Radio"}, --- Nome do Produto, Preço, id do item ( se tiver inventário )
        },
        ["Markers"] = {
            { x = 1243.142578125, y = 204.7587890625, z = 19.645431518555, size = 1.2, blip = 46,color = {15, 200, 10, 100}}
        },
    },
    ["Functions"] = {
        ["giveItem"] = function(thePlayer, itemID)
            exports["n3xt_inventario"]:giveItem(thePlayer,itemID,1)
        end,
        ["getItem"] = function(thePlayer, itemID)
            return exports["n3xt_inventario"]:getItem(thePlayer,itemID) -- Retorna valor boleano ( true ou false )
        end,
        ["takeMoney"] = function(thePlayer, price)
            if getPlayerMoney(thePlayer) >= tonumber(price) then
                takePlayerMoney(thePlayer, tonumber(price))
                return true
            else
                return false
            end
        end,
        ["sendMessage"] = function(thePlayer, msg, info, type)
            if type == "client" then
                triggerEvent("serverNotifys2", thePlayer, thePlayer, msg, info)
            elseif type == "server" then
                triggerClientEvent(thePlayer, "serverNotifys2", thePlayer, msg, info)
            end
        end,
    }
}