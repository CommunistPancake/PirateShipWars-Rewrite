include("shared.lua")
include("explosion.lua")
include("vgui/teamselect.lua")
include("vgui/hud.lua")

function GM:ShowTeam()
	TeamSelect.ShowMenu()
end