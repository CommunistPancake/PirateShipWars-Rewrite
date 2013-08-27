GM.Name = "Pirate Ship Wars"
GM.Author = ""
GM.Website = ""

function GM:Initialize()
	
end

team.SetUp(1, "Red Pirates", Color(200, 0, 0, 255))
team.SetUp(2, "Blue Pirates", Color(0, 0, 200, 255))
team.SetUp(3, "Spectators", Color(200, 200, 200, 255))

TEAM_RED = 1
TEAM_BLUE = 2
TEAM_SPECTATOR = 3