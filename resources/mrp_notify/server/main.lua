function AddNotify(source, title, message, icon)
	if (source ~= root) and (not isElement(source) or (getElementType(source) ~= "player")) then
		return
	end
	triggerClientEvent(source, "mrp_notify->AddNotify", resourceRoot, title, message, icon)
end