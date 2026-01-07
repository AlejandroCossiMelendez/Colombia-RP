local loading = {};
loading.fonts = {
    medium = dxCreateFont("Files/Fonts/Font-Medium.ttf", math.ceil(screenScale * 16)),
    regular = dxCreateFont("Files/Fonts/Font-Regular.ttf", math.ceil(screenScale * 14))
};

loading.textures = {
    background = dxCreateTexture("Files/Assets/background.png", "argb", true, "clamp"),
    discord = dxCreateTexture("Files/Assets/discord.png", "argb", true, "clamp"),
    gradient = dxCreateTexture("Files/Assets/gradient.png", "argb", true, "clamp"),
    left = dxCreateTexture("Files/Assets/left.png", "argb", true, "clamp"),
    news = dxCreateTexture("Files/Assets/news.png", "argb", true, "clamp"),
    picture = dxCreateTexture("Files/Assets/picture.png", "argb", true, "clamp"),
    tiktok = dxCreateTexture("Files/Assets/tiktok.png", "argb", true, "clamp"),
    twitch = dxCreateTexture("Files/Assets/twitch.png", "argb", true, "clamp")
};

-- Tema cromático y utilidades estéticas
loading.theme = {
    primary = {0, 56, 168},         -- Azul bandera
    secondary = {252, 209, 22},     -- Amarillo bandera
    accent = {206, 17, 38},         -- Rojo bandera
    shadow = {0, 0, 0},
    panel = {12, 14, 20},           -- Panel oscuro neutro
};

local function rgba(color, alpha)
    return tocolor(color[1], color[2], color[3], alpha or 255);
end

local function drawTextWithShadow(text, x, y, w, h, color, scale, font, alignX, alignY, clip)
    dxDrawText(text, x + screenScale * 1.5, y + screenScale * 1.5, w, h, tocolor(0, 0, 0, 160), scale, font, alignX, alignY, clip);
    dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip);
end

loading.sequences = {
    {
        image = dxCreateTexture("Files/Assets/Sequences/1.png", "argb", true, "clamp"), 
    },
    {
        image = dxCreateTexture("Files/Assets/Sequences/2.png", "argb", true, "clamp"),
    },
    {
        image = dxCreateTexture("Files/Assets/Sequences/3.png", "argb", true, "clamp"),
    },
    {
        image = dxCreateTexture("Files/Assets/Sequences/4.png", "argb", true, "clamp"),
    }
};

loading.sequenceWidth = math.floor(screenScale * 300);
loading.sequenceHeight = math.floor(screenScale * 220);

loading.padding = math.floor(screenScale * 10);
loading.offset = loading.padding / 2;
loading.roundedCorners = math.floor(screenScale * 12);

loading.index = 1;
loading.last = #loading.sequences;
loading.selected = 1;

loading.downloaded = "";
loading.total = "";
loading.percentage = 0;
loading.wasActive = false;

local function renderBox()
    if(isTransferBoxActive() == true)then
        if(not loading.wasActive)then
            showChat(false);
            loading.wasActive = true;
        end
        local cursor = Vector2(getCursorPosition()) or 0;
        loading.x = - cursor.x * loading.padding;
        loading.y = - cursor.y * loading.padding;

        dxDrawImage(loading.x, loading.y, screenSize.x + loading.padding, screenSize.y + loading.padding, loading.textures.background);
        -- Vignette y tintes bandera (amarillo, azul, rojo) sutiles
        dxDrawImage(0, 0, screenSize.x, screenSize.y, loading.textures.gradient, 0, 0, 0, tocolor(0, 0, 0, 220));
        dxDrawImage(0, 0, screenSize.x, screenSize.y, loading.textures.gradient, -30, 0, 0, rgba(loading.theme.primary, 30));
        dxDrawImage(0, 0, screenSize.x, screenSize.y, loading.textures.gradient, 30, 0, 0, rgba(loading.theme.secondary, 35));
        dxDrawImage(0, 0, screenSize.x, screenSize.y, loading.textures.gradient, 60, 0, 0, rgba(loading.theme.accent, 25));

        -- Panel de contenido para organizar carrusel y actualizaciones
        local cpX = loading.padding * 3.5;
        local cpY = loading.padding * 23;
        local cpW = loading.sequenceWidth + loading.padding * 8;
        local cpH = loading.sequenceHeight + loading.padding * 22;
        dxDrawRectangle(cpX, cpY, cpW, cpH, tocolor(loading.theme.panel[1], loading.theme.panel[2], loading.theme.panel[3], 165));
        -- Bordes sutiles tricolor
        dxDrawRectangle(cpX, cpY, cpW, screenScale * 1, rgba(loading.theme.secondary, 210));
        dxDrawRectangle(cpX, cpY + cpH - screenScale * 1, cpW, screenScale * 1, rgba(loading.theme.primary, 210));
        dxDrawRectangle(cpX, cpY, screenScale * 1, cpH, rgba(loading.theme.accent, 200));

        dxDrawImage(0, 0, screenSize.x, screenSize.y, loading.textures.left, 0, 0, 0, tocolor(255, 255, 255, 255));
        drawTextWithShadow("Bienvenido a", loading.padding * 4, loading.padding * 4, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "top", true);
        drawTextWithShadow("LA CAPITAL RP", loading.padding * 4, loading.padding * 6, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.medium, "left", "top", true);

        local welcomeWidth = dxGetTextWidth("Bienvenido a", 1, loading.fonts.regular);
        local mainTitleWidth = dxGetTextWidth("LA CAPITAL RP", 1, loading.fonts.medium);
        dxDrawRectangle(welcomeWidth + loading.padding * 5, loading.padding * 5.25, loading.padding * 10, screenScale * 1, rgba(loading.theme.secondary, 255));
        dxDrawRectangle(loading.padding * 4, loading.padding * 10, mainTitleWidth, screenScale * 1, rgba(loading.theme.primary, 255));
        dxDrawRectangle(loading.padding * 4, loading.padding * 10 + screenScale * 1.8, mainTitleWidth, screenScale * 0.6, rgba(loading.theme.accent, 255));

        drawTextWithShadow("Momentos en el servidor", loading.padding * 4, loading.padding * 16, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "top", true);
        drawTextWithShadow("Últimas imagenes del servidor", loading.padding * 4, loading.padding * 18, screenSize.x, screenSize.y, tocolor(255, 255, 255, 200), 1, loading.fonts.regular, "left", "top", true);

        dxDrawImage(loading.padding * 4, loading.padding * 24, loading.padding * 3.2, loading.padding * 3.2, loading.textures.picture, 0, 0, 0, tocolor(255, 255, 255, 255));

        drawTextWithShadow("Presiona las flechas para\ncambiar las imagenes", - (screenSize.x - loading.padding * 40), loading.padding * 28, screenSize.x, screenSize.y, tocolor(255, 255, 255, 240), 1, loading.fonts.medium, "center", "top", true);

        dxDrawText("<", loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), screenSize.x, screenSize.y,
            isMouseHovering(loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), loading.padding * 2, loading.padding * 2) and rgba(loading.theme.accent, 220) or rgba(loading.theme.primary, 220),
            1, loading.fonts.regular, "left", "top", true);
        for i = loading.index, loading.last do
            local selected = loading.sequences[loading.selected].image;
            dxDrawImage(loading.padding * 5, loading.padding * 36, loading.sequenceWidth, loading.sequenceHeight, selected, 1, 0, 0, tocolor(255, 255, 255, i == loading.index and 255 or 0));
        end
        dxDrawText(">", loading.padding * 5 + loading.sequenceWidth + loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), screenSize.x, screenSize.y,
            isMouseHovering(loading.padding * 5 + loading.sequenceWidth + loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), loading.padding * 2, loading.padding * 2) and rgba(loading.theme.accent, 220) or rgba(loading.theme.primary, 220),
            1, loading.fonts.regular, "left", "top", true);

        drawTextWithShadow("Actualizaciones", loading.padding * 4, loading.padding * 28, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "center", true);
        drawTextWithShadow("Últimas actualizaciones", loading.padding * 4, loading.padding * 32, screenSize.x, screenSize.y, tocolor(255, 255, 255, 200), 1, loading.fonts.regular, "left", "center", true);

        local offsetY = loading.padding * 48;
        for i = 1, 6 do
            local row = news[i];
            dxDrawText("•", loading.padding * 5.5, offsetY, screenSize.x, screenSize.y, rgba(loading.theme.accent, 255), 1, loading.fonts.regular, "left", "center", true);
            drawTextWithShadow(row.row, loading.padding * 7, offsetY, screenSize.x - (screenSize.x - loading.padding * 34), screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "center", true);

            offsetY = offsetY + loading.padding * 5;
        end

        dxDrawImage(loading.padding * 4, screenSize.y / 2 + loading.padding * 18, loading.padding * 3.2, loading.padding * 3.2, loading.textures.news, 0, 0, 0, tocolor(255, 255, 255, 255));

        drawTextWithShadow("Siguenos en nuestras redes sociales", loading.padding * 4, screenSize.y - loading.padding * 10, screenSize.x, screenSize.y, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "top", true);

        dxDrawImage(loading.padding * 4, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2, loading.textures.discord, 0, 0, 0,
            isMouseHovering(loading.padding * 4, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2) and rgba(loading.theme.primary, 220) or tocolor(255, 255, 255, 255));
        dxDrawImage(loading.padding * 8, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2, loading.textures.tiktok, 0, 0, 0,
            isMouseHovering(loading.padding * 8, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2) and rgba(loading.theme.accent, 220) or tocolor(255, 255, 255, 255));
        dxDrawImage(loading.padding * 12, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2, loading.textures.twitch, 0, 0, 0,
            isMouseHovering(loading.padding * 12, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2) and rgba(loading.theme.primary, 220) or tocolor(255, 255, 255, 255));

        local triW = loading.padding * 18;
        local seg = triW / 3;
        local barX = loading.padding * 16;
        local barY = screenSize.y - loading.padding * 4.5;
        dxDrawRectangle(barX, barY, seg, screenScale * 1, rgba(loading.theme.secondary, 255));
        dxDrawRectangle(barX + seg, barY, seg, screenScale * 1, rgba(loading.theme.primary, 255));
        dxDrawRectangle(barX + seg * 2, barY, seg, screenScale * 1, rgba(loading.theme.accent, 255));

        drawTextWithShadow("Por favor espera, el servidor está cargando... ("..loading.percentage.."%)", loading.padding * 40, 0, screenSize.x, screenSize.y - loading.padding * 6, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "left", "bottom", true);
        dxDrawText(loading.downloaded.." MB de "..loading.total.." MB", 0, 0, screenSize.x - loading.padding * 4, screenSize.y - loading.padding * 4, tocolor(255, 255, 255, 255), 1, loading.fonts.regular, "right", "bottom", true);

        local width = screenSize.x - loading.padding * 68;
        -- Fondo barra de progreso
        dxDrawRectangle(loading.padding * 40, screenSize.y - loading.padding * 5.5, width, loading.padding, tocolor(255, 255, 255, 35));
        -- Progreso tricolor (amarillo, azul, rojo)
        local filled = width * (loading.percentage / 100);
        if(filled > 0) then
            local third = filled / 3;
            dxDrawRectangle(loading.padding * 40, screenSize.y - loading.padding * 5.5, third, loading.padding, rgba(loading.theme.secondary, 230));
            dxDrawRectangle(loading.padding * 40 + third, screenSize.y - loading.padding * 5.5, third, loading.padding, rgba(loading.theme.primary, 230));
            dxDrawRectangle(loading.padding * 40 + third * 2, screenSize.y - loading.padding * 5.5, filled - third * 2, loading.padding, rgba(loading.theme.accent, 230));
        end
        -- Brillo animado
        local tick = getTickCount() % 1800;
        local t = tick / 1800;
        local glossWidth = math.max(loading.padding * 2.5, filled * 0.15);
        local glossX = loading.padding * 40 + (filled - glossWidth) * t;
        if(filled > 0) then
            dxDrawRectangle(glossX, screenSize.y - loading.padding * 5.5, glossWidth, loading.padding, tocolor(255, 255, 255, 70));
        end

        -- Indicadores del carrusel (puntos) con leve sombra y colores alternos bandera
        local indicatorsY = loading.padding * 36 + loading.sequenceHeight + loading.padding * 2.5;
        local dotSize = loading.padding * 0.9;
        local dotsGap = loading.padding * 0.8;
        local startX = loading.padding * 5;
        for i = 1, loading.last do
            local base = (i % 3 == 1) and loading.theme.secondary or ((i % 3 == 2) and loading.theme.primary or loading.theme.accent);
            local color = (i == loading.selected) and rgba(base, 255) or tocolor(base[1], base[2], base[3], 130);
            dxDrawRectangle(startX + (i - 1) * (dotSize + dotsGap) + 1, indicatorsY + 1, dotSize, dotSize, tocolor(0, 0, 0, 110));
            dxDrawRectangle(startX + (i - 1) * (dotSize + dotsGap), indicatorsY, dotSize, dotSize, color);
        end
    else
        if(loading.wasActive)then
            showChat(true);
            loading.wasActive = false;
        end
    end
end
addEventHandler("onClientRender", root, renderBox);

local function clickManager(button, state)
    if(isTransferBoxActive() == true)then
        if(button == "left" and state == "down")then
            if(isMouseHovering(loading.padding * 4, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2))then -- @discord
                setClipboard("https://discord.gg/eZ8Jc3nZ2G");
            elseif(isMouseHovering(loading.padding * 8, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2))then -- @tiktok
                setClipboard("https://www.tiktok.com/@proyecto_paisa");
            elseif(isMouseHovering(loading.padding * 12, screenSize.y - loading.padding * 6, loading.padding * 3.2, loading.padding * 3.2))then -- @twitch
                setClipboard("https://www.twitch.tv/brahiangil77");
            elseif(isMouseHovering(loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), loading.padding * 2, loading.padding * 2))then -- @left
                if(loading.selected < loading.last)then
                    loading.selected = loading.selected + 1;
                end
            elseif(isMouseHovering(loading.padding * 5 + loading.sequenceWidth + loading.padding * 2, loading.padding * 35.5 + (loading.sequenceHeight / 2), loading.padding * 2, loading.padding * 2))then -- @right
                if(loading.selected > loading.index)then
                    loading.selected = loading.selected - 1;
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, clickManager);

local function updateProgress(downloadedSize, totalSize)
    if(isTransferBoxActive() == true)then
        local percentage = math.floor(math.min((downloadedSize / totalSize) * 100, 100));
        local downloaded = string.format("%.2f", downloadedSize / 1024 / 1024);
        local total = string.format("%.2f", totalSize / 1024 / 1024);
        loading.downloaded = downloaded;
        loading.total = total;
        loading.percentage = percentage;
        
    else
        loading.downloaded = "";
        loading.total = "";
        loading.percentage = 0;
    end
end
addEventHandler("onClientTransferBoxProgressChange", root, updateProgress);