GM.Author = "Cryotheum"
GM.Email = "N/A"
GM.Name = "Phasmophobia"
GM.TeamBased = false
GM.Website = "N/A"

--deriving sandbox!
DeriveGamemode("sandbox")

--functions
function GM:InitPostEntity()
	--more?
	self:PlayerRegisterItemSlots(4)
end