local precios = {
{m = "Admiral", p = 999, c = 1, vip = true},
{m = "Banshee", p = 999, c = 13, vip = true},
{m = "BF-400", p = 37200000, c = 9, vip = false},
{m = "Blade", p = 9500000, c = 4, vip = false},
{m = "Blista Compact", p = 13500000, c = 1, vip = false},
{m = "Bobcat", p = 170000000, c = 10, vip = false},
{m = "Berkley's RC Van", p = 29200000, c = 10, vip = false},	
{m = "Bravura", p = 9500000, c = 5, vip = false},
{m = "Buffalo", p = 75354000, c = 6, vip = false},
{m = "Bullet", p = 999, c = 13, vip = true},
{m = "Camper", p = 7000000, c = 5, vip = false},
{m = "Cadrona", p = 17000000, c = 12, vip = false},
{m = "Clover", p = 80000000, c = 1, vip = false},
{m = "Club", p = 7000000, c = 12, vip = false},
{m = "Comet", p = 34700000, c = 3, vip = false},
{m = "DFT-30", p = 37500000, c = 3, vip = false},
{m = "Elegant", p = 9830000, c = 2, vip = false},
{m = "Elegy", p = 18000000, c = 1, vip = false},
{m = "Emperor", p = 53600000, c = 1, vip = false},
{m = "Esperanto", p = 45000000, c = 1, vip = false},
{m = "Euros", p = 12400000, c = 5, vip = false},
{m = "FCR-900", p = 45700000, c = 1, vip = false},
{m = "Faggio", p = 7300000, c = 1, vip = false},
{m = "Feltzer", p = 20500000, c = 1, vip = false},
{m = "Flash", p = 12000000, c = 1, vip = false},
{m = "Fortune", p = 11000000, c = 1, vip = false},
{m = "Hermes", p = 5500000, c = 1, vip = false},
{m = "Huntley", p = 200000000, c = 6, vip = false},
{m = "Hustler", p = 2000000, c = 1, vip = false},
{m = "Intruder", p = 100000000, c = 1, vip = false},  
{m = "Jester", p = 999, c = 13, vip = true},
{m = "Landstalker", p = 225000000, c = 6, vip = false},
{m = "Mountain Bike", p = 970000, c = 1, vip = false},
{m = "Manana", p = 19000000, c = 1, vip = false},
{m = "Merit", p = 18000000, c = 1, vip = false},
{m = "Mesa", p = 17000000, c = 12, vip = false},
{m = "Nebula", p = 110000000, c = 1, vip = false},
{m = "NRG-500", p = 999, c = 1, vip = true},
{m = "Oceanic", p = 3500000, c = 1, vip = false},
{m = "PCJ-600", p = 5000000, c = 10, vip = false},
{m = "Perennial", p = 63500000, c = 1, vip = false},
{m = "Phoenix", p = 22700999, c = 4, vip = false},
{m = "Picador", p = 4500000, c = 1, vip = false},
{m = "Pony", p = 15000000, c = 1, vip = false},
{m = "Premier", p = 34700000, c = 5, vip = false},
{m = "Primo", p = 11700000, c = 2, vip = false},
{m = "Quadbike", p = 35000000, c = 1, vip = false},
{m = "Rancher", p = 43000000, c = 3, vip = false},
{m = "Regina", p = 170000000, c = 3, vip = false},
{m = "Romero", p = 35000000, c = 3, vip = false},
{m = "Sandking", p = 30000000, c = 1, vip = false},
{m = "Sadler", p = 1000000, c = 1, vip = false},
{m = "Sanchez", p = 4200000, c = 10, vip = false},
{m = "Sabre", p = 3200000, c = 10, vip = false},
{m = "Savanna", p = 6500000, c = 4, vip = false},
{m = "Sentinel", p = 40000000, c = 1, vip = false},
{m = "Slamvan", p = 5000000, c = 4, vip = false},
{m = "Solair", p = 24500000, c = 1, vip = false},
{m = "Stafford", p = 999, c = 1, vip = true},
{m = "Greenwood", p = 999, c = 1, vip = true},
{m = "Sultan", p = 60000000, c = 1, vip = false},
{m = "Super GT", p = 999, c = 13, vip = true},
{m = "Sunrise", p = 450000000, c = 2, vip = false},
{m = "Tahoma", p = 75000000, c = 4, vip = false},
{m = "Tampa", p = 11500000, c = 12, vip = false},
{m = "Tornado", p = 9000000, c = 4, vip = false},
{m = "Turismo", p = 48500000, c = 8, vip = false},
{m = "Infernus", p = 999, c = 13, vip = true},
{m = "Uranus", p = 13000000, c = 2, vip = false},
{m = "Voodoo", p = 12000000, c = 4, vip = false},
{m = "Washington", p = 3000000, c = 1, vip = false},
{m = "Vincent", p = 35700000, c = 1, vip = false},
{m = "Willard", p = 75500000, c = 13, vip = false},
{m = "Yosemite", p = 25000000, c = 12, vip = false},
{m = "Wayfarer", p = 35800000, c = 12, vip = false},
}


function getDatos()
	return precios
end	

function getPrecioFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.p
			end	
		end
	end
end

function getClaseFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.c
			end	
		end
	end
end

function isModelVIP (model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return v.vip
			end
		end
	end
end

function getCosteRenovacionFromModel(model)
	if model then
		for k, v in ipairs(precios) do
			if v.m == tostring(model) then
				return math.floor(v.p*0.1667)
			end
		end
	end
end