if CLIENT then return end

--entity fields
ENT.Base = "phasmophobia_map_entity"
ENT.Instructions = "Place this trigger in a room to setup the environment."
ENT.PrintName = "Phasmophobia Area Trigger"
ENT.Purpose = "Designate areas and rooms."
ENT.Type = "brush"

--custom entity fields
ENT.KeyValueMethods = {
	temperature = "TargetTemperature: number",
	temperaturebias = "TargetTemperatureBias: number",
}

ENT.SpawnFlagFields = {
	"SuitableGhostRoom",
	"CreakyFloor",
	"Outdoors"
}

--entity functions
function ENT:EndTouch(entity)
	local area_table = entity.PhasmophobiaAreaTable
	
	if not area_table then return end
	
	local current_count = area_table[entity]
	
	if current_count then
		if current_count <= 1 then area_table[entity] = nil
		else area_table[entity] = current_count - 1 end
	end
end

function ENT:Initialize()
	
end

function ENT:StartTouch(entity)
	local area_table = entity.PhasmophobiaAreaTable
	
	if not area_table then
		local area_table = {[entity] = 1}
		entity.PhasmophobiaAreaTable = area_table
	else
		local current_count = area_table[entity]
		
		if current_count then area_table[entity] = current_count + 1
		else area_table[entity] = 1 end
	end
end