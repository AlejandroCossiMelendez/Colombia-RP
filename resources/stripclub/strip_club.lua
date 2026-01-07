local stripClubPeds = { -- Lista de NPCs con su posición, skin, interior, dimensión y animación
    {x = 1208.1416, y = -6.4638, z = 1001.3281, rot = 180, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_A"},
    {x = 1214.6777, y = -4.7695, z = 1001.3281, rot = 90, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_B"},
    {x = 1218.2001, y = -8.1738, z = 1001.3281, rot = 180, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_C"},
    {x = 1219.1298, y = -4.8818, z = 1001.3281, rot = 0, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_D"},
    {x = 1222.8125, y = -2.2138, z = 1001.3281, rot = 180, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_E"},
    {x = 1222.4960, y = -11.6894, z = 1001.3281, rot = 180, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_F"},
    {x = 1220.9570, y = 7.7822, z = 1001.3356, rot = 180, skin = 152, interior = 2, dimension = 370, animBlock = "STRIP", animName = "strip_G"},
    {x = 1203.9648, y = 16.6045, z = 1000.9218, rot = 151.7921, skin = 152, interior = 2, dimension = 372, animBlock = "STRIP", animName = "strip_D"}, -- Última bailarina en dimensión 372
      
    {x = 1268.994140625, y = -800.4697265625, z = 88.305015563965, rot = 237.93179321289, skin = 152, interior = 0, dimension = 0, animBlock = "STRIP", animName = "strip_G"},   
    {x = 1274.462890625, y = -811.09765625, z = 88.315116882324, rot = 359.75006103516, skin = 152, interior = 0, dimension = 0, animBlock = "STRIP", animName = "strip_B"},
    {x = 1289.2177734375, y = -803.75390625, z = 88.315124511719, rot = 66.624847412109, skin = 152, interior = 0, dimension = 0, animBlock = "STRIP", animName = "strip_G"},
    {x = 1290.482421875, y = -794.9521484375, z = 88.3125, rot = 132.29113769531, skin = 152, interior = 0, dimension = 0, animBlock = "STRIP", animName = "strip_D"},
    
    -- Agregamos más bailarinas con otras animaciones
    --{x = 1258.8, y = -499.3, z = 35.2, rot = 135, skin = 152, interior = 0, dimension = 0, animBlock = "CLUB", animName = "clubdance_loop"}, 
    --{x = 1260.2, y = -503.5, z = 35.2, rot = 315, skin = 152, interior = 0, dimension = 0, animBlock = "DANCING", animName = "dance_loop"},
   -- {x = 1262.6, y = -500.8, z = 35.2, rot = 45, skin = 152, interior = 0, dimension = 0, animBlock = "PED", animName = "IDLE_tired"},
   -- {x = 1264.0, y = -502.4, z = 35.2, rot = 90, skin = 152, interior = 0, dimension = 0, animBlock = "STRIP", animName = "strip_G"},
   {x = 1208.3339, y = -5.2607, z = 1001.3281, rot = 94.9481, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_A"},
{x = 1208.3759, y = -7.8027, z = 1001.3281, rot = 86.3072, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_B"},
{x = 1214.8203, y = -4.9902, z = 1001.3281, rot = 43.5203, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_C"},
{x = 1218.4209, y = -4.7871, z = 1001.3281, rot = 356.4156, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_D"},
{x = 1217.9307, y = -8.3975, z = 1001.3281, rot = 179.5276, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_E"},
{x = 1223.0010, y = -12.0234, z = 1001.3281, rot = 124.5786, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_F"},
{x = 1222.8164, y = -1.9697, z = 1001.3281, rot = 34.2147, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_G"},
{x = 1223.3311, y = -6.5000, z = 1001.3281, rot = 87.9826, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_H"},
{x = 1221.4434, y = 8.6221, z = 1001.3356, rot = 130.1268, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_I"},
{x = 1203.9707, y = 16.6875, z = 1000.9219, rot = 137.4109, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_J"},
{x = 1203.0254, y = -8.4727, z = 1002.0255, rot = 266.7439, skin = 152, interior = 2, dimension = 481, animBlock = "STRIP", animName = "strip_K"},

}  

function crearBailarinas()
    for _, pedData in ipairs(stripClubPeds) do
        local ped = createPed(pedData.skin, pedData.x, pedData.y, pedData.z, pedData.rot)
        setElementInterior(ped, pedData.interior) -- Asignar interior correcto
        setElementDimension(ped, pedData.dimension) -- Asignar dimensión correcta
        setElementFrozen(ped, true) -- Para que no caminen

        -- Esperar 1 segundo antes de aplicar la animación para evitar bugs
        setTimer(function()
            if isElement(ped) then
                setPedAnimation(ped, pedData.animBlock, pedData.animName, -1, true, false, false) -- Diferentes animaciones para cada NPC
            end
        end, 1000, 1)
    end
end
addEventHandler("onResourceStart", resourceRoot, crearBailarinas)  