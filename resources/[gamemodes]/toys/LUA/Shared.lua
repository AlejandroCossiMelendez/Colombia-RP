Accesorios = {
	bandanas = {1672, 2033, 2034},
	mascaras = {2769, 2768, 2814, 2823, 2647, 2342, 2663, 1937, 2880, 2856, 2861, 1916, 1917},--13
	sombreros = {2035, 2036, 2044, 2045, 1429},

}


if getLocalPlayer then

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		for path, k in pairs(Accesorios) do
			for i,v in ipairs(k) do
				engineImportTXD(engineLoadTXD('mods/'..path..'/'..v..'.txd'),v)
				--engineImportTXD(engineLoadTXD('mods/'..path..'/'..v..'.txd'),v)
				engineReplaceModel(engineLoadDFF('mods/'..path..'/'..v..'.dff'),v)
			end
		end
	end
)

GUIEditor = {
    button = {},
    window = {}
}

GUIEditor.window[1] = guiCreateWindow(0.03, 0.79, 0.38, 0.20, "Posición ------------ Rotación", true)
guiWindowSetSizable(GUIEditor.window[1], false)
GUIEditor.window[1].visible = false
GUIEditor.button[1] = guiCreateButton(0.03, 0.32, 0.12, 0.16, "X -", true, GUIEditor.window[1])
GUIEditor.button[2] = guiCreateButton(0.27, 0.32, 0.12, 0.16, "X +", true, GUIEditor.window[1])
GUIEditor.button[3] = guiCreateButton(0.15, 0.17, 0.12, 0.16, "Y +", true, GUIEditor.window[1])
GUIEditor.button[4] = guiCreateButton(0.15, 0.48, 0.12, 0.16, "Y -", true, GUIEditor.window[1])
GUIEditor.button[5] = guiCreateButton(0.09, 0.70, 0.12, 0.16, "Z -", true, GUIEditor.window[1])
GUIEditor.button[6] = guiCreateButton(0.22, 0.70, 0.12, 0.16, "Z +", true, GUIEditor.window[1])
GUIEditor.button[7] = guiCreateButton(0.85, 0.32, 0.12, 0.16, "rX +", true, GUIEditor.window[1])
GUIEditor.button[8] = guiCreateButton(0.61, 0.32, 0.12, 0.16, "rX -", true, GUIEditor.window[1])
GUIEditor.button[9] = guiCreateButton(0.73, 0.17, 0.12, 0.16, "rY +", true, GUIEditor.window[1])
GUIEditor.button[10] = guiCreateButton(0.73, 0.48, 0.12, 0.16, "rY -", true, GUIEditor.window[1])
GUIEditor.button[11] = guiCreateButton(0.80, 0.70, 0.12, 0.16, "rZ +", true, GUIEditor.window[1])
GUIEditor.button[12] = guiCreateButton(0.67, 0.70, 0.12, 0.16, "rZ -", true, GUIEditor.window[1])
GUIEditor.button[13] = guiCreateButton(0.45, 0.26, 0.12, 0.16, "Size +", true, GUIEditor.window[1])
GUIEditor.button[14] = guiCreateButton(0.45, 0.44, 0.12, 0.16, "Size -", true, GUIEditor.window[1])
 
addEventHandler('onClientGUIClick', root,
	function(b,s)
		if not (b == 'left' and s == 'up') then
			return
		end
		if isElement(toys.obj) then
			if source == GUIEditor.button[1] then -- X -

				toys.offsets[1] = toys.offsets[1] - 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])

			elseif source == GUIEditor.button[2] then -- X +

				toys.offsets[1] = toys.offsets[1] + 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])
				
			elseif source == GUIEditor.button[3] then -- Y +

				toys.offsets[2] = toys.offsets[2] + 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])

			elseif source == GUIEditor.button[4] then -- Y -

				toys.offsets[2] = toys.offsets[2] - 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])

			elseif source == GUIEditor.button[5] then -- Z -

				toys.offsets[3] = toys.offsets[3] - 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])

			elseif source == GUIEditor.button[6] then -- Z +

				toys.offsets[3] = toys.offsets[3] + 0.01
				exports.bone_attach:setElementBonePositionOffset(toys.obj, toys.offsets[1], toys.offsets[2], toys.offsets[3])

			elseif source == GUIEditor.button[7] then -- rX +

				toys.offsets[4] = toys.offsets[4] + 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])

			elseif source == GUIEditor.button[8] then -- rX -

				toys.offsets[4] = toys.offsets[4] - 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])
				
			elseif source == GUIEditor.button[9] then -- rY +

				toys.offsets[5] = toys.offsets[5] + 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])

			elseif source == GUIEditor.button[10] then -- rY -

				toys.offsets[5] = toys.offsets[5] - 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])

			elseif source == GUIEditor.button[11] then -- rZ +

				toys.offsets[6] = toys.offsets[6] + 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])

			elseif source == GUIEditor.button[12] then -- rZ -

				toys.offsets[6] = toys.offsets[6] - 3
				exports.bone_attach:setElementBoneRotationOffset(toys.obj, toys.offsets[4], toys.offsets[5], toys.offsets[6])

			elseif source == GUIEditor.button[13] then

				toys.offsets[7] = toys.offsets[7] + 0.01
				setObjectScale( toys.obj, toys.offsets[7])

			elseif source == GUIEditor.button[14] then

				toys.offsets[7] = toys.offsets[7] - 0.01
				setObjectScale( toys.obj, toys.offsets[7])

			end
		end
	end
)

end