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
local reach = 48
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

--[[ eigth attempt
	function ENT:UseCaptureThink(ply)
		local debug_time = FrameTime() * 2.01
		
		local angles = self:GetAngles()
		local drag_position = self:LocalToWorld(self.DragPosition)
		local eye_angles = ply:EyeAngles()
		local eye_direction = ply:GetAimVector()
		local eye_position = ply:EyePos()
		local eye_position_offset = eye_position + self.DragEyeOffset
		local eye_yaw = Angle(0, eye_angles.yaw, 0)
		local eye_yaw_direction = eye_yaw:Forward()
		--local forward = angles:Forward()
		--local right = angles:Right()
		local normal = self.DragNormal
		local physics = self:GetPhysicsObject()
		local planar_normal = self.DragNormal2D
		local planar_normal_angle = planar_normal:Angle()
		local projected = eye_position + eye_direction * self.DragDistance
		local ray_hit = util.IntersectRayWithPlane(eye_position, eye_direction, eye_position_offset, planar_normal)
		
		if not ray_hit then return end
		
		local ray_localized = WorldToLocal(ray_hit, angle_zero, drag_position, angles)
		local ray_sign = math.SignBiased(ray_localized.y)
		
		debugoverlay.BoxAngles(eye_position_offset, Vector(-1, -20, -20), Vector(0, 20, 20), planar_normal_angle, debug_time, Color(255, 255, 255, 64))
		debugoverlay.Cross(ray_hit, 5, debug_time, Color(255, 0, 0))
		
		if ray_sign < 0 then
			print("negative")
			
			local local_projected = WorldToLocal(projected, angle_zero, drag_position, planar_normal_angle)
			local_projected.y = -local_projected.y
			projected = LocalToWorld(-local_projected, angle_zero, drag_position, planar_normal_angle)
			
		else print("positive") end
		
		debugoverlay.Cross(projected, 3, debug_time, Color(0, 0, 255))
		
		physics:SetVelocity(vector_origin)
		physics:ApplyForceOffset((projected - drag_position) * 50, drag_position)
	end
--]]

--[[ sixth attempt
	function ENT:UseCaptureThink(ply)
		local angles = self:GetAngles()
		local eye_angles = ply:EyeAngles()
		local physics = self:GetPhysicsObject()
		local push_angle = 0
		--local turn = 0
		
		local current_turn = select(2, WorldToLocal(vector_origin, angles, vector_origin, self.DragAngles)).yaw
		local eye_turn = select(2, WorldToLocal(vector_origin, eye_angles, vector_origin, self.DragEyeAngles)).yaw
		
		local turn = eye_turn - current_turn
		local turn_sign = math.Sign(turn)
		local turn_strength = math.min(math.abs(turn) ^ 1, maximum_turn_speed)
		
		physics:SetVelocity(Vector(0, 0, 0))
		physics:ApplyForceOffset(angles:Right() * turn_strength * turn_sign * turn_speed, self:LocalToWorld(self.DragPosition * Vector(1, 0, 1)))
	end
--]]

--[[ fifth attempt
	function ENT:DragTrace(ply)
		local eye_direction = ply:GetAimVector()
		local eye_position = ply:EyePos()
		
		return util.IntersectRayWithPlane(
			eye_position,
			eye_direction,
			eye_position + self.DragEyeOffset,
			-Angle(0, self.DragEyeAngles.yaw, 0):Forward()
		)
	end

	function ENT:UseCaptureThink(ply)
		local angles = self:GetAngles()
		local debug_time = FrameTime() * 2.01
		local drag_eye_angles = self.DragEyeAngles
		local drag_local = self.DragPosition
		local drag_position = self:LocalToWorld(drag_local)
		local eye_offset = self.DragEyeOffset
		local eye_position = ply:EyePos()
		local eye_projection = eye_position + eye_offset
		local plane_yaw = Angle(0, drag_eye_angles.yaw, 0)
		local physics = self:GetPhysicsObject()
		local ray_hit = self:DragTrace(ply)
		
		if not ray_hit then return end
		
		debugoverlay.BoxAngles(
			eye_projection,
			Vector(0.1, -20, -20),
			Vector(0, 20, 20),
			plane_yaw,
			debug_time,
			Color(255, 255, 255, 128)
		)
		
		debugoverlay.Cross(ray_hit, 5, debug_time, Color(255, 0, 0), true)
		
		local difference = ray_hit - drag_position
		--local push = WorldToLocal(ray_hit, angle_zero, drag_position, angles).x
		
		physics:SetVelocity(vector_origin)
		physics:ApplyForceOffset(difference, drag_position)
	end
--]]

--[[ fourth attempt
	local drag_scale = 50
	drag_scale = Vector(drag_scale, drag_scale, 0)

	function ENT:UseCaptureThink(ply)
		local angles = self:GetAngles()
		local drag_distance = self.DragDistance
		local drag_local = self.DragPosition
		local drag_position = self:LocalToWorld(drag_local)
		local physics = self:GetPhysicsObject()
		local projected = ply:EyePos() + ply:GetAimVector() * drag_distance
		
		local localized = WorldToLocal(projected, angle_zero, drag_position, angles)
		local worlded = LocalToWorld(localized, angle_zero, drag_position, angles)
		
		print(localized)
		
		physics:SetVelocity(vector_origin)
		physics:ApplyForceOffset(localized * drag_scale, drag_position)
	end
--]]

--[[ third attempt
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
--]]

--[[ second attempt
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
--]]

--[[ first attempt
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
	end
--]]