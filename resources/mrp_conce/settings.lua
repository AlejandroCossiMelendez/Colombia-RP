local VEHICLES = { -- Tabla para los vehiculos de cada concesionario
	{ -- Concesionario de Los Santos (ID 1)
		data = {
			{
				name = "Aston Martin", -- Nombre del vehiculo
				model = 429, -- Modelo del vehiculo
				price = 120000000, -- Precio del vehiculo
				stock = 100, -- Stock del vehiculo
			},
			{
				name = "Audi", -- Nombre del vehiculo
				model = 546, -- Modelo del vehiculo
				price = 85000000, -- Precio del vehiculo
				stock = 100, -- Stock del vehiculo
			},
			{
				name = "Bentley", -- Nombre del vehiculo
				model = 517, -- Modelo del vehiculo
				price = 35000000, -- Precio del vehiculo
				stock = 100, -- Stock del vehiculo
			},
			{
				name = "Porsche Boxters GT5", -- Nombre del vehiculo
				model = 480, -- Modelo del vehiculo
				price = 135000000, -- Precio del vehiculo
				stock = 100, -- Stock del vehiculo
			},
			{
				name = "Cadillac Escalade", -- Nombre del vehiculo
				model = 566, -- Modelo del vehiculo
				price = 230000000, -- Precio del vehiculo
				stock = 50, -- Stock del vehiculo
			},
			{
				name = "Corvette", -- Nombre del vehiculo
				model = 516, -- Modelo del vehiculo
				price = 150000000, -- Precio del vehiculo
				stock = 100, -- Stock del vehiculo
			},
			{
				name = "Toyota LandCruiser", -- Nombre del vehiculo
				model = 580, -- Modelo del vehiculo
				price = 210000000, -- Precio del vehiculo
				stock = 50, -- Stock del vehiculo
			},
			{
				name = "Dodge",
				model = 551,
				price = 60000000,
				stock = 100,
			},
			{
				name = "Chevrolet Duster",
				model = 565,
				price = 50000000,
				stock = 100,
			},
			{
				name = "Ford Raptor",
				model = 479,
				price = 270000000,
				stock = 50,
			},
			{
				name = "Toyota LandCruiser 2",
				model = 540,
				price = 180000000,
				stock = 100,
			},
			{
				name = "Toyota LandCruiser 3 V8",
				model = 579,
				price = 260000000,
				stock = 50,
			},
			{
				name = "Mazda CX-90",
				model = 404,
				price = 75000000,
				stock = 100,
			},
			{
				name = "Mclaren",
				model = 550,
				price = 120000000,
				stock = 100,
			},
			{
				name = "Mustang GT",
				model = 402,
				price = 85000000,
				stock = 100,
			},
			{
				name = "Nissan GTR",
				model = 541,
				price = 140000000,
				stock = 100,
			},
			{
				name = "Porsche",
				model = 547,
				price = 100000000,
				stock = 100,
			},
			{
				name = "Sultan",
				model = 560,
				price = 135000000,
				stock = 50,
			},
			{
				name = "Vans",
				model = 482,
				price = 400000000,
				stock = 20,
							{
				name = "BMW",
				model = 426,
				price = 75000000,
				stock = 10,
			},
			},
						{
				name = "BMW M3",
				model = 558,
				price = 95000000,
				stock = 100,
			},
			{
				name = "Moto BMW S1000",
				model = 522,
				price = 85000000,
				stock = 100,
			},
			{
				name = "MOTO MT10 VIP",
				model = 461,
				price = 9999999999,
				stock = 50,
			},
			{
				name = "MOTO NMAX",
				model = 462,
				price = 25000000,
				stock = 100,
			},
			{
				name = "MOTO Kawasaki z100",
				model = 477,
				price = 90000000,
				stock = 100,
			},
			{
				name = "MOTO Honda X-ADV",
				model = 586,
				price = 70000000,
				stock = 100,
			},
			{
				name = "Bugatti VIP",
				model = 475,
				price = 9999999999,
				stock = 20,
			},
			{
				name = "Cupra Formentor VIP",
				model = 561,
				price = 9999999999,
				stock = 20,
			},
			{
				name = "Ferrari GTB VIP",
				model = 411,
				price = 9999999999,
				stock = 20,
			},
						{
				name = "G-WA VIP",
				model = 490,
				price = 9999999999,
				stock = 20,
			},
						{
				name = "LAMBORGHINI VIP",
				model = 559,
				price = 9999999999,
				stock = 20,
			},
			{
				name = "TUNDRA VIP",
				model = 492,
				price = 9999999999,
				stock = 20,
			},
			{
				name = "CYBERTRUCK EXCLUSIVO NO VIP",
				model = 604,
				price = 9999999999,
				stock = 10,
			},
			{
				name = "HURACAN EXCLUSIVO",
				model = 502,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "JESKO EXCLUSIVO",
				model = 477,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "KOENISEGG GEMERA EXCLUSIVO",
				model = 542,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "BMW M3 EXCLUSIVO",
				model = 415,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "MCLAREN EXCLUSIVO",
				model = 555,
				price = 99999999999,
				stock = 10,
			},
		{
				name = "PAGANI EXCLUSIVO",
				model = 494,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "SKYLINE EXCLUSIVO",
				model = 562,
				price = 99999999999,
				stock = 10,
			},
			{
				name = "TAYCAN EXCLUSIVO",
				model = 602,
				price = 99999999999,
				stock = 10,
			},
		
			
		},
	},
	-- Aquí pueden añadir más vehiculos para otros concesionarios
	-- Ejemplo:
	-- { -- Concesionario de San Fierro (ID 2)
	-- 	data = {
	-- 		{
	-- 			name = "Elegy",
	-- 			model = 562,
	-- 			price = 10000,
	-- 			stock = 10,
	-- 		},
	-- },
}

settings = {
	zoom = { -- Nivel de zoom de la cámara al previsualizar el vehiculo
		min = 5, -- Zoom mínimo
		max = 10, -- Zoom máximo
		default = 10, -- Zoom por defecto
	},
	conces = { -- Tabla de concesionarios
		{
			id = 1, -- ID del concesionario
			name = "Concesionario La Capital RP", -- Nombre del concesionario
			marker = { -- Marker para el concesionario
				position = { 1754.646484375, -1110.568359375, 25.079999923706 }, -- Posición del marker
				type = "cylinder", -- Tipo de marker
				size = 1, -- Tamaño del marker
				color = { 255, 144, 164, 1 }, -- Color del marker
				interior = 0, -- Interior del marker
				dimension = 0, -- Dimensión del marker
			},
			vehicle = { -- Posición dónde aparecerá el vehiculo para previsualizar
				position = { 1706.71, -1128.58, 25.1895 }, -- Posición del vehiculo
				rotation = 269.154, -- Rotación del vehiculo
				interior = 0, -- Interior del vehiculo
				dimension = 0, -- Dimensión del vehiculo
			},
			vehicles = VEHICLES[1].data, -- Tabla de vehiculos del concesionario
			vehicle_test = { -- Posición dónde podrán hacer la prueba del vehiculo
				position = { 1547.79, -1014.22, 23.618 },
				rotation = 261.65,
				time = 10, -- Tiempo de prueba del vehiculo (en segundos)
			},
			vehicle_spawn = { -- Posición dónde aparecerá el vehiculo una vez comprado
				position = { 1811.57, -1150.88, 23.588 }, -- Posición del vehiculo
				rotation = 125.942, -- Rotación del vehiculo
			},
		},
		-- Aquí pueden añadir más concesionarios
		-- Ejemplo:
		-- {
		-- 	id = 2,
		-- 	name = "Concesionario de San Fierro",
		-- 	marker = {
		-- 		position = { 0, 0, 0 },
		-- 		type = "cylinder",
		-- 		size = 1,
		-- 		color = { 0, 0, 0, 0 },
		-- 		interior = 0,
		-- 		dimension = 0,
		-- 	},
		-- 	vehicle = {
		-- 		position = { 0, 0, 0 },
		-- 		rotation = { 0, 0, 0 },
		-- 		interior = 0,
		-- 		dimension = 0,
		-- 	},
		-- 	vehicles = VEHICLES[2].data,
		-- 	vehicle_test = {
		-- 		position = { 0, 0, 0 },
		-- 		rotation = { 0, 0, 0 },
		-- 		time = 30,
		-- 	},
		-- 	vehicle_spawn = {
		-- 		position = { 0, 0, 0 },
		-- 		rotation = { 0, 0, 0 },
		-- 	},
		-- },
	},
}