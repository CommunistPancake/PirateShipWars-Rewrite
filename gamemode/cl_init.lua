include("shared.lua")
include("explosion.lua")
include("vgui/teamselect.lua")
include("vgui/hud.lua")

function GM:PlayerNoClip(ply)
	return false
end

function GM:ShowTeam()
	TeamSelect.ShowMenu()
end