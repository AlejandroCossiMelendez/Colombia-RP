
addEvent("devs_Assobio", true) -- Crear un evento con nombre personalizado> Whistle Rds
addEventHandler("devs_Assobio", root, -- ¡Agregue el evento Whistle Rds para funcionar!
    function(cx, cy, cz)
        local Som = playSound3D('sonido/silvar.mp3', cx, cy, cz) -- define una variable (sonido) y crea un sonido 3D
        setSoundMaxDistance(Som, 95) -- define la distancia de la variable!
        setSoundSpeed(Som, 1.4) -- establece la velocidad de la variable!
    end -- ¡Fin de la función!
)