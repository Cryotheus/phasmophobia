AddCSLuaFile()

--swep fields
ENT.Author = "Cryotheum"
ENT.Base = "phasmophobia_item"
ENT.Category = "Phasmophobia"
ENT.Contact = "Discord: Cryotheum#4096"
ENT.Instructions = "Primary toggles light."
ENT.PrintName = "Flashlight"
ENT.Purpose = "Light up the way."
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true

--custom fields
ENT.HeldAnglesOffset = Angle(0, 0, 0)
ENT.HeldPositionOffset = Vector(0, 0, 0)
ENT.HoldType = "pistol"
ENT.PrimaryDelay = 0.2
ENT.ViewModelAnglesOffset = Angle(0, -12, 0)
ENT.ViewModelPositionOffset = Vector(20, -16, -10)
ENT.WorldModel = "models/maxofs2d/lamp_flashlight.mdl"

--flashlight specific
ENT.Brightness = 1
ENT.DelocalAngles = Angle(0, 12, 0)
ENT.DelocalPosition = Vector(-23.5, 11.5, 10)
ENT.Distance = 448
ENT.FlashlightStrength = 1
ENT.FOV = 55
ENT.LocalAngles = Angle(0, 0, 0)
ENT.LocalPosition = Vector(0, 0, 0)
ENT.Texture = "effects/flashlight001"

--entity functions
function ENT:CreateLamp()
	if CLIENT then return end
	
	self:RemoveLamp()
	
	local lamp = GAMEMODE:EntityLampCreate()
	self.Lamp = lamp
	
	lamp:SetBrightness(self.Brightness)
	lamp:SetFOV(self.FOV)
	lamp:SetParent(self)
	
	lamp:SetLocalAngles(self.UseLocalAngles)
	lamp:SetLocalPos(self.UseLocalPosition)
	lamp:Spawn()
	lamp:InputTexture(self.Texture)
	
	return lamp
end

--function ENT:DrawTranslucent(flags) end
--function ENT:Initialize() self:ItemInitialize() end

function ENT:OnDropped(ply, item_slot)
	self.UseLocalAngles = nil
	self.UseLocalPosition = nil
	
	self:DrawShadow(true)
end

function ENT:OnEquipped(ply, item_slot)
	self.UseLocalAngles = self.DelocalAngles
	self.UseLocalPosition = self.DelocalPosition
	
	self:DrawShadow(false)
end

function ENT:OnRemove() self:RemoveLamp() end
function ENT:PrimaryUse(ply, item_slot) self:Toggle() end
function ENT:RemoveLamp() if IsValid(self.Lamp) then self.Lamp:Remove() end end

function ENT:ThinkPre()
	if CLIENT then return end
	
	--local lamp = self.Lamp
	
	--if IsValid(lamp) then lamp:SetTexture(self.Texture) end
end

function ENT:SetupDataTables()
	self:ItemSetupDataTables() --call the base class' method first
	self:NetworkVar("Bool", 0, "Lit")
	self:NetworkVarNotify("Lit", function(self, name, old, new) if old ~= new then self:Toggled(new, old == nil) end end)
	
	if SERVER then self:SetupNetworkVars() end
end

function ENT:SetupNetworkVars() self:SetLit(false) end
function ENT:Toggle() self:SetLit(not self:GetLit()) end

function ENT:Toggled(state, initial)
	if state then self:CreateLamp()
	else self:RemoveLamp() end
	if initial then return end
	
	--play sounds
end