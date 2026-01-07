# JEICORDERO AC - Versión Limpia
## Guía de Instalación y Configuración

### 📋 ARCHIVOS INCLUIDOS
- `cSchootz.lua` - Cliente (Anti-Spoofer y Anti-Executor)
- `sSchootz.lua` - Servidor (Anti-VPN y lógica principal)  
- `gSchootz.lua` - Configuración centralizada
- `meta.xml` - Configuración del resource
- `README_INSTALACION.md` - Esta guía

### 🔧 PASO 1: PREPARACIÓN
1. **Ubicar en servidor:**
   - Copiar carpeta completa a `/resources/PEGASUS_AC/`
   
2. **Verificar archivos:**
   - Todos los archivos deben estar en su lugar
   - No es necesario renombrar nada

### ⚙️ PASO 2: CONFIGURACIÓN OBLIGATORIA

#### A) Configurar Webhooks de Discord
Editar `gSchootz.lua` líneas 16-21:
```lua
webhooks = {
    antivpn = "https://discord.com/api/webhooks/TU_ID/TU_TOKEN",
    antispoofer = "https://discord.com/api/webhooks/TU_ID/TU_TOKEN", 
    antiexecutor = "https://discord.com/api/webhooks/TU_ID/TU_TOKEN",
    general = "https://discord.com/api/webhooks/TU_ID/TU_TOKEN"
}
```

#### B) Configurar API VPN
Editar `gSchootz.lua` líneas 24-30:
1. Registrarse GRATIS en https://vpnapi.io/
2. Obtener API Key gratuita (1000 consultas/mes)
3. Reemplazar:
```lua
vpn_api = {
    enabled = true,
    url = "https://vpnapi.io/api/",
    key = "22bcbb101bb84b3c98f604a047fdc60a",  -- Tu API key aquí
    timeout = 10000,
    fallback_ban = false
}
```

#### C) Configurar Grupos ACL
Editar `gSchootz.lua` líneas 35-42:
```lua
bypass = {
    acl_groups = {
        "Console",
        "Admin",        -- Tus grupos ACL
        "Staff",
        "Moderator",
        "Developer"
    }
}
```

### 🚀 PASO 3: INSTALACIÓN
1. **Iniciar resource:**
   ```
   start PEGASUS_AC
   ```

2. **Verificar funcionamiento:**
   - Revisar console: debe mostrar "✅ Configuración válida"
   - Si hay errores, revisar configuración

### 📊 COMANDOS ADMINISTRATIVOS
- `/acstats` - Ver estadísticas completas del anticheat
- `/addvpnwhitelist [IP] [razón]` - Añadir IP a whitelist VPN
- `/removevpnwhitelist [IP]` - Remover IP de whitelist VPN

### 🔍 FUNCIONES ACTIVAS

#### 🚫 Anti-VPN
- Verifica todas las conexiones contra API VPN
- Banea automáticamente VPNs detectadas
- Sistema de whitelist para IPs legítimas

#### 🔍 Anti-Spoofer  
- Detecta cambios de serial del cliente
- Guarda serial en archivo local del cliente
- Banea permanentemente spoofers

#### 💻 Anti-Executor
- Detecta uso de `loadstring` malicioso
- Monitorea código pegado en chat/console  
- Detecta patrones específicos para tu problema:
  - `triggerServerEvent.*roadblockCreateWorldObject` (tu problema específico)
  - `createObject.*252[15]` (inodoros maliciosos ID 2525/2521)
  - Modificación de dinero/level/ID de jugador
  - Creación de vehículos y armas no autorizados
- Sube código malicioso a Hastebin para análisis

### ⚠️ SOLUCIÓN DE PROBLEMAS

#### Error: "Webhook no configurado"
- Configurar webhooks reales en `gSchootz.lua`

#### Error: "API Key no configurada" 
- Obtener API key de vpnapi.io y configurarla

#### No detecta VPNs
- Verificar que la API key sea válida
- Comprobar conexión a internet del servidor

#### Falsos positivos en Anti-Executor
- Añadir jugadores a grupos ACL bypass
- Modificar patrones en configuración

### 🔒 SEGURIDAD ADICIONAL
Para mayor seguridad, compilar el cliente:
```bash
luac -o cSchootz.luac cSchootz.lua
```
Y cambiar en meta.xml:
```xml
<script src="cSchootz.luac" type="client" cache="false" />
```

### 📈 MONITOREO
- Revisar logs del servidor regularmente
- Monitorear webhooks de Discord
- Usar `/acstats` para ver estadísticas

---
**Soporte:** Si tienes problemas, revisa la configuración paso a paso.
