--locals
local phasmophobia_fast_switch = CreateClientConVar("phasmophobia_fast_switch", "1", true, false, "Enable fast item switch. This is like normal fast switch but is specific to Phasmophobia instead.")

--local functions
local function update_fast_switch()
	local gm = GM or GAMEMODE
	
	gm.PlayerBindPress = phasmophobia_fast_switch:GetBool() and gm.PlayerBindingFastSwitch or nil
end

--local tables
local bind_overrides = {
	invnext = function(ply, pressed, code, active_slot)
		local item_slots = ply:GetItemSlots()
		local item_slot = item_slots[(active_slot:GetSlot() - 1) % #item_slots + 1]
		
		if IsValid(item_slot) then input.SelectWeapon(item_slot) end
	end,
	
	invprev = function(ply, pressed, code, active_slot)
		local item_slots = ply:GetItemSlots()
		local item_slot = item_slots[(active_slot:GetSlot() + 1) % #item_slots + 1]
		
		if IsValid(item_slot) then input.SelectWeapon(item_slot) end
	end,
}

--gamemode functions
function GM:PlayerBindingFastSwitch(ply, bind, pressed, code)
	local active_weapon = ply:GetActiveWeapon()
	
	if active_weapon:IsValid() and active_weapon.IsPhasmophobiaItemSlot then
		if string.StartWith(bind, "slot") then
			local item_slots = ply:GetItemSlots()
			local number = tonumber(string.sub(bind, 5))
			
			if not number or not item_slots then return end
			
			local item_slot = item_slots[number]
			
			if IsValid(item_slot) then input.SelectWeapon(item_slot) end
		else
			local bind_override = bind_overrides[bind]
			
			if bind_override then return bind_override(ply, pressed, code, active_weapon) end
		end
	end
end

--convars
cvars.AddChangeCallback("phasmophobia_fast_switch", update_fast_switch, "PhasmophobiaPlayerBinding")

--post
update_fast_switch()