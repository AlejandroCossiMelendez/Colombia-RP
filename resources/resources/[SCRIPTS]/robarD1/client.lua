addEventHandler("onClientRender", root,
function()
 if (getDistanceBetweenPoints3D( 252.572265625, -54.6376953125, 1.5776442289352, getElementPosition(getLocalPlayer()))) < 5 then
  local coords = {getScreenFromWorldPosition( 252.572265625, -54.6376953125, 1.5776442289352)}
  if coords[1] and coords[2] then
   dxDrawText("Frente a la caja usa [P] para robar", coords[1], coords[2], coords[1], coords[2], tocolor(255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
  end
 end
end)