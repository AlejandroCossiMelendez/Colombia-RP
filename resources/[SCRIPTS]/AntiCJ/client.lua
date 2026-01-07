local screenWidth, screenHeight = guiGetScreenSize()

function showCJNotification()
    dxDrawText("No cometas CJ o recae en sanción", screenWidth / 2 - 150, screenHeight / 2 - 20, screenWidth / 2 + 150, screenHeight / 2 + 20, tocolor(255, 0, 0), 1, "default-bold", "center", "center")
end
addEvent("showCJNotification", true)
addEventHandler("showCJNotification", resourceRoot, showCJNotification)
