function stopSonidos()
    for k, v in ipairs(getElementsByType("sound")) do
        stopSound(v)
    end
    outputChatBox("Has parado todos los sonidos.", 0, 255, 0)
end
addCommandHandler("stopaudio", stopSonidos)