--locals
local player_meta = FindMetaTable("Player")
local player_trace_distance = 1024

--player meta functions
function player_meta:GetAimEntity() --returns the aim entity and the trace's distance
	local tick = engine.TickCount()
	
	if tick == self.AimTraceTicked then return self.AimEntityTraced, self.AimEntityTraceDistance, self.AimEntityHit, self.AimEntityNormal end
	
	local eye_position = self:EyePos()
	local player_trace = self.AimEntityTrace
	local player_result = self.AimEntityTraceResult
	
	if not player_trace then
		player_result = {}
		
		player_trace = {
			filter = self,
			mask = MASK_SHOT,
			output = player_result
		}
		
		self.AimEntityTrace = player_trace
		self.AimEntityTraceResult = player_result
	end
	
	player_trace.endpos = eye_position + self:GetAimVector() * player_trace_distance
	player_trace.start = eye_position
	
	util.TraceLine(player_trace)
	
	local distance = player_result.Fraction * player_trace_distance
	local entity = player_result.Entity
	local hit = player_result.HitPos
	local normal = player_result.HitNormal
	self.AimEntityHit = hit
	self.AimEntityNormal = normal
	self.AimEntityTraced = entity
	self.AimEntityTraceDistance = distance
	self.AimTraceTicked = tick
	
	return entity, distance, hit, normal
end