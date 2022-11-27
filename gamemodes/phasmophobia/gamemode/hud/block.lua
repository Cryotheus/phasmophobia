--locals
local phasmophobia_fast_switch = GetConVar("phasmophobia_fast_switch")

--local tables
local hud_blocks = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudDamageIndicator = true,
	CHudPoisonDamageIndicator = true,
	CHudHealth = true,
	CHUDQuickInfo = true,
	CHudSecondaryAmmo = true,
	CHudSquadStatus = true,
	CHudSuitPower = true,
	CHudVehicle = true,
	CHudWeaponSelection = phasmophobia_fast_switch:GetBool(),
	CHudZoom = true,
}

--globals
GM.HUDBlocks = hud_blocks

--gamemode functions
function GM:HUDShouldDraw(name) return not hud_blocks[name] end

--cvars
cvars.AddChangeCallback("phasmophobia_fast_switch", function()
	--must make sure we have created the convar before we try to use it
	hud_blocks.CHudWeaponSelection = phasmophobia_fast_switch:GetBool()
end, "PhasmophobiaHUDBlock")