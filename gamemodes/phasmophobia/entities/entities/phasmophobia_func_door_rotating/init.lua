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

--locals
local air_drag = 20
local hinge_flexibility = 2
local mass = 20
local maximum_speed = 200
local reach = 52
local speed = 50

--entity functions
function ENT:EndTouch(entity) end

function ENT:Initialize()
	self:SetModel(self.BrushModel)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local physics = self:GetPhysicsObject()
	local hinge_maximum = self.HingeTolerance
	local hinge_minimum = 0
	self.HingeDirection = Angle(0, hinge_maximum, 0):Forward()
	self.SpawnAngles = self:GetAngles()
	
	if hinge_maximum < hinge_minimum then hinge_maximum, hinge_minimum = hinge_minimum, hinge_maximum end
	
	hinge_maximum = hinge_maximum - hinge_flexibility
	hinge_minimum = hinge_minimum + hinge_flexibility
	
	local hinge_maximum_angle = Angle(0, hinge_maximum, 0)
	self.HingeMaximum = hinge_maximum
	self.HingeMaximumAngle = hinge_maximum_angle
	self.HingeMaximumForward = hinge_maximum_angle:Forward()
	self.HingeMaximumRight = hinge_maximum_angle:Right()
	
	local hinge_minimum_angle = Angle(0, hinge_minimum, 0)
	self.HingeMinimum = hinge_minimum
	self.HingeMinimumAngle = hinge_minimum_angle
	self.HingeMinimumForward = hinge_minimum_angle:Forward()
	self.HingeMinimumRight = hinge_minimum_angle:Right()
	
	physics:EnableMotion(false)
	physics:SetDragCoefficient(air_drag)
	physics:SetMass(mass * self.MassScale)
	
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
	local aim_entity, distance, hit, normal = ply:GetAimEntity()
	
	if aim_entity ~= self then return end
	if not hook.Run("PropCaptureUse", ply, self, 144) then return end
	
	local local_hit = self:WorldToLocal(hit)
	local physics = self:GetPhysicsObject()
	--local ray_hit = self:DragTrace(ply)
	self.DragAngles = self:GetAngles()
	self.DragDistance = distance
	self.DragEyeAngles = ply:EyeAngles()
	self.DragEyeOffset = hit - ply:EyePos()
	self.DragHit = hit
	self.DragNormal = normal
	self.DragNormal2D = Angle(0, normal:Angle().yaw, 0):Forward()
	self.DragPosition = local_hit
	self.DragPositionX = Vector(local_hit.x, 0, 0)
	--self.DragRayHit = ray_hit
	
	physics:EnableMotion(true)
	physics:SetDragCoefficient(0)
	physics:Wake()
	
	--print(self.SpawnAngles, self.HingeTolerance, self.HingeOrigin)
end

function ENT:UseCaptureFinish(ply)
	local physics = self:GetPhysicsObject()
	
	physics:EnableMotion(false)
	physics:SetDragCoefficient(air_drag)
end

function ENT:UseCaptureThink(ply)
	local angles_yaw = self:GetAngles().yaw
	local drag_position = self:LocalToWorld(self.DragPosition)
	local physics = self:GetPhysicsObject()
	local difference = (ply:EyePos() + ply:GetAimVector() * reach - drag_position) * speed
	--local projected = ply:EyePos() + ply:GetAimVector() * reach
	
	--clamp the speed
	if difference:Length() > maximum_speed then difference:SetLength(maximum_speed) end
	
	--prevent the door from turning too far (the ballsocket is too flexible)
	if angles_yaw > self.HingeMaximum then difference = difference * math.max(1 - (angles_yaw - self.HingeMaximum) / hinge_flexibility, 0)
	elseif angles_yaw < self.HingeMinimum then difference = difference * math.max(1 - (self.HingeMinimum - angles_yaw) / hinge_flexibility, 0) end
	
	physics:SetVelocity(vector_origin)
	physics:ApplyForceOffset(difference * physics:GetMass(), drag_position)
end