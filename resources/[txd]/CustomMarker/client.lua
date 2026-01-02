addEventHandler("onClientResourceStart", resourceRoot,
function()
	shwaeki = dxCreateShader( "Arquivos/Castiel.fx" )
	texture = dxCreateTexture("Arquivos/marker.png")
	dxSetShaderValue(shwaeki, "MarkerSkin", texture)
	engineApplyShaderToWorldTexture(shwaeki, "cj_w_grad")
end )