--color globals, done in the same style as color_white (lower snake case)
color_client = Color(231, 219, 116)
color_client_pale = Color(231, 226, 175)
color_server = Color(144, 219, 232)
color_server_pale = Color(175, 226, 232)

--replicate debug print color
if SERVER then
	color_realm = color_server
	color_realm_pale = color_server_pale
else
	color_realm = color_client
	color_realm_pale = color_client_pale
end

--color table
GM.GlobalColor = {
	Players = {
		--classic colors from the original game
		Color(255, 119, 19),
		Color(89, 205, 231),
		Color(208, 242, 128),
		Color(255, 129, 234),
		
		--additional colors for extra players
		Color(255, 115, 115),
		Color(159, 130, 255),
		Color(143, 143, 143),
		Color(247, 247, 247),
		Color(33, 33, 33),
	},
	
	Teams = {
		[TEAM_LOBBY] = Color(224, 228, 244),
		[TEAM_INVESTIGATOR] = Color(96, 128, 224),
		[TEAM_HUNTER] = Color(224, 128, 96),
		[TEAM_GHOST] = Color(131, 255, 179),
	},
}