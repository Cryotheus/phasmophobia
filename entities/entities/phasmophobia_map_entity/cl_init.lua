include("shared.lua")

--entity functions
function ENT:Initialize()
	if self.Type == "anim" then
		self.Draw = self.DrawModel
		
		--defaults to point sized render bounds, so we must set them here
		self:SetRenderBounds(self:GetModelBounds())
	end
end