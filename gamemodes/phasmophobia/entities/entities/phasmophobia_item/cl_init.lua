include("shared.lua")

--entity functions
function ENT:DrawHeld(flags)
	local ply = self:GetOwner()
	
	--if ply:IsValid() then self:UpdateHeldPosition(ply) end
	if not ply:IsValid() or ply:ShouldDrawLocalPlayer() or self:GetActivelyHeld() then return self:DrawModel(flags) end
end

function ENT:GetHoldOffsets(ply, position, angles)
	local model = self:GetModel()
	local offset_angle = self.HeldAnglesOffset or GAMEMODE.PlayerItemModelOffsetsHeldAngle[model]
	local offset_position = self.HeldPositionOffset or GAMEMODE.PlayerItemModelOffsetsHeldPosition[model]
	
	return LocalToWorld(offset_position or vector_origin, offset_angle or angle_zero, position, angles)
end

function ENT:Initialize()
	self.Draw = self.DrawModel
	self.DrawDropped = self.DrawModel
	self.NextThink = self.SetNextClientThink
	self.Think = IsValid(self:GetItemSlot()) and self.ThinkHeld or self.ThinkDropped
end