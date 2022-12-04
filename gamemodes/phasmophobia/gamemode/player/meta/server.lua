--locals
local player_meta = FindMetaTable("Player")

--player meta functions
function player_meta:GetItemSlots()
	local item_slots = self.ItemSlots
	
	if item_slots then return item_slots end
	
	hook.Run("PlayerLoadout", self)
	
	--then try again
	return self.ItemSlots
end