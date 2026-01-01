local precios = {
{m = "Admiral", p = 50000, c = 4, vip = false},
{m = "Alpha", p = 155000, c = 2, vip = false},
{m = "Banshee", p = 285000, c = 2, vip = false},
{m = "BF-400", p = 100000, c = 9, vip = false},
{m = "Blade", p = 90000, c = 4, vip = false},
{m = "Blista Compact", p = 95000, c = 5, vip = false},
{m = "Bobcat", p = 68000, c = 7, vip = false},
{m = "Bravura", p = 72000, c = 5, vip = false},
{m = "Buccaneer", p = 80000, c = 4, vip = false},
{m = "Buffalo", p = 300000, c = 2, vip = false},
{m = "Bullet", p = 350000, c = 2, vip = false},
{m = "Burrito", p = 180000, c = 7, vip = false},
{m = "Cadrona", p = 50000, c = 5, vip = false},
{m = "Cheetah", p = 400000, c = 2, vip = false},
{m = "Clover", p = 38000, c = 5, vip = false},
{m = "Club", p = 55000, c = 5, vip = false},
{m = "Comet", p = 350000, c = 2, vip = false},
{m = "Elegant", p = 70000, c = 4, vip = false},
{m = "Elegy", p = 320000, c = 2, vip = false},
{m = "Emperor", p = 58000, c = 4, vip = false},
{m = "Esperanto", p = 60000, c = 4, vip = false},
{m = "Euros", p = 180000, c = 2, vip = false},
{m = "FCR-900", p = 300000, c = 9, vip = false},
{m = "Faggio", p = 25000, c = 1, vip = false},
{m = "Feltzer", p = 60000, c = 4, vip = false},
{m = "Flash", p = 85000, c = 2, vip = false},
{m = "Fortune", p = 78000, c = 5, vip = false},
{m = "Freeway", p = 67000, c = 9, vip = false},
{m = "Hermes", p = 69000, c = 5, vip = false},
{m = "Huntley", p = 500000, c = 6, vip = false},
{m = "Hustler", p = 170000, c = 2, vip = false},
{m = "Intruder", p = 58300, c = 4, vip = false},  
{m = "Jester", p = 250000, c = 2, vip = false},
{m = "Landstalker", p = 89000, c = 6, vip = false},
{m = "Manana", p = 56000, c = 1, vip = false},
{m = "Merit", p = 70000, c = 4, vip = false},
{m = "Mesa", p = 99000, c = 6, vip = false},
{m = "Moonbeam", p = 80000, c = 7, vip = false},
{m = "Nebula", p = 59000, c = 4, vip = false},
{m = "NRG-500", p = 450000, c = 2, vip = false},
{m = "Oceanic", p = 72000, c = 4, vip = false},
{m = "PCJ-600", p = 70000, c = 9, vip = false},
{m = "Perennial", p = 58000, c = 3, vip = false},
{m = "Phoenix", p = 320000, c = 2, vip = false},
{m = "Picador", p = 79000, c = 7, vip = false},
{m = "Pony", p = 110000, c = 7, vip = false},
{m = "Premier", p = 64300, c = 4, vip = false},
{m = "Primo", p = 75000, c = 4, vip = false},
{m = "Quadbike", p = 80000, c = 8, vip = false},
{m = "Rancher", p = 190000, c = 6, vip = false},
{m = "Remington", p = 89000, c = 4, vip = false},
{m = "Sandking", p = 390000, c = 6, vip = false},
{m = "Sabre", p = 450000, c = 2, vip = false},
{m = "Sadler", p = 54000, c = 1, vip = false},
{m = "Sanchez", p = 90000, c = 8, vip = false},
{m = "Savanna", p = 79000, c = 4, vip = false},
{m = "Sentinel", p = 148000, c = 4, vip = false},
{m = "Slamvan", p = 73000, c = 4, vip = false},
{m = "Stallion", p = 94000, c = 5, vip = false},
{m = "Stratum", p = 79000, c = 3, vip = false},
{m = "Sultan", p = 200000, c = 2, vip = false},
{m = "Super GT", p = 430000, c = 2, vip = false},
{m = "Sunrise", p = 93000, c = 2, vip = false},
{m = "Tahoma", p = 67200, c = 4, vip = false},
{m = "Tampa", p = 65000, c = 1, vip = false},
{m = "Tornado", p = 77000, c = 4, vip = false},
{m = "Turismo", p = 392000, c = 2, vip = false},
{m = "Infernus", p = 590000, c = 2, vip = false},
{m = "Uranus", p = 110000, c = 2, vip = false},
{m = "Vincent", p = 77000, c = 4, vip = false},
{m = "Voodoo", p = 80000, c = 4, vip = false},
{m = "Washington", p = 78000, c = 4, vip = false},
{m = "Wayfarer", p = 70200, c = 9, vip = false},
{m = "Windsor", p = 145300, c = 2, vip = false},
{m = "Willard", p = 87000, c = 4, vip = false},
{m = "Yosemite", p = 98000, c = 7, vip = false},
{m = "ZR-350", p = 120000, c = 2, vip = false},
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