addCommandHandler("checkcef", function()
    if isBrowserSupported() then
        outputChatBox("CEF está habilitado y funcionando en tu cliente.", 0, 255, 0)
    else
        outputChatBox("CEF no está habilitado o no funciona en tu cliente.", 255, 0, 0)
    end
end)
