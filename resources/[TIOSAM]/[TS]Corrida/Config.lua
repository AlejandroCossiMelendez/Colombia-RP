--[[
 ______    ______      _____       ____        ______                 
/\__  _\  /\__  _\    /\  __`\    /\  _`\     /\  _  \     /'\_/`\    
\/_/\ \/  \/_/\ \/    \ \ \/\ \   \ \,\L\_\   \ \ \L\ \   /\      \   
   \ \ \     \ \ \     \ \ \ \ \   \/_\__ \    \ \  __ \  \ \ \__\ \  
    \ \ \     \_\ \__   \ \ \_\ \    /\ \L\ \   \ \ \/\ \  \ \ \_/\ \ 
     \ \_\    /\_____\   \ \_____\   \ `\____\   \ \_\ \_\  \ \_\\ \_\
      \/_/    \/_____/    \/_____/    \/_____/    \/_/\/_/   \/_/ \/_/
                                                     
                         » CopyRight © 2025
                 » Meu discord discord.gg/sY5wHR8hW3                                                                          
]]--

ConfigLicense = {
    license = "D2B-9B4-DE8-01F-TIOSAM" -- KEY DO USUARIO
}

config = {

    ["Importantes"] = {   
        ["aclPolicial"] = "Policia"; -- ACL QUE RECEBERA O AVISO DE QUANDO INICIAR UMA CORRIDA	
		["numeroParticipantes"] = 1; -- NUMERO MINIMO DE PARTICIPANTES PARA INICIAR UMA CORRIDA	
        ["tempoCorrida"] = 3; -- TEMPO DA CORRIDA ( EM MINUTOS )
        ["teclaCorrida"] = "e"; -- TECLA PARA ENTRAR NA CORRIDA ( LETRA MINISCULA )
        ["markerInicio"] = 11; -- TAMANHO DO MARKER DE INICIO DA CORRIDA
		["markerCheckpoint"] = 8; -- TAMANHO DO MARKER DO CHECKPOINT DA CORRIDA		
        ["markerFim"] = 8; -- TAMANHO DO MARKER DO FIM DA CORRIDA		
        ["blipCorrida"] = 33; -- ID DO BLIP DO LOCAL DA CORRIDA
        ["blipCheckpoint"] = 53; -- ID DO BLIP DOS CHECKPOINTS CRIADOS NA CORRIDA
        ["blipFim"] = 41; -- ID DO BLIP MARCANDO O FIM DA CORRIDA
        ["codigoCor"] = "#9250ff"; -- CODIGO DA COR DA MENSAGEM ( ATUALMENTE ESTA ROXO )
        ["corDX"] = {['r'] = 146, ['g'] = 80, ['b'] = 255};  -- COR DO DX ( ATUALMENTE ESTA ROXO )
        ["corMarkerInicio"] = {['r'] = 30, ['g'] = 99, ['b'] = 227, ['a'] = 50}; -- COR E OPACIDADE DO MARKER DE INICIO DA CORRIDA 
        ["corMarkerRota"] = {['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 255}; -- COR E OPACIDADE DOS MARKERS DE CHECKPOINTS DA CORRIDA
        ["corMarkerFim"] = {['r'] = 0, ['g'] = 114, ['b'] = 255, ['a'] = 200}; -- COR E OPACIDADE DO MARKER DO FIM DA CORRIDA
    };
	
    ["vinculacaoTicket"] = {   
        ["comTicket"] = false;
        ["itemTicket"] = "Item"; 
        ["pastaInventario"] = "SeuInventario"; 
    };		

    Corridas = {
        [1] = {
            nome = 'Desagues Fluviales', -- NOME DA CORRIDA
 
            inicio = {2603.568359375, -1503.861328125, 15.830095291138 - 1}, -- MARKER DE INICIO DA CORRIDA
 
            markers = { -- MARKER DOS CHECKPOINTS
                {2584.8720703125, -1587.056640625, 4.6371068954468}, 
                {2569.5166015625, -1757.2509765625, 1.3515703678131}, 
                {2490.974609375, -1849.2041015625, 1.5526261329651}, 
                {2198.5400390625, -1851.1943359375, 1.8441749811172}, 
                {1935.9765625, -1839.8701171875, 3.6951818466187}, 
                {1619.509765625, -1763.4208984375, 3.6651847362518}, 
                {1397.58203125, -1715.7548828125, 7.5668392181396}, 
                {1360.3662109375, -1611.251953125, 8.3255405426025}, 
                {1401.357421875, -1454.369140625, 8.387113571167}, 
                {1409.0146484375, -1312.7783203125, 8.8319597244263}, 
                {1391.5390625, -1488.73046875, 8.3826513290405}, 
                {1383.1923828125, -1518.0693359375, 8.386528968811}, 
                {1366.69921875, -1707.9150390625, 8.5067558288574}, 
                {1620.16796875, -1763.8564453125, 3.6673362255096}, 
                {1910.8330078125, -1835.396484375, 3.6981294155121}, 
                {2061.55078125, -1851.57421875, 3.7021145820618}, 
                {2297.6787109375, -1851.41796875, -0.42656582593918}, 
                {2543.08984375, -1850.9736328125, 3.2248558998108}, 
                {2596.51171875, -1747.630859375, 1.3579255342484},  
            }, 

            fim = {2603.9873046875, -1515.76171875, 14.536884307861 - 1}, -- MARKER DO FIM DA CORRIDA
        },
		
        [2] = {
            nome = 'Estadio', -- NOME DA CORRIDA
  
            inicio = {2779.772, -1849.406, 9.793 - 1}, -- MARKER DE INICIO DA CORRIDA
  
            markers = { -- MARKER DOS CHECKPOINTS
                {2809.51, -1849.066, 10.245}, 
                {2831.654, -1771.733, 10.875}, 
                {2847.324, -1691.24, 10.883}, 
                {2828.793, -1657.383, 10.695}, 
                {2763.317, -1658.045, 11.761}, 
                {2722.582, -1638.639, 12.912}, 
                {2699.428, -1610.68, 13.879}, 
                {2586.864, -1603.464, 19.241}, 
                {2482.7, -1603.587, 16.298}, 
                {2408.275, -1586.86, 14.795}, 
                {2351.291, -1564.237, 23.844}, 
                {2331.758, -1484.403, 23.446},  
                {2309.641, -1483.977, 23.39}, 
                {2236.23, -1484.103, 23.559}, 
                {2212.601, -1471.377, 23.828}, 
                {2212.438, -1402.384, 23.822}, 
                {2175.658, -1384.313, 23.828}, 
                {2090.145, -1384.252, 23.827}, 
                {2069.394, -1346.314, 23.82}, 
                {2055.275, -1261.14, 23.464}, 
                {2027.895, -1260.767, 23.82}, 
                {1969.494, -1260.632, 23.82}, 
                {1906.812, -1260.796, 13.457}, 
                {1850.421, -1261.009, 13.457}, 
                {1794.817, -1271.687, 13.469}, 
                {1729.089, -1300.515, 13.412}, 
                {1658.327, -1300.852, 14.562}, 

            }, 

            fim = {1548.275, -1300.29, 15.957 - 1}, -- MARKER DO FIM DA CORRIDA
        }, 		
		
        [3] = {
            nome = 'Aeroporto SF', -- NOME DA CORRIDA

            inicio = {-1652.291, -537.077, 11.359 - 1}, -- MARKER DE INICIO DA CORRIDA
            
            markers = { -- MARKER DOS CHECKPOINTS
                {-1717.961, -579.047, 15.992}, 
                {-1796.63, -579.896, 16.15}, 
                {-1822.054, -536.673, 15.196}, 
                {-1817.712, -427.252, 14.961}, 
                {-1800.486, -315.242, 24.759}, 
                {-1799.137, -224.002, 17.991}, 
                {-1799.141, -116.57, 5.506}, 
                {-1799.157, -33.486, 15.141}, 
                {-1807.658, 117.122, 14.961}, 
                {-1808.45, 227.419, 14.954}, 
                {-1751.445, 301.646, 7.038}, 
                {-1651.724, 401.232, 7.031}, 
                {-1570.37, 486.248, 7.031}, 
                {-1558.875, 607.431, 7.039}, 
                {-1546.372, 735.489, 7.032}, 
                {-1533.741, 849.039, 7.039}, 
                {-1529.698, 948.266, 7.039}, 
                {-1578.215, 1019.006, 7.039}, 
                {-1585.144, 1165.702, 7.047}, 
                {-1633.417, 1246.424, 7.039}, 
                {-1736.69, 1349.51, 7.039}, 
                {-1859.083, 1366.145, 7.039}, 
                {-1939.593, 1308.939, 7.039}, 
                {-2052.712, 1285.69, 7.302}, 
                {-2186.529, 1270.964, 30.668}, 
                {-2269.373, 1237.921, 45.73}, 
                {-2281.122, 1176.406, 55.41}, 
                {-2362.292, 1176.481, 41.185}, 
                {-2445.739, 1192.945, 35.016}, 
                {-2510.256, 1186.489, 40.081}, 
                {-2607.832, 1210.801, 52.578}, 
                {-2664.609, 1212.666, 55.43}, 
                {-2673.194, 1321.805, 55.43}, 
                {-2673.971, 1466.779, 55.626}, 
                {-2673.92, 1583.397, 63.468}, 
                {-2673.933, 1679.006, 67.05}, 
                {-2673.857, 1829.924, 67.48}, 
                {-2673.881, 1988.254, 61.029}, 
                {-2673.94, 2130.211, 55.422}, 
                {-2698.307, 2252.987, 55.507}, 
                {-2735.501, 2345.324, 71.811}, 
                {-2729.087, 2492.828, 76.584}, 
                {-2657.25, 2587.632, 74.026}, 


            }, 

            fim = {-2509.766, 2621.216, 56.752 - 1}, -- MARKER DO FIM DA CORRIDA
        }, 	
		
    }, 
}

function money(player, moneycorrida)
    return exports.players:giveMoney(player, moneycorrida) -- CASO QUEIRA QUE SEJA GANHO DINHEIRO LIMPO AO FINALIZAR A CORRIDA
    --return exports["SeuInventario"]:givemItem(player, "Dinheiro Sujo", moneycorrida)
end

function getItemInv(player)
    return exports[config['vinculacaoTicket']['pastaInventario']]:getItem(player, config['vinculacaoTicket']['itemTicket']) or 0 
end 

function takeItemInv(player)
    return exports[config['vinculacaoTicket']['pastaInventario']]:takeItem(player, config['vinculacaoTicket']['itemTicket'], 1) 
end 

function message(player, text, type) 
    exports['dxmessages']:addBox(player, text, type) -- EXPORTS DA SUA INFOBOX
end