function GM:CreateTeams()
	--RELEASE: create player classes!
	team.SetUp(TEAM_LOBBY, "Players", color_white)
	team.SetSpawnPoint(TEAM_LOBBY, "info_player_start")
	team.SetClass(TEAM_LOBBY, "player_sandbox")
	
	team.SetUp(TEAM_INVESTIGATOR, "Investigators", color_white)
	team.SetSpawnPoint(TEAM_INVESTIGATOR, "info_player_start")
	team.SetClass(TEAM_INVESTIGATOR, "player_sandbox")
	
	team.SetUp(TEAM_HUNTER, "Hunters", color_white)
	team.SetSpawnPoint(TEAM_HUNTER, "info_player_start")
	team.SetClass(TEAM_HUNTER, "player_sandbox")
	
	team.SetUp(TEAM_GHOST, "Ghosts", color_white)
	team.SetSpawnPoint(TEAM_GHOST, "info_player_start")
	team.SetClass(TEAM_GHOST, "player_sandbox")
end