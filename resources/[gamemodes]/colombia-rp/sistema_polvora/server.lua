-- SERVER.LUA - Sistema de Pólvora y Pirotecnia
local db = dbConnect("sqlite", "polvora.db")

-- Crear tabla
dbExec(db, [[CREATE TABLE IF NOT EXISTS inventario_polvora (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario TEXT,
    item TEXT,
    cantidad INTEGER DEFAULT 1
)]])

-- Posición del NPC vendedor
local npcPos = {x = 2040.73865, y = 1543.47925, z = 10.67188, rot = 180}

-- Crear NPC
local npc = createPed(29, npcPos.x, npcPos.y, npcPos.z, npcPos.rot) -- Skin de vendedor
setElementFrozen(npc, true)
setElementData(npc, "esVendedorPolvora", true)
setPedAnimation(npc, "DEALER", "DEALER_IDLE", -1, true, false, false, false)

-- Items de pólvora disponibles
local itemsPolvora = {
    {id = 1, nombre = "Petardo Pequeño", precio = 50, efecto = "petardo", desc = "Pequeño estallido con chispas"},
    {id = 2, nombre = "Bengala de Mano", precio = 100, efecto = "bengala", desc = "Chispas doradas en la mano"},
    {id = 3, nombre = "Cohete Volador", precio = 250, efecto = "cohete", desc = "Sube y explota en colores"},
    {id = 4, nombre = "Trueno Explosivo", precio = 300, efecto = "trueno", desc = "Gran explosión con sonido fuerte"},
    {id = 5, nombre = "Fuente de Chispas", precio = 400, efecto = "fuente", desc = "Cascada de chispas doradas"},
    {id = 6, nombre = "Bomba de Humo", precio = 200, efecto = "humo", desc = "Nube de humo de colores"},
    {id = 7, nombre = "Pirotecnia Profesional", precio = 800, efecto = "profesional", desc = "Show completo de fuegos artificiales"},
    {id = 8, nombre = "Granada de Destello", precio = 500, efecto = "destello", desc = "Gran destello cegador"},
}

-- Click en el NPC
addEvent("polvora:clickNPC", true)
addEventHandler("polvora:clickNPC", root, function()
    triggerClientEvent(source, "polvora:abrirPanel", source, itemsPolvora)
end)

-- Comprar item
addEvent("polvora:comprarItem", true)
addEventHandler("polvora:comprarItem", root, function(itemID, precio, nombre)
    local dinero = getPlayerMoney(source)
    local usuario = getElementData(source, "usuario") or getPlayerName(source)
    
    if dinero >= precio then
        takePlayerMoney(source, precio)
        
        -- Verificar si ya tiene el item
        local query = dbQuery(db, "SELECT * FROM inventario_polvora WHERE usuario=? AND item=?", usuario, nombre)
        local result = dbPoll(query, -1)
        
        if result and #result > 0 then
            -- Incrementar cantidad
            dbExec(db, "UPDATE inventario_polvora SET cantidad=cantidad+1 WHERE usuario=? AND item=?", usuario, nombre)
        else
            -- Insertar nuevo
            dbExec(db, "INSERT INTO inventario_polvora (usuario, item, cantidad) VALUES (?, ?, 1)", usuario, nombre)
        end
        
        outputChatBox("✓ Has comprado: " .. nombre .. " por $" .. precio, source, 0, 255, 0)
        triggerClientEvent(source, "mostrarInfobox", source, "success", "¡" .. nombre .. " comprado!")
        triggerEvent("polvora:obtenerInventario", source)
    else
        outputChatBox("✗ No tienes suficiente dinero", source, 255, 50, 50)
        triggerClientEvent(source, "mostrarInfobox", source, "error", "Necesitas $" .. precio)
    end
end)

-- Obtener inventario
addEvent("polvora:obtenerInventario", true)
addEventHandler("polvora:obtenerInventario", root, function()
    local usuario = getElementData(source, "usuario") or getPlayerName(source)
    local query = dbQuery(db, "SELECT * FROM inventario_polvora WHERE usuario=?", usuario)
    local result = dbPoll(query, -1)
    
    if result then
        triggerClientEvent(source, "polvora:recibirInventario", source, result)
    else
        triggerClientEvent(source, "polvora:recibirInventario", source, {})
    end
end)

-- Usar item de pólvora
addEvent("polvora:usarItem", true)
addEventHandler("polvora:usarItem", root, function(itemNombre, efecto)
    local usuario = getElementData(source, "usuario") or getPlayerName(source)
    
    -- Verificar que tenga el item
    local query = dbQuery(db, "SELECT * FROM inventario_polvora WHERE usuario=? AND item=?", usuario, itemNombre)
    local result = dbPoll(query, -1)
    
    if result and #result > 0 and result[1].cantidad > 0 then
        -- Reducir cantidad
        local nuevaCantidad = result[1].cantidad - 1
        
        if nuevaCantidad > 0 then
            dbExec(db, "UPDATE inventario_polvora SET cantidad=? WHERE usuario=? AND item=?", nuevaCantidad, usuario, itemNombre)
        else
            dbExec(db, "DELETE FROM inventario_polvora WHERE usuario=? AND item=?", usuario, itemNombre)
        end
        
        -- Obtener posición del jugador
        local x, y, z = getElementPosition(source)
        
        -- Activar efecto para todos los jugadores cercanos
        for _, player in ipairs(getElementsByType("player")) do
            local px, py, pz = getElementPosition(player)
            local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            
            if distancia < 100 then
                triggerClientEvent(player, "polvora:activarEfecto", player, efecto, x, y, z)
            end
        end
        
        outputChatBox("✓ Has usado: " .. itemNombre, source, 255, 200, 0)
        triggerEvent("polvora:obtenerInventario", source)
    else
        outputChatBox("✗ No tienes este item", source, 255, 50, 50)
        triggerClientEvent(source, "mostrarInfobox", source, "error", "No tienes este item")
    end
end)

-- Export
function getPlayerFireworks(player)
    local usuario = getElementData(player, "usuario") or getPlayerName(player)
    local query = dbQuery(db, "SELECT * FROM inventario_polvora WHERE usuario=?", usuario)
    return dbPoll(query, -1) or {}
end