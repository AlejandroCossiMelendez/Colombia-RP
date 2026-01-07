screenSize = Vector2(guiGetScreenSize());
screenScale = math.max(0.6, screenSize.y/1080);

news = {
    {
        row = "A- Handling de coches"
    },
    {
        row = "B- Coches VIP"
    },
    {
        row = "C- Hud y Velocimetro"
    },
    {
        row = "D- Sistema de Robar ATM"
    },
    {
        row = "E- Fabricar armas"
    },
    {
        row = "F- Activos faccionario f7"
    }
};

function isMouseHovering(x, y, width, height)
    if(not isCursorShowing())then return false; end
    local cursor = Vector2(getCursorPosition());
    cursor.x, cursor.y = cursor.x * screenSize.x, cursor.y * screenSize.y;
    if(cursor.x >= x and cursor.x <= x + width and cursor.y >= y and cursor.y <= y + height)then
        return true;
    end
    return false;
end