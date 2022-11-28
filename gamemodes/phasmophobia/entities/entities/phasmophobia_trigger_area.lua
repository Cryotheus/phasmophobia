if CLIENT then return end

--entity fields
ENT.Base = "phasmophobia_map_entity"
ENT.Instructions = "Place this trigger in a room to setup the environment."
ENT.PrintName = "Phasmophobia Area Trigger"
ENT.Purpose = "Designate areas and rooms."
ENT.Type = "brush"

--custom entity fields
ENT.KeyValueMethods = {
	floor = "Floor: number",
	keyname = "RoomKey",
	temperature = "TargetTemperature: number",
	temperaturebias = "TargetTemperatureBias: number",
}

ENT.SpawnFlagFields = {
	"SuitableGhostRoom",
	"CreakyFloor",
	"Outdoors",
	"Staircase",
	"HidingSpot"
}

--lua_run local p=player.GetAll()[1] timer.Create("a",0,0,function() local l = {} for k,v in pairs(p.PhasmophobiaAreaRecord) do table.insert(l, k) end p:PrintMessage(HUD_PRINTCENTER, table.concat(l, "\n")) end)
--entity functions
function ENT:EndTouch(entity)
	local area_table = entity.PhasmophobiaAreaRecord
	local key = self.RoomKey or "unknown"
	
	if area_table and key then
		local current_count = area_table[key]
		
		--print((entity.Nick and entity:Nick() or tostring(entity)) .. " left " .. key .. (self.HidingSpot and " (hiding spot)" or ""))
		
		if current_count then
			if current_count <= 1 then area_table[key] = nil
			else area_table[key] = current_count - 1 end
		end
	end
end

function ENT:Initialize()
	local key = self.RoomKey
	
	if not key or key == "" then
		self.RoomKey = nil
		
		if self.HidingSpot then print("we need to find the key name for a hiding spot", self)
		else
			MsgC(GAMEMODE.GlobalColor.Message.Error, "[Phasmophobia ERROR] phasmophobia_trigger_area brush is missing Key Name (keyname) field! This brush will be deleted to prevent more errors.\nPlease report this error to the creator of the " .. game.GetMap() .. " map.\n")
			self:Remove()
		end
	end
end

function ENT:StartTouch(entity)
	local area_table = entity.PhasmophobiaAreaRecord
	local key = self.RoomKey
	
	if not key then return end
	
	--print((entity.Nick and entity:Nick() or tostring(entity)) .. " entered " .. key .. (self.HidingSpot and " (hiding spot)" or ""))
	
	if not area_table then
		local area_table = {[key] = 1}
		entity.PhasmophobiaAreaRecord = area_table
	else
		local current_count = area_table[key]
		
		if current_count then area_table[key] = current_count + 1
		else area_table[key] = 1 end
	end
end