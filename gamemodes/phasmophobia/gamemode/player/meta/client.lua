--locals
local player_meta = FindMetaTable("Player")

--player meta functions
function player_meta:GetItemSlots()
	local item_slots = self.ItemSlots
	
	if not item_slots then
		item_slots = {}
		self.ItemSlots = item_slots
	else table.Empty(item_slots) end
	
	for index, weapon in ipairs(self:GetWeapons()) do if weapon.IsPhasmophobiaItemSlot then item_slots[weapon:GetSlot() + 1] = weapon end end
	
	return item_slots
end