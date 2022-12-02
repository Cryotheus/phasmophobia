--locals
local player_duck_height = 36
local player_height = 72
local player_width = 24

--constructed
local player_hull_duck_maximums = Vector(player_width * 0.5, player_width * 0.5, player_duck_height)
local player_hull_duck_minimums = Vector(player_width * -0.5, player_width * -0.5, 0)
local player_hull_maximums = Vector(player_width * 0.5, player_width * 0.5, player_height)
local player_hull_minimums = Vector(player_width * -0.5, player_width * -0.5, 0)

--gamemode functions
function GM:PlayerSetHull(ply)
	print("player created", ply)
	
	ply:SetHull(player_hull_minimums, player_hull_maximums)
	ply:SetHullDuck(player_hull_duck_minimums, player_hull_duck_maximums)
end