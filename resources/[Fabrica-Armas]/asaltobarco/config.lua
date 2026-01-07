CONFIG = {
    MARKER = {
        x = 358.97247314453,
        y = 2548.6342773438,
        z = 24.542186737061,
        interior = 10,
        dimension = 14,
        color = {r = 255, g = 0, b = 0, a = 100}
    },
    TIEMPOS = {
        HACKEO = 180000, -- 3 minutos
        COOLDOWN = 2100000, -- 35 minutos
        SONIDO_DURACION = 11000 -- 11 segundos
    },
    SONIDO = {
        MIN_DISTANCIA = 10,
        MAX_DISTANCIA = 30,
        VOLUMEN = 0.5
    },
    FACCIONES = {
        ILEGALES = {5, 10, 11, 12},
        POLICIA = 1,
        EJERCITO = 4,
        MIN_POLICIAS = 3,
        MIN_ILEGALES = 3
    },
    ITEMS = {
        PORTATIL = {id = 91, nombre = "Portátil de Hackeo"},
        USB = {id = 92, nombre = "USB de Hackeo"}
    },
    RECOMPENSAS = {
        ARMAS = {
            {id = 29, data = "30", nombre = "Ak-47", cantidad = 5},
            {id = 29, data = "32", nombre = "Tec-9", cantidad = 5},
            {id = 29, data = "22", nombre = "Colt-45", cantidad = 5}
        },
        CARGADORES = {
            {id = 43, data = "22", nombre = "Cargador Colt-45", balas = 12, cantidad = 3},
            {id = 43, data = "30", nombre = "Cargador ak-47", balas = 30, cantidad = 3},
            {id = 43, data = "32", nombre = "Cargador Tec-9", balas = 35, cantidad = 3}
        }
    }
}