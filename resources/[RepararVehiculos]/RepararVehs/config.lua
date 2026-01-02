config = {
	---------------------------------------- MENSAJES -----------------------------------------------------
	
	EsperarReparar = "Debes esperar un momento antes de reparar otro vehículo", -- Cuando usa 1 vez el checkpoint mensaje si entra de una otra vez
	MensajeReparando = "Empezamos tu reparación espera un momento por favor", -- Mensaje de cuando el jugador este reparando
	VidaCompleta = "El vehículo ya está completamente reparado. No es necesario repararlo", -- Vehiculo totalmente reparado
	VehExento = "Vehículo reparado. No se te ha cobrado nada. Este vehículo está exento por ser de servicio público", -- Vehiculo Extento Reparado
	MecaActivo = "Hay más de un mecánico conectado. No se puede reparar en este momento", -- Mecanico Conectados
	
	---------------------------------------- GLOBAL -----------------------------------------------------

	FaccionGlobal = 3, -- Faccion Global (se le dara el presupuesto, la que usara el comando duty)
	ValorReparo = 875000, -- Valor de la reparacion
	PresupuestoMeca = 1000, -- Presupuesto que dara cada reparacion
	TiempoReparando = 5000, -- Tiempo que demora reparando (Milisegundos)
	TiempoEsperarReparar = 10000, -- Tiempo para volver a reparar el vehiculo
	MecanicosOn = 1, -- Cuantos mecas debe haber para tirar error y no reparar
	ComandoDuty = "dutym", -- Comando Duty
	partesAbiertas = true, -- Abrir partes del vehiculo al reparar {true o false}
	SonidoReparacion = true, -- Reproducir Sonido al entrar al checkpoint {true o false}
	VehiculosExentos = {416, 433, 427, 490, 528, 407, 544, 523, 470, 596, 598, 599, 597, 432, 601, 428, 479}, --Agrega todos los carros que quieres que NO se le cobre a la hora de reparar
};


checkpointsConfig = { -- Configurar checkpoints para saber donde repara
	--{ pos = {x, y, z -1}, rgb = {r, g, b, x}, size = tamaño, tipo = "cylinder"};
	
	    { pos = {719.779296875, -454.7001953125, 16.3359375 - 1}, rgb = {255, 0, 0, 250}, size = 3, tipo = "cylinder"};
        { pos = {111.4658203125, -189.6513671875, 1.5125000476837 - 1}, rgb = {255, 0, 0, 250}, size = 3, tipo = "cylinder"};
		{ pos = {2244.931640625, 25.548828125, 26.263601303101 - 1}, rgb = {255, 0, 0, 250}, size = 3, tipo = "cylinder"};
		{ pos = {-2.6435546875, 1362.623046875, 8.9705924987793 - 1}, rgb = {255, 0, 0, 250}, size = 3, tipo = "cylinder"};
        { pos = {-653.3564453125, 954.134765625, 12.219535827637 - 1}, rgb = {255, 0, 0, 250}, size = 3, tipo = "cylinder"};
};