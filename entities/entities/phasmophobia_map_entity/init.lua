AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--locals
local key_value_casts = {
	angle = function(self, value) return Angle(unpack(string.Split(value, " "))) end,
	bool = function(self, value) return tobool(value) end,
	color = function(self, value) return Color(unpack(string.Split(value, " "))) end,
	number = function(self, value) return tonumber(value) end,
	string = function(self, value) return tostring(value) end,
	target = function(self, value, field) PhasmophobiaTargettedEntities[self] = {value, key, field} end,
	vector = function(self, value) return Vector(unpack(string.Split(value, " "))) end,
}

--globals
PhasmophobiaTargettedEntities = PhasmophobiaTargettedEntities or {}

--entity functions
function ENT:KeyValue(key, value)
	--sets fields according to the SpawnFlagFields table
	local spawn_flag_fields = self.SpawnFlagFields
	
	if spawn_flag_fields and key == "spawnflags" then
		local value = tonumber(value)
		
		--check each bit and set the related field
		for index, field in ipairs(spawn_flag_fields) do self[field] = bit.band(value, 2 ^ (index - 1)) ~= 0 end
		
		return --don't perform the default key value behavior
	end
	
	--handle all other key values using the KeyValueMethods table
	local key_value_methods = self.KeyValueMethods
	
	if not key_value_methods then return end
	
	local method = self.KeyValueMethods[key]
	
	if isstring(method) then
		local segments = string.Explode("%s*:%s*", method, true)
		
		if #segments == 1 then self[method] = value
		else
			local field = segments[1]
			local type_cast = key_value_casts[segments[2]]
			
			self[field] = type_cast(self, value, field)
		end
	elseif isfunction(method) then method(self, key, value) end
end