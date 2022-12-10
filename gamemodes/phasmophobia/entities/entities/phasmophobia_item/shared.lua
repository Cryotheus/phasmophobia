--entity fields
ENT.Author = "Cryotheum"
ENT.Base = "phasmophobia_map_entity"
ENT.Contact = "Discord: Cryotheum#4096"
ENT.Instructions = "Derive this as the base entity to create an item, or place it in your map as an item that can be picked up."
ENT.PrintName = "Phasmophobia Item"
ENT.Purpose = "Provides base functionality for items."
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.Type = "anim"

--custom entity fields
ENT.DroppedCollisionGroup = COLLISION_GROUP_WEAPON --doesn't collide with players
ENT.IsPhasmophobiaItem = true

--[[
	Think is set to one of these:
		ThinkDropped
		ThinkHeld
		ThinkRacked
]]

--entity functions
function ENT:Dropped(ply, item_slot)
	self.Draw = self.DrawDropped
	
	self:UpdateDroppedCollisions(item_slot)
	self:OnDropped(ply, item_slot)
end

function ENT:Equipped(ply, item_slot)
	self.Draw = self.DrawHeld
	
	self:UpdateHeldCollisions(item_slot)
	self:OnEquipped(ply, item_slot)
end

function ENT:GetThrowAngles(ply, item_slot)
	--use the player's eye angles, or player's eye angles offset by ThrowAnglesOffset
	local angle_offset = self.ThrowAnglesOffset
	
	return angle_offset and select(2, LocalToWorld(vector_origin, angle_offset, vector_origin, ply:EyeAngles())) or ply:EyeAngles()
end

function ENT:GetViewModelOffsets(ply, position, angles)
	local model = self:GetModel()
	local offset_angle = self.ViewModelAnglesOffset or GAMEMODE.PlayerItemModelOffsetsViewModelAngle[model]
	local offset_position = self.ViewModelPositionOffset or GAMEMODE.PlayerItemModelOffsetsViewModelPosition[model]
	
	return LocalToWorld(offset_position or vector_origin, offset_angle or angle_zero, position, angles)
end

function ENT:HeldStatusUpdated(held) end

function ENT:ItemSetupDataTables()
	--we use the last slots available to make deriving easier
	self:NetworkVar("Bool", 31, "ActivelyHeld")
	self:NetworkVar("Entity", 31, "ItemSlot")
	self:NetworkVar("Int", 30, "PrimaryUses")
	self:NetworkVar("Int", 31, "SecondaryUses")
	
	self:NetworkVarNotify("ActivelyHeld", function(self, name, old, new)
		if old == new then return end
		
		self:HeldStatusUpdated(new)
	end)
	
	self:NetworkVarNotify("ItemSlot", function(self, name, old, new)
		if self.LastItemSlot == new then return end
		
		self.LastItemSlot = new
		
		self:ItemSlotChanged(new)
	end)
end

function ENT:ItemThinkHeld()
	local ply = self:GetOwner()
	
	if IsValid(ply) then self:UpdateHeldPosition(ply) end
	
	--this is an alias of SetNextClientThink on CLIENT
	self:NextThink(CurTime() + 0.1)
	
	return true
end

function ENT:ItemSlotChanged(item_slot) if IsValid(item_slot) then self:UpdateHeldCollisions(item_slot) end end
function ENT:OnDropped(ply, item_slot) end
function ENT:OnEquipped(ply, item_slot) end
function ENT:PrimaryUse(ply, item_slot) end
function ENT:SecondaryUse(ply, item_slot) end

function ENT:Store(ply, item_slot) --when stored on rack
	local truck = GAMEMODE.Truck
	
	if not IsValid(truck) then return end
	
	self:UpdateDroppedCollisions(item_slot)
	self:GetPhysicsObject():EnableMotion(false)
	
	self.Think = self.ThinkRacked
end

function ENT:ThinkDropped() end

function ENT:Throw(ply, item_slot, no_force)
	self:UpdateDroppedCollisions(item_slot)
	self:SetAngles(self:GetThrowAngles(ply, item_slot))
	self:SetPos(ply:EyePos())
	
	if SERVER then
		local physics = self:GetPhysicsObject()
		
		physics:Wake()
		self:FreezeOnSleep()
		
		if no_force then return end
		
		physics:SetVelocity(ply:GetAimVector() * 400)
	end
end

function ENT:UpdateDroppedCollisions(item_slot)
	if item_slot == self:GetItemSlot() then
		self.Think = self.ThinkDropped
		
		if SERVER then self:GetPhysicsObject():EnableMotion(true) end
		
		self:SetCollisionGroup(self.DroppedCollisionGroup)
		self:SetItemSlot(NULL)
		self:SetOwner(NULL)
	end
end

function ENT:UpdateHeldCollisions(item_slot)
	if item_slot ~= self:GetItemSlot() then
		self.Think = self.ThinkHeld
		
		if SERVER then self:GetPhysicsObject():EnableMotion(false) end
		
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:SetItemSlot(item_slot)
		self:SetOwner(item_slot:GetOwner())
	end
end

--post
ENT.SetupDataTables = ENT.ItemSetupDataTables
ENT.ThinkHeld = ENT.ItemThinkHeld