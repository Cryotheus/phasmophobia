AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--custom entity fields
ENT.KeyValueMethods = {
	distance = "HingeTolerance: number",
	massScale = "MassScale: number",
	model = "BrushModel",
	origin = "HingeOrigin: vector",
}

ENT.SpawnFlagFields = {
	"DisablePlayerInteraction",
	"DisableGhostInteraction",
	"GenerateDoorHandle",
	"EntranceDoor"
}

--entity functions
function ENT:EndTouch(entity) end

function ENT:Initialize()
	self:SetModel(self.BrushModel)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local physics = self:GetPhysicsObject()
	local hinge_maximum = self.HingeTolerance
	local hinge_minimum = 0
	
	if hinge_maximum < hinge_minimum then hinge_maximum, hinge_minimum = hinge_minimum, hinge_maximum end
	
	physics:SetDragCoefficient(20)
	physics:SetMass(20 * self.MassScale)
	
	--create the hinge
	constraint.AdvBallsocket(
		game.GetWorld(), --entity
		self, --entity
		
		0, --bone
		0, --bone
		
		self.HingeOrigin, --local position
		vector_origin, --local position
		
		0, --force limit
		0, --torque limit
		
		0, --x min
		0, --y min
		hinge_minimum, --z min
		
		0, --x max
		0, --y max
		hinge_maximum, --z max
		
		10, --x fric
		10, --y fric
		10, --z fric
		
		0, --onlyrotation
		1 --nocollide
	)
end

function ENT:StartTouch(entity) end
function ENT:UpdateTransmitState() return TRANSMIT_PVS end

function ENT:Use(ply)
	local physics = self:GetPhysicsObject()
	
	physics:EnableMotion(true)
	physics:Wake()
	
	ply:PickupObject(hook.Run("PropGetPickupInterrupt"))
end

--unused
function ENT:OnRemove() end
function ENT:PassesTriggerFilters(entity) return true end
function ENT:Think() end
function ENT:Touch(entity) end