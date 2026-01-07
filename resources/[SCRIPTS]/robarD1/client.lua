addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D( 254.96875, -54.833984375, 1.5703125, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition( 254.96875, -54.833984375, 1.5703125)}
  if coords[1] and coords[2] then
   dxDrawText("Frente a la caja usa [P] para robar", coords[1], coords[2], coords[1], coords[2], tocolor(255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)