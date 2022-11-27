--gamemode functions
function GM:AllowPlayerPickup(ply, entity)
	if entity.IsPhasmophobiaItem then return false end
	
	return true
end

function GM:PropDropped(ply, entity)
	
end

--PhasmophobiaFreezingOnSleep
function GM:PlayerUse(ply, entity)
	if entity.PhasmophobiaUnfreezeOnUse then
		local physics = entity:GetPhysicsObject()
		
		if not physics:IsMotionEnabled() then
			physics:EnableMotion(true)
			physics:Wake()
		end
	end
	
	return true
end

function GM:PropGetPickupInterrupt()
	local interrupt = PhasmophobiaPickupInterrupt
	
	if IsValid(interrupt) then return interrupt end
	
	interrupt = ents.Create("phasmophobia_pickup_interrupt")
	local ply = player.GetAll()[1]
	local player_spawn = ents.FindByClass("info_player_start")[1]
	
	interrupt:SetAng(angle_zero)
	interrupt:SetPos(player_spawn and player_spawn:GetPos() or ply and ply:GetPos() or vector_origin)
	interrupt:Spawn()
	
	return interrupt
end

function GM:PropPickupInterrupt(ply)
	local interrupt = self:PropGetPickupInterrupt()
	
	interrupt:AddPlayer(ply)
end