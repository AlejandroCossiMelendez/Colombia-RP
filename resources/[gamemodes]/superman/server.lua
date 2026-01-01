-- Copyright (c) 2017, Alberto Alonso
--
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright notice, this
--       list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice, this
--       list of conditions and the following disclaimer in the documentation and/or other
--       materials provided with the distribution.
--     * Neither the name of the superman script nor the names of its contributors may be used
--       to endorse or promote products derived from this software without specific prior
--       written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
local Superman = {}

-- Static global values
local rootElement = getRootElement()
local thisResource = getThisResource()

local allowedACL = -- Modify which groups of staff/ACL's can use the Superman script (copy and paste new line as below in the table to add more ACL names)
{
	[aclGetGroup("Administrador")] = true,
	[aclGetGroup("GameOperator")] = true,
	[aclGetGroup("Helper")] = true,
	[aclGetGroup("Desarrollador")] = true,
}

-- Resource events
addEvent("superman:start", true)
addEvent("superman:stop", true)
addEvent("superman:checkRight", true)

--
-- Start/stop functions
--

function Superman.Start()
  local self = Superman

  addEventHandler("superman:start", rootElement, self.clientStart)
  addEventHandler("superman:stop", rootElement, self.clientStop)
  addEventHandler("onPlayerVehicleEnter",rootElement,self.enterVehicle)
  addEventHandler("onPlayerJoin",rootElement,self.updateRight)
  addEventHandler("onPlayerLogin",rootElement,self.updateRight)
  addEventHandler("onPlayerLogout",rootElement,self.updateRight)
  addEventHandler("superman:checkRight",rootElement,self.updateRight)

end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), Superman.Start, false)

function Superman.clientStart()
  setElementData(client, "superman:flying", true)
end

function Superman.clientStop()
  setElementData(client, "superman:flying", false)
end

-- Fix for players glitching other players' vehicles by warping into them while superman is active, causing them to flinch into air and get stuck.
function Superman.enterVehicle()
	if getElementData(source,"superman:flying") or getElementData(source,"superman:takingOff") then
		removePedFromVehicle(source)
		local x,y,z = getElementPosition(source)
		setElementPosition(source,x,y,z)
	end
end

function Superman.updateRight()

	if client and source~=client then return end
	
	local isAllowed = false

	for group,_ in pairs(allowedACL) do
		local account = getPlayerAccount(source)
		local name = getAccountName(account)
		if isObjectInACLGroup("user."..name,group) then
			isAllowed=true
			break
		end
	end
	
	triggerClientEvent(source,"superman:updateRight",source,isAllowed)

end