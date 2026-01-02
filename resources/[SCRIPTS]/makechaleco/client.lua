addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D( 1408.9597167969, -249.2451171875, 12.653544425964, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition( 1408.9597167969, -249.2451171875, 12.653544425964, 13.38990)}
  if coords[1] and coords[2] then
   dxDrawText("Presione  [H]  para fabricar un 'Chaleco Antibalas'", coords[1], coords[2], coords[1], coords[2], tocolor(250, 250, 250), 1.00, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)