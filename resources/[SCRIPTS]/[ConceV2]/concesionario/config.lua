vehiclesTable = {
	{model = 445, name = 'Bugatti Chiron', cost = 999999999, vip = true},
	{model = 429, name = 'Audi R8', cost = 999999999, vip = true},
	{model = 581, name = 'Kawazaki Z1', cost = 7200000, vip = false},      
	{model = 496, name = 'Renault 4', cost = 13500000, vip = false},                
	{model = 459, name = 'Furgoneta', cost = 29200000, vip = false},
	{model = 402, name = 'Ford Mustang Shelby', cost = 77200000, vip = false},
	{model = 541, name = 'Nissan GTR', cost = 999999999, vip = true},
	{model = 527, name = 'Cadrona RS', cost = 22700000, vip = false},
	{model = 542, name = 'McLaren Senna', cost = 80000000, vip = false},
	{model = 463, name = 'Moto Clasica', cost = 24700000, vip = false},
	{model = 589, name = 'Volkswagen Gol', cost = 11200000, vip = false},
	{model = 480, name = 'Coche Ruso', cost = 34700000, vip = false},
	{model = 507, name = 'Chevrolet Spark GT', cost = 11500000, vip = false},
	{model = 562, name = 'Nissan Skyline', cost = 23500000, vip = false},
	{model = 585, name = 'Jeep Cherokee', cost = 55720000, vip = false},
	{model = 587, name = 'Jeep Wrangler', cost = 14200000, vip = false},
	{model = 521, name = 'Yamaha MT-09', cost = 47500000, vip = false},
	{model = 462, name = 'Yamaha N-Max', cost = 8720000, vip = false},
	{model = 533, name = 'Toyota Supra', cost = 30100000, vip = false},
	{model = 565, name = 'Chevrolet Spark', cost = 12700000, vip = false},
	{model = 526, name = 'Mercedez AMG', cost = 13400000, vip = false},
	{model = 579, name = 'Toyota VX-R', cost = 200000000, vip = false},
	{model = 546, name = 'Ford Ranger', cost = 82900000, vip = false}, --ParcheAgogo
	{model = 559, name = 'Lamborghini Murcielago', cost = 999999999, vip = true},
	{model = 400, name = 'Cadillac Scalade', cost = 225000000, vip = false},
	{model = 510, name = 'Cicla Gravity', cost = 980000, vip = false},
	{model = 551, name = 'Dodge Charger SRT', cost = 18700000, vip = false},
	{model = 500, name = 'Toyota Prado', cost = 89700000, vip = false},
	{model = 516, name = 'Lexus LX-570', cost = 120000000, vip = false},
	{model = 522, name = 'Ninja H2R', cost = 999999999, vip = true},
	{model = 467, name = 'Oceanic', cost = 7800000, vip = false},
	{model = 461, name = 'Pulsar NS-200', cost = 5000000, vip = false},
	{model = 404, name = 'Toyota 4Runner', cost = 87500000, vip = false},
	{model = 603, name = 'Toyota Supra MK5', cost = 22700000, vip = false}, --ParcheAgogo
	{model = 426, name = 'BMW X4', cost = 42500000, vip = false},
	{model = 471, name = 'Cuatrimoto', cost = 11700000, vip = false},
	{model = 489, name = 'Ford Raptor', cost = 93000000, vip = false},
	{model = 468, name = 'Yamaha DT', cost = 5800000, vip = false},
	{model = 405, name = 'Ford Explorer', cost = 42500000, vip = false},
	{model = 458, name = 'Mitsubishi Pajero', cost = 32760000, vip = false},
	{model = 580, name = 'Bentley Continental', cost = 999999999, vip = true},
	{model = 492, name = 'Toyota Tundra', cost = 999999999, vip = true},
	{model = 560, name = 'Mercedez GT-63', cost = 60750000, vip = false},
	{model = 506, name = 'Tesla', cost = 999999999, vip = true},
	{model = 550, name = 'Lamborghini Urus', cost = 320000000, vip = false},
	{model = 451, name = 'Dodge Challenger', cost = 52000000, vip = false},
	{model = 411, name = 'Lamborghini Tuning', cost = 999999999, vip = true},
	{model = 529, name = 'Hummer H3', cost = 77800000, vip = false},
	{model = 554, name = 'Toyota Hilux', cost = 37500000, vip = false},
	{model = 586, name = 'Suzuki DR650', cost = 36000000, vip = false},

	}


-- vehiclearker --

posMaker = {
	{posx = 108.188,posy =  -156.200, posz = 1.882, r = 255, g = 0, b = 255,  price = math.random(0, 1000)},
}
-- variables globals --
isPlayerBuy = false

-- funcions globales
function nose ()
	vehPrev = {}
	for i, v in ipairs(vehiclesTable) do
		table.insert(vehPrev, {v.model, v.name, v.cost, v.vip})
	end
end 

function vehicleCreatePreview(model, x, y, z)
	if isElement(vehicle) then
		destroyElement(vehicle)
		killTimer(timer)
	end
	vehicle = createVehicle(model, x, y, z)
	setElementFrozen(vehicle, true)
	timer = setTimer(function()
		if isElement(vehicle) then
			local rx, ry, rz = getElementRotation(vehicle)
			setElementRotation(vehicle, rx, ry, rz + 0.3)
		end
	end, 1, 0)
end





function deleteVehicle()
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
end

function NumerosComas(number)
    return tostring(number):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,", "")
end