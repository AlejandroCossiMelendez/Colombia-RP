local objects = {
    {modelID = 3499, distance = 3000}, -- Primer objeto
    {modelID = 3524, distance = 3000},
    {modelID = 3524, distance = 1851},
    {modelID = 3524, distance = 2694},
    {modelID = 3524, distance = 10946},
    {modelID = 3524, distance = 3483},
    {modelID = 3524, distance = 3484},
    {modelID = 3524, distance = 3485},
    {modelID = 3524, distance = 3486},
    {modelID = 3524, distance = 3487},
    {modelID = 3524, distance = 1232},
    {modelID = 3524, distance = 3115},
    {modelID = 3524, distance = 5154},
    {modelID = 3524, distance = 5155},
    {modelID = 3524, distance = 5156 },
    {modelID = 3524, distance = 5157},
    {modelID = 3524, distance = 5158},
    {modelID = 3524, distance = 5160},
    {modelID = 3524, distance = 5166},
    {modelID = 3524, distance = 5167},
    {modelID = 3524, distance = 3886},
    {modelID = 3524, distance = 7102},
    {modelID = 3524, distance = 3585},
    {modelID = 3524, distance = 3585},
    {modelID = 3524, distance = 3575},

	{modelID = 3524, distance = 2927} -- Segundo objeto
	
}

-- Función para aplicar las distancias de dibujado y crear los objetos
addEventHandler("onClientResourceStart", resourceRoot, function()
    for _, obj in ipairs(objects) do
        -- Ajustar la distancia de LOD para cada modelo
        engineSetModelLODDistance(obj.modelID, obj.distance)
    end
end)
