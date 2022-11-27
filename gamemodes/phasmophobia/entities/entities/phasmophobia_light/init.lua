AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--custom entity fields
ENT.KeyValueMethods = {
	area = "Area: target",
	_cone = "Cone: number",
	distance = "Distance: number",
	_inner_cone = "InnerCone: number",
	
	_light = function(self, key, value)
		local r, g, b, brightness = unpack(string.Split(value, " "))
		
		self.Brightness = brightness
		self.Color = Color(r, g, b)
	end,
	
	lightswitch = "Lightswitch: target",
	spotlight_radius = "SpotRadius: number"
}

ENT.SpawnFlagFields = {
	"GhostIntangible",
	"GhostUnbreakable",
	"MaintainPlayerSanity",
	"RequiresPower"
}

--entity functions
function ENT:EndTouch(entity) end

function ENT:Initialize()
	self:SetColor(self.Color)
	self:SetModel("models/empty.mdl")
	self:SetNWBool("GhostIntangible", self.GhostIntangible)
	self:SetNWFloat("Brightness", self.Brightness)
	self:SetNWFloat("Distance", self.Distance)
	
	local outer_angle = self.Cone
	
	if outer_angle and outer_angle > 0 then
		self:SetNWBool("Directional", true)
		self:SetNWFloat("InnerAngle", self.InnerCone)
		self:SetNWFloat("OuterAngle", self.Cone)
	else self:SetNWBool("Directional", false) end
	
	--probably doesn't matter if we do this
	self:PhysicsInit(SOLID_NONE)
end

function ENT:SetupNetworkVars()
	if self.RequiresPower then self:SetLit(GAMEMODE.LocationPowered or false)
	else self:SetLit(true) end
end

function ENT:StartTouch(entity) end
function ENT:UpdateTransmitState() return TRANSMIT_PVS end

--unused
function ENT:OnRemove() end
function ENT:PassesTriggerFilters(entity) return true end
function ENT:Think() end
function ENT:Toggled(lit) end
function ENT:Touch(entity) end