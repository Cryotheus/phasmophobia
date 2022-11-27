--locals
local entity_meta = FindMetaTable("Entity")

--entity functions
function entity_meta:FreezeOnSleep()
	self.PhasmophobiaFreezingOnSleep = true
	
	--as soon as the entity sleeps, it freezes
	hook.Add("Think", self, function()
		local physics = self:GetPhysicsObject()
		
		if physics:IsValid() and physics:IsMotionEnabled() then
			if physics:IsAsleep() then physics:EnableMotion(false)
			else return end
		end
		
		self.PhasmophobiaFreezingOnSleep = false
		
		hook.Remove("Think", self)
	end)
end