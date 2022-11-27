include("shared.lua")

--locals
local light_duration = 0.25
local refresh_interval = light_duration * 0.9
--local material_glow = Material("sprites/glow01")
--local material_glow_soft = Material("sprites/glow02")
--local material_glow_sharp = Material("sprites/glow03")
--local material_glow_sharp_alternative = Material("sprites/glow04")

--entity functions
function ENT:DrawLight(flags)
	if self:IsDormant() then return print(self, "preventing light render as light is marked dormant on client") end
	
	--we set DrawTranslucent to this when the light turns on
	local glow_size = self:GetNWFloat("GlowSize")
	local position = self:GetPos()
	local real_time = RealTime()
	
	if real_time > self.NextRefresh then
		local light = DynamicLight(self:EntIndex())
		self.NextRefresh = real_time + refresh_interval
		
		if light then
			local color = self:GetColor()
			
			light.brightness = self:GetNWFloat("Brightness", 4)
			light.dietime = CurTime() + light_duration
			light.pos = position
			light.r, light.g, light.b = color.r, color.g, color.b
			light.size = self:GetNWFloat("Distance", 0)
			
			if self:GetNWBool("Directional") then
				light.dir = self:GetForward()
				light.innerangle = self:GetNWFloat("InnerAngle", 0)
				light.outerangle = self:GetNWFloat("OuterAngle", 0)
			end
		end
	end
	
	if glow_size and glow_size > 0 then
		local glow_size = glow_size * util.PixelVisible(position, 4, self.VisibilityHandle) ^ 0.5
		
		do cam.Start3D2D(position, PhasmophobiaSpriteAngle, glow_size)
			surface.SetDrawColor(255, 255, 255, 192)
			surface.SetMaterial()
			surface.DrawRect(-64, -64, 128, 128)
		end cam.End3D2D()
	end
end

function ENT:Initialize()
	self.NextRefresh = 0
	self.VisibilityHandle = util.GetPixelVisibleHandle()
end

function ENT:Toggled(lit)
	if lit then self.DrawTranslucent = self.DrawLight
	else self.DrawTranslucent = nil end
end