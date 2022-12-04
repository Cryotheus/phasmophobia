--gamemode functions
function GM:PlayerSwitchFlashlight(ply, enabled)
	local flashlight, other_flashlights = self:PlayerFlashlight(ply)
	
	if not flashlight then return end
	
	--turn off all other flashlights
	for index, other_flashlight in ipairs(other_flashlights) do if other_flashlight:GetLit() then other_flashlight:SetLit(false) end end
	
	flashlight:Toggle()
	
	return false
end

function GM:PlayerFlashlight(ply) --gets the player's best flashlight
	local flashlight
	local flashlights = {}
	local item_slots = ply:GetItemSlots()
	local record = 0
	
	for index, item_slot in ipairs(item_slots) do
		local item = item_slot:GetItem()
		
		if IsValid(item) then
			local score = item.FlashlightStrength
			
			if score and score > record then
				if flashlight then table.insert(flashlights, flashlight) end
				
				flashlight = item
				record = score
			end
		end
	end
	
	return flashlight, flashlight and flashlights
end