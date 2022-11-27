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
	Automatic = true,
	ClipSize = -1,
	DefaultClip = -1,
}

SWEP.Secondary = {
	Ammo = "none",
	Automatic = true,
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

function SWEP:DumpNetVars() --for debug
	MsgC(color_realm, "Network Variable dump for " .. tostring(self), "\n")
	MsgC(color_realm, "NV::Item\t" .. tostring(self:GetItem()), "\n")
end

function SWEP:Holster()
	local item = self:GetItem()
	self.Deployed = false
	
	if IsValid(item) then item:SetActivelyHeld(false) end
	
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

function SWEP:Pickup(item)
	self:SetItem(item)
	item:SetActivelyHeld(self.Deployed)
end

function SWEP:PrimaryAttack()
	--unsafe to do prediction with entity interactions
	if not IsFirstTimePredicted() then return end
	
	local item = self:GetItem()
	
	if IsValid(item) then item:PrimaryUse(self:GetOwner(), self) end
end

function SWEP:Reload()
	--unsafe to do prediction with entity interactions
	if not IsFirstTimePredicted() then return end
	
	local item = self:GetItem()
	
	if IsValid(item) then
		item:Throw(self:GetOwner(), self)
		self:SetItem(NULL)
	end
end

function SWEP:SecondaryAttack()
	--unsafe to do prediction with entity interactions
	if not IsFirstTimePredicted() then return end
	
	local item = self:GetItem()
	
	if IsValid(item) then item:SecondaryUse(self:GetOwner(), self) end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Item")
	
	self:NetworkVarNotify("Item", function(self, name, old, new)
		if old == new then return end
		if IsValid(old) then self:ItemDropped(old) end
		if new:IsValid() then self:ItemEquipped(new) end
	end)
end