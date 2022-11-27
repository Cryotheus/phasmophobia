GM.Author = "Cryotheum"
GM.Email = "N/A"
GM.Name = "Phasmophobia"
GM.TeamBased = false
GM.Website = "N/A"

--deriving sandbox!
DeriveGamemode("sandbox")

--local functions
local function incluce(path)
	AddCSLuaFile(path)
	include(path)
end

--includes
incluce("global.lua")
incluce("entity/meta.lua")
incluce("player/item/model.lua")
incluce("player/item/shared.lua")
incluce("player/meta.lua")

--functions
function GM:InitPostEntity()
	--more?
	self:PlayerRegisterItemSlots(4)
end