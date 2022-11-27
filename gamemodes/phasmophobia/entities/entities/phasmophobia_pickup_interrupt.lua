--entity fields
ENT.Base = "base_entity"
ENT.Type = "anim"

--locals
local duplex_insert = PHASMOPHOBIA._DuplexInsert
local duplex_remove = PHASMOPHOBIA._DuplexRemove

--entity functions
function ENT:Initialize()
	if CLIENT then
		self.Draw = self.DrawModel
		
		return
	end
	
	PhasmophobiaPickupInterrupt = self
	self.Players = {}
	
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetModel("models/hunter/plates/plate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

function ENT:AddPlayer(ply)
	duplex_insert(self.Players, ply)
	ply:PickupObject(self)
end

function ENT:Think()
	local players = self.Players
	
	--we iterate in reverse to make modification to the duplex safe
	for index = #players, 1, -1 do
		local ply = players[index]
		
		if not ply:KeyDown(IN_USE) then
			local interrupt_target = ply.PhasmophobiaInterruptTarget
			ply.PhasmophobiaInterruptTarget = nil
			
			duplex_remove(players, index)
			ply:DropObject()
			
			--we call this last in case of script errors
			if IsValid(interrupt_target) and interrupt_target.PickupInterruptDropped then interrupt_target:PickupInterruptDropped(ply) end
		end
	end
	
	self:NextThink(0)
	
	return true
end