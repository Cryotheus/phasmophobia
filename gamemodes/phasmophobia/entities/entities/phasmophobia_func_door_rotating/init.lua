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
local mass = 20

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
	
	self.HingeMaximum = hinge_maximum
	self.HingeMinimum = hinge_minimum
	
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
	local aim_entity, distance, hit = ply:GetAimEntity()
	
	if aim_entity ~= self then return end
	if not hook.Run("PropCaptureUse", ply, self, 144) then return end
	
	local physics = self:GetPhysicsObject()
	self.DragDistance = distance
	self.DragPosition = self:WorldToLocal(hit)
	
	physics:EnableMotion(true)
	physics:SetDragCoefficient(0)
	physics:Wake()
	
	print(self.SpawnAngles, self.HingeTolerance, self.HingeOrigin)
end

function ENT:UseCaptureFinish(ply) self:GetPhysicsObject():SetDragCoefficient(air_drag) end

function ENT:UseCaptureThink(ply)
	print("rewrite this math. again.")
end

--[[
local slam = 5

function ENT:UseCaptureThink(ply)
	local drag_position = self:LocalToWorld(self.DragPosition)
	local eye_right = ply:EyeAngles():Right()
	local eye_position = ply:EyePos()
	local physics = self:GetPhysicsObject()
	local yaw = self:GetAngles().yaw
	
	drag_position.z = 0
	eye_right.z = 0
	eye_position.z = 0
	
	
	eye_right:Normalize()
	
	--local hinge_maximum = self.HingeMaximum
	--local hinge_minimum = self.HingeMinimum
	local product = eye_right:Dot(eye_position - drag_position)
	--local remaining = 0
	
	--if product < 0 then remaining = hinge_maximum - yaw
	--elseif product > 0 then remaining = yaw - hinge_minimum end
	
	--remaining = math.min(remaining, slam) / slam
	
	print(product)
	
	physics:SetVelocity(vector_origin)
	physics:ApplyForceOffset(Angle(0, yaw, 0):Forward() * product * physics:GetMass(), drag_position)
end
]]

--[[
function ENT:UseCaptureThink(ply)
	local drag_position = self:LocalToWorld(self.DragPosition)
	local eye_position = ply:EyePos()
	local hinge_origin = self.HingeOrigin
	local physics = self:GetPhysicsObject()
	local ray = util.IntersectRayWithPlane(eye_position, ply:GetAimVector(), drag_position, Vector(0, 0, drag_position.z < eye_position.z and 1 or -1))
	local yaw = Angle(0, self:GetAngles().yaw, 0)
	local yaw_forward = yaw:Forward()
	local yaw_right = -yaw:Right()
	
	local dot = yaw_forward:Dot(ray - hinge_origin)
	--local strength = math.abs(dot) ^ 1
	
	--from_hinge:Normalize()
	physics:SetVelocity(vector_origin)
	physics:ApplyForceOffset(yaw_right * math.Clamp(dot, -100, 100) * physics:GetMass() * 100, drag_position)
	--physics:ApplyForceOffset(yaw_right * strength * math.Sign(dot) * physics:GetMass() * 20, drag_position)
end
]]

--[[
function ENT:UseCaptureThink(ply)
	--local aim_entity, distance, hit = ply:GetAimEntity()
	local drag = self:LocalToWorld(self.DragPosition)
	local eye_position = ply:EyePos()
	--local drag_distance = self.DragDistance
	local physics = self:GetPhysicsObject()
	local ray = util.IntersectRayWithPlane(eye_position, ply:GetAimVector(), drag, Vector(0, 0, drag.z < eye_position.z and 1 or -1))
	
	local ray_difference = ray - drag
	
	--limit magnitude to 200 to prevent extreme physics
	if ray_difference:Length() > 200 then ray_difference:SetLength(200) end
	
	physics:SetVelocity(vector_origin)
	physics:ApplyForceOffset(ray_difference * physics:GetMass() * 2, drag)
end --]]--