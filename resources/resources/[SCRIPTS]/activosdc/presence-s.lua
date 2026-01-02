--[[
    https://discord.com/developers/applications <- LINK DISCORD DEVELOPERS PAGE
    CREATE APPLICATION (WITH YOUR SERVER NAME)
    INSERT YOUR SERVER LOGO
    COPY THIS APPLICATION ID
--]]

local application = {

    id = "1129236664368238602",
    logo = "https://i.imgur.com/HHWYY3T.png",
    logo_staff = "https://i.imgur.com/HHWYY3T.png",
    logo_info = "TOP 1 COLOMBIA [MTA] 🏆",

    
    buttons = {
        [1] = {
            use = true,
            name = "✈️WEB✈️",
            link = "https://beacons.ai/mta.versorp"
        },

        [2] = {
            use = true,
            name = "🌐Jugar Verso🌐",
            link = "mtasa://51.81.48.177:22511"
        }
    },

    detailsList = {
        "↬ 🌍 Mapa Unico",
        "↬ 💵 Economía Realista",
        "↬ 💻 Optimizado",
        "↬ 👓 Sistemas Unicos",
        "↬ 🚘 Carros Exclusivos",
        "↬ 💼 Trabajos Disponibles",
        "↬ 🧙‍ Staff Activo",
        "↬ 🏝️ Rol Serio",
    }
};

addEventHandler("onPlayerResourceStart", root,
    function(theResource)
        if (theResource == resource) then
            triggerClientEvent(source, "addPlayerRichPresence", source, application);
        end
    end
);