createPickup(2410.0146484375, 99.486328124, 27.96773147583-1.7, 3, 1210)


function sonido()
martilla = playSound("martillo.mp3")
setSoundVolume(martilla, 0.3)
end
addEvent("sonido", true)
addEventHandler("sonido", getRootElement(), sonido)

function sonido2()
martilla2 = playSound("martillo.mp3")
    setSoundVolume(martilla2, 0.3)

    end
    addEvent("sonido2", true)
    addEventHandler("sonido2", getRootElement(), sonido2)