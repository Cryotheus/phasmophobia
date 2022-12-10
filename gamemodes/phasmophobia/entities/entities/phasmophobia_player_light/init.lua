AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--entity functions
function ENT:Initialize()
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetModel("models/empty.mdl")
end