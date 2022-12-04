AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--locals
local hold_type_enumerations = {
	"ar2", --1
	"camera", --2
	"crossbow", --3
	"duel", --4
	"fist", --5
	"grenade", --6
	"knife", --7
	"magic", --8
	"melee", --9
	"melee2", --10
	"normal", --11
	"passive", --12
	"physgun", --13
	"pistol", --14
	"revolver", --15
	"rpg", --16
	"shotgun", --17
	"slam", --18
	"smg", --19
}

--custom entity fields
ENT.KeyValueMethods = {
	holdtype = function(self, key, value) self.HoldType = hold_type_enumerations[tonumber(value)] end,
	mass = "Mass: number",
	model = "MapModel",
	primary = "PrimaryUses: number",
	primary_delay = "PrimaryDelay: number",
	secondary = "SecondaryUses: number",
	secondary_delay = "SecondaryDelay: number",
}

ENT.SpawnFlagFields = {
	"GhostIntangible",
	"DeadPlayerIntangible",
	"SpawnFrozen",
	"GhostCannotUnfreeze",
	"GenerateRack"
}

--entity functions
function ENT:ItemInitialize()
	local map_model = self.MapModel
	local mass = self.Mass
	self.Draw = self.DrawModel
	self.Think = self.ThinkDropped
	
	if map_model and #map_model > 0 then self:SetModel(map_model)
	else self:SetModel(self.WorldModel or "models/lamps/torch.mdl") end
	
	--attempt to use vphysics
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local physics = self:GetPhysicsObject()
	
	--otherwise use box physics
	if not physics:IsValid() then
		self:PhysicsInitBox(self:GetModelRenderBounds())
		
		physics = self:GetPhysicsObject()
	end
	
	self:SetCollisionGroup(self.DroppedCollisionGroup)
	self:SetUseType(SIMPLE_USE)
	
	if mass then physics:SetMass(mass) end
	if self.SpawnFrozen then physics:EnableMotion(false)
	else physics:Wake() end
	
	self:FreezeOnSleep()
end

function ENT:Use(ply) hook.Run("PlayerItemPickup", ply, self) end

--post
ENT.Initialize = ENT.ItemInitialize