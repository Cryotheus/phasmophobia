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