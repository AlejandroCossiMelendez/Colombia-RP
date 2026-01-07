local objectID=objectID

function replace()
	txd = engineLoadTXD("flag.txd")
	engineImportTXD(txd, 1302 )
	local dff = engineLoadDFF("flag.dff", 1302) 
	engineReplaceModel(dff, 1302)
	for _,v in ipairs(getElementsByType("object")) do 
		if getElementModel(v)==1302 then
			setElementCollisionsEnabled(v,true)
			setElementDoubleSided(v,true)
		end
	end
	startShader()
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), replace )


local shader
local flag
local amplitudePower=1.2
local waveSpeed=2
local waves=1
function startShader()
	shader = dxCreateShader("flag.fx")
	if not shader then return end
	dxSetShaderValue(shader,"flag0",dxCreateTexture("flag.png"))--put here your flag texture
	dxSetShaderValue(shader,"noise0",dxCreateTexture("noise.jpg"))
	dxSetShaderValue(shader,"amplitudePower",amplitudePower)
	dxSetShaderValue(shader,"waveSpeed",waveSpeed)
	dxSetShaderValue(shader,"waves",waves)
	engineApplyShaderToWorldTexture(shader,"flag")
end


--[[--]]

