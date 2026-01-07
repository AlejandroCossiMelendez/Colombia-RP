local resource = getThisResource(  )
local resourceName = getResourceName(resource)
function dxGetNotifications()
    local string = [[]]
    for i, func in ipairs(getResourceExportedFunctions( resource )) do
        string = string..'\n'..func..' = function(...) return call ( getResourceFromName ( "'..resourceName..'" ), "'..func..'", ... ) end'
    end
    return string   
end 
