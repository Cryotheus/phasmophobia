--locals
local entity_meta = FindMetaTable("Entity")

--entity functions
function entity_meta:DumpNetVars()
	MsgC(color_realm, "Network Variable dump for " .. tostring(self), "\n")
	
	for key, value in pairs(self:GetNetworkVars()) do MsgC(color_realm_pale, "\tNV::" .. key .. " =\t" .. tostring(value) .. "\n") end
end

function GM:OnEntityCreated(entity)
	if entity:IsValid() and entity:GetClass() == "player" then self:PlayerSetHull(entity) end
end