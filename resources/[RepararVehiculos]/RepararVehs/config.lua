checkpointsConfig = { -- Configurar checkpoints para saber donde repara
	--{ pos = {x, y, z -1}, rgb = {r, g, b, x}, size = tamaño, tipo = "cylinder"};
	
	--{ pos = {64.1455078125, -193.9091796875, 1.6406593322754 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
        { pos = {1406.505859375, 455.3818359375, 20.21217918396 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
        { pos = {2256.115234375, -86.757225036621, 26.331750869751 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
        { pos = {665.1240234375, -547.21484375, 16.3359375 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
		{ pos = {-255.69062805176, 992.24041748047, 19.668750762939 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
		{ pos = {-186.2216796875, -305.17578125, 1.915815114975 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --RHUGOBOSS
		{ pos = {2023.1488037109, -58.649803161621, 30.446750640869 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --PEPSI
		--{ pos = {-1103.5146484375, -69.3359375, 6.1687498092651 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --CARTELDEMEDELLIN
		{ pos = {-913.279296875, -535.107421875, 25.953638076782 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --LATERRAZA
		{ pos = {1032.52734375, -317.380859375, 73.9921875 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --LASFARC
		{ pos = {2286.2111816406, -765.13787841797, 131.11891174316 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"}; --CARTELDECALI
		{ pos = {-545.2255859375, 2616.3994140625, 53.515625 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};
		{ pos = {-320.8720703125, 421.60000610352, 16.116580963135 - 1}, rgb = {255, 0, 0, 150}, size = 3.5, tipo = "cylinder"};--CLANDELGOLFO
	-- ESTOS SON TODOS LOS SPRITES DE REPARACION Y PUNTOS QUE HAY EN TODO SAN ANDREAS SI QUIERES AGREGA MÁS
};


config = {
    ValorReparo = { 
        Valor = 1400000, -- Valor de reparacion
    },
	
	
	PresupuestoMeca = { 
        Valor = 1000000, -- Cada reparación le sumara lo que pongas ahí a la faccion 3 (que es meca por defecto)
    },
	
	
	wait = { 
        waitTime = 2000, -- Tiempo de espera antes de la reparación en milisegundos
    },
	
	
	cooldown = { 
        cooldownTime = 2000, -- Tiempo de cooldown para volver a usar el punto.
    },	
	
	VehiculosExentos = {416, 433, 427, 490, 528, 407, 544, 523, 470, 596, 598, 599, 597, 432, 601, 428, 413, 459, 414}, --Agrega todos los carros que quieres que NO se le cobre a la hora de reparar
}


---  AUTORES: MonsalveGod, JuanCo
---  Discord DT SHOP: https://discord.gg/nwBBpkdcyY