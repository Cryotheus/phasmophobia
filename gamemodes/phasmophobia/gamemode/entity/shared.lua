--gamemode functions
function GM:OnEntityCreated(entity)
	if entity:IsValid() and entity:IsPlayer() then
		self:PlayerSetHull(entity)
		self:PlayerCreated(entity)
	end
end