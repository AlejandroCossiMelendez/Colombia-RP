--[[
    =============================================
    ARCHIVO DE CONFIGURACIÓN - SISTEMA CCTV v2.0
    =============================================
    
    Este archivo contiene toda la configuración del sistema de cámaras.
    Modifica los valores según tus necesidades sin tocar el código principal.
    
    IMPORTANTE: 
    - Reinicia el recurso después de hacer cambios
    - Verifica la sintaxis antes de guardar
    - Usa /cctv-info para verificar que todo esté correcto
]]

Config = {}

-- =============================================
-- CONFIGURACIÓN GENERAL DEL SISTEMA
-- =============================================

Config.General = {
    -- Información del sistema
    version = "2.0",
    author = "Sistema CCTV MTA",
    
    -- Configuración de debug y logs
    debugMode = false,              -- true = permite acceso a todos (solo para testing)
    enableLogs = true,              -- true = habilita logs en consola
    enableDetailedLogs = false,     -- true = logs más detallados
    
    -- Configuración de mantenimiento
    integrityCheckInterval = 300000, -- Verificar integridad cada 5 minutos (en ms)
    enableAutoCheck = true,          -- Verificación automática de datos
}

-- =============================================
-- CONFIGURACIÓN DEL MARCADOR DE ACCESO
-- =============================================

Config.Marker = {
    -- Posición del marcador (donde los jugadores acceden al sistema)
    position = {
        x = 1590.6038818359,
        y = -1689.3034667969,
        z = 19.007499694824-1
    },
    
    -- Propiedades visuales del marcador
    size = 1.5,
    color = {
        r = 255,
        g = 0,
        b = 0,
        alpha = 100
    },
    
    -- Mundo del marcador
    interior = 0,
    dimension = 0,
    id = "camaraMarker",
    
    -- Configuración de comportamiento
    autoExit = true,        -- Salir automáticamente al alejarse del marcador
    exitDistance = 5.0,     -- Distancia máxima antes de salir automáticamente
}

-- =============================================
-- CONFIGURACIÓN DE ACCESO Y PERMISOS
-- =============================================

Config.Access = {
    -- Sistema de facciones
    factionSystem = {
        enabled = true,                 -- Habilitar verificación por facciones
        resourceName = "factions",      -- Nombre del recurso de facciones
        allowedFactions = {             -- IDs de facciones con acceso
            1,  -- Policía
            2,  -- FBI (ejemplo)
            -- Agrega más IDs según necesites
        }
    },
    
    -- Sistema de administradores
    adminAccess = {
        enabled = true,                 -- Permitir acceso a administradores
        aclGroup = "Admin",            -- Grupo ACL requerido
        bypassFactionCheck = true,     -- Los admins no necesitan estar en facción
    },
    
    -- Sistema de cuentas específicas
    accountAccess = {
        enabled = false,               -- Habilitar acceso por nombres de cuenta
        allowedAccounts = {            -- Nombres de cuenta con acceso
            -- "NombreUsuario1",
            -- "NombreUsuario2",
        }
    },
    
    -- Mensajes de acceso
    messages = {
        accessGranted = "✅ Acceso concedido al sistema de cámaras",
        accessDenied = "❌ Acceso denegado: Solo personal autorizado",
        adminAccess = "🔑 Acceso de administrador concedido",
        factionAccess = "👮 Acceso policial concedido",
        systemActivated = "📹 Sistema CCTV activado - Usa las flechas para navegar",
        debugAccess = "🐛 Acceso concedido por modo debug",
    }
}

-- =============================================
-- CONFIGURACIÓN DE CÁMARAS POR UBICACIÓN
-- =============================================

--[[
    GUÍA PARA AGREGAR CÁMARAS:
    
    1. Estructura básica:
    ["Nombre de la Ubicación"] = {
        {
            x = 100.0, y = 200.0, z = 15.0,           -- Posición de la cámara
            lookX = 105.0, lookY = 205.0, lookZ = 15.0, -- Hacia donde mira
            interior = 0,                               -- Interior (0 = exterior)
            dimension = 0,                              -- Dimensión del mundo
            name = "Descripción de la cámara",         -- Nombre opcional
        },
    },
    
    2. Cómo obtener coordenadas:
    - Posiciónate donde quieres la cámara
    - Usa el comando /getpos (si está disponible)
    - O anota las coordenadas del F11
    
    3. Cómo calcular lookX, lookY, lookZ:
    - Determina hacia dónde quieres que mire la cámara
    - lookX/Y/Z debe ser un punto a unos 5-10 metros de distancia
    - Si la cámara está en (100, 200, 15) y quieres que mire al este:
      lookX = 105, lookY = 200, lookZ = 15
    
    4. Interiores comunes:
    - 0 = Mundo exterior
    - 1 = Casas/Negocios básicos
    - 10 = Comisaría
    - 18 = Fábricas
    
    5. Dimensiones:
    - 0 = Dimensión principal
    - Otras = Dimensiones personalizadas de tu servidor
]]

Config.CameraLocations = {
    
    -- ===== BARCO - NUEVA CONFIGURACIÓN =====
    ["Barco"] = {
        {
            x = 2808.9736328125,
            y = -2375.3371582031,
            z = 17.63557434082,
            lookX = 2881.7670898438,
            lookY = -2438.8850097656,
            lookZ = -8.1091260910034,
            interior = 0,
            dimension = 0,
            name = "Entrada Principal"
        },
        {
            x = 2807.150390625,
            y = -2448.5092773438,
            z = 18.418846130371,
            lookX = 2871.37890625,
            lookY = -2378.7524414062,
            lookZ = -13.341329574585,
            interior = 0,
            dimension = 0,
            name = "Entrada Secundaria"
        },
        {
            x = 2817.6198730469,
            y = -2315.7058105469,
            z = 26.125865936279,
            lookX = 2865.6267089844,
            lookY = -2400.9631347656,
            lookZ = 5.4726643562317,
            interior = 0,
            dimension = 0,
            name = "Vista Aérea Proa"
        },
        {
            x = 421.60971069336,
            y = 2545.2646484375,
            z = 35.248538970947,
            lookX = 378.91073608398,
            lookY = 2630.4743652344,
            lookZ = 4.9814047813416,
            interior = 10,
            dimension = 14,
            name = "Interior - Entrada"
        },
        {
            x = 426.49713134766,
            y = 2541.9245605469,
            z = 28.035947799683,
            lookX = 381.80361938477,
            lookY = 2627.126953125,
            lookZ = 0.77692192792892,
            interior = 10,
            dimension = 14,
            name = "Interior - Escaleras"
        },
        {
            x = 410.84063720703,
            y = 2555.9018554688,
            z = 27.983148574829,
            lookX = 334.3117980957,
            lookY = 2496.9057617188,
            lookZ = 2.2384476661682,
            interior = 10,
            dimension = 14,
            name = "Interior - Sala Principal"
        },
        {
            x = 408.61944580078,
            y = 2537.8505859375,
            z = 27.578056335449,
            lookX = 334.00204467773,
            lookY = 2600.4370117188,
            lookZ = 4.8806796073914,
            interior = 10,
            dimension = 14,
            name = "Interior - Sala Principal 2"
        },
        {
            x = 359.82604980469,
            y = 2556.6735839844,
            z = 27.427543640137,
            lookX = 396.99542236328,
            lookY = 2468.3298339844,
            lookZ = -1.1001901626587,
            interior = 10,
            dimension = 14,
            name = "Interior - Sala Principal 3"
        },
    },
    
    -- ===== OFICINA POLICIA NACIONAL =====
    ["OFICINA POLICIA NACIONAL"] = {
        {
            x = 1537.5053710938,
            y = -1597.9888916016,
            z = 24.022008895874,
            lookX = 1603.7645263672,
            lookY = -1667.4460449219,
            lookZ = -4.0035905838013,
            interior = 0,
            dimension = 0,
            name = "Exterior - Vista Parque y Oficinas"
        },
        {
            x = 1533.4393310547,
            y = -1732.6293945312,
            z = 22.468954086304,
            lookX = 1593.1087646484,
            lookY = -1658.4163818359,
            lookZ = -8.059362411499,
            interior = 0,
            dimension = 0,
            name = "Exterior - Vista Parque y Comisaría"
        },
        {
            x = 1590.6229248047,
            y = -1683.9775390625,
            z = 16.918043136597,
            lookX = 1502.3499755859,
            lookY = -1641.9039306641,
            lookZ = -4.0033249855042,
            interior = 0,
            dimension = 0,
            name = "Interior - Entrada Principal"
        },
        {
            x = 1599.1871337891,
            y = -1639.0085449219,
            z = 17.415166854858,
            lookX = 1521.2828369141,
            lookY = -1691.3675537109,
            lookZ = -17.073287963867,
            interior = 0,
            dimension = 0,
            name = "Interior - Zona de Comidas"
        },
        {
            x = 1577.3393554688,
            y = -1639.0942382812,
            z = 22.616621017456,
            lookX = 1575.1322021484,
            lookY = -1731.4061279297,
            lookZ = -15.771489143372,
            interior = 0,
            dimension = 0,
            name = "Segundo Piso - Sala de Reuniones"
        },
        {
            x = 1572.4263916016,
            y = -1716.0981445312,
            z = 21.714479446411,
            lookX = 1629.4652099609,
            lookY = -1640.6706542969,
            lookZ = -10.801034927368,
            interior = 0,
            dimension = 0,
            name = "Interior - Escaleras"
        },
        {
            x = 1611.1791992188,
            y = -1658.4548339844,
            z = 11.78457736969,
            lookX = 1531.0861816406,
            lookY = -1705.9603271484,
            lookZ = -24.661695480347,
            interior = 0,
            dimension = 0,
            name = "Sótano - Calabozos"
        },
        {
            x = 1630.5063476562,
            y = -1606.2283935547,
            z = 11.008472442627,
            lookX = 1560.1353759766,
            lookY = -1669.9008789062,
            lookZ = -20.515171051025,
            interior = 0,
            dimension = 0,
            name = "Sótano - Entrada Vehículos"
        },
        {
            x = 1567.7211914062,
            y = -1637.7084960938,
            z = 10.390803337097,
            lookX = 1652.8499755859,
            lookY = -1586.5432128906,
            lookZ = -1.2369120121002,
            interior = 0,
            dimension = 0,
            name = "Sótano - Parqueadero Completo"
        },
    },
    
    -- ===== BANCOLOMBIA =====
    ["BANCOLOMBIA"] = {
        {
            x = 1720.7161865234,
            y = -1296.6990966797,
            z = 30.535089492798,
            lookX = 1663.0423583984,
            lookY = -1373.0603027344,
            lookZ = 1.5060029029846,
            interior = 0,
            dimension = 0,
            name = "Dron - Vista Aérea Edificio"
        },
        {
            x = 1623.9084472656,
            y = -1308.2545166016,
            z = 27.52060508728,
            lookX = 1677.0366210938,
            lookY = -1387.8453369141,
            lookZ = -1.508481502533,
            interior = 0,
            dimension = 0,
            name = "Exterior - Parqueadero y Calles"
        },
        {
            x = 1656.1586914062,
            y = -1334.3026123047,
            z = 29.83962059021,
            lookX = 1720.2115478516,
            lookY = -1400.8126220703,
            lookZ = -8.5484895706177,
            interior = 0,
            dimension = 0,
            name = "Interior - Sala Principal (Esquina 1)"
        },
        {
            x = 1695.9353027344,
            y = -1335.3831787109,
            z = 30.072174072266,
            lookX = 1611.6622314453,
            lookY = -1372.626953125,
            lookZ = -8.7987985610962,
            interior = 0,
            dimension = 0,
            name = "Interior - Sala Principal (Esquina 2)"
        },
        {
            x = 1697.2332763672,
            y = -1333.6766357422,
            z = 21.717861175537,
            lookX = 1665.7489013672,
            lookY = -1422.1033935547,
            lookZ = -12.770592689514,
            interior = 0,
            dimension = 0,
            name = "Interior - Pasillo Principal"
        },
        {
            x = 1655.3110351562,
            y = -1364.2830810547,
            z = 22.246543884277,
            lookX = 1739.9068603516,
            lookY = -1324.0340576172,
            lookZ = -12.732816696167,
            interior = 0,
            dimension = 0,
            name = "Interior - Área de Recepción"
        },
        {
            x = 1689.5787353516,
            y = -1338.7760009766,
            z = 19.301071166992,
            lookX = 1665.9652099609,
            lookY = -1434.1987304688,
            lookZ = 0.94615167379379,
            interior = 0,
            dimension = 0,
            name = "Interior - Cajeros Automáticos"
        },
        {
            x = 1684.0446777344,
            y = -1369.5235595703,
            z = 15.330383300781,
            lookX = 1722.4810791016,
            lookY = -1282.2259521484,
            lookZ = -14.69900894165,
            interior = 0,
            dimension = 0,
            name = "Sótano - Exterior Caja Fuerte"
        },
        {
            x = 1689.2548828125,
            y = -1353.1107177734,
            z = 15.429330825806,
            lookX = 1720.29296875,
            lookY = -1265.1127929688,
            lookZ = -20.528951644897,
            interior = 0,
            dimension = 0,
            name = "Sótano - Interior Caja Fuerte"
        },
        {
            x = 1655.8442382812,
            y = -1316.9427490234,
            z = 15.536285400391,
            lookX = 1714.6864013672,
            lookY = -1389.3624267578,
            lookZ = -20.421997070312,
            interior = 0,
            dimension = 0,
            name = "Sótano - Parqueadero Interno"
        },
        {
            x = 1656.3447265625,
            y = -1363.0050048828,
            z = 34.821273803711,
            lookX = 1731.7590332031,
            lookY = -1301.1087646484,
            lookZ = 12.877241134644,
            interior = 0,
            dimension = 0,
            name = "Azotea - Vista Panorámica"
        },
        {
            x = 1681.4689941406,
            y = -1369.9167480469,
            z = 14.124105453491,
            lookX = 1598.1534423828,
            lookY = -1324.4768066406,
            lookZ = -17.399538040161,
            interior = 0,
            dimension = 0,
            name = "Sótano - Puerta Parqueadero"
        },
    },
    
    -- ===== FAVELA =====
    ["FAVELA"] = {
        {
            x = 2595.0974121094,
            y = -1061.9692382812,
            z = 75.140853881836,
            lookX = 2604.1872558594,
            lookY = -962.54187011719,
            lookZ = 69.522392272949,
            interior = 0,
            dimension = 0,
            name = "Entrada Principal"
        },
        {
            x = 2668.3930664062,
            y = -964.57037353516,
            z = 88.638359069824,
            lookX = 2573.4838867188,
            lookY = -968.42529296875,
            lookZ = 57.375011444092,
            interior = 0,
            dimension = 0,
            name = "Entrada Secundaria"
        },
        {
            x = 2562.9846191406,
            y = -854.9599609375,
            z = 84.407028198242,
            lookX = 2473.3337402344,
            lookY = -883.67272949219,
            lookZ = 50.668376922607,
            interior = 0,
            dimension = 0,
            name = "Vista Panorámica Calles"
        },
        {
            x = 2455.2893066406,
            y = -844.81201171875,
            z = 83.168418884277,
            lookX = 2546.7663574219,
            lookY = -878.22991943359,
            lookZ = 60.471042633057,
            interior = 0,
            dimension = 0,
            name = "Zona Roja - Área Ilegal"
        },
        {
            x = 2470.2756347656,
            y = -924.96966552734,
            z = 86.140655517578,
            lookX = 2393.8435058594,
            lookY = -869.71697998047,
            lookZ = 52.89527130127,
            interior = 0,
            dimension = 0,
            name = "Cancha de Fútbol"
        },
        {
            x = 2496.3688964844,
            y = -977.68670654297,
            z = 87.271110534668,
            lookX = 2573.1765136719,
            lookY = -919.05401611328,
            lookZ = 61.52640914917,
            interior = 0,
            dimension = 0,
            name = "Calle Residencial"
        },
    },
    
    -- ===== BUNKER 07 =====
    ["BUNKER 07"] = {
        {
            x = 1339.7506103516,
            y = -334.63809204102,
            z = 14.661127090454,
            lookX = 1367.5695800781,
            lookY = -425.01977539062,
            lookZ = -17.854387283325,
            interior = 0,
            dimension = 0,
            name = "Entrada Principal"
        },
        {
            x = 1441.8806152344,
            y = -462.53854370117,
            z = 1.034340262413,
            lookX = 1407.1181640625,
            lookY = -551.01983642578,
            lookZ = -29.992065429688,
            interior = 0,
            dimension = 0,
            name = "Vista General - Esquina Norte"
        },
        {
            x = 1472.9110107422,
            y = -568.55218505859,
            z = 0.086488075554371,
            lookX = 1407.1348876953,
            lookY = -500.37432861328,
            lookZ = -31.933528900146,
            interior = 0,
            dimension = 0,
            name = "Vista General - Esquina Sur"
        },
        {
            x = 1409.4814453125,
            y = -550.82330322266,
            z = -2.6920502185822,
            lookX = 1490.0834960938,
            lookY = -592.30517578125,
            lookZ = -44.912494659424,
            interior = 0,
            dimension = 0,
            name = "Sótano - Plantación Marihuana"
        },
        {
            x = 1388.953125,
            y = -521.80139160156,
            z = -12.162685394287,
            lookX = 1445.8189697266,
            lookY = -449.56814575195,
            lookZ = -51.51545715332,
            interior = 0,
            dimension = 0,
            name = "Sótano - Arsenal de Armas"
        },
        {
            x = 1400.1497802734,
            y = -512.02386474609,
            z = -11.170937538147,
            lookX = 1440.3256835938,
            lookY = -429.33618164062,
            lookZ = -50.523708343506,
            interior = 0,
            dimension = 0,
            name = "Sótano - Ring de Peleas"
        },
        {
            x = 1407.8283691406,
            y = -544.17980957031,
            z = -11.849751472473,
            lookX = 1312.818359375,
            lookY = -531.55926513672,
            lookZ = -40.377487182617,
            interior = 0,
            dimension = 0,
            name = "Sótano - Taller Mecánico Ilegal"
        },
        {
            x = 1448.1226806641,
            y = -562.39440917969,
            z = -12.065818786621,
            lookX = 1526.4157714844,
            lookY = -511.62835693359,
            lookZ = -48.024101257324,
            interior = 0,
            dimension = 0,
            name = "Sótano - Oficinas Ilegales"
        },
        {
            x = 1430.3200683594,
            y = -562.31695556641,
            z = -11.559358596802,
            lookX = 1382.9772949219,
            lookY = -489.25604248047,
            lookZ = -60.760684967041,
            interior = 0,
            dimension = 0,
            name = "Sótano - Dormitorios"
        },
        {
            x = 1458.5913085938,
            y = -508.87191772461,
            z = -13.570147514343,
            lookX = 1369.4674072266,
            lookY = -552.97216796875,
            lookZ = -24.157346725464,
            interior = 0,
            dimension = 0,
            name = "Sótano - Vista Panorámica Central"
        },
    },
    
    --[[
    -- ===== PLANTILLA PARA NUEVAS UBICACIONES =====
    -- Copia esta plantilla y modifica los valores según necesites
    
    ["Tu Nueva Ubicación"] = {
        {
            x = 0.0,        -- Coordenada X de la cámara
            y = 0.0,        -- Coordenada Y de la cámara  
            z = 0.0,        -- Coordenada Z de la cámara
            lookX = 5.0,    -- X hacia donde mira (normalmente x + 5)
            lookY = 0.0,    -- Y hacia donde mira
            lookZ = 0.0,    -- Z hacia donde mira
            interior = 0,   -- Interior (0 = exterior)
            dimension = 0,  -- Dimensión (0 = principal)
            name = "Descripción de la cámara"
        },
        -- Puedes agregar más cámaras aquí
        {
            x = 10.0, y = 10.0, z = 5.0,
            lookX = 15.0, lookY = 10.0, lookZ = 5.0,
            interior = 0, dimension = 0,
            name = "Segunda cámara"
        },
    },
    ]]
}

-- =============================================
-- CONFIGURACIÓN DE COMANDOS ADMINISTRATIVOS
-- =============================================

Config.Commands = {
    -- Prefijo para todos los comandos del sistema
    prefix = "cctv",
    
    -- Comandos disponibles
    commands = {
        debug = {
            enabled = true,
            command = "cctv-debug",        -- Comando: /cctv-debug [on/off]
            adminOnly = true,              -- Solo administradores
            description = "Activar/desactivar modo debug"
        },
        
        info = {
            enabled = true,
            command = "cctv-info",         -- Comando: /cctv-info
            adminOnly = false,             -- Cualquiera con acceso al sistema
            description = "Mostrar información del sistema"
        },
        
        list = {
            enabled = true,
            command = "cctv-list",         -- Comando: /cctv-list
            adminOnly = false,             -- Cualquiera con acceso al sistema
            description = "Listar todas las ubicaciones"
        },
        
        reload = {
            enabled = true,
            command = "cctv-reload",       -- Comando: /cctv-reload
            adminOnly = true,              -- Solo administradores
            description = "Recargar configuración"
        },
    }
}

-- =============================================
-- CONFIGURACIÓN DE EFECTOS VISUALES
-- =============================================

Config.Effects = {
    -- Efectos CCTV
    scanLines = {
        enabled = true,             -- Líneas de escaneo
        speed = 25,                 -- Velocidad de movimiento
        opacity = 3,                -- Opacidad (0-255)
        color = {0, 255, 0},       -- Color RGB (verde por defecto)
    },
    
    noise = {
        enabled = true,             -- Ruido visual
        frequency = 0.015,          -- Frecuencia (0.0-1.0, menor = menos frecuente)
        intensity = {15, 35},       -- Rango de intensidad (min, max)
    },
    
    interference = {
        enabled = true,             -- Interferencia horizontal
        frequency = 0.025,          -- Frecuencia de aparición
        color = {255, 255, 255, 50}, -- Color RGBA
    },
    
    vignette = {
        enabled = true,             -- Bordes oscuros
        size = 50,                  -- Tamaño base del borde
        opacity = 100,              -- Opacidad base
    },
    
    filter = {
        enabled = true,             -- Filtro de color general
        color = {0, 255, 0, 2},    -- Color RGBA (verde muy sutil)
    }
}

-- =============================================
-- CONFIGURACIÓN DE LA INTERFAZ (UI)
-- =============================================

Config.UI = {
    -- Configuración del panel de control
    controlPanel = {
        position = {
            x = 0.7,        -- 70% desde la izquierda (0.0-1.0)
            y = 0.6,        -- 60% desde arriba (0.0-1.0)
            width = 0.25,   -- 25% del ancho de pantalla
            height = 0.35   -- 35% del alto de pantalla
        },
        
        -- Colores del panel
        backgroundColor = {0, 0, 0, 180},
        borderColor = {0, 150, 0, 255},
        borderSize = 3,
    },
    
    -- Configuración de botones
    buttons = {
        minSize = 40,           -- Tamaño mínimo de botones
        baseSize = 60,          -- Tamaño base
        spacing = 10,           -- Espaciado entre botones
        
        -- Colores de botones
        normalColor = {0, 100, 0, 200},
        hoverColor = {0, 150, 0, 255},
        textColor = {255, 255, 255, 255},
    },
    
    -- Configuración de fuentes
    fonts = {
        title = {
            baseSize = 1.2,
            minSize = 0.8,
        },
        normal = {
            baseSize = 1.0,
            minSize = 0.7,
        },
        small = {
            baseSize = 0.8,
            minSize = 0.6,
        }
    },
    
    -- Configuración de información en pantalla
    info = {
        showCameraInfo = true,      -- Mostrar info de cámara actual
        showInstructions = true,    -- Mostrar instrucciones de uso
        showDateTime = true,        -- Mostrar fecha y hora
        
        -- Posición de la información
        infoPosition = {
            x = 0.02,               -- 2% desde la izquierda
            y = 0.02,               -- 2% desde arriba
            width = 0.3,            -- 30% del ancho
        }
    }
}

-- =============================================
-- CONFIGURACIÓN DE CONTROLES
-- =============================================

Config.Controls = {
    -- Velocidad de rotación de cámaras
    rotationSpeed = 50.0,           -- Grados por segundo
    
    -- Teclas de control (no cambiar a menos que sepas lo que haces)
    keys = {
        rotateLeft = "arrow_l",     -- Flecha izquierda
        rotateRight = "arrow_r",    -- Flecha derecha
        nextCamera = "arrow_u",     -- Flecha arriba
        prevCamera = "arrow_d",     -- Flecha abajo
        exit = "backspace",         -- Tecla borrar
        toggleLocations = "tab",    -- Tecla tab
    },
    
    -- Configuración de mouse
    mouse = {
        enableClicks = true,        -- Permitir clics en botones
        cursorRequired = true,      -- Mostrar cursor automáticamente
    }
}

-- =============================================
-- MENSAJES DEL SISTEMA
-- =============================================

Config.Messages = {
    -- Mensajes de inicio
    system = {
        loaded = "Sistema de Cámaras CCTV v%s cargado exitosamente",
        started = "Sistema iniciado: %d ubicaciones, %d cámaras",
        stopped = "Sistema de cámaras desactivado",
    },
    
    -- Mensajes de error
    errors = {
        invalidCamera = "⚠️ Cámaras con errores: %d",
        noLocations = "❌ No se encontraron ubicaciones con cámaras disponibles",
        factionSystemError = "⚠️ Sistema de facciones no disponible",
        markerError = "❌ ERROR: No se pudo crear el marcador de acceso",
    },
    
    -- Mensajes de información
    info = {
        cameraActivated = "📹 Sistema CCTV activado - Usa las flechas para navegar",
        locationInfo = "Ubicaciones disponibles: %d | Total cámaras: %d",
        debugEnabled = "🐛 Modo debug del sistema CCTV activado",
        debugDisabled = "🐛 Modo debug del sistema CCTV desactivado",
        allCamerasValid = "✅ Todas las cámaras están configuradas correctamente",
    },
    
    -- Instrucciones para el usuario
    instructions = {
        navigation = "← → : Rotar | ↑: Cambiar cámara | TAB: Ubicaciones",
        exit = "PRESIONA LA TECLA BORRAR PARA SALIR",
        locationSelector = "Haz clic en una ubicación para ver sus cámaras",
        backTocameras = "Presiona TAB para volver a las cámaras",
    }
}

-- =============================================
-- CONFIGURACIÓN AVANZADA
-- =============================================

Config.Advanced = {
    -- Optimización de rendimiento
    performance = {
        maxFPS = 60,                    -- FPS máximo para efectos
        updateInterval = 16,            -- Intervalo de actualización (ms)
        enableVSync = false,            -- Sincronización vertical
    },
    
    -- Configuración de red
    network = {
        maxDataSize = 1024,             -- Tamaño máximo de datos por envío
        compressionLevel = 6,           -- Nivel de compresión (1-9)
        enableEncryption = false,       -- Encriptación de datos (experimental)
    },
    
    -- Configuración de seguridad
    security = {
        enableAntiSpam = true,          -- Anti-spam de comandos
        maxCommandsPerMinute = 10,      -- Máximo comandos por minuto
        logSuspiciousActivity = true,   -- Log de actividad sospechosa
    },
    
    -- Configuración experimental
    experimental = {
        enableZoom = false,             -- Zoom de cámaras (experimental)
        enableRecording = false,        -- Grabación de cámaras (experimental)
        enableAI = false,               -- Detección automática (experimental)
    }
}

--[[
    =============================================
    NOTAS IMPORTANTES:
    =============================================
    
    1. SIEMPRE haz backup de este archivo antes de modificarlo
    
    2. Después de hacer cambios, reinicia el recurso con:
       /restart cameras (o el nombre de tu recurso)
    
    3. Verifica que no hay errores de sintaxis antes de guardar
    
    4. Usa los comandos administrativos para verificar:
       /cctv-info - Ver información del sistema
       /cctv-list - Ver todas las ubicaciones
       /cctv-debug on/off - Modo debug
    
    5. Si algo no funciona:
       - Revisa los logs del servidor
       - Verifica que las coordenadas sean correctas
       - Asegúrate de que los interiores/dimensiones existan
    
    6. Para agregar nuevas ubicaciones:
       - Copia la plantilla comentada
       - Modifica las coordenadas
       - Reinicia el recurso
    
    =============================================
]]

-- Retornar la configuración para uso en otros archivos
return Config
