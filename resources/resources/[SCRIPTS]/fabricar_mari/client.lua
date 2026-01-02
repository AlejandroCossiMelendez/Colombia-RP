addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D( 1939.6455078125, 144.74609375, 37.260635375977, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition( 1939.6455078125, 144.74609375, 37.260635375977, 13.38990)}
  if coords[1] and coords[2] then
   dxDrawText("Siembra semillas de marihuana con [H]'", coords[1], coords[2], coords[1], coords[2], tocolor(250, 250, 250), 1.00, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)