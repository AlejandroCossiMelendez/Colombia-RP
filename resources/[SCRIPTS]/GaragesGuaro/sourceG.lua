configPanelVehs = {
    ["Key User"] = {
        keyUser = "K7u05ED5VKDCDv5zH8mWglNtUt4c886S",
    },

    ["General"] = {
        costoSacarVeh = 150000,
        comandoGuardar = "eliminarVehiculos",
        colorMarkets = {240, 240, 21, 100},
    },

    ["Posiciones Garajes"] = {
        poscionesGarajes = {
            {-1981.837890625, 275.1875, 34.974460601807},
            {174.03161621094, 310.69815063477, 2.2133922576904},
            {1126.6904296875, 1126.4853515625, 10.820344924927},
            {1547.1796875, 695.7001953125, 10.8203125},
            {2170.990234375, 1665.595703125, 10.8203125},
            {2154.2109375, 2350.5163574219, 10.671862602234}, -- SURA
            {1742.8486328125, -1720.9326171875, 13.546875}, -- ESTACION CALI
            {-1998.10546875, 119.2763671875, 27.6875}, -- ESTACION BOGOTA
            {2032.38671875, 961.9912109375, 10.468893051147}, -- ESTACION MEDELLIN
            {1057.1455078125, -1032.224609375, 31.816188812256}, -- MECA
            {2006.375, 1157.7236328125, 10.984312057495}, -- CASINO
            {2301.001953125, -75.3583984375, 26.484375},
            {1233.5751953125, -1461.4658203125, 13.75156211853},-- GARAGE ALADO DE HOSPITAL
            {1921.5322265625, -2088.6726074219, 13.958974838257},-- GARAGE ALADO DE AEROPUERTO
            {1804.1162109375, -1133.5771484375, 23.876874923706},-- GARAGE DE CONCE
            {1694.0665283203, -2277.75, 13.377690315247},-- GARAGE DE Aeropuerto
            {1561.1917724609, -1703.2470703125, 13.558982849121},-- GARAGE PD 
            {1231.5576171875, -1304.7880859375, 13.360502243042},-- GARAGE DENTRO DE HOSPITAL
            {840.9150390625, -1758.787109375, 13.551250457764},-- GARAGE FARMACIA
            {1055.8894042969, -932.71923828125, 42.806903839111},-- GARAGE GASOLINERA POS31
            {1843.4814453125, -1721.9443359375, 13.556212425232},-- GARAGE parque secundario
            {181.90351867676, -1830.9896240234, 4.9337682723999},-- GARAGE EJERCITO   
            {991.59509277344, -1583.7138671875, 13.546924591064},-- Garage Ropas
            {2915.2436523438, -1950.6721191406, 13.207813262939}, -- GARAGE ELN
            {2508.7368164062, -1554.4154052734, 26.10781288147}, -- GARAGE CDG
            {2198.1413574219, -1333.8829345703, 26.026182174683} -- GARAGE CDJ
        }
    },

    ["Configurar Imagen Markets"] = {
        fixedSize = 80, -- Tamaño base del icono (aún más pequeño)
        maxRenderDistance = 50, -- Distancia maxima para renderizar
        offsetZ = 1, -- Altura sobre el marker en el mundo (más bajo)
        screenOffsetY = 16, -- Desplazamiento vertical extra en pantalla (más abajo)
    },

    ["Configuracion Panel"] = {
        ["Configuracion Ventana Principal"] = {
            title = "Garaje Personal.",
            closebutton = false,
            rounded = 10,
            colorbackground = tocolor(15, 15, 15, 255), -- Fondo negro oscuro (inspirado en el contorno del logo)
            colortitle = tocolor(255, 255, 255, 255) -- Título blanco
        },

        ["Configuracion GridList"] = {
            colorback = tocolor(30, 30, 35, 255), -- Fondo negro-azulado
            colortext = tocolor(255, 255, 255, 255), -- Texto blanco
            colorselected = tocolor(255, 0, 0, 255), -- Rojo vibrante para la selección
            colorLine = tocolor(40, 40, 50, 255), -- Líneas gris oscuro
            colorScrollBack = tocolor(20, 20, 25, 255), -- Fondo scroll oscuro
            colorScrollBoton = tocolor(100, 100, 120, 255), -- Botón scroll gris
            colorScrollText = tocolor(255, 255, 255, 255) -- Texto scroll blanco
        },

        ["Configuracion Botones"] = {
            ["Configuracion Boton Cerrar"] = {
                texto = "Cerrar Panel (o Backspace)",
                rounded = 6,
                colorBoton = tocolor(255, 0, 0, 255), -- Rojo vibrante (similar al texto del logo)
                colorTexto = tocolor(255, 255, 255, 255), -- Blanco
                colorSeleccionado = tocolor(200, 0, 0, 255) -- Rojo ligeramente más oscuro al presionar
            },
            ["Configuracion Boton Guardar"] = {
                texto = "Guardar Vehículo",
                rounded = 6,
                colorBoton = tocolor(0, 0, 255, 255), -- Azul vibrante (basado en "100% Optimizado")
                colorTexto = tocolor(255, 255, 255, 255), -- Blanco
                colorSeleccionado = tocolor(0, 0, 200, 255) -- Azul más oscuro al presionar
            },
            ["Configuracion Boton Sacar"] = {
                texto = "Sacar Vehículo",
                rounded = 6,
                colorBoton = tocolor(255, 255, 0, 255), -- Amarillo brillante (contraste del logo)
                colorTexto = tocolor(0, 0, 0, 255), -- Negro
                colorSeleccionado = tocolor(200, 200, 0, 255) -- Amarillo más oscuro al presionar
            }
        }
    }
}

notify = {
    ['warning'] = "warning",
    ['success'] = "success",
    ['error'] = "error",
    ['info'] = "info"
};

geral = {
    ['sNotify'] = function(element, message, type)
        return exports['a_infobox']:addBox(element, message, notify[type]);
    end,

    ['cNotify'] = function(element, message, type)
        return triggerEvent("addNotification", element, message, notify[type]);
    end
};