local gates = {
    -- Puertas CABES (Comando: /cabepuertas)
    --cabe = {
      --  {971, 1245.1927490234, -738.0693359375, 97.35807800293, 0, 0, 26, 1245.1927490234, -738.0693359375, 88.533081054688},
        --{971, 1237.2923583984, -741.96936035156, 97.35807800293, 0, 0, 25.999145507812, 1237.2923583984, -741.96936035156, 88.533081054688},
        --{971, 1359.9423828125, -843.25933837891, 47.163082122803, 0, 0, 75.999145507812, 1359.9423828125, -843.25933837891, 39.838081359863}
    --},

    -- Puertas HERBER (Comando: /herberpuertas)
    herber = {
        {971, 1083.8422851562, -777.05194091797, 108.97743988037, 0, 0, 10.749145507812, 1083.8422851562, -777.05194091797, 101.35243988037},
        {971, 1075.1428222656, -778.70178222656, 108.97743988037, 0, 0, 10.74462890625, 1075.1428222656, -778.70178222656, 101.32743835449}
    },

    -- Puertas EJERCITO (Comando: /ejercitopuertas)
    ejercito = {
        {971, 162.10000610352, -1789, 6.9000000953674, 0, 0, 90, 162.10000610352, -1789, -1.1000000238419},
        {971, 162.10000610352, -1780.1999511719, 6.90000000953674, 0, 0, 90, 162.10000610352, -1780.1999511719, -1.1000000238419}
    },

    -- Puerta FABIA (Comando: /fabiapuertas)
    fabian = {
        {980, 1389.4000244141, 32.700000762939, 31.700000762939, 0, 0, 38.25, 1389.4000244141, 32.700000762939, 25.5}
    },

    -- Puerta CDM 1 (Comando: /cdmpuerta1)
    cdmpuerta1 = {
        {980, -1259.5, -1369.3000488281, 121.59999847412, 0, 354.92980957031, 17.75, -1259.5, -1369.3000488281, 115.69999694824}
    },

    -- Puerta CDM 2 (Comando: /cdmpuerta2)
    cdmpuerta2 = {
        {980, -1400.4000244141, -1474.0999755859, 103.59999847412, 0, 0, 90, -1400.4000244141, -1474.0999755859, 97.5}
    }
}

local createdGates = {}

function createGates()
    for group, gateList in pairs(gates) do
        createdGates[group] = {}
        for i, gate in ipairs(gateList) do
            local obj = createObject(gate[1], gate[2], gate[3], gate[4], gate[5], gate[6], gate[7])
            if obj then
                createdGates[group][obj] = {
                    closed = {gate[2], gate[3], gate[4]},
                    open = {gate[8], gate[9], gate[10]},
                    state = "closed"
                }
            end
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, createGates)

function toggleGate(player, command, group)
    if createdGates[group] then
        for obj, data in pairs(createdGates[group]) do
            if data.state == "closed" then
                moveObject(obj, 2000, unpack(data.open))
                data.state = "open"

                setTimer(function()
                    if data.state == "open" then
                        moveObject(obj, 2000, unpack(data.closed))
                        data.state = "closed"
                    end
                end, 7000, 1)
            end
        end
        outputChatBox("Las puertas de " .. group .. " se abrirán y se cerrarán en 7 segundos", player, 0, 255, 0)
    else
        outputChatBox("Ese grupo de puertas no existe", player, 255, 0, 0)
    end
end

--addCommandHandler("cabepuertas", function(player) toggleGate(player, "cabepuertas", "cabe") end)
addCommandHandler("herberpuertas", function(player) toggleGate(player, "herberpuertas", "herber") end)
addCommandHandler("ejercitopuertas", function(player) toggleGate(player, "ejercitopuertas", "ejercito") end)
addCommandHandler("fabianpuertas", function(player) toggleGate(player, "fabianpuertas", "fabian") end)
addCommandHandler("cdmpuerta1", function(player) toggleGate(player, "cdmpuerta1", "cdmpuerta1") end)
addCommandHandler("cdmpuerta2", function(player) toggleGate(player, "cdmpuerta2", "cdmpuerta2") end)
