local CLIENT = triggerServerEvent;

if(CLIENT)then
    addEvent("addPlayerRichPresence", true);

    local detailsIndex = 1;
    local details = {
        "• 🔰 Staff 24/7 🔰",
        "• ⭐ Resmastered ⭐",
        "• ❄️ Trabajos Disponibles ❄️",
        "• 💎 Colombia 💎", 
        "• 🥷 Texturas Colombianas 🥷", 
        "• 🚗 Autos Reales 🚗", 
        "• 🚉 La Capital Roleplay 🚉", 
    };

    local application = {};

    function changeDetails()
        local value = details[detailsIndex];
        detailsIndex = detailsIndex + 1;
        if(detailsIndex > #details)then
            detailsIndex = 1;
        end
        return value;
    end

    function changeState(stateType)
        if(stateType == 1)then
            local playersOnline = #getElementsByType("player");
            local playerID = localPlayer:getData("playerid");
            local playerName = localPlayer:getName():gsub( " ", " " );
            return playersOnline.."/"..application.max_slots.." | ".." ID:".. playerID .." | ".. playerName;
        else
            local playerVehicle = getPedOccupiedVehicle(localPlayer);
            local playerPosition = Vector3(getElementPosition(localPlayer));
            local playerZone = getZoneName(playerPosition.x, playerPosition.y, playerPosition.z, false);
            local playerID = localPlayer:getData("playerid");
            local playerName = localPlayer:getName();
            return playerVehicle and "ID: "..playerID.." | "..playerName.." | en vehículo por "..playerZone or "ID: "..playerID.." | "..playerName.." | a pie en "..playerZone;
        end
    end

    setTimer(function() local details = changeDetails(); setDiscordRichPresenceDetails(details); end, 2000, 0);
    setTimer(function() local stateType = math.random(1, 2) local state = changeState(stateType); setDiscordRichPresenceState(state); end, 10000, 0);

    function Initialize()
        if(not isDiscordRichPresenceConnected())then return; end
        resetDiscordRichPresenceData();
        local connected = setDiscordApplicationID(application.id);
        if(connected)then
            if(application["buttons"][1].use)then setDiscordRichPresenceButton(1, application["buttons"][1].name, application["buttons"][1].link); end
            if(application["buttons"][2].use)then setDiscordRichPresenceButton(2, application["buttons"][2].name, application["buttons"][2].link); end
            setDiscordRichPresenceAsset(application.logo, application.logo_name);
            setDiscordRichPresenceStartTime(1);
        end
    end

    addEventHandler("addPlayerRichPresence", localPlayer, function(data)
        application = data;
        Initialize();
    end, false);
else
    local application = {
        id = "1407629228765347840",
        max_slots = "300",
        logo = "https://imgur.com/n3378F1.png",
        logo_name = "La Capital Roleplay",
        buttons = {
            [1] = {
                use = true,
                name = "🚉Discord🚉",
                link = "https://discord.gg/uZhyaPAezt"
            },
            [2] = {
                use = true,
                name = "💫Beta 💫",
                link = "mtasa://154.223.16.5:22015"
            }
        }
    };

    addEventHandler("onPlayerResourceStart", root, function(theResource)
        if(theResource == resource)then
            triggerClientEvent(source, "addPlayerRichPresence", source, application);
        end
    end);
end