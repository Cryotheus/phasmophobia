include("shared.lua")

--entity functions
function ENT:GetHeldOffsets(ply, position, angles)
	local model = self:GetModel()
	local offset_angle = self.HeldAnglesOffset or GAMEMODE.PlayerItemModelOffsetsHeldAngle[model]
	local offset_position = self.HeldPositionOffset or GAMEMODE.PlayerItemModelOffsetsHeldPosition[model]
	
	return LocalToWorld(offset_position or vector_origin, offset_angle or angle_zero, position, angles)
end

function ENT:ItemDrawHeld(flags)
	local ply = self:GetOwner()
	
	--if ply:IsValid() then self:UpdateHeldPosition(ply) end
	if not ply:IsValid() or ply:ShouldDrawLocalPlayer() or self:GetActivelyHeld() then return self:DrawModel(flags) end
end

function ENT:ItemInitialize()
	self.Draw = self.Draw or  self.DrawModel
	self.DrawDropped = self.DrawDropped or self.DrawModel
	self.NextThink = self.SetNextClientThink
	self.Think = IsValid(self:GetItemSlot()) and self.ThinkHeld or self.ThinkDropped
end

function ENT:UpdateHeldPosition(ply)
	local position, angles
	
	if ply:ShouldDrawLocalPlayer() then
		local attachment = ply:LookupAttachment("anim_attachment_RH")
		local attachment_position, attachment_angles
		
		if attachment > 0 then --expected behavior
			local pair = ply:GetAttachment(attachment)
			
			attachment_angles = pair.Ang
			attachment_position = pair.Pos
		else --fallback
			attachment_angles = ply:EyeAngles()
			attachment_position = ply:WorldSpaceCenter()
		end
		
		position, angles = self:GetHeldOffsets(ply, attachment_position, attachment_angles)
	else position, angles = self:GetViewModelOffsets(ply, ply:EyePos(), ply:EyeAngles()) end
	
	self:SetAngles(angles)
	self:SetPos(position)
end

--post
ENT.DrawHeld = ENT.ItemDrawHeld
ENT.Initialize = ENT.ItemInitialize