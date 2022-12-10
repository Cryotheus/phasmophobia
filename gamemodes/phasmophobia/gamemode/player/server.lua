--gamemode functions
function GM:PlayerCreated(ply)
	local light = ents.Create("phasmophobia_player_light")
	
	light:Spawn()
	light:SetPlayer(ply)
end