--swep fields
ENT.Author = "Cryotheum"
ENT.Base = "phasmophobia_item"
ENT.Contact = "Discord: Cryotheum#4096"
ENT.Instructions = "Primary toggles light."
ENT.PrintName = "Phasmophobia Item"
ENT.Purpose = "Light up the way."
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = true

--swep functions
function ENT:Draw()
	
end

function ENT:Initialize()
	local lamp = ProjectedTexture()
	self.Lamp = lamp
	
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lit")
	self:NetworkVarNotify("Lit", function(name, old, new) if old ~= new then self:Toggled(new) end end)
	
	if SERVER then self:SetupNetworkVars() end
end

function ENT:SetupNetworkVars() self:SetLit(false) end