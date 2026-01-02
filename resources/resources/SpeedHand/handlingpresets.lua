local predefinedHandling = {

	[426] = {
		["engineAcceleration"] = 14,
		["dragCoeff"] = 0,
		["maxVelocity"] = 150,
		["tractionMultiplier"] = 0.7,
		["tractionLoss"] = 1.1,
	},
	[585] = {
		["engineAcceleration"] = 14,
		["dragCoeff"] = 0,
		["maxVelocity"] = 190,
		["tractionMultiplier"] = 0.7,
		["tractionLoss"] = 1.1,
	},
		[533] = { -- Elegy Default Drift Ayarı - Bu Şekilde Bir Aracın Handını Ayarlaya Bilirsiniz.
		["driveType"] = "rwd",
		["engineAcceleration"] = 200,
		["dragCoeff"] = 1.5,
		["maxVelocity"] = 300,
		["tractionMultiplier"] = 0.7,
		["tractionLoss"] = 0.8,
		["collisionDamageMultiplier"] = 0.4,
		["engineInertia"] = -175,
		["steeringLock"] = 75,
		["numberOfGears"] = 4,
		["suspensionForceLevel"] = 0.8,
		["suspensionDamping"] = 0.8,
		["suspensionUpperLimit"] = 0.33,
		["suspensionFrontRearBias"] = 0.3,
		["mass"] = 1800,
		["turnMass"] = 3000,
		["centerOfMass"] = { [1]=0, [2]=-0.2, [3]=-0.5 }, -- Good example to understand centerOfMass parameter usage
	},

	--next model below etc (copy rows)
}

for i,v in pairs (predefinedHandling) do
	if i then
		for handling, value in pairs (v) do
			if not setModelHandling (i, handling, value) then
				outputDebugString ("* Predefined handling '"..tostring(handling).."' for vehicle model '"..tostring(i).."' could not be set to '"..tostring(value).."'")
			end
		end
	end
end

for _,v in ipairs (getElementsByType("vehicle")) do
	if v and predefinedHandling[getElementModel(v)] then
		for k,vl in pairs (predefinedHandling[getElementModel(v)]) do
			setVehicleHandling (v, k, vl)
		end
	end
end

function resetHandling()
	for model in pairs (predefinedHandling) do
		if model then
			for k in pairs(getOriginalHandling(model)) do
				setModelHandling(model, k, nil)
			end
		end
	end

	for _,v in ipairs (getElementsByType("vehicle")) do
		if v then
			local model = getElementModel(v)
			if predefinedHandling[model] then
				for k,h in pairs(getOriginalHandling(model)) do
					setVehicleHandling(v, k, h)
				end
			end
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, resetHandling)