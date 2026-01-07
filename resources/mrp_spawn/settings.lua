settings = {
    spawns = { -- Posiciones de las previsualizaciones de spawn
        {
            name = "Manrique", -- Nombre de la localización
            fov = 70, -- Campo de visión de la cámara
            height = 5, -- Altura de la cámara
            position = {  2743.685546875, -8.1376953125, 71.262588500977 }, -- Posición de la cámara
        },
        {
            name = "El Poblado",
            fov = 70,
            height = 5,
            position = { 657.76171875, -1198.4794921875, 64.029502868652 },
        },
        {
            name = "Laureles",
            fov = 70,
            height = 5,
            position = { 2062.73046875, -1864.7822265625, 45.383205413818 },
        }
    },
    -- Spawn inicial para personajes nuevos (Ayuntamiento/Inicio)
    initial_spawn = {
        name = "Aeropuerto",
        fov = 70,
        height = 5,
        position = { 1705.6563720703, -2286.40234375, 13.3776903152474 },
        interior = 0,
        dimension = 0,
    },
	notify_c = function(msg, icon)
		return exports["mrp_notify"]:AddNotify("Spawn", msg, icon)
	end,
	notify_s = function(player, msg, icon)
		return exports["mrp_notify"]:AddNotify(player, "Spawn", msg, icon)
	end,
}