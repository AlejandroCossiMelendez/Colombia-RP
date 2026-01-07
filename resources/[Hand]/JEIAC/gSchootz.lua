-- ============================================================================
-- JEICORDERO AC - CONFIGURACIÓN PRINCIPAL
-- Versión: 2.0 Limpia - Solo Anti-VPN, Anti-Spoofer y Anti-Executor
-- ============================================================================

-- ===== CONFIGURACIÓN PRINCIPAL =====
config = {
    -- Información del servidor
    server_info = {
        name = "CAPITAL RP",
        version = "2.0",
        author = "Jeicordero AC"
    },
    
    -- ===== WEBHOOKS DE DISCORD (CONFIGURADO) =====
    webhooks = {
        -- URL única para todos los módulos del anticheat
        main = "https://discord.com/api/webhooks/1419705593958105090/-lTtAA5lbY0TjNJA29JF4jYtCr6repYx04-V6jgkZjKB5JeDq8dadAnfwspkKOz5XCYV"
    },
    
    -- ===== API VPN (OBLIGATORIO CAMBIAR) =====
    vpn_api = {
        enabled = true,
        url = "https://vpnapi.io/api/",
        key = "22bcbb101bb84b3c98f604a047fdc60a",  -- Obtener GRATIS en https://vpnapi.io/
        timeout = 10000,  -- Timeout en ms
        fallback_ban = false  -- Si no responde API, ¿banear por defecto?
    },
    
    -- ===== SISTEMA DE BYPASS =====
    bypass = {
        -- Grupos ACL que tienen bypass completo
        acl_groups = {
            "Console",
            "Admin", 
            "Desarrollador",
            "Moderator",
            "GameOperator"
        },
        
        -- Element data que dan bypass completo
        element_data = {
            "admin",
            "staff", 
            "moderator",
            "developer",
            "ac_bypass"
        }
    },
    
    -- ===== CONFIGURACIÓN ANTI-VPN =====
    modules = {
        antivpn = {
            enabled = false,
            ban_time = 1440,  -- Minutos (1440 = 24h, 0 = permanente)
            ban_reason = "Uso de VPN detectado. Si es un error, contacta administración.",
            check_delay = 2000,  -- Delay antes de verificar VPN (ms)
            whitelist_command = "addvpnwhitelist",
            auto_whitelist_verified = true  -- Auto-whitelist IPs verificados como no-VPN
        },
        
        -- ===== CONFIGURACIÓN ANTI-SPOOFER =====
        antispoofer = {
            enabled = true,
            ban_time = 0,  -- Ban permanente
            ban_reason = "Serial Spoofer detectado",
            file_name = "@pegasus_serial.json",
            check_interval = 300000  -- Re-verificar cada 5 minutos
        },
        
        -- ===== CONFIGURACIÓN ANTI-EXECUTOR =====
        antiexecutor = {
            enabled = true,
            ban_time = 0,  -- Ban permanente  
            ban_reason = "Uso de executor/hack detectado",
            
            -- Patrones sospechosos a detectar (REGEX)
            suspicious_patterns = {
                "triggerServerEvent.*roadblockCreateWorldObject",  -- Tu problema específico
                "createObject.*252[15]",  -- Inodoros maliciosos (2525, 2521)
                "setElementData.*ID.*%d+",  -- Cambio de ID de jugador
                "setElementData.*Level.*%d+",  -- Cambio de level
                "setElementData.*Money.*%d+",  -- Cambio de dinero
                "setElementData.*Cash.*%d+",  -- Cambio de cash
                "setElementData.*Exp.*%d+",  -- Cambio de experiencia
                "givePlayerMoney.*%d+",  -- Dar dinero
                "setPlayerMoney.*%d+",  -- Establecer dinero
                "createVehicle.*%d+",  -- Crear vehículos
                "giveWeapon.*%d+",  -- Dar armas
                "setPedStat.*%d+",  -- Cambiar stats
                "setElementHealth.*999[0-9]",  -- Vida infinita
                "setVehicleEngineState.*true",  -- Encender vehículos
                "warpPedIntoVehicle"  -- Teletransporte a vehículos
            },
            
            -- Funciones completamente bloqueadas
            blocked_functions = {
                "loadstring",
                "executeCommandHandler",
                "addCommandHandler"
            },
            
            -- Configuración de detección
            detection = {
                max_detections_before_ban = 3,  -- Máximo 3 detecciones antes de ban
                reset_detections_time = 3600000  -- Reset detecciones cada hora
            }
        }
    },
    
    -- ===== COMANDOS ADMINISTRATIVOS =====
    commands = {
        stats = "acstats",
        whitelist_vpn = "addvpnwhitelist",
        remove_whitelist = "removevpnwhitelist",
        reload_config = "acreload",
        check_player = "accheck"
    },
    
    -- ===== CONFIGURACIÓN DE BASE DE DATOS =====
    database = {
        name = "pegasus_data.sqlite",
        backup_interval = 3600000,  -- Backup cada hora
        cleanup_old_records = true,
        max_records_per_table = 10000
    },
    
    -- ===== CONFIGURACIÓN DE LOGS =====
    logging = {
        enabled = true,
        debug_mode = true,
        console_output = true,
        file_logging = false,
        webhook_logs = true,
        log_successful_connections = false  -- Solo logs de problemas
    }
}

-- Función para verificar si la configuración es válida
function validateConfig()
    local errors = {}
    
    -- Verificar webhooks (buscar placeholders no configurados)
    for name, webhook in pairs(config.webhooks) do
        if webhook:find("TU_WEBHOOK") then
            table.insert(errors, "⚠️ Webhook " .. name .. " no configurado")
        end
    end
    
    -- Verificar API VPN (buscar placeholder no configurado)
    if config.vpn_api.key:find("TU_API_KEY") then
        table.insert(errors, "⚠️ API Key de VPN no configurada")
    end
    
    return errors
end

-- Función para mostrar errores de configuración
function showConfigErrors()
    local errors = validateConfig()
    if #errors > 0 then
        outputDebugString("❌ [JEICORDERO AC] Errores de configuración encontrados:", 1)
        for _, error in ipairs(errors) do
            outputDebugString("   " .. error, 1)
        end
        outputDebugString("📝 [JEICORDERO AC] Edita gSchootz.lua para corregir estos errores", 1)
    else
        outputDebugString("✅ [JEICORDERO AC] Configuración válida", 3)
    end
end

-- Verificar configuración al iniciar
setTimer(showConfigErrors, 1000, 1)

-- Función de utilidad para logs
function logMessage(message, level)
    level = level or 3
    if config.logging.console_output then
        outputDebugString("[JEICORDERO AC] " .. message, level)
    end
end

-- Función de utilidad para notificaciones (opcional)
function notifyPlayer(player, message, type)
    type = type or "info"
    
    -- Si tienes un sistema de notificaciones personalizado, úsalo aquí
    -- Por ejemplo: exports.notifications:show(player, message, type)
    
    -- Fallback a chatbox
    local colors = {
        info = {0, 255, 255},
        success = {0, 255, 0}, 
        warning = {255, 255, 0},
        error = {255, 0, 0}
    }
    
    local color = colors[type] or colors.info
    outputChatBox("[AC] " .. message, player, color[1], color[2], color[3])
end
