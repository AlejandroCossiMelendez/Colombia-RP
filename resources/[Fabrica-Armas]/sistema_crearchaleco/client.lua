addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D(346.5862121582, -715.97149658203, 11.873379707336, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition(346.5862121582, -715.97149658203, 11.873379707336, 13.38990)}
  if coords[1] and coords[2] then
   dxDrawText("Presione  [H]  para fabricar un 'Chaleco Antibalas'", coords[1], coords[2], coords[1], coords[2], tocolor(250, 250, 250), 1.00, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)