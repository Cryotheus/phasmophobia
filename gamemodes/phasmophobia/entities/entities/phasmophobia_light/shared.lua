--entity fields
ENT.Base = "phasmophobia_map_entity"
ENT.Instructions = "Due to source engine limits, there cannot be more than 32 of these at a time."
ENT.PrintName = "Phasmophobia Light"
ENT.Purpose = "Light things up."
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Type = "anim"

--entity functions
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lit")
	self:NetworkVarNotify("Lit", function(self, name, old, new) if old ~= new then self:Toggled(new) end end)
	
	if SERVER then self:SetupNetworkVars() end
end