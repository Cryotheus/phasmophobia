--locals
local held_angle_offsets = {}
local held_position_offsets = {}
local model_hold_types = {}
local throw_angle_offsets = {}
local view_model_angle_offsets = {}
local view_model_position_offsets = {}

--local tables
local model_offsets = {
	["models/props_lab/frame001a.mdl"] = {
		ViewModelAngle = Angle(-20, 180, 0),
		ViewModelPosition = Vector(25, 0, -11),
	},
	
	["models/props/cs_office/projector_remote.mdl"] = {
		HeldAngle = Angle(0, 0, 0),
		HeldPosition = Vector(0, 0, 0),
		HoldType = "pistol",
		ViewModelAngle = Angle(0, 90, -25),
		ViewModelPosition = Vector(12, -10, -5),
	},
	
	["models/props_phx/misc/soccerball.mdl"] = {
		ViewModelAngle = Angle(0, 0, 0),
		ViewModelPosition = Vector(20, 0, -10),
	},
}

--globals
GM.PlayerItemModelHoldTypes = model_hold_types
GM.PlayerItemModelOffsets = model_offsets
GM.PlayerItemModelOffsetsHeldAngle = held_angle_offsets
GM.PlayerItemModelOffsetsHeldPosition = held_position_offsets
GM.PlayerItemModelOffsetsThrowAngle = throw_angle_offsets
GM.PlayerItemModelOffsetsViewModelAngle = view_model_angle_offsets
GM.PlayerItemModelOffsetsViewModelPosition = view_model_position_offsets

--post
hook.Run("PlayerItemOffsetsRegister", model_offsets)

for model, offsets in pairs(model_offsets) do
	held_angle_offsets[model] = offsets.HeldAngle
	held_position_offsets[model] = offsets.HeldPosition
	model_hold_types[model] = offsets.HoldType
	throw_angle_offsets[model] = offsets.ThrowAngle
	view_model_angle_offsets[model] = offsets.ViewModelAngle
	view_model_position_offsets[model] = offsets.ViewModelPosition
end