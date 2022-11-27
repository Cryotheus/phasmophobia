--locals
local maximum_item_count = 3
--local maximum_item_slot = maximum_item_count - 1
--local pickup_distance = 84

--gamemode functions
function GM:PlayerLoadout(ply)
	local item_slots = ply.ItemSlots
	
	if not item_slots then
		item_slots = {}
		ply.ItemSlots = item_slots
	else table.Empty(item_slots) end
	
	ply:RemoveAllItems()
	
	--create all the item slots we will need (weapon to hold item entities)
	for index = 1, maximum_item_count do item_slots[index] = ply:Give(index > 1 and "phasmophobia_item_slot_" .. index or "phasmophobia_item_slot") end
end

function GM:PlayerItemPickup(ply, item)
	
	--prevent hackers from duplicating items
	if IsValid(item:GetItemSlot()) then return false end
	
	--try to pickup item with the active slot first
	local item_slots = ply:GetItemSlots()
	local item_slot = ply:GetActiveWeapon()
	
	if string.StartWith(item_slot:GetClass(), "phasmophobia_item_slot") and not IsValid(item_slot:GetItem()) then
		item_slot:Pickup(item)
		
		return true
	end
	
	--otherwise, put the item in any open slot
	for index, item_slot in ipairs(item_slots) do
		local held_item = item_slot:GetItem()
		
		if not IsValid(held_item) then
			item_slot:Pickup(item)
			
			return true
		elseif item == held_item then return false end
	end
	
	return false
end

function GM:PlayerRegisterItemSlots(maximum)
	for index = 2, maximum do
		local phasmophobia_item_slot = weapons.Get("phasmophobia_item_slot")
		phasmophobia_item_slot.Slot = index - 1
		phasmophobia_item_slot.PrintName = "Phasmophobia Item Slot #" .. index
		
		weapons.Register(phasmophobia_item_slot, "phasmophobia_item_slot_" .. index)
	end
end