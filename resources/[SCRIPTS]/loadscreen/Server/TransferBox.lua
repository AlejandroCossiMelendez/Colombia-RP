addEventHandler("onResourceStart", resourceRoot, function() setTransferBoxVisible(false); end);

addEventHandler("onPlayerJoin", root, function()
    showCursor(source, false);
end);   