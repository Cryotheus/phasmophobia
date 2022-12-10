include("shared.lua")

--accessor functions
AccessorFunc(ENT, "Brightness", "Brightness", FORCE_NUMBER)
AccessorFunc(ENT, "Player", "Player")
AccessorFunc(ENT, "Size", "Size", FORCE_NUMBER)

--entity functions
function ENT:Draw() end

function ENT:Initialize()
	self:SetBrightness(256)
	self:SetSize(256)
end

function ENT:ThinkActive()
	local ply = self.Player
	
	if ply:IsValid() then
		local light = DynamicLight(self:EntIndex())
		
		light.brightness = 1
		light.pos = ply:EyePos()
		
		light.r = 224
		light.g = 240
		light.b = 255
		
		light.DieTime = CurTime() + 0.25
		light.Size = self.Size
		
		return true
	else
		--why does think sometimes get called after the entity gets removed?
		self.Think = nil
		
		self:Remove()
	end
end

function ENT:SetPlayer(ply)
	self.Player = ply
	self.Think = self.ThinkActive
	
	self:SetParent(ply)
	self:SetLocalAngles(angle_zero)
	self:SetLocalPos(vector_origin)
end