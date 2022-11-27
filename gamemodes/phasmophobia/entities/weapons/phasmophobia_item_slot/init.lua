AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--swep functions
function SWEP:ShouldDropOnDie() return false end