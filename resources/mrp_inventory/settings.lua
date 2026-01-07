settings = {
    ui_color = { 209, 67, 67 }, -- Color de respaldo del inventario (se sobreescribe si hay paleta)
    ui_palette = { -- Colores tricolor estilo Colombia (Amarillo, Azul, Rojo)
        { 255, 206, 0 },
        { 0, 57, 166 },
        { 213, 43, 30 },
    },
    ui_tricolor_cycle = true, -- Activar ciclo suave entre los colores de la paleta
    ui_tricolor_speed = 1200, -- Velocidad del ciclo por color en ms
    important_item_ids = { 1, 5, 6, 12, 15, 29, 43 }, -- IDs con confirmación al soltar
}