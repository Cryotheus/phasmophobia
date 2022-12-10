--swep fields
SWEP.Author = "Cryotheum"
SWEP.Contact = "Discord: Cryotheum#4096"
SWEP.Instructions = "Collect an item with your use key, and use the item with your primary and secondary fire."
SWEP.PrintName = "Phasmophobia Item Slot #1"
SWEP.Purpose = "Provides base functionality for holding items."
SWEP.RenderGroup = RENDERGROUP_OPAQUE
SWEP.Spawnable = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.ViewModelFOV = 54
SWEP.WorldModel = Model("models/empty.mdl")
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Primary = {
	Ammo = "none",
	Automatic = false,
	ClipSize = -1,
	DefaultClip = -1,
}

SWEP.Secondary = {
	Ammo = "none",
	Automatic = false,
	ClipSize = -1,
	DefaultClip = -1,
}

--custom fields
SWEP.IsPhasmophobiaItemSlot = true

--swep functions
function SWEP:Deploy()
	local item = self:GetItem()
	self.Deployed = true
	
	if IsValid(item) then item:SetActivelyHeld(true) end
	
	return true
end

function SWEP:Holster()
	local item = self:GetItem()
	self.Deployed = false
	
	if IsValid(item) then
		item:SetActivelyHeld(false)
		
		if item.Heavy then self:Throw(true) end
	end
	
	return true
end

function SWEP:Initialize() self:SetHoldType("normal") end

function SWEP:ItemDropped(item)
	item:SetActivelyHeld(false)
	item:Dropped(self:GetOwner(), self)
	self:SetHoldType("normal")
end

function SWEP:ItemEquipped(item)
	item:Equipped(self:GetOwner(), self)
	self:SetHoldType(item.HoldType or "pistol")
end

function SWEP:OnReloaded() if self.ClassName == "phasmophobia_item_slot" then GAMEMODE:PlayerRegisterItemSlots(4) end end

function SWEP:Pickup(item)
	--prevent heavy items from being stored in inactive slots
	if item.Heavy and not self.Deployed then return end
	
	self:SetItem(item)
	item:SetActivelyHeld(self.Deployed)
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end --unsafe to do prediction with entity interactions
	
	local item = self:GetItem()
	local fire_delay = item.PrimaryDelay
	
	if IsValid(item) then item:PrimaryUse(self:GetOwner(), self) end
	if fire_delay then self:SetNextPrimaryFire(CurTime() + fire_delay) end
end

function SWEP:Reload() self:Throw() end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end --unsafe to do prediction with entity interactions
	
	local item = self:GetItem()
	local fire_delay = item.SecondaryDelay
	
	if IsValid(item) then item:SecondaryUse(self:GetOwner(), self) end
	if fire_delay then self:SetNextPrimaryFire(CurTime() + fire_delay) end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Item")
	
	self:NetworkVarNotify("Item", function(self, name, old, new)
		if old == new then return end
		if IsValid(old) then self:ItemDropped(old) end
		if new:IsValid() then self:ItemEquipped(new) end
	end)
end

function SWEP:Throw(no_force)
	local item = self:GetItem()
	
	if IsValid(item) then
		--unsafe to do prediction with entity interactions
		if IsFirstTimePredicted() then item:Throw(self:GetOwner(), self, no_force) end
		
		self:SetItem(NULL)
	end
end