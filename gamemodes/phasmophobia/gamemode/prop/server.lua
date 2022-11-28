--locals
local captured_users = {}

--globals
GM.PropCapturedUsers = captured_users

--[[notes
	PhasmophobiaFreezingOnSleep
]]

--gamemode functions
function GM:AllowPlayerPickup(ply, entity) return false end


function GM:PlayerUse(ply, entity)
	if ply.PhasmophobiaUseCapture then return false end
	
	if entity.PhasmophobiaUnfreezeOnUse then
		local physics = entity:GetPhysicsObject()
		
		if not physics:IsMotionEnabled() then
			physics:EnableMotion(true)
			physics:Wake()
		end
	end
	
	return true
end

function GM:PropCaptureUse(ply, target)
	--can't have multiple
	print("capture?", ply, target)
	
	if ply.PhasmophobiaUseCapture then return false end
	
	print("start capture", ply, target)
	
	ply.PhasmophobiaUseCapture = target
	
	table.insert(captured_users, ply)
	
	return true
end

function GM:PropThink()
	for index = #captured_users, 1, -1 do
		local ply = captured_users[index]
		local target = ply.PhasmophobiaUseCapture
		
		if ply:IsValid() and IsValid(target) and ply:KeyDown(IN_USE) then if target.UseCaptureThink then target:UseCaptureThink(ply) end
		else
			ply.PhasmophobiaUseCapture = nil
			
			if target.UseCaptureFinish then target:UseCaptureFinish(ply) end
			
			table.remove(captured_users)
		end
	end
end

function GM:Think() if self.PropThink then self:PropThink() end end